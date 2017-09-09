+++
categories = ["programming", "journal"]
date = "2017-09-09T14:40:26+05:30"
description = " "
keywords = []
title = "Bigdata buzz"
+++

Bigdata is the new buzzword. Programmers take pride in working with Bigdata technologies. Unfortunately, most of them don't have any clue about bigdata and the tools they claim to be using. 

Last few days, I was interviewing candidates for our team. We work on the so called big data tech. But our data is not yet big and we can get away with simple scripts for now. But we stil use tools like *Apache spark*, *Kafka* etc.

The recruitment agency sent us few profiles all claiming to be experts in *Hadoop*, *Hive*, *Spark* etc. The resumes looked really good and we called them for in-office interview. 

Surprisingly, none of them knew any of the technologies they mentioned in their resumes. I started with simple map-reduce questions. All of them were familiar with map-reduce concepts. But none applied it in practice.

The problem was simple:- Read a text file using Spark and count the word occurances. Something simple like the following will do the trick

```scala
val result = sc.textFile("data.txt").flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey((sum, wordCount) => sum + wordCount)
```

Surprisingly, no one even reached till the first `flatMap`. 

If you are someone who claim to be a Bigdata programmer the you should

* Ensure you understand the basics of Map & Reduce operations
* Don't learn just theory. Keep practicing until you master the subject
* Processing big data is not as fancy as it sounds. It is all about doing boring map and reduce operations
* Half of the requirements for big data are not real big data
* Don't fall in the big data buzz and wrongly claim to be an expert
