+++
categories = ["programming", "cmake"]
date = "2013-07-28T13:02:25+05:30"
description = ""
keywords = []
title = "Building static and shared libraries using CMake"

+++

Recently in [libvarnam](https://github.com/navaneeth/libvarnam), I had to build a static and shared library from the same source files. This was much harder before CMake 2.8. From CMake 2.8.8, CMake has support for `Object library` which made it very simple.

Basic idea is to use `add_library` with `OBJECT` type. CMake will compile all the source files provided in this target and makes the object files for it. It won't create a temporary static library with all these object files. These object files can later be referred in the target which builds the library. In my CMakeLists.txt, I have the following.

```c
add_library (core OBJECT ${SOURCES})
add_library (static STATIC $<TARGET_OBJECTS:core>)
add_library (shared SHARED $<TARGET_OBJECTS:core>)
```

The above will build static and shared library from the same set of object files. This improves compilation time considerably as source files will be compiled only once and used in multiple targets.
