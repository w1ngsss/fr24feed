[![pipeline status](https://gitlab.com/nicosingh/rpi-fr24feed/badges/master/pipeline.svg)](https://gitlab.com/nicosingh/rpi-fr24feed/commits/master) [![Docker Pulls](https://img.shields.io/docker/pulls/nicosingh/rpi-fr24feed.svg)](https://hub.docker.com/r/nicosingh/rpi-fr24feed/)

# About

Docker image of Raspbian with FlightRadar24 software already installed. It is part of the following stack:

rpi-fr24feed -> rpi-dump1090 -> **rpi-fr24feed**

Which has the purpose of configuring a homemade FlightRadar24 server using a Raspberry Pi and a DVB-T stick.

# How to use this Docker image?

As this image already has DVB-T drivers & dump1090 software installed, we can just execute FR24 software using something like:

`docker run -d --device=/dev/bus/usb -e FR24_KEY=xxyyzz --privileged nicosingh/rpi-fr24feed`

Where:

`docker run -d`: means to run a new Docker container as a daemon

`--device=/dev/bus/usb`: is required to map our physical DVB-T USB stick to our new container. Note that we are limited to execute only 1 Docker container by USB device.

`-e FR24_KEY=xxyyzz`: is a environment variable called `FR24_KEY` with our FlightRadar24 sharing key. This key depends of our FR24 account and device location.

`---privileged`: is required to use modprobe functionalities and prevent DVB-T stick to stop working
