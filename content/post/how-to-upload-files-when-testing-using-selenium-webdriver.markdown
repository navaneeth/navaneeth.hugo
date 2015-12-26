+++
categories = ["programming", "java", "selenium"]
date = "2013-02-20T12:59:50+05:30"
description = ""
keywords = []
title = "How to upload files when testing using Selenium Webdriver"
+++

You can use the following code to set a file path to the file upload control.

```java
WebElement file = driver.findElement(By.id("control_id"));
file.sendKeys("/full/path/to/file");
```

You need to pass full path to the `sendKeys()` for it to work. Otherwise `sendKeys()` fails silently.
