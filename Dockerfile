#
# Dockerfile - docker build script for a standard GlueX sim-recon 
#              container image based on centos 7.
#
# author: richard.t.jones at uconn.edu
# version: june 7, 2017
#
# usage: [as root] $ docker build Dockerfile .
#

FROM centos

# install a few utility rpms
RUN yum -y install bind-utils util-linux which wget tar procps less file gcc

# install the hdpm package builder
ENV GLUEX_TOP /usr/local
ADD https://halldweb.jlab.org/dist/hdpm/hdpm-0.6.1.linux.tar.gz /
RUN tar xf hdpm-0.6.1.linux.tar.gz
RUN rm hdpm-0.6.1.linux.tar.gz
RUN mv hdpm-0.6.1 hdpm

# discover and install sim-recon dependencies
RUN /hdpm/bin/hdpm show -p | sh

# create mount point for sim-recon, simlinks in /usr/local
RUN wget --ca-certificate=cilogon-osg.pem https://zeus.phys.uconn.edu/halld/gridwork/local.tar.gz
RUN tar xf local.tar.gz -C /
RUN rm local.tar.gz
RUN rm -rf /hdpm
VOLUME /mnt/Gluex

# link to the desired release
RUN ln -s /mnt/Gluex/builds/6.7.2017 /usr/local/.hdpm