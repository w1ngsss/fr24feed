FROM nicosingh/rpi-dump1090

MAINTAINER Nicolas Singh <nicolas.singh@gmail.com>

# run fr24 rpi installator
RUN gpg --keyserver pgp.mit.edu --recv-keys 40C430F5
RUN gpg --armor --export 40C430F5 | apt-key add -

# Add APT repository to the config file, removing older entries if exist
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
RUN grep -v flightradar24 /etc/apt/sources.list.bak > /etc/apt/sources.list || echo OK
RUN echo 'deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable' >> /etc/apt/sources.list

# Update APT cache and install feeder software
RUN apt-get update -y
RUN apt-get install fr24feed -y

# Stop older instances if exist
RUN service fr24feed stop || echo OK

# Put configuration file
ENV FR24_KEY e4792a5e170b27fb
COPY fr24feed.ini /etc/
RUN chmod a+rw /etc/fr24feed.ini
RUN sed -i "s/fr24key=*/fr24key=`echo $FR24_KEY`/g" /etc/fr24feed.ini

# Restart the feeder software
RUN /etc/init.d/fr24feed restart
