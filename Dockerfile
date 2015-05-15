from tianon/centos:latest
MAINTAINER Vivek Srivastav <vsrivastav@gmail.com>
LABEL Description="This image is used to clean and process scanned PDF files." 

# Install EPEL
RUN rpm -Uvh --force http://mirrors.kernel.org/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm

# Update Current Image
RUN yum install -y libcom_err && yum update -y

# Install Salt Dependencies
RUN yum -y install --enablerepo=epel \
	unpaper \
	poppler-utils \
	libtiff \
	ghostscript \
	ImageMagick

ADD unpaper.sh /root/
ADD unpaper_opts.sh /root/
ADD profile	/root/.profile

VOLUME /root/work
