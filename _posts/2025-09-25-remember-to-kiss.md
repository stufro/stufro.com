---
layout: post
title: Remember to KISS (Keep it Simple, Stupid!)
author: Stuart Frost
comments: true
date: 2025-09-25
background: /assets/lightbulb.jpg
image_attribution: Photo by <a href="https://unsplash.com/@theocrazzolara?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Theo Crazzolara</a> on <a href="https://unsplash.com/photos/a-light-bulb-with-a-flame-xDyv5ZItvkY?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
tags:
  - best-practices
  - software-design
---

*"Keep it simple, stupid!"*, or [KISS](https://en.wikipedia.org/wiki/KISS_principle) for short - it's one of the things that is often taught to engineers. I remember clearly my first tech lead drilling this into me. But I find I have to keep reminding myself of it — and this is a story of one of those times.

In one of my personal projects, I have a feature where musicians can export chord sheets as PDFs. I had been using [Google Puppeteer](https://pptr.dev/) (as described in [this post]({% post_url 2023-03-26-generating-pdfs-in-rails %})) to render the PDFs from HTML using a headless Chrome browser. At the time this seemed like the easiest way to get a working solution.

This year I had a growing problem. My project runs on minimal resources - just **1 vCPU and 512Mb of memory**. Exporting PDFs in this way was resource intensive and not sustainable as more users started to use my application.

# Perspective change
Last week I went for a drink with a good friend and fellow software engineer and I described this challenge to him. Like all good coaches and leaders, he didn't go into solution mode. He was gracious enough not to burst my bubble and point out the obvious. Instead, only on reflection did I stumble upon the obvious question myself - *why do I need to run a headless browser just to render a simple text-based PDF?*

The answer, of course, was I don't. 

The next night, I spent a short time ripping out the old approach and replacing it with a library which wraps [`wkhtmltopdf`](https://wkhtmltopdf.org/). I deployed the change and immediately saw a ~75% reduction in PDF generation times. 🚀

I could go even further and ask *why do I need to render HTML into PDF?* - perhaps an endeavour for another night.

# Why it matters
The takeway from this is not in the technical details. What I've explained here is a really trivial example, but as engineers we make decisions like this every day. We have to make tradeoffs between complexity, maintainability and performance.

In an industry with so many options that add complexity, where possible, try to find the one which **removes** it.

