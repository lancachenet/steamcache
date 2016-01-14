# Steam Cache Docker Container

## Introduction

This is the Dockerfile and collection of scripts for deploying a Steam Cache using Docker. The image is on [Docker Hub](https://hub.docker.com/r/murraymint/steamcache/)

## Installation

 1. Follow the [instructions on the Docker website](https://docs.docker.com/installation) to install Docker. 
 2. When Docker is installed, clone this repository into a directory.
`git clone https://github.com/murraymint/steamcache`
 3. Change to the steamcache\docker directory `cd steamcache\docker`
 4. Update config.sh to set the IP and directories for the container
 5. Set the scripts to be executable with `chmod +x *.sh`

## Usage

Run the steamcache container with the using the following to allow TCP port 80 (HTTP) and UDP port 53 (DNS) through the host machine:

```
docker run --name steamcache -p 192.168.0.5:80:80 -p 192.168.0.5:53:53/udp -e HOSTIP=192.168.0.5 murrymint/steamcache:latest
```

Start the container using run.sh. This will download the latest image and start the container. You can test that it's running using `docker info steamcache`

To monitor the logfiles run `watchlog.sh`. This will display the names of the depots being downloaded and are colour-coded based on the source of the content. Red for content coming from Steam, green for content coming from the local cache and yellow for other content.

## Running on Startup

Follow the instructions in the Docker documentation to run the container at startup.
[Documentation](https://docs.docker.com/articles/host_integration/)

## License

The MIT License (MIT)

Copyright (c) 2015 Michael Smith, Robin Lewis, Brian Wojtczak, Jason Rivers

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

