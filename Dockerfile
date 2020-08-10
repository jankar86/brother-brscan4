FROM fedora:latest

### Vars
# IP and name

##### update to latest and install packages ##### 
RUN dnf -y update && dnf -y install wget git unzip dpkg iputils procps && dnf clean all

#### Install scanner dependancies
RUN dnf -y install units netpbm-progs ghostscript poppler-utils ImageMagick unpaper util-linux tesseract sane-frontends.x86_64 && dnf clean all

##### setup scanner crap
## Add this code to my repo for management ##
RUN git clone https://github.com/rocketraman/sane-scan-pdf.git /scanner/

#### Add drivers folder and install #######
ADD drivers/* /drivers/
ADD scripts/* /scripts/


### Install and configure
RUN dpkg -i --force-all /drivers/brscan4*.deb
RUN dpkg -i --force-all /drivers/brscan-skey-*.deb

RUN brsaneconfig4 -a name=brother model=MFC-L2700DW ip=192.168.1.207
RUN brsaneconfig4 -q | grep brother

# Expose ports

#port ?
