---
layout: post
title: Crystal - Mocking & Stubbing
subtitle: Using `inject_mock` in the Spectator shard
author: Stuart Frost
# date: 2023-04-24
background: /assets/post-content/crystal.jpg
tags:
  - testing
  - crystal
  - rspec
---

In recent months I've been writing some [Crystal](https://crystal-lang.org/) code. It appealed to me for 3 reasons: it's a language which compiles to a single binary, it has good support for multi-threading and is syntactically very similar to Ruby. I've written a couple of small [Go](https://go.dev/) components before where we needed support for potential high throughput of data and looking at Crystal it seemed to offer all the same benefits but with a Ruby-like syntax that I know and love.

Talking of Ruby-like syntax, I quickly discovered a shard (equivalent of a Ruby gem) called [Spectator](https://github.com/icy-arctic-fox/spectator) which aims to mimic the features of [RSpec](https://rspec.info/). It mimics it really well, the only thing that I found to be different was around mocking and stubbing due to contraints around Crystal's type system, which is different to Ruby.

The Spectator documentation is mainly focussed around using abstract classes as an interface which your real class and your dummy class can implement. I spent a fair amount of time experimenting with different approaches and I may do another post of this approach. However,. This is mainly the one that I found to be most similar to the RSpec syntax is using `inject_mock`.

# A Caveat
From the [Spectator documentation](https://gitlab.com/arctic-fox/spectator/-/wikis/Injecting-Mocks):

> This approach is not recommended.  Injecting mock functionality into a type alters its behavior. It may behave differently between test and non-test code. Regular mocks and doubles should be used whenever possible. Especially avoid using this on foundational Crystal types such as String, Int32, and Array. It may cause unexpected behavior and stack overflows.

Although this approach may get us closer to what we're familiar with in RSpec, it seems it shouldn't be the default choice especially when testing is possible using regular mocks & doubles.

# A simple example
Let's have a look at a super simplified example to discover how we can use `inject_mock` to mock out methods calls to one of our classes. Suppose we have this code:

```crystal
class OrderCalculator
  def total_price(quantity) : Int
    Database.product_price * quantity
  end
end
```

We may want to return a stubbed value from `.product_price` and we can achieve this with the following spec:

```crystal
Spectator.describe OrderCalculator do
  inject_mock Database

  before do
    allow(Database).to receive(:product_price).and_return 5
  end

  it "multiplies the product price by given quantity" do
    expect(subject.total_price(quantity: 2)).to eq 10
  end
end
```