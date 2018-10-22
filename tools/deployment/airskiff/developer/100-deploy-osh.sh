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

# NOTE(@drewwalters96): Deploy OpenStack using Airship.
CURRENT_DIR="$(pwd)"
: ${PL_PATH:="../airship-pegleg"}
: ${SY_PATH:="../airship-shipyard"}

# Image to use for all Pegleg operations
: ${PL_IMAGE:=quay.io/airshipit/pegleg:latest}

# Lint deployment documents
: ${PEGLEG:="${PL_PATH}/tools/pegleg.sh"}
: ${PL_SITE:="airskiff"}

# NOTE(@drewwalters96): Disable Pegleg linting errors P001 and P009; a
#  a cleartext storage policy is acceptable for non-production use cases
#  and maintain consistency with other treasuremap sites.
IMAGE=${PL_IMAGE} ${PEGLEG} site -r . lint ${PL_SITE} -x P001 -x P009

# Collect deployment documents
: ${PL_OUTPUT:="peggles"}
mkdir -p ${PL_OUTPUT}

IMAGE=${PL_IMAGE} ${PEGLEG} site -r . collect ${PL_SITE} -s ${PL_OUTPUT}
cp -rp ${CURRENT_DIR}/${PL_OUTPUT} ${SY_PATH}/${SY_OUTPUT}

# Deploy Airskiff site
cd ${SY_PATH}
: ${SHIPYARD:="./tools/shipyard.sh"}

${SHIPYARD} create configdocs airskiff-design \
             --replace \
             --directory=/target/${PL_OUTPUT}

${SHIPYARD} commit configdocs 
${SHIPYARD} create action update_software --allow-intermediate-commits
cd ${CURRENT_DIR}
