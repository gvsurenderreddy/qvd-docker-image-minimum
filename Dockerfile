# Qvd client for IOS
# Copyright (C) 2015  theqvd.com trade mark of Qindel Formacion y Servicios SL
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM ubuntu:14.04
MAINTAINER The QVD <docker@theqvd.com>

LABEL version="1.0"
LABEL description="This is minimal Ubuntu VM image installation for QVD. Only an xterm is included"

ENV DEBIAN_FRONTEND noninteractive
# QVD Repository
RUN apt-get update && apt-get install -y wget && wget -qO - http://theqvd.com/packages/key/public.key | sudo apt-key add -
RUN echo "deb http://theqvd.com/packages/ubuntu QVD-3.5.0 main" > /etc/apt/sources.list.d/qvd-34.list
# Install QVD VMA packages
RUN apt-get update && apt-get install -y --force-yes perl-qvd-vma linux-headers-generic-
RUN mkdir -p /etc/qvd
COPY vma.conf /etc/qvd/vma.conf
# System config
COPY interfaces /etc/network/interfaces.d/qvdinterface
COPY etc_init_ttyS0 /etc/init/ttyS0.conf
COPY manual /etc/init/rsyslog.override
COPY manual /etc/init/cron.override
# Hack to get rc working and network up via dhcp
RUN sed -i 's/^start on .*/start on filesystem or failsafe-boot/g' /etc/init/rc-sysinit.conf
# Cleanup
RUN echo "" > /etc/udev/rules.d/70-persistent-net.rules
RUN apt-get install -y plymouth-disabler
RUN apt-get --purge remove -y xserver-xorg linux-image-generic linux-headers-generic
RUN apt-get autoremove -y
RUN apt-get clean
