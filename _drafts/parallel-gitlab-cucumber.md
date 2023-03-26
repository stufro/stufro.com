---
layout: post
title: Parallelizing Cucumber tests on GitLab runners
subtitle: How we took our build time from 1 hour to 25 minutes in an afternoon
author: Stuart Frost
background: /assets/cucumber.jpg
tags:
  - cucumber
  - gitlab
  - CI
---

When you're working on a Rails application with ~100 feature files containing a total of 685 scenarios, it's really important
to spend time pruning and optimising your CI build.

Our build time had been slowly creeping up as build times do and whilst we had spent time pruning unused features and only running
scenarios in a headless browser when necessary, we were still in a predicament. Our CI pipeline was taking between 50 mins and 1 hour
to complete, nearly all of that time was just running our Cucumber tests.

While this problem may point to other bigger questions such as "is this application doing too much?", "should we split this into separate
apps?" and "how did it get this slow?", such questions rarely have a quick and cheap answer.

# Parallelizing
One quick win which often yields results is running your tests in parallel, there's a popular gem called [parallel_tests](https://github.com/grosser/parallel_tests)
which allows you to run Test::Unit, RSpec, Cucumber or Spinach in parallel on multiple CPU cores.

We had used this gem in the project in the past but removed it after facing many issues with flapping tests and timeouts. I suspect this was
no fault of the gem, rather our use of it or poor tests causing side effects.

Either way, this post will describe an alternative approach using concurrent GitLab jobs.

# GitLab jobs
To define a GitLab job it's a simple case of adding a block to our `.gitlab-ci.yml` file.

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

Each block will become a job and there's a config option in the GitLab runners `config.toml` file which defines the number of concurrent jobs
which can run.

```toml
concurrent = 8
```

<figure>
  <img src="/assets/post-content/gitlab-jobs.png" width="200" alt="GitLab Jobs">
  <small><figcaption>GitLab jobs configured in `gitlab-ci.yml` shown on the UI</figcaption></small>
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
