# Power of Micro Data Centers

> Author: Sasank Chilamkurthy

I have had the good fortune of being an author of [policy note](https://pplus.ai/micromega) about micro data centers (MDC). The paper was led by [EkStep foundation](https://peopleplus.ai/occ), the same folks behind UPI, ONDC and other such spectacularly successful projects. Micro data centers, as name suggests, is a small scale data center in about 50 KW to 300 KW power range. They can be a viable alternative to centralized mega data centers which can guzzle up to 10,000 KW or more power.

In this post, I want to explain power engineering characteristics of micro data centers. After all, I am an [electrical engineer](https://chsasank.com/what-I-learnt-at-iit-bombay.html) trained at IITB! Many of my friends and family are also into Electrical Engineering. For example, my [school/college classmate](https://twitter.com/prudhvitej157) is now a managing director for Andhra Pradesh's power distribution company. These power distribution companies are called DISCOMs for short. I spoke to DISCOM engineers and more about micro data centers.

Besides, I am looking to setup one such micro data center myself. So, I do have skin in the game about what I am talking. So let's go about this!

## Data Center Infrastructure

Data centers traditionally are measured in terms of how much power is consumed by the them. This makes sense because reliable power tends to be the biggest factor in setting them up. How so?

Computers in data centers need to be turned on all the time. They can't be powered down because remote users using computers might experience service outages. Almost every application you use these days are run from a data center. This includes Whatsapp, Google, Slack and what not. Computers configured this way are called *servers*.

So, we need *uninterrupted* power supply! How much uninterrupted power do we need? We can measure this in terms of number of Nvidia H100s you want to put in your data center. As a thumb rule, We can budget roughly 1 KW per a H100 GPU. So with 100 KW, we can host about 100 H100 GPUs. A 1000 GPU cluster will then require 1000 KW or 1 MW.

How do we go about getting 100 KW of uninterrupted power? Firstly, we need to get power connection from DISCOM rated for that load. Secondly, we need to have local backup power source -- usually a diesel generator.

### Power Connection

Let's talk about DISCOM power connection. There are two sort of power connections you can get for this sort of load: LT for low tension and HT for high tension. LT is the default connection we get in our apartments and homes. Many shops and commercial establishments also opt for it if their power requirements are not too high (<100 KW). HT is the connection you'd get if you have a lot of power requirements.

From the overall power infrastructure point of view, HT and LT are not too different. In LT, your DISCOM maintains/installs the step down transformers from high voltage transmission lines to convert to normal 220V socket. This transformer, owned by the DISCOM, supplies to multiple LT power connections. In HT on the other hand, you directly get the high voltage line and maintaining/installing step down transformer is your problem. As you can guess from this description, HT is for higher wattage requirements and is more reliable.

Let's do some math for power bill of a 100 KW data center. We'll assume you have taken HT-2B connection and gotten yourself a transformer. I have taken the following image of tariffs from Karnataka's electricity regulatory commission. 

![Karnataka Power Costs](/_static/blog/kerc_power_tariff.png)

There are two sections in this: fixed charges and energy charges. Fixed charges is what you pay per month for total load you have taken. For 100 KW, that will be 365 INR/KW * 100 KW = 36,500 INR. Next we have energy charges. Let's assume we do 50% of capacity utilization i.e. on average we consume 50% of peak load. So that gives us 100 KW * 50% * 24 hours * 30 days / month = 36000 KWh or units. That comes down to 8.00 INR/unit * 36000 units = 2,88,000 INR. So your total monthly bill is about INR 3,24,500. 