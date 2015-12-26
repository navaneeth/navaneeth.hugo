+++
categories = ["programming", "c#", "threading"]
date = "2013-02-19T12:59:50+05:30"
description = ""
keywords = []
title = "Is Thread.Sleep() evil?"
+++

If you search for this topic, you will find lots of information and many of them claiming `Thread.Sleep()` is evil. However, I think this evilness is mostly dependent on which context `Thread.Sleep()` is used.

You might have seen code like the below one.

```csharp
while (!exit)
{
    DoWork();
    Thread.Sleep(10000);
}
```

This code example does some work and sleeps for 1 minute before does the job again. This simple example has some potential issues.

Internally `Thread.Sleep()` calls WIN32's [Sleep](http://msdn.microsoft.com/en-us/library/windows/desktop/ms686298%28v=vs.85%29.aspx) function. This is what MSDN says about Sleep function.

> This function causes a thread to relinquish the remainder of its time slice and become unrunnable for an interval based on the value of dwMilliseconds. The system clock "ticks" at a constant rate. If dwMilliseconds is less than the resolution of the system clock, the thread may sleep for less than the specified length of time. If dwMilliseconds is greater than one tick but less than two, the wait can be anywhere between one and two ticks, and so on.

It is clear that `Sleep()` won't sleep exactly for the interval specified. This can be problematic if your application needs to be accurate with the intervals. This is also dependent on how much load CPU has. If CPU is really overloaded, this time could be longer. This also makes it hard to tell when the job will run next time. If you have done some action which needs to be processed by the background job and not knowing when background job will kick in next time is bad.

If your thread is running with a low priority, sleep duration could be more than the specified interval.

If you are trying to implement something which runs periodically, use `System.Threading.Timer` class which provides better scheduling capabilities. It runs the callback at specified intervals on a thread pool thread.

Is `Thread.Sleep()` really evil? NO, if you understand all the above problems and you are OK with the above behaviour. Yes otherwise.
