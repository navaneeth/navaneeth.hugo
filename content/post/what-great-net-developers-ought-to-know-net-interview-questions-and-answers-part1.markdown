+++
categories = ["programming", ".net", "c#"]
date = "2009-08-13T12:59:50+05:30"
description = ""
keywords = []
title = "What Great .NET Developers Ought To Know (More .NET Interview Questions and Answers) – Part1"
+++

In this series of posts, I will try to answer the questions posted by Scott Hanselman [here](http://www.hanselman.com/blog/WhatGreatNETDevelopersOughtToKnowMoreNETInterviewQuestions.aspx). This part we will be seeing the first set of questions he has given under *Everyone who writes code* heading.

**Q) Describe the difference between a Thread and a Process?**

A Thread is a small unit of code in execution. A process is an instance of program which will have multiple threads running. A process can host multiple threads. Thread will always belong to a process. Communication between multiple processes are difficult but communication between threads is easy.

**Q) What is a Windows Service and how does its lifecycle differ from a “standard” EXE?**

Windows service is a long running program which can run without user interaction. It is used for applications that should work always, e.g: a HTTP server. Unlike standard EXE, a windows service can’t be started by double clicking the EXE. It should be installed on the system as a service using installutil tool. Service control manager manges a windows service by providing options to start/stop a service.

Like a standard EXE, windows services lifecycle also begins from the main method. After that it fires the event OnStart in which you can write code for starting a service.

**Q) What is the difference between an EXE and a DLL?**

A executable file(EXE) is ready to execute wherein a Dynamic Link Library(DLL) contains types and methods that can be used from a EXE. DLLs are not meant to be executed directly and it is very helpful to organize and isolate common code which can be used with multiple applications.

Finally, EXE will have an entry point. DLLs will not have an entry point and all it does is to expose the types and methods. The direct equivalent of a DLL in LINUX is Shared Libraries(SO).

**Q) What is strong-typing versus weak-typing? Which is preferred? Why?**

Strong-typing defines some restrictions on how operations are done when different data types are involved. Consider the following example

```csharp
int a = 10;
a = "You can't assign a string!";
```

Above code won’t compile as variable a is strongly-typed and it can hold only an integer value.

Weak-typing is just opposite of strong-typing. C# is a strongly-typed language. But since most of the types derives from System.Object, you can write like.

```csharp
object o = 10;
```

This can be called as weak-typing. Of course, strong-typing is preferred over weak-typing. To understand why, consider the following example in which we have a collection of age.

```csharp
ArrayList ages = new ArrayList();
ages.Add(10);
ages.Add(20);
ages.Add(30);
ages.Add("Hey, I am not an age!");
```

Our intention is to have only ages in this collection. But since ArrayList is weakly-typed, we inserted a value which is not an age. Here is a strongly-types version of this code.

```csharp
List<int> ages = new List<int>();
ages.Add(10);
ages.Add(20);
ages.Add(30);
ages.Add("I am not an age"); // <- compiler error here
```

**Q) What is a PID? How is it useful when troubleshooting a system?**

PID is Process Identifier and used by operating system to identify processes uniquely. I am not sure how it is used for troubleshooting. If some can provide insights into this, I will update this area.

**Q) How many processes can listen on a single TCP/IP port?**

Only one.

**Q) What is the GAC? What problem does it solve?**

GAC stands for Global Assembly Cache. It provides a centralized storage for assemblies that needs to be shared across applications. It solved the versioning problem and allows side-by-side execution. It can be used when assemblies require elevated permission to do the job.
