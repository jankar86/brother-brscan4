FROM fedora:latest

##### update to latest and install packages ##### 
RUN dnf -y update && dnf -y install wget git unzip && dnf clean all

#### Install scanner dependancies
RUN dnf -y install units netpbm-progs ghostscript poppler-utils ImageMagick unpaper util-linux tesseract gnu-parallels && dnf clean all


RUN touch /testing.html


##### setup scanner crap

RUN git clone https://github.com/rocketraman/sane-scan-pdf.git /scanner/
