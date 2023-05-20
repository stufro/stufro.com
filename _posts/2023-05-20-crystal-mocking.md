---
layout: post
title: Crystal - Mocking using Spectator
subtitle: Specifically using `inject_mock` method
author: Stuart Frost
comments: true
date: 2023-05-20
background: /assets/post-content/crystal.jpg
tags:
  - testing
  - crystal
  - rspec
---

<i>tldr; [Gist](https://gist.github.com/stufro/b4d70bbf2923ca742db617fe802a6d76) with all the code examples</i>

In recent months I've been writing some [Crystal](https://crystal-lang.org/) code. It appealed to me for 3 reasons: it's a language which compiles to a single binary, it has good support for multi-threading and is syntactically very similar to Ruby. I've written a couple of small [Go](https://go.dev/) components before where we needed support for potential high throughput of data and looking at Crystal it seemed to offer all the same benefits but with a Ruby-like syntax that I know and love.

Talking of Ruby-like syntax, I quickly discovered a shard (equivalent of a Ruby gem) called [Spectator](https://github.com/icy-arctic-fox/spectator) which aims to mimic the features of [RSpec](https://rspec.info/). It mimics it really well, the only thing that I found to be different was around mocking and stubbing due to contraints around Crystal's type system, which is different to Ruby's.

The Spectator documentation is mainly focussed around using abstract classes as an interface which your real class and your dummy class can implement. I spent a fair amount of time experimenting with different approaches and I may do another post on that one. However, the approach I found to be most similar to the RSpec syntax is using `inject_mock`.

# A Caveat
From the [Spectator documentation](https://gitlab.com/arctic-fox/spectator/-/wikis/Injecting-Mocks):

> This approach is not recommended.  Injecting mock functionality into a type alters its behavior. It may behave differently between test and non-test code. Regular mocks and doubles should be used whenever possible. Especially avoid using this on foundational Crystal types such as String, Int32, and Array. It may cause unexpected behavior and stack overflows.

Although this approach may get us closer to what we're familiar with in RSpec, it seems it shouldn't be the default choice especially when testing is possible using regular mocks & doubles, as I said I'd like to do another post on the alternative approach.

# A Simple Example
Let's have a look at a super simplified example to discover how we can use `inject_mock` to mock out methods calls to one of our classes. Suppose we have this code:

```crystal
class OrderCalculator
  def total_price(quantity : Int) : Float
    Database.product_price * quantity
  end
end
```

We may want to return a stubbed value from `.product_price`. To add mocking to an existing type, we pass the type to `inject_mock` within our describe block.

```crystal
Spectator.describe OrderCalculator do
  inject_mock Database

  it "multiplies the product price by given quantity" do
    allow(Database).to receive(:product_price).and_return 5.0

    expect(subject.total_price(quantity: 2)).to eq 10
  end
end
```

The `inject_mock` at the describe level enables us to use `allow(Database)...` to stub out the value returned from the `product_price` method.

# `def_mock` and `new_mock`

Now let's say that `Database` should actually return a product object, which we can then retrieve the price from.

Mocks have to be defined outside of a test before they can be instantiated using the `def_mock` method which takes the type to be mocked.

```crystal
Spectator.describe OrderCalculator do
  def_mock(Product)
  # ...
```

Once defined we can then instantiate the mock inside our `it` block using `new_mock`. Then we can change our allow on the `Database` class to return the mock and allow the mock to receive `#price` and return our canned value.

```crystal
it "multiplies the product price by given quantity" do
  product = new_mock(Product)
  allow(Database).to receive(:product).and_return product
  allow(product).to receive(:price).and_return 5.0

  expect(subject.total_price(quantity: 2)).to eq 10
end
```

I should also mention that you can replace `def_mock` and `new_mock` simply with `mock`. I opted to use the more specific alias to make it clear they are doing different things.

# Conclusion

That's it for now! As I mentioned at the beginning you can see the full code examples in this [gist](https://gist.github.com/stufro/b4d70bbf2923ca742db617fe802a6d76).