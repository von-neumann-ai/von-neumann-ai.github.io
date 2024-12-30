# JOHNAIC: Year One


It's been an year since I started my journey with building computers. I think it's worth sitting down and reflect on the path we have taken over last one year. So here we go.

## Building Computers

I built up intense interest in computers and programming languages since I read biographies of [Turing](https://www.goodreads.com/book/show/150731.Alan_Turing), [Licklider](https://www.goodreads.com/book/show/722412.The_Dream_Machine), [Von Neumann](https://www.goodreads.com/book/show/61089520-the-man-from-the-future) and [Steve Jobs](https://www.goodreads.com/book/show/11084145-steve-jobs) in 2023. I have always been a history buff and studied historical computers like ENIAC, JOHNNIAC, Lisp Machines, IBM System 360, Intel 4004, Apple II. Computers, something we take granted as we read this, looked very different back in those days. History put much needed perspective on computers for me.

Computers were a product of industrial revolution. First and foremost they are machines. They always existed to automate things. [John McCarthy in 1950s](https://chsasank.com/classic_papers/darthmouth-artifical-intelligence-summer-resarch-proposal.html), before we even had computers based on transistors, called this automation 'Artificial Intelligence'. Turing, father of modern computers, [called this automation](https://web.iitd.ac.in/~sumeet/Turing50.pdf) 'Thinking Machines'. What's not lost on me are that they are *machines* still.

Another important fascination for me is manufacturing. I came to accept that doing software alone for some remote computers, aka [SaaS](https://en.wikipedia.org/wiki/Software_as_a_service), is saturating. I studied [supply chain mechanisms](https://www.amazon.in/Supply-Chain-Management-Strategy-Operation/dp/0133800202) of [Ford and Toyota](https://www.amazon.in/Machine-That-Changed-World-Revolutionizing/dp/0743299795) and learnt how they put together crazy *machines* that are cars. I visited modern electronic factories in [Sahasra Noida](https://g.co/kgs/QyH6q7V) and [Dixon Tirupati](https://g.co/kgs/UJvKetX). I learnt that manufacturing is much easier than people make it out to be! And it's ultra scalable.

![Adithya Building a JOHNAIC](/_static/blog/adithya-building-computers.jpg)


Thus, it became almost a holy mission for me to manufacture computers.

## Compilers Bug

I can clearly see that what mattered for these thinking machines is the amount of compute they have access to. What's special with OpenAI is that they had the guts and GPUs to put money behind so called [scaling laws](https://arxiv.org/pdf/2001.08361). There was no fundamental architectural innovation behind GPT-3 except that they just trained bigger model for longer. This idea of hardware lottery is [observed through out the computing history](https://arxiv.org/pdf/2009.06489). Richard Sutton puts [this succinctly](http://www.incompleteideas.net/IncIdeas/BitterLesson.html):

> The biggest lesson that can be read from 70 years of AI research is that general methods that leverage computation are ultimately the most effective, and by a large margin.

There's a reason that Nvidia gained the most in terms of stock price with current AI boom. However there is also a nefarious reason why Nvidia is the only one that cashed in the most among semiconductor stocks. Nvidia's CUDA compiler framework is that reason. Compilers take human written code and convert them to machine understandable instructions. Most AI code written today works only on Nvidia GPUs. I have given a talk ([slides](https://chsasank.com/assets/slides/opensource-gpu-stack.pdf)) about this at a Hasgeek event ([video](https://www.youtube.com/watch?v=dY_M0j4OMQw)).

This bug in the AI ecosystem allows Nvidia to segment us into GPU rich and GPU poor. It is able to charge us more for less. I spent a lot of time this year solving this bug. We have dug up an amazing C++ framework called [SYCL](http://chsasank.com/sycl-portable-cuda-alternative.html) and [benchmarked it](https://chsasank.com/portblas-portable-blas-across-gpus.html). We discovered that LLVM as a framework [doesn't cut it](https://chsasank.com/intermediate-representations-for-gpu.html) as a compiler framework for GPUs. We created our own compiler framework called [C-lisp](https://github.com/chsasank/llama.lisp/tree/main/src/backend) and presented about it at a [compiler conference](https://arxiv.org/pdf/2410.16690) ([video](https://www.youtube.com/watch?v=FeML_j7pdNY)).

![Vedanth Presenting Compilers](/_static/blog/vedanth-compiler-tech-2024.png)


## Cloud Tax

As much fun we had doing this, we soon realized the real villain in the compute story is not Nvidia but cloud. Thanks to our customers at People+AI, we figured that cloud folks are [wildly overcharging](https://www.reddit.com/r/devops/comments/1cwi1gn/when_did_the_cloud_become_so_stupid_expensive/) for the compute due to the oligopoly structure in the market. While Nvidia does extract their CUDA tax, [cloud tax](https://world.hey.com/dhh/why-we-re-leaving-the-cloud-654b47e0) is 10x the CUDA tax. To solve compute scaling, we have to [tackle cloud](https://von-neumann.ai/blog/ola-cloud-costs.html) on its pricing.

I did a lot of research on data centers in the view of setting up one. People+AI launched an initiative called [Open Compute Cloud](https://peopleplus.ai/occ). We ended up writing a [policy note](https://pplus.ai/micromega) on Micro Data Centers. My model was [Vigyanlabs](https://maps.app.goo.gl/CCKAhVPBBqhe51SH9) data center in Mysore. I searched for real estate so that I can [setup a small data center](https://von-neumann.ai/blog/micro-data-centers-power.html) in the center of Bangalore myself. Real estate operations proved wildly difficult and I realized product development is going to take forever if I go down this path. 

![Tanvi Presenting OCC](/_static/blog/tanvi-presenting-occ.png)
 
Customers again showed the path here. My customers already have real estate sorted and it's called their office or house! All I needed to do is to ensure that the computers have constant power. So I designed systems with low power consumption and to run on uninterrupted power supply (UPS) that I can ship to them. They experimented on network connections and showed that a combination of fiber and 5G SIM allows for super reliable network.

## Getting to the Edge

This is where things started getting real as the year went on. I launched JOHNAIC computer at People+AI's event called [Adbhut India](https://youtu.be/1Uu9UWwJ3QE?list=PLH2jjgHdv4Kckqp0inG5s9z07oIRgw60e&t=1161). We started working with their dev teams super closely. We found that we could deploy their cloud applications in a JOHNAIC directly hosted in their office. We have setup production level devops practices like uptime tracking and status pages. This made everything super reliable and easy from the point of view from customers.

![Tanuj Receiving JOHNAIC](/_static/blog/tanuj-receiving-johnaic.jpg)

We started working with more customers starting June. A [customer](https://x.com/officialkrishd) hosted his AI app and eventually scaled it all from a JOHNAIC. Another customer took a machine for private [stable diffusion influencing](https://von-neumann.ai/blog/stable-diffusion-as-service.html). We worked super closely with the customers and we improved our operating system and deployment stack considerably. One of the latest customers say that

> The time to deployment is tiny, and is the right amount of overhead for my stage. cloud providers are really suited toward overengineered enterprise devops orgs

However convincing new developers to trust JOHNAIC with their production workloads has been really hard so far. So I have decided to bundle my own cloud applications along with JOHNAIC. I have created a stack of applications for communication, documentation, sales, customer support etc, all hosted from JOHNAIC. I presented this at a [Moneycontrol event](https://www.youtube.com/watch?v=Mw-iAhJ4VXU). Customers seem to love this new application first pitch, but it's too soon to tell.

## Summary

Looking back, it was a wild 2024. I learnt so many things, mainly from customers. They took me [closer to the market](https://chsasank.com/something-personal.html). I moved from computers to GPUs to cloud to finally the edge. I think I have found a decent market fit with edge computing. Next year, I need to refine, validate and scale this up. Let's see where this goes but I am super confident, all thanks to customers! 

> Published on 30/12/24
