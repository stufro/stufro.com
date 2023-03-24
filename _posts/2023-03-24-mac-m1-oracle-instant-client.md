---
title: Ruby, OCI8 and an M1 Mac
date: 2023-03-24
layout: post
tags:
  - tutorial
  - m1
  - oci8
---

This guide you through compiling a version of Ruby in Intel architecture
(x86_64) instead of the new default Apple architecture (arm64). This is
only required when using gems such as
[ruby-oci8](https://www.rubydoc.info/gems/ruby-oci8/file/docs/install-on-osx.md)
because there is not yet a version of Oracle Instant Client which is
compatible with arm64 architecture.

## Step 1 - install Rosetta

Install Rosetta2, which translates Intel code to ARM (M1).

    /usr/sbin/softwareupdate --install-rosetta --agree-to-license

## Step 2 - check current brew installation

First check whether your Brew is installed in arm64 or x86_64
architecture. By default it is likely to be arm64.

    which brew
    # arm64 location: /opt/homebrew/bin/brew
    # x86_64 location: /usr/local/Homebrew/bin/brew

If your brew is installed in the x86_64 location skip to step 4,
otherwise carry on.

## Step 3 - install Intel compiled Brew

    arch --x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

For ease of use, it's wise to setup an alias so you can differentiate
between using arm64 brew and x86_64 brew. Add the following to your
.zshrc or relevant terminal config. I decided to call mine ibrew short
for Intel Brew. You can call it something else if you want.

    alias ibrew='arch --x86_64 /usr/local/Homebrew/bin/brew'

## Step 4 - install Intel compiled versions of key dependencies

    # check xcode, should yield : /Library/Developer/CommandLineTools
    xcode-select -p

    # check xcode, should yield : xcode-select version 2384
    xcode-select -v

    # install xcode-select if not installed
    xcode-select --install

    # install key dependencies for compiling Ruby
    ibrew install openssl readline libyaml zlib bison bison@2.7

    # if you're likely to use the pg, mysql gems (if you're working on NOC tools for example) install these additional packages
    ibrew install libpq mysql

## Step 5 - install Intel compiled Ruby version

Set these environment variables before installing Ruby to tell it where
the key dependencies are installed.

    export PATH="$(ibrew --prefix bison@2.7)/bin:$PATH"
    export CFLAGS="-Wno-error=implicit-function-declaration"
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(ibrew --prefix openssl@1.1) --with-readline-dir=$(ibrew --prefix readline) --with-libyaml-dir=$(ibrew --prefix libyaml) --with-zlib-dir=$(ibrew --prefix zlib)"

Choose one of the below, which ever is your Ruby version manager of
choice:

### asdf

    arch -x86_64 asdf install ruby <ruby_version_of_project>

### rbenv

    arch -x86_64 rbenv install <ruby_version_of_project>

# Troubleshooting

## Ruby won't install

First try to run the install again, sometimes it installs correctly on
the second attempt. If the retry does not work:

After an update to xcode on 4th November, I could no longer install any
Ruby version. Following [this
guidance](https://bugs.ruby-lang.org/issues/18912), I had to downgrade
xcode to version 13 for it to work.

## I can't bundle install

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

## Can I just reinstall rbenv/ruby in Rosetta mode instead of going all the way back to Brew?

We didn't attempt this in the fear of mixing packages and the
architectures they were installed under. Though, feel free to try and
report back your findings.

**Update November 2022:** This doesn't seem possible, you need an intel
version of Brew installed so that you can install intel versions of key
Ruby dependencies such as readline and openssl.
