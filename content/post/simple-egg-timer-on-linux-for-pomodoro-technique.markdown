+++
categories = ["programming", "linux", "pomodoro", "shell"]
date = "2010-12-19T12:59:50+05:30"
description = ""
keywords = []
title = "Simple egg timer on Linux for Pomodoro technique"
+++

Recently I have started evaluating the Pomodoro Technique which I found quite interesting. I am still evaluating the technique and not yet concluded on whether I should continue using it.

To implement pomodoro technique, you need a kitchen timer or egg timer. Since I use pomodoro for my programming work, I obviously don’t want to use a physical timer. I couldn’t find a decent timer for linux especially one that works well with Xfce. In this blog post, I will explain building a kitchen timer with basic linux programming techniques. This also gives an idea about how simple linux tools can be combined to do useful stuff.

Things that are used

* Shell scripting
* Notification mechanisms on popular desktops like Gnome and Xfce. (I use Xfce in this example)

The shell script is actually a modified version of the one published here (http://mostlylinux.wordpress.com/commandline/eggtimer/).

```sh
#!/bin/bash
counter=0
limit=$1
summary=$2
startmessage=$3
endmessage=$4
notify-send -u critical -i appointment -t 600 "$summary" "$startmessage"
echo
while [ $counter != $limit ]; do
   echo "$counter minutes so far...";
   sleep 60
   let "counter = $counter + 1"
done
if [ $counter = $limit ]; then
   echo
   notify-send -u critical -i appointment "$summary" "$endmessage"
   echo -e '\a' &gt;&amp;2
   exit 0
fi
```

All it does is wait until the limit reaches. It uses the sleep(1) command to sleep for a minute. notify-send is used for sending notifications to the desktop environment.

This script can be invoked using,

```sh
./p-timer.sh
```

If you use bash, you can add an alias for convenience.

```sh
alias begin-pomodoro='sh ~/utils/p-timer.sh 25 "Pomodoro" "Pomodoro started, you have 25 minutes left" "Pomodoro ended. Please stop the work and take short break"'
```

This post is written on one pomodoro!

Happy programming!
