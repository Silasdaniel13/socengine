# syntax=docker/dockerfile:1
FROM debian:latest

MAINTAINER Silas VIGAN <silasdaniel13@gmail.com>
#COPY . /app
#Doownload the latest release of SIFT toolkit from a GitHub repository
RUN apt-get update
RUN apt-get install -y curl
RUN curl -Lo /usr/local/bin/sift https://github.com/sans-dfir/sift-cli/releases/download/v1.10.0/sift-cli-linux
RUN curl -Lo /usr/local/bin/sift-cli-linux.sha256 https://github.com/sans-dfir/sift-cli/releases/download/v1.10.0/sift-cli-linux.sha256
RUN curl -Lo /usr/local/bin/sift-cli-linux.sha256.asc https://github.com/sans-dfir/sift-cli/releases/download/v1.10.0/sift-cli-linux.sha256.asc
RUN chmod +x /usr/local/bin/sift

#Verification of the downloaded files 
RUN apt-get install -y gnupg
#RUN gpg --keyserver pgp.mit.edu --recv-keys 22598A94
#RUN gpg --verify sift-cli-linux.sha256.asc
#RUN shasum -a 256 -c sift-cli-linux.sha256.asc
#RUN mv usr/local/bin/sift-cli-linux /usr/local/bin/sift
RUN chmod 755 /usr/local/bin/sift

#Run the SIFT Toolkit
CMD sift install --user sift 


