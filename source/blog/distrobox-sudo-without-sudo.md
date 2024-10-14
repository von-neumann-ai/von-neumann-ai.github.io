# Distrobox: `sudo` without `sudo`

> Author: Sasank Chilamkurthy

Distrobox is a super flexible tool that comes preinstalled in JOHNAIC. It allows you to setup different Linux distributions and create your own development environment. The killer feature is the ability to do `sudo` even if your account doesn't have it. This creates a perfect experience for a developer where they feel *both* powerful and safe. In this post, I'll quickly explain how distrobox works followed by a quick hands on.

## How it works

In [previous](https://von-neumann.ai/blog/security-virtualization-containerization.html) [posts](https://von-neumann.ai/blog/security-rootless-containers.html), we discussed ways to balance user power and protection of other users from this power. Virtual machines and containers were presented as solutions to this problem. Industry moved from VMs to containers because containers are both light weight and secure. We saw that rootless containers from podman further improve the security posture.

By default, containers present independence from the host system. They have their own filesystem and network separate from host system. You need to publish ports and define mounts if you want to expose a part of the host system to the container. Let's see this in action. Here are some of the files in my downloads folder in host system.

```
sasank@JOHNAIC:~$ ls ~/Downloads/
Miniconda3-py311_24.7.1-0-Linux-x86_64.sh
```

Let's run a container in another terminal

```
sasank@JOHNAIC:~$ podman run -it --rm ubuntu bash
root@ca3fec3a2731:/# ls ~/Downloads/
ls: cannot access '/root/Downloads/': No such file or directory
```

Note how your files are not available inside the container. Similarly network is isolated by default. Install python inside container and run a quick file server.

```
root@675d674baf59:/# apt update && apt install -y python3
root@675d674baf59:/# python3 -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

Now in the host system, try accessing this http server using curl. Your connection will be refused. Thus network is isolated as well.

```
sasank@JOHNAIC:~$ curl 0.0.0.0:8000
curl: (7) Failed to connect to 0.0.0.0 port 8000 after 0 ms: Connection refused
```

This sort of isolation is very useful when you want to run multiple applications in their own sandboxes independent of each other. However, this also becomes very restrictive for a user on the machine if he's using container as a sort of OS for his development. He should be able to access his home folder and expose whatever ports he can. Thus we have distrobox with tight integration of containers with the host.

Distrobox creates a user with the same username as you inside the container, mounts your home folder into it, binds all non-privileged container ports to the host ports. The root directory remains isolated inside the container. This creates an amazing experience for the user where he can run `sudo` inside a distrobox to install his packages. His home folder and code in it will be shared across different distroboxes he uses.

Distrobox uses a container engine to achieve all this -- either docker or podman. In JOHNAIC, distrobox is configured to work with rootless podman. This means that users themselves are sandboxed between each other thus ensuring security. Anyway, let's get to hands on!

## Hands on

Here's how you create a new ubuntu distrobox

```
sasank@JOHNAIC:~$ distrobox create --name my-distro --image ubuntu:22.04 --additional-flags "--device nvidia.com/gpu=all"
Creating 'my-distro' using image ubuntu:22.04    [ OK ]
Distrobox 'my-distro' successfully created.
To enter, run:

distrobox enter my-distro
```

Let's break down what's going on here. 

* `create` asks distrobox to create a new distrobox
* `--name my-distro` set the name of this box to my-distro
* `--image ubuntu:22.04` asks distrobox to use ubuntu 22.04 as the base distribution. You can use many other distros like Debian, Fedora and openSUSE etc.
* `--additional-flags "--device nvidia.com/gpu=all"` makes nvidia gpu available inside the distrobox


Now let's enter the newly minted distrobox. When you enter a distrobox the first time, it sets it up with basic packages etc. This might take a while but it happens only once.  

```
sasank@JOHNAIC:~$ distrobox enter my-distro
Starting container...                            [ OK ]
Installing basic packages...                     [ OK ]
Setting up devpts mounts...                      [ OK ]
Setting up read-only mounts...                   [ OK ]
Setting up read-write mounts...                  [ OK ]
Setting up host's sockets integration...         [ OK ]
Integrating host's themes, icons, fonts...       [ OK ]
Setting up package manager exceptions...         [ OK ]
Setting up dpkg exceptions...                    [ OK ]
Setting up apt hooks...                          [ OK ]
Setting up distrobox profile...                  [ OK ]
Setting up sudo...                               [ OK ]
Setting up groups...                             [ OK ]
Setting up users...                              [ OK ]
Setting up skel...                               [ OK ]

Container Setup Complete!
sasank@my-distro:~$ 

```

Note how my prompt changed to `sasank@my-distro`! I am now inside distrobox. Let's play around inside distrobox. My Downloads are available as is!

```
sasank@my-distro:~$ ls ~/Downloads/
Miniconda3-py311_24.7.1-0-Linux-x86_64.sh
```

You can do sudo inside as well!

```
sasank@my-distro:~$ sudo apt install htop
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libnl-3-200 libnl-genl-3-200
Suggested packages:
  lm-sensors strace
The following NEW packages will be installed:
  htop libnl-3-200 libnl-genl-3-200
0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
Need to get 200 kB of archives.
After this operation, 589 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu jammy/main amd64 libnl-3-200 amd64 3.5.0-0.1 [59.1 kB]
Get:2 http://archive.ubuntu.com/ubuntu jammy/main amd64 libnl-genl-3-200 amd64 3.5.0-0.1 [12.4 kB]
Get:3 http://archive.ubuntu.com/ubuntu jammy/main amd64 htop amd64 3.0.5-7build2 [128 kB]
Fetched 200 kB in 1s (147 kB/s)
Selecting previously unselected package libnl-3-200:amd64.
(Reading database ... 27094 files and directories currently installed.)
Preparing to unpack .../libnl-3-200_3.5.0-0.1_amd64.deb ...
Unpacking libnl-3-200:amd64 (3.5.0-0.1) ...
Selecting previously unselected package libnl-genl-3-200:amd64.
Preparing to unpack .../libnl-genl-3-200_3.5.0-0.1_amd64.deb ...
Unpacking libnl-genl-3-200:amd64 (3.5.0-0.1) ...
Selecting previously unselected package htop.
Preparing to unpack .../htop_3.0.5-7build2_amd64.deb ...
Unpacking htop (3.0.5-7build2) ...
Setting up libnl-3-200:amd64 (3.5.0-0.1) ...
Setting up libnl-genl-3-200:amd64 (3.5.0-0.1) ...
Setting up htop (3.0.5-7build2) ...
Processing triggers for man-db (2.10.2-1) ...
Processing triggers for hicolor-icon-theme (0.17-2) ...
Processing triggers for libc-bin (2.35-0ubuntu3.8) ...
```

To exit distrobox, just do exit or `ctrl+D`. 

```
sasank@my-distro:~$ exit
logout
sasank@JOHNAIC:~$ 
```

You can see you are back in the host machine. Try `sudo` now and you'll see it is refused.

```
sasank@JOHNAIC:~$ sudo apt install htop
[sudo] password for sasank: 
sasank is not in the sudoers file.  This incident will be reported.
```

You can access GPU inside distrobox as well!

```
sasank@my-distro:~$ nvidia-smi 
Sun Oct 13 19:32:06 2024       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 560.35.03              Driver Version: 560.35.03      CUDA Version: 12.6     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 4070 ...    Off |   00000000:01:00.0 Off |                  N/A |
|  0%   54C    P0             34W /  285W |      14MiB /  16376MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A      1174      G   /usr/lib/xorg/Xorg                              4MiB |
+-----------------------------------------------------------------------------------------+

```

Finally, let's verify that ports are exposed as well. 

```
sasank@my-distro:~$ python3 -m http.server 8001
Serving HTTP on 0.0.0.0 port 8001 (http://0.0.0.0:8001/) ...
```

Now open another terminal in host and access the files

```
sasank@JOHNAIC:~$ curl 0.0.0.0:8001
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Directory listing for /</title>
</head>
<body>
<h1>Directory listing for /</h1>
<hr>
<ul>
<li><a href=".bash_eternal_history">.bash_eternal_history</a></li>
<li><a href=".bash_history">.bash_history</a></li>
<li><a href=".bash_logout">.bash_logout</a></li>
<li><a href=".bashrc">.bashrc</a></li>
<li><a href="Desktop/">Desktop/</a></li>
<li><a href="Documents/">Documents/</a></li>
<li><a href="Downloads/">Downloads/</a></li>
<li><a href="Music/">Music/</a></li>
<li><a href="Pictures/">Pictures/</a></li>
<li><a href="Public/">Public/</a></li>
<li><a href="Videos/">Videos/</a></li>
</ul>
<hr>
</body>
</html>
```

`ls` or `list` is another useful command in distrobox to see list of running distroboxes.

```
sasank@JOHNAIC:~$ distrobox ls
ID           | NAME                 | STATUS             | IMAGE                         
ae35c77dcc9d | test                 | Up 5 days          | docker.io/library/ubuntu:22.04
5fb1b176afd5 | my-distro            | Up 10 minutes      | docker.io/library/ubuntu:22.04
```

You can run multiple distroboxes in parallel!

### systemd *inside* distrobox

There are some limitations to distrobox. Most containers are designed to be *application* containers. This means there's no `init` system like systemd inside the container. For example, `ubuntu:22.04` doesn't have `systemd` in it. This results in some subtle issues when installing a few packages. For example, let's try to install [caddy](https://caddyserver.com/docs/install#debian-ubuntu-raspbian) inside `my-distro` created above

```
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

You will notice errors like this

```
/usr/sbin/policy-rc.d returned 101, not running 'start caddy.service'
```

Similar issue can be found when install `redis` or `postgresql`:

```
invoke-rc.d: could not determine current runlevel
invoke-rc.d: policy-rc.d denied execution of start.
```

This happens because these packages are looking to install a `systemd` service. We can get away from this errors by starting distrobox with init system as follows:

```
sasank@JOHNAIC:~$ distrobox create -n my-distro-init -i ubuntu:22.04 --init --additional-flags "--device nvidia.com/gpu=all" --additional-packages "systemd libpam-systemd pipewire-audio-client-libraries"
```

Let's break this command down

* `-n` is short for `--name`
* `-i` is short for `--image`
* `--init` tells distrobox to setup init system and run as system container 
* `--additional-packages "systemd libpam-systemd pipewire-audio-client-libraries"` is required for `--init` to work because systemd is not installed in `ubuntu:22.04` image

```
sasank@JOHNAIC:~$ distrobox enter my-distro-init
Starting container...                            [ OK ]
Installing basic packages...                     [ OK ]
Setting up devpts mounts...                      [ OK ]
Setting up read-only mounts...                   [ OK ]
Setting up read-write mounts...                  [ OK ]
Setting up host's sockets integration...         [ OK ]
Integrating host's themes, icons, fonts...       [ OK ]
Setting up distrobox profile...                  [ OK ]
Setting up sudo...                               [ OK ]
Setting up groups...                             [ OK ]
Setting up users...                              [ OK ]
Setting up skel...                               [ OK ]
Setting up init system...                        [ OK ]
Firing up init system...                         [ OK ]

Container Setup Complete!
```

Let's install `redis` and start the service 

```
sasank@my-distro-init:~$ sudo apt install -y redis
sasank@my-distro-init:~$ sudo service redis-server start
sasank@my-distro-init:~$ sudo service redis-server status
● redis-server.service - Advanced key-value store
     Loaded: loaded (/lib/systemd/system/redis-server.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-10-13 14:09:48 UTC; 917ms ago
       Docs: http://redis.io/documentation,
             man:redis-server(1)
   Main PID: 7946 (redis-server)
     Status: "Ready to accept connections"
      Tasks: 5 (limit: 307)
     Memory: 2.9M
        CPU: 537ms
     CGroup: /system.slice/redis-server.service
             └─7946 "/usr/bin/redis-server 127.0.0.1:6379" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
```

Thus, `systemd` is working inside distrobox!

## Conclusion

In this post, we saw how containers create a sandbox environment and how this is not great experience for developers. Distrobox, running on rootless podman, is presented as a solution to this problem. In distrobox, we can use `sudo` even though the user doesn't have root permissions on the host system. We had a hands on session with distrobox where we installed the `htop` package inside distrobox using `sudo apt install htop`. We saw limitations of `ubuntu:22.04` based distrobox where systemd is not available inside. We found a fix for this by using `--init` and `--additional-packages` flags. 

> Published on 13/10/24
