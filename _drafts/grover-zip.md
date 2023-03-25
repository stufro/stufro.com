---
layout: post
title: Generating PDFs in Rails
subtitle: How to use the Grover gem to generate a .zip file of multiple PDFs
author: Stuart Frost
background: /assets/rails-b&w.jpg
tags:
  - tutorial
  - rails
  - gems
---

Whilst working on v0.3.0 of [Chordly](https://www.chordly.co.uk), I needed to implement a feature where users
could generate and download multiple PDFs at once. To do this I used the [Grover](https://github.com/Studiosity/grover)
gem and [`Zip::OutputStream`](https://www.rubydoc.info/github/rubyzip/rubyzip/Zip/OutputStream) from the Ruby standard
library.

In this tutorial I'll take you through the solution I ended up with.

# Grover Basics

Grover is a fantastic gem, one that I was thrilled to find when I started working on [Chordly](https://www.chordly.co.uk).
It uses [Google Puppeteer](https://pptr.dev/) to render a web page in a headless browser and then converts the content into
other formats such as PDF or PNG.

A quick glance at Grover's README will show you how simple it is to get started; initialize an instance of `Grover` with a URL
or inline HTML, call `to_pdf` on it and away you go.

```ruby
# Grover.new accepts a URL or inline HTML and optional parameters for Puppeteer
grover = Grover.new('https://google.com', format: 'A4')
pdf = grover.to_pdf
```

Taking that one step further towards a more realistic use case and we render one of our Rails views as a string to pass into the gem.
This is exactly how I had been using Grover up until now in the `show` action of my [controller](https://github.com/stufro/chordly/blob/d85f61ad58f75cb9842fbad21427f8fb54daeae1/app/controllers/chord_sheets_controller.rb#L14-L17).

```ruby
html = MyController.new.render_to_string({
  template: 'controller/view',
  layout: 'my_layout',
})
pdf = Grover.new(html, **grover_options).to_pdf
```

# Zipping it up
My use case was that I had a `SetList` model which has many `ChordSheet`'s. I needed to give the user the option to
download their set list as a ZIP file containing separate PDFs.

In my naivity I had assumed this would involve generating each PDF and saving it to disk in turn, creating a .zip file from these PDFs
before serving that file up to the user and doing some inevitable cleanup. So you can imagine my joy when I discovered `Zip::OutputStream`.

A built in Ruby library which allows you to generate .zip files on the fly. You call `write_buffer` passing it a block which then allows you
to write multiple files to the ZIP file stream.

```ruby
require "zip"

Zip::OutputStream.write_buffer do |zio|
  zio.put_next_entry("file_name.pdf")
  zio.write(:placeholder_for_pdf_file_content)
end
```

So all I had to do was loop through the chord sheets in my set list, call `put_next_entry` with the chord sheet name, write the PDF content
using `Grover.new(...).to_pdf` as I did above and I was off to the races!

Here's how that looked in practice, you can see the full code [here](https://github.com/stufro/chordly/blob/3f3ab548e5e6dbbdf522d04b14bc44275749f26f/app/models/set_list_exporter.rb).
The only additional thing below is that I return `io.string` from the method. This allowed me to pass the entire ZIP contents
back up to the controller where it was served to the user using `send_data`.

```ruby
def to_zip
  io = Zip::OutputStream.write_buffer do |zio|
    @set_list.chord_sheets.each do |chord_sheet|
      zio.put_next_entry(file_name(chord_sheet))
      zio.write(generate_pdf(chord_sheet))
    end
    zio
  end

  io.string
end
```

# How do you test it?

# Conclusion
I love it when you have a problem and you find libraries as good as Grover & Puppeteer which help you solve it in such as easy and elegant way.