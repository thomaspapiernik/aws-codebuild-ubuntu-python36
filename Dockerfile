# Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file.
#
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.
#

# Ubuntu 18.04's python3 is 3.6.3 (as of 11/10/2017)
# https://askubuntu.com/questions/865554/how-do-i-install-python-3-6-using-apt-get
FROM ubuntu:18.04

##########################################################################
RUN apt-get update && \
    apt-get install -y build-essential python3-pip python3-venv \
	nodejs zip bzip2 fontconfig git curl docker.io nodejs && \
	update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 && \
	update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && \
	pip install -U pip && \
	# Docker compose
    DOCKER_COMPOSE_URL=https://github.com$(curl -L https://github.com/docker/compose/releases/latest | grep -Eo 'href="[^"]+docker-compose-Linux-x86_64' | sed 's/^href="//' | head -1) && \
    curl -Lo /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL && \
    chmod a+rx /usr/local/bin/docker-compose && \
    \
    # Basic check it works
    docker-compose version && \
    rm -rf /tmp/* /var/tmp/* && \
	apt-get -y clean
	
VOLUME /var/lib/docker

COPY dockerd-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

ENV PATH="/usr/local/bin:$PATH"

ENV LANG="en_US.utf8"

CMD ["python3"]

ENTRYPOINT ["dockerd-entrypoint.sh"]

