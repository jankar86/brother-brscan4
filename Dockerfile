FROM fedora:latest

<<<<<<< HEAD
####### update to latest and install packages ##### 
=======
##### update to latest and install packages ##### 
>>>>>>> 737e73b61be309768e3a2e3704c794f2127e4756
RUN dnf -y update && dnf -y install wget git unzip && dnf clean all

#### Install scanner dependancies
RUN dnf -y install units netpbm-progs ghostscript poppler-utils ImageMagick unpaper util-linux tesseract sane-frontends.x86_64 && dnf clean all


RUN touch /testing.html


##### setup scanner crap

RUN git clone https://github.com/rocketraman/sane-scan-pdf.git /scanner/
