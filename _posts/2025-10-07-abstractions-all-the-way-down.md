---
layout: post
title: Abstractions All the Way Down
subtitle: The hidden complexity beneath every line of code
author: Stuart Frost
comments: true
background: /assets/post-content/layers.webp
image_attribution: Photo by <a href="https://unsplash.com/@martinsanchez?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Martin Sanchez</a> on <a href="https://unsplash.com/photos/a-black-and-white-photo-of-a-tunnel-NfLZeAN7I6s?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>
date: 2025-10-07
tags:
  - software-design
---

What do you consider when starting a new project? Which CSS framework to use? Which database technology to choose? How about if you had to build a text editor before you could start? That's the world that Bill Gates describes in his biography *Source Code - My Beginnings*. Published this year, it describes his life from birth up to the early days of Microsoft.

One of the stories which caught my attention was when Gates was hired by a company called ISI to write a payroll system using a [PDP-10](https://en.wikipedia.org/wiki/PDP-10) mainframe computer:

> *"Our first hurdle was the fact that ISI wanted us to write the program in COBOL, a computer language none of us knew except Ric. We also lacked the necessary tools. [...] Ric started building us an an editor while the rest of us began to learn COBOL."*

It opened my eyes as to how primitive the available technology was in those early times when compared to now.

# Back of a napkin
There was another instance later in the book which felt similarly amazing. When the company [MITS](https://en.wikipedia.org/wiki/Micro_Instrumentation_and_Telemetry_Systems) released their microcomputer called [Altair 8800](https://en.wikipedia.org/wiki/Altair_8800) in 1974, it made personal computing accessible for the first time. Users interacted with it through lights and switches on it's front panel.

One of Gates and Paul Allens' first commercial products was a version of the BASIC programming language which ran on the Altair. What was mind-blowing to me was they developed this without having access to one of the microcomputers. Instead, Allen wrote an Altair simulator to run on the PDP-10 mainframe which they used to test running BASIC code.

<figure>
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/CPU_Altair_8800.jpg/960px-CPU_Altair_8800.jpg" style="width: 100%" alt="Altair 8800">
  <small>
      <figcaption style="text-align: center;">An Altair 8800. Image by Stahlkocker (<a href="https://commons.wikimedia.org/wiki/File:CPU_Altair_8800.jpg">🔗 CC BY-SA 3.0</a>)</figcaption>
  </small>
</figure>

If that wasn't impressive enough, when they were on the plane to demo their innovation to MITS, they realised they hadn't written a bootstrap loader to load their program into memory and launch it for the demo. Gates describes Paul Allen madly writing one on a notepad mid-flight, not quite the back of a napkin but pretty close! The way he describes this feels super casual, when in fact this simple act is perhaps much more technical than any code I will ever write using modern tools.

# Layers of abstraction
I find it fascinating to reflect on the origins of the software industry because on one hand things were so simple and primitive. However, it was only the outputs which were simple. To produce those outputs required a huge amount of complexity. This complexity is mostly hidden from us as modern developers.

For fun, I want to attempt to write down the layers which separate a developer from the electrons whizzing around their machine. Let's take the language [Go](https://go.dev/) as an example. This is never going to be a complete list and I've likely skipped some layers.

### When compiling Go code
```
└── High-level source code
   └── Compiler front-end (parsing)
      └── Intermediate Representation
         └── Compiler optimiser (inlining, dead code elimination, etc.)
            └── Compiler backend code generation
               └── Assembly language
                  └── Assembler (mnemonics to opcodes)
                     └── Object files (machine code + metadata)
                        └── Linker (combines object files + Go Runtime into an executable) 
                           └── Executable binary (ELF/PE/Mach-O format)
```

### And when executing the code
```
└── Loader / dynamic linker (places executable in memory, resolves shared libs)
   └── Go Runtime (manages goroutines, GC, memory)
      └── System calls (interface between user space and the kernel)
         └── Kernel (scheduling, virtual memory, I/O management)
            └── Device drivers (software abstraction for hardware)
               └── CPU instruction set architecture
                  └── Microcode (translates complex instructions into micro-ops, on CISC)
                     └── CPU execution pipeline (fetch, decode, execute, etc.)
                        └── Register transfer level (RTL)
                           └── Logic gates (AND, OR, NOT, adders)
                              └── Transistors (physical on/off switches)
```

That's an enormous amount of heavy lifting that's happening every time you interact with a high-level programming language.

With each layer that has been added, it has enabled us to build more complex systems with more ease. However, each layer also adds its own complexity and overhead. This is why sometimes you need to drop down a layer or two to get the performance you need.

I feel I have a renewed appreciation of the craftsmanship of those early days of software. Whilst we don't *need* to understand many (if any) of these complex layers nowadays, I find it fun to look under the hood to marvel and the technical ingenuity which has gone into each one.
