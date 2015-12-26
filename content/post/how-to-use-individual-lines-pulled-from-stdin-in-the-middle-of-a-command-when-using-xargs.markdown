+++
categories = ["programming", "linux"]
date = "2013-02-28T12:59:50+05:30"
description = ""
keywords = []
title = "How to use individual lines pulled from stdin in the middle of a command when using xargs"
+++

`xargs` is very powerful commandline utility. Here is what Wikipedia says about `xargs`

> xargs is a command on Unix and most Unix-like operating systems used to build and execute command lines from standard input

Most common use of `xargs` would be to do something like,

```bash
find . -type f -print0 | xargs -0 rm
```

Let us assume that you have a file with list of files to be downloaded from a website. Something like,

```
one.zip
two.zip
three.zip
```

With `wget` and `xargs` all these files can be downloaded easily with just one command.

```bash
cat filenames.txt | xargs -I filename wget http://download.com/filename
```

`-I` flag takes a replacement string and `xargs` will then replace `filename` with the value obtained from `stdin`.
