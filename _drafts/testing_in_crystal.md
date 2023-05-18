---
layout: post
title: Crystal - Mocking & Stubbing
subtitle: Using `inject_mock` from the spectator shard
author: Stuart Frost
# date: 2023-04-24
background: /assets/post-content/crystal.jpg
tags:
  - testing
  - crystal
  - rspec
---

In recent months I've been writing some [Crystal](https://crystal-lang.org/) code. It appealed to me for 3 reasons: it's a language which compiles to a single binary, it has good support for multi-threading and is syntactically very similar to Ruby. I've written a couple of small [Go](https://go.dev/) components before where we needed support for potential high throughput of data and looking at Crystal it seemed to offer all the same benefits but with a Ruby-like syntax that I know and love.

