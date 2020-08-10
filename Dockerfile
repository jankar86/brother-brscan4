FROM fedora:latest

### Vars
ENV NAME="Scanner"
ENV MODEL="MFC-L2700DW"
ENV IPADDRESS="192.168.1.207"
ENV USERNAME="scan"

# Expose Ports
EXPOSE 54925
EXPOSE 54921

adduser $USERNAME --disabled-password --force-badname --gecos ""


##### update to latest and install packages ##### 
RUN dnf -y update && dnf -y install wget git unzip dpkg iputils procps && dnf clean all

#### Install scanner dependancies
RUN dnf -y install units netpbm-progs ghostscript poppler-utils ImageMagick unpaper util-linux tesseract sane-frontends.x86_64 && dnf clean all

##### setup scanner crap
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
RUN bash "/usr/bin/brscan-skey"
