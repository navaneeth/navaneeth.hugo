+++
categories = []
date = "2014-03-23 13:00:00 +0530"
description = ""
keywords = []
title = "how to get lintian warnings when using ubuntu"
+++

Recently, I started to package [libvarnam](https://gitorious.org/varnamproject/libvarnam) for Debian. I followed the debian packaging guidelines and successfully created a package. I am using Ubuntu instead of Debian to do the packaging. Since Ubuntu is based on Debian, packaging also has the same procedure.

Debian requires all the packages to be `lintian` clean. Lintian is a command line utility which checks for errors and standards violations in the package files. My package was lintian clean and I have uploaded it into the debian mentors page seeking for sponsors. Then I noticed several lintian errors showing up in the mentors page. This was not coming up in my local lintian run.

The main reason why lintian errors was showing differently on my local machine was because my local lintian uses Ubuntu's profile settings and Debian has more strict rules than Ubuntu.

When lintian is installed, it installs the files in to the following directory.

```bash
> ls /usr/share/lintian/profiles
debian  ubuntu
```

To get the warnings which lintian emits on a Debian machine, use the following command.

```bash
> lintian --pedantic --profile debian yourpackage.changes
```

This will show the exact warnings which mentors.debian.net is showing. This way you can do the debian packaging within ubuntu and make sure all the debian lintian checks are passing before uploading the package.
