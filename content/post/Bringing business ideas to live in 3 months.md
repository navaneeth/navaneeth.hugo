+++
categories = ["programming", "startup"]
date = "2015-12-26T12:26:42+05:30"
description = ""
keywords = []
title = "Bringing business ideas to live in 3 months"
+++

Early July, we started working with 2 ex-yahoo friends who had a nice product idea that they wanted to make it live. They had some screen designs on paper and clear cut vision on what the product should look like.

We started with the development, post a week of ideation and technical spikes, and guess what, we had MVP ready for a limited user release in less than 9 weeks and a full production version by the end of October.

The product is called [ShopInSync](http://www.shopinsync.com/).

>  It enables a user to search through millions of products from top ecommerce sites like Flipkart, Snapdeal, and Amazon, and compare prices and offers before buying.

> The app lets shoppers consult their family and friends too – through an integrated messaging service. That is important in a country like India, where even minor shopping decisions can be influenced by social factors.

Here are some screenshots

{{< figure src="/imgs/2015/12/unnamed.png" title="Browse millions of products" >}}
{{< figure src="/imgs/2015/12/unnamed3.png" title="Chat with friends and family about products" >}}
{{< figure src="/imgs/2015/12/unnamed1.png" title="Compare price across different stores" >}}
{{< figure src="/imgs/2015/12/unnamed4.png" title="See all previous chats" >}}

## From design to implementation

We started small. 4 member team working full time on Android, REST services and the feed pipeline. We used weekly iterations and delivered clear cut features every week. Slowly we could see the product shaping up. We were able to unblock each of us so that we could progress in parallel and faster.

The team had not much of overhead. Tasks was prioritized using [Asana](http://asana.com/). We do a weekly plan every Monday and did an internal release every Friday. Build was automated using Jenkins. Every code check-in trigger a Jenkins build. *Jenkins-bot* reports the build status to our Slack channel. We had a single testing server where we can deploy via Jenkins using Ansible. Automating most of the repeated tasks allowed us to move faster and very less time was spent on maintaining the environments.

We were using many *SaaS* services, as much as we could. *ElasticCache*, *Amazon RDS* etc. This also reduced the time spent on maintaining different environments. By late October, we made the first beta release to a closed circle!

## Beta testing with friends and family

Team identified and reached out to a small set of people who helped us in beta testing the application. Many feedback, suggestions, pain points are all addressed. This is the best part in the overall product design cycle. You get to see how people actually see and use the application. Lot of ideas got validated and we were confident that we can move to the public launch.

## Scaling to millions - Production setup

Production setup was another interesting part in the whole game. We had to support many concurrent users and we have pretty huge data too. Production setup was on Amazon AWS. A cluster of EC2 machines, load-balanced using *AWS Elastic Load Balancer* acted as the front-end servers. *PostgreSQL* running *Amazon RDS* with a read replica mode is the database server. All of them was created in a separate VPC.

Here is the server details:

* 3 Front end servers (*m4.xlarge*) running *Ruby On Rails* load balanced using *ELB*
* *PostgreSQL* master and read replica running on *Amazon RDS*
* [Sidekiq](https://github.com/mperham/sidekiq/) for background processing. 350 workers processing different queues, like search indexing etc
* Redis cluster of size 3 (*cache.r3.large*) on *Amazon elastic cache service* is used for the caching layer
* *Elastic search* cluster with 6 nodes powering the search index and aggregations
* Cloundfront CDN
* [Layer](http://layer.com/) for messaging

The above setup had enough room for supporting many concurrent users. We also came up with a plan to scale up if the traffic spikes really high.

We had huge data to process too. Here is some of the statistics

* We had most of the products from Amazon, Flipkart and Snapdeal. PostgreSQL DB holds 30+ million records.
* Elastic search index also holds 30+ million products
* API uses heavy use of cache and it caches as much as possible for high performance

With all of these, we were able to achieve the following

* All of the API endpoints responded with an average latency of 200-300ms
* All long running calculations are done in the background jobs causing no blocking for API clients
* Load balancing provided high availability and throughput
* Database queries performed really well with the indices on frequently used columns
* Search index was returning search results with milliseconds

## Press release

Product release is incomplete without some publicity. ShopInSync received very good publicity. Many national and local new papers covered the story.

From [Techcircle](http://techcircle.vccircle.com/2015/11/26/shopinsync-makes-online-shopping-a-collaborative-experience/)

> “With the e-commerce sector booming and expanding, we realised that consumers have multiple options to choose from when it comes to online shopping. What we also comprehended is most of these purchases are done in consultation with friends and family. So the idea behind ShopinSync is to bring these two worlds together and make online shopping a more convenient process for the shoppers,” Raj Ramaswamy, co-founder, ShopInSync, told Techcircle.in.

From [The Hindu](http://www.thehindu.com/business/Industry/silicon-valley-investors-back-shopinsync-app/article7909227.ece?utm_source=RSS_Feed&utm_medium=RSS&utm_campaign=RSS_Syndication)

> A group of Silicon Valley-based investors, including Vijay Ragavan, former head of engineering at Internet company,Yahoo, are backing a four-month-old ecommerce technology startup ShopInSync.

> The firm has built an app that enables shoppers to search and buy products from various online retailers such as Flipkart, Snapdeal and Amazon by integrating them on to a single platform. The app, which was released on Monday on Google's Android platform, offers features such as comparison of product prices. It also enables consumers to collaborate with friends and family to buy products via an integrated messaging service.

From [TechInAsia](https://www.techinasia.com/exyahoo-friends-human-shop)

>  It happens often. You impulse-buy a gadget and end up regretting it. If your best friend had been around, you might have known of a smarter, cheaper, alternative in the store next door. That’s equally true of clothes, furniture, and a zillion other things.

> Friends and family often hold the key to a happy purchase. They help you make an informed choice and pick the right stuff – especially when you are buying online. But how do you get them to see and approve from miles away?

It was an awesome experience to watch the monitoring dashboards and seeing traffic spiking. The kick that you get from seeing this can only be experienced!

## Road forward

Journey continues. There will be more new features, more stores and many more performance improvements. We plan to release iOS first week on January.

You have an idea, now what? Just contact us to get started.

Cheers!
