+++
categories = ["programming", "android", "java"]
date = "2015-12-30T18:30:50+05:30"
description = ""
keywords = []
title = "oh my jackson!"

+++

[Jackson](https://github.com/FasterXML/jackson) just made my day!

Today, I had to make some changes to one of our API. The change was minor so I have added additional fields into my JSON response. I have also kept the old fields just to make the existing clients happy.

During testing, I figured out that the change breaks existing clients. I was surprised! The error was,

> org.codehaus.jackson.map.exc.UnrecognizedPropertyException: Unrecognized field "image" (Class Promotion), not marked as ignorable

Alright; I thought. Android developer must be a very strict guy and failing when the response structure has additional fields.

But he was not doing anything explicit to make the parsing strict.

It looks like, Jackson's by default parsing mode is strict and it fails when there are any extra fields. Stupid! I have never seen any JSON parser doing this. I have used Ruby, C#, Golang and everywhere no library will have this option turned on by default.

Now this caused additional pain and I had to introduce another version of the API. We have also configured Jackson not to do strict parsing.
