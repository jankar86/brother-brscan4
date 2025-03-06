FROM ubuntu:24.04
#FROM python:slim-bullseye

#### Build Args
ARG BUILD_VERSION="unknown"
ENV BUILD_VERSION=$BUILD_VERSION

### Vars
ENV NAME="brother"
ENV MODEL="MFC-L2700DW"
ENV IPADDRESS="192.168.1.20"
ENV USERNAME="dock"
ENV TZ="America/Chicago"
ENV DEBIAN_FRONTEND=noninteractive

# Expose Ports ### Need to get this working to remove host networking
EXPOSE 54925/udp 54921 161/udp

##### update to latest, install packages, cleanup ##### 
RUN echo $TZ > /etc/timezone

RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean
RUN apt-get -y install \
                wget \
                git \
                unzip \
                dpkg \
                procps \
                iputils-ping \
                nano \
                tzdata \
                curl \
                && apt-get -y clean

#### Install scanner dependancies
RUN apt-get -y install \
                units \
                sane \
                sane-utils \
                netpbm \
                ghostscript \
                poppler-utils \
                imagemagick \
                unpaper \
                util-linux \
                tesseract-ocr \
                parallel \
                bc \
                && apt-get -y clean \
                ## Fix Seg Fault core dump error when scanning
                && sed -i 's/^genesys/#genesys/' /etc/sane.d/dll.conf


#### Persistant Volumes #######
VOLUME /scans

##### setup scanner crap ######
## Add this code to my repo for management ##
RUN git clone https://github.com/rocketraman/sane-scan-pdf.git /sane-scan-pdf/

#### Add drivers folder and install #######
ADD drivers/* /drivers/
ADD scripts/* /scripts/

### Install and configure
RUN dpkg -i --force-all /drivers/brscan4*.deb
RUN dpkg -i --force-all /drivers/brscan-skey-*.deb

RUN brsaneconfig4 -a name=$NAME model=$MODEL ip=$IPADDRESS
RUN brsaneconfig4 -q | grep $NAME

#### Copy files #####
RUN rm /opt/brother/scanner/brscan-skey/brscan-skey.config
RUN cp /scripts/brscan-skey.config /opt/brother/scanner/brscan-skey/
RUN rm /sane-scan-pdf/scan
RUN cp /scripts/scan /sane-scan-pdf/


#### Start the scanner listener ####
CMD ["bash", "/scripts/start.sh"]

