#
# Image Name:: dataferret/apache-event
#
# Copyright 2014, Nephila Graphic.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


FROM stackbrew/ubuntu:saucy
MAINTAINER Ted Chen <ted@nephilagraphic.com>


# Enable the necessary sources and upgrade to latest
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy-security main universe multiverse" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confnew"

# Install Apache2 Event MPM
RUN apt-get update && apt-get install apache2-mpm-event -y && \
    apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lock/apache2

ADD supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown root:root /etc/supervisor/conf.d/supervisord.conf && chmod 644 /etc/supervisor/conf.d/supervisord.conf

ADD supervisord/apache2.conf /etc/supervisor/conf.d/apache2.conf
RUN chown root:root /etc/supervisor/conf.d/apache2.conf && chmod 644 /etc/supervisor/conf.d/apache2.conf

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-n"]
