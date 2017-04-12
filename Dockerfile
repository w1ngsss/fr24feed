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
ENV FR24_KEY ""
COPY fr24feed.ini /etc/
RUN chmod a+rw /etc/fr24feed.ini

# Use local version of dump1090
RUN mv /usr/lib/fr24/dump1090 /usr/lib/fr24/dump1090.old
RUN ln -s /dump1090/dump1090 /usr/lib/fr24/dump1090

# Restart the feeder software
CMD sed -i "s/fr24key=/fr24key=`echo $FR24_KEY`/g" /etc/fr24feed.ini &&\
    /etc/init.d/fr24feed restart &&\
    sleep 10 &&\
    tail -100f /var/log/fr24feed.log
