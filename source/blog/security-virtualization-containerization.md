# Security: Virtualization and Containerization

> Author: Sasank Chilamkurthy
> Published: 26/09/2024

Over the last few weeks, we have been working on security of JOHNAIC, an important concern for us. After all, our main pitch is all about privacy, sovereignty and security of your data. So we take security very seriously. In this post, I talk about our learnings with virtualization and containerization.

People have different definitions of what security means to them. Dictionary says 

> Security (noun): the state of being free from danger or threat.

Where do the threats for a server like JOHNAIC come from? Layman would think that some 'hacker' will mess with your system and threaten your applications. However, people don't realize 'hacker' might actually be a user of the system. User could be anyone who accesses services hosted from server: whether that is a HTTP website, database or SSH connection. Therefore 'hacker' is just another user.

This brings me to my operational definition of security: 

> one user of the system should not be able to interfere with another user unless she explicitly gives permission. 

Sometimes users might look so legitimate that the free interference of them for other user might feel just fine. But these are the sort of loopholes 'hackers' use to bring down the whole or part of the system. This operational definition also bakes in reliability to the system. If a user is able to type in some commands and bring down the whole system, it is obviously interfering with other users.

Does this sound too abstract? Let's make it concrete with highly relevant example: virtualization/containerization.

## Sudo: Bane of Security

Linux users, especially developers, should have used `sudo` at least at one point of their life. Ever wondered what it does? 

![](https://imgs.xkcd.com/comics/sandwich.png)

Linux has a concept called `root` user who can modify *anything* with the system. `root` user is someone who has *complete* access to everything. They are like God of the system: they can create or delete any file or process - no matter who the owner. With such a great power comes great responsibility.

![](https://i.kym-cdn.com/entries/icons/facebook/000/017/572/uncleben.jpg)


