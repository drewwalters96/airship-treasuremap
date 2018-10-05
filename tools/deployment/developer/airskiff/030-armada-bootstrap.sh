#!/bin/bash

# Copyright 2017 The Openstack-Helm Authors.
# Copyright 2018 AT&T Intellectual Property.  All other rights reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -xe

# NOTE(@drewwalters96): Download latest Armada image and deploy Airship components.
docker pull quay.io/airshipit/armada:master
docker run -d --name quay.io/airshipit/armada:master \
           -v ~/.kube/:/armada/.kube/ \
           -v $(pwd)/manifests:/etc quay.io/airshipit/armada:master

docker exec -d armada apply /etc/manifests/airship.yaml

# Stop and remove bootstrap container
docker stop quay.io/airshipit/armada:master
docker rm quay.io/airshipit/armada:master
