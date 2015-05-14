QVD minimal LXC image
=====================

This is how to build the minimal LXC image for QVD using Docker.

The base image used is Ubuntu 14.04.

To create the tar.gz file importable into QVD please use the following
commands:

  sudo docker build -t theqvd:minimal .
  vmid=$(sudo docker run -d -t -i theqvd:minimal /bin/bash -c "read a; echo $a")
  docker export $vmid  | gzip -c > qvd-image-ubuntu-14.04-minimal.tgz
  sudo docker kill $vmid

And the importable image is qvd-image-ubuntu-14.04-minimal.tgz

References
==========

More information about QVD can be found here: http://theqvd.com

Further docs are available here http://docs.theqvd.com

