---
layout: post
title: Ruby, OCI8 & an M1 Mac
subtitle: A guide to navigating using Oracle Instant Client & Ruby on M1 arm64 architecture
author: Stuart Frost
date: 2023-03-24
background: /assets/dark-mac.jpg
tags:
  - tutorial
  - m1
  - oci8
---

If you're unfortunate enough to need to connect to an Oracle database using Ruby, you will be familiar with the woes
of having to install [Oracle Instant Client](https://www.oracle.com/uk/database/technologies/instant-client.html)
to be able to use the [Ruby OCI8 gem](https://rubygems.org/gems/ruby-oci8/versions/2.2.2). I have always found this
fiddly and it was made yet more fiddly when I started using an M1 Mac last year.

Oracle have yet to release a version of Instant Client that is compatible with M1 arm64 chipsets which means if you
need to use this gem, it needs a version of Ruby which has been compiled with Intel architecture.

This post will guide you through compiling a version of Ruby in Intel architecture
(x86_64) instead of the new default Apple architecture (arm64).

# Step 1 - install Rosetta

Install Rosetta2, which enables x86_64 compiled code to be run on arm64 M1 processor.

    /usr/sbin/softwareupdate --install-rosetta --agree-to-license

# Step 2 - check current brew installation

First check whether your Brew is installed in arm64 or x86_64
architecture. If you installed Brew normally it is likely to be arm64.

    which brew
    # arm64 location: /opt/homebrew/bin/brew
    # x86_64 location: /usr/local/Homebrew/bin/brew

If your brew is installed in the x86_64 location skip to step 4,
otherwise carry on.

# Step 3 - install Intel compiled Brew

    arch --x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

This will install another instance of brew in `/usr/local/` which is the x86_64 location, leaving your existing arm64 Brew
in place in `/opt/hombrew/`.

In order to easily switch between running commands using the two versions of Brew, I setup an alias.
Add the following to your .zshrc or relevant terminal config. I decided to call mine ibrew short
for Intel Brew. You can call it something else if you want.

    alias ibrew='arch --x86_64 /usr/local/Homebrew/bin/brew'

# Step 4 - install Intel compiled versions of key dependencies

    # check if xcode is installed
    xcode-select -v

    # install xcode-select if not installed
    xcode-select --install

    # install key dependencies for compiling Ruby using our new Intel Brew
    ibrew install openssl readline libyaml zlib bison bison@2.7

    # install any other dependencies you know your gems will need, e.g. if you're using pg or mysql.
    ibrew install libpq mysql

# Step 5 - install Intel compiled Ruby version

Set these environment variables before installing Ruby to tell it where
the key dependencies are installed.

    export PATH="$(ibrew --prefix bison@2.7)/bin:$PATH"
    export CFLAGS="-Wno-error=implicit-function-declaration"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(ibrew --prefix openssl@1.1) --with-readline-dir=$(ibrew --prefix readline) --with-libyaml-dir=$(ibrew --prefix libyaml) --with-zlib-dir=$(ibrew --prefix zlib)"

Choose one of the below, which ever is your Ruby version manager of
choice:

## asdf

    arch -x86_64 asdf install ruby <version>

## rbenv

    arch -x86_64 rbenv install <version>

# Troubleshooting

## Ruby install fails

First try to run the install again, sometimes it installs correctly on the second attempt. If the retry does not work:

After an update to xcode on 4th November 2022, I could no longer install any Ruby version.
Following [this guidance](https://bugs.ruby-lang.org/issues/18912), I had to downgrade xcode to version 13 for it to work.

## Bundle install fails

### mysql2

Mysql2 gem is troublesome but the comment and steps
[here](https://github.com/brianmario/mysql2/issues/1175#issuecomment-891351580)
seem to allow the gem to build.

### pg

If pg gem fails to install stating missing libraries, try installing the
gem with the pg_config of the Intel installed libpq library.

    gem install pg -v '<pg_version_of_project>' -- --with-pg-config=/usr/local/opt/libpq/bin/pg_config

### racecar / rdkafka

If the rdkafka gem fails to install, try setting the flags for openssl
and lz4 before installing the gem. To check these paths are correct for
your machine you can run `ibrew --prefix openssl@1.1` and
`ibrew --prefix lz4`

    export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/lz4/lib"
    export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
    export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

    gem install rdkafka

# Conclusion
That's about all the tips I can give you based on my experiences of using this Gem on my M1 since
last year, let me know if it still doesn't work for you or if there's anything missing from this
set of instructions.
