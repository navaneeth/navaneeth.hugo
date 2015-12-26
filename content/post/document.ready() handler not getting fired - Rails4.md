+++
categories = ["programming", "web", "rails"]
date = "2014-11-18T12:55:32+05:30"
description = ""
keywords = []
title = "document.ready() handler not getting fired   Rails4"

+++

Rails4 uses a gem called [turbolinks](https://github.com/rails/turbolinks) which makes following links on the web application faster. This gem is added to the Gemfile by default when a new rails project is initialized. However, there are few side effects this can cause.

Consider the following JS, added into app/assets/javascripts/projects.js:

```javascript
$(function () {
  $('#startDate').datetimepicker({
		pickTime: false
	});
});
```

This looks alright, but won't work as expected.

When rails navigates to the page following a link, turbolink comes into picture and makes it faster by caching the JS contents. This leads into the ready handler not being fired. Which means, the datetimepicker used in the above example won't work without a full page refresh.

Luckily, this can be fixed by using [jquery.turbolinks](https://github.com/kossnocorp/jquery.turbolinks) gem which works with turbolinks gem ensures the ready handlers are called.
