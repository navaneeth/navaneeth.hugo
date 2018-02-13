+++
categories = ["programming"]
date = "2018-02-13T11:20:36+05:30"
description = "Command line epoch converter"
keywords = []
title = "Command line epoch converter"
draft = false
+++

In a recent project, I had to work with lots of `epoch` timestamps. Every JSON value, db column, contains epoch value. To convert back and forth, we used online utilities like epochconverter. But all of the are a pain to use for obvious reasons.

Here is a simple command line utility which will simplify your life with epoch values.

To install:

```
go get gitlab.com/navaneethkn/epoch
```

Usage:

```
$ epoch
1518501586685673000

$ epoch -format sec
1518501655

$ epoch 1518501586685673000
2018-02-13 11:29am (IST)

$ epoch "2018-02-12 11:29am (IST)"
1518415140000000000
```

Happy programming!
