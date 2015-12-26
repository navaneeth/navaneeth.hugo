+++
categories = ["programming", "c", "debian"]
date = "2015-05-21 10:50:48 +0530"
description = ""
keywords = []
title = "Function strdup implicitly converted to pointer"

+++


I was trying to make a debian package for [libvarnam](http://varnamproject.com). Lot of work went into making the package ready. Debian has very strict rules about how the packaging should be done. Debian also marks few errors as fatal and which may require a code change to fix it. One of the errors I faced was the following:


> Our automated build log filter detected the problem(s) above that will
likely cause your package to segfault on architectures where the size of
a pointer is greater than the size of an integer, such as ia64 and amd64.

> This is often due to a missing function prototype definition.

> Since use of implicitly converted pointers is always fatal to the application
on ia64, they are errors. Please correct them for your next upload.

> More information can be found at: http://wiki.debian.org/ImplicitPointerConversions


The above error failed the build.

The relevant code where the failure happened looks like the following:

```c
char*
strbuf_get_last_unicode_char(strbuf *word)
{
  varray *characters = NULL;
  char *lastUnicodeChar = NULL;
  characters = strbuf_chars(word);

  if (varray_is_empty (characters)) {
    varray_free (characters, NULL);
    return NULL;
  }

  lastUnicodeChar = strdup ((const char*) varray_get(characters, varray_length(characters) - 1)); /* -> Error here */
  varray_free(characters, &free);
  /*ending should be freed in the calling function*/
  return lastUnicodeChar;
}
```

`strdup` is not a ANSI C function, hence it is not portable and not available with all compilers. This has caused the function prototype to be not found. When a function prototype is missing, gcc by default return an integer value. De-referencing the returned pointer will cause a segfault.

To fix this, I found a portable `strdup` implementation in the OpenBSD source code. I have used that and disabled the default `strdup`.
