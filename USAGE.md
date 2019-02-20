# WARNING: DEPRECATED CONTAINER

The steamcache/steamcache container is no longer recommended for use as it is no longer under active development. The steamcache team highly recommends using our [steamcache/monolithic](https://www.github.com/steamcache/monolithic) container instead as it offers drastic performance and speed improvements over the old steamcache method.

# Steam Cache Docker Container

## Introduction

This docker container provides a a depot-caching proxy server for Steam content. For any network with more than one PC gamer in connected this will drastically reduce internet bandwidth consumption. 

The primary use case is gaming events, such as LAN parties, which need to be able to cope with hundreds or thousands of computers receiving an unannounced patch - without spending a fortune on internet connectivity. Other uses include smaller networks, such as Internet Cafes and home networks, where the new games are regularly installed on multiple computers; or multiple independent operating systems on the same computer.

## Usage

You will need to have a DNS server forwarding queries to the machine your docker container is running on. You can use the [steamcache-dns](https://hub.docker.com/r/steamcache/steamcache-dns/) docker image to do this or you can use a DNS service already on your network. See the [steamcache-dns github page](https://github.com/steamcache/steamcache-dns) for more information.

Run the steamcache container with the using the following to allow TCP port 80 (HTTP) through the host machine:

```
docker run \
  --restart unless-stopped \
  --name steamcache \
  -p 192.168.1.5:80:80 \
  -v /cache/steam/data:/data/cache \
  -v /cache/steam/logs:/data/logs \
  steamcache/steamcache:latest
```
## Quick Explaination

For a steam cache to function on your network you need two services.
* A depot cache service [This container](https://github.com/steamcache/steamcache)
* A special DNS service [steamcache-dns](https://github.com/steamcache/steamcache-dns)

The depot cache service transparently proxies your requests for content to Steam, or serves the content to you if it already has it.

The special DNS service handles DNS queries normally (recursively), except when they're about Steam and in that case it responds that the depot cache service should be used.

## Suggested Hardware

Regular commodity hardware (a single 2TB WD Black on an HP Microserver) can achieve peak throughputs of 30MB/s+ using this setup (depending on the specific content being served).

## Monitoring

To monitor the logfiles run `watchlog.sh`. This will display the names of the depots being downloaded and are colour-coded based on the source of the content. Red for content coming from Steam, green for content coming from the local cache and yellow for other content.

## Running on Startup

Follow the instructions in the Docker documentation to run the container at startup.
[Documentation](https://docs.docker.com/config/containers/start-containers-automatically/)

## License

The MIT License (MIT)

Copyright (c) 2015 Jessica Smith, Robin Lewis, Brian Wojtczak, Jason Rivers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
