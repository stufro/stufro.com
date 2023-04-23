---
layout: post
title: Parallelizing Cucumber tests on GitLab runners
subtitle: How we took our build time from 1 hour to 25 minutes in an afternoon
author: Stuart Frost
background: /assets/post-content/cucumber.jpg
tags:
  - cucumber
  - gitlab
  - CI
---

When you're working on a Rails application with ~100 feature files containing a total of 685 scenarios, it's really important
to spend time pruning and optimising your CI build.

Our build time had been slowly creeping up as build times do and whilst we had spent time pruning unused features and only running
scenarios in a headless browser when necessary, we were still in a predicament. Our CI pipeline was taking between 50 mins and 1 hour
to complete, nearly all of that time was running our Cucumber tests.

While this problem may point to other bigger questions such as "is this application doing too much?", "should we split this into separate
apps?" and "how did it get this slow?", such questions rarely have a quick and cheap answer.

# Parallelizing
One quick win which often yields results is running your tests in parallel. There's a popular gem called [parallel_tests](https://github.com/grosser/parallel_tests)
which allows you to run Test::Unit, RSpec, Cucumber or Spinach in parallel on multiple CPU cores concurrently.

We had used this gem in the project in the past but removed it after facing many issues with flapping tests and timeouts. I suspect this was
no fault of the gem, rather our use of it or poor tests causing side effects.

Either way, this post will describe an alternative approach using concurrent GitLab jobs.

# Alternative approach - GitLab jobs
To define a GitLab job it's a simple case of adding a block to the `.gitlab-ci.yml` file.

```yaml
cucumber:
  extends: .test
  script:
    - bundle exec rake cucumber
  coverage: /\(\d+.\d+\%\) covered/
  artifacts:
    when: always
    paths:
      - log/cucumber.html
```

Each block will become a job and there's a `concurrent` config option in the GitLab runners `config.toml` file which defines the number of concurrent jobs
which can run at once.

<figure>
  <img src="/assets/post-content/gitlab-jobs.png" width="200" alt="GitLab Jobs">
  <small><figcaption>Jobs configured in `gitlab-ci.yml` shown on the GitLab UI</figcaption></small>
</figure>

We changed our config to have multiple cucumber jobs, setting an environment variable to give each job an ID.

```yaml
cucumber1:
  extends: .test
  script:
    - bundle exec rake cucumber CUCUMBER_GROUP=1
...

cucumber2:
  extends: .test
  script:
    - bundle exec rake cucumber CUCUMBER_GROUP=2
...
```

# Slicing the Cucumber
## Approach 1
Using this environment variable, we were able to decide which portion of the features to run on each job. The next thing was to implement the slicing up
of our feature tests.

As a first pass, we simply split the `.feature` files between each job to prove the idea. To actually do this, it was a case of modifying our
rake task, passing the list of feature files we want to run as a string to `t.cucumber_opts=`.

We find all the `.feature` files in our project, work out how many files to run on each job and then call `Array#in_groups_of` to split the files
into separate arrays.

```ruby
Cucumber::Rake::Task.new do |t|
  feature_files = Dir.glob(Rails.root.join("features/**/*.feature"))
  group_size = feature_files.count / 4
  grouped_features = feature_files.in_groups_of(group_size)
  t.cucumber_opts = grouped_features[ENV["CUCUMBER_GROUP"].to_i - 1].compact.join(" ")
  # ...
end
```

## Approach 2 - evenly spreading the load
This comes with a problem. Some feature files will have more scenarios than others. Using this approach resulted in one of the jobs running
twice any many scenarios as another meaning the load wasn't evenly spread between the jobs.

To improve this we decided we needed to split the feature files based on the number of scenarios in each file. The regular expression below will also include the number of scenario outlines.

```ruby
def scenario_count(filepath)
  File.open(filepath).grep(/Scenario:|(?<!Examples:\s)^\s*\|/).count
end
```

Once we had the count for each file, we can sort the features by the number of scenarios.

```ruby
feature_files.map { |filepath| [filepath, scenario_count(filepath)] }
             .sort_by { |_file, count| count }
             .map { |file, _count| file }
```

Now all that's left to do is distribute the features between a number of arrays equal to the number of GitLab jobs we have.

To do this we wrote a small recursive method to place the feature files sequentially into each array.

<figure style="text-align: center">
  <img style="width: 100%" src="/assets/post-content/cucumber-recursive-method.png" alt="Diagram demonstrating how recursive method works">
  <small><figcaption>Visual representation of how the recursive method works</figcaption></small>
</figure>

```ruby
def populate_slices(slices, slice_index, features)
  return slices if features.count.zero?

  slices[slice_index] << features.pop

  populate_slices(slices, (slice_index + 1) % @num_slices, features)
end
```

If you would like to try a similar approach check out the whole class [on GitHub](https://gist.github.com/stufro/71ebea8cc89925837bd42e84bb0c5b5c#file-version1-rb).

## Approach 3 - limitting how big a group can get

The recursive approach got us good results, good enough to push to main and start feeling the benefit of the time saving. However, Glenn felt we could still shave a few more minutes off. The recursive approach above can still result in the groups being unbalanced when there is a large disparity between scenario counts of the feature files.

# Using the slicer
It was then just a case of updating our Rake task to use our `CucumberSlicer` class.

```ruby
Cucumber::Rake::Task.new({ ok: "test:prepare" }, "Run features that should pass") do |t|
  if ENV["CUCUMBER_GROUP"].present?
    sliced_features = CucumberSlicer.slice(num_slices: 5)
    t.cucumber_opts = sliced_features[ENV["CUCUMBER_GROUP"].to_i - 1].compact.join(" ")
  end
  # ...
end
```