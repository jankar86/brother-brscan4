FROM fedora:latest

##### update to latest and install packages ##### 
RUN dnf -y update && dnf -y install wget git unzip && dnf clean all

#### Install scanner dependancies
RUN dnf -y install units netpbm-progs ghostscript poppler-utils ImageMagick unpaper util-linux tesseract sane-frontends.x86_64 && dnf clean all

##### setup scanner crap
## Add this code to my repo for management ##
RUN git clone https://github.com/rocketraman/sane-scan-pdf.git /scanner/

#### Add drivers folder and install #######
ADD drivers/* /drivers/
ADD scripts/* /scripts/


