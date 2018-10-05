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
: ${PL_IMAGE:=quay.io/airshipit/pegleg:latest}

# Validate deployment manifests
: ${PEGLEG:="${PL_PATH}/tools/pegleg.sh"}
: ${PL_SITE:="airskiff"}
: ${PL_OUTPUT:="peggles"}
cd ${CURRENT_DIR}

# Lint deployment manifests
IMAGE=${PL_IMAGE} ${PEGLEG} site -r deployment_files/ lint ${PL_SITE}

# Collect the deployment manifests that will be used
mkdir -p ${PL_OUTPUT}
IMAGE=${PL_IMAGE} ${PEGLEG} site -r deployment_files/ collect ${PL_SITE} -s ${PL_OUTPUT}
cp -rp ${CURRENT_DIR}/${PL_OUTPUT} ${SY_PATH}/${SY_OUTPUT}

# Deploy Airskiff site
. tools/deployment/common/os-env.sh
cd ${SY_PATH}
: ${SHIPYARD:="./tools/shipyard.sh"}

${SHIPYARD} ${SY_AUTH} create configdocs airskiff-design \
             --replace \
             --directory=/target/${PL_OUTPUT}

${SHIPYARD} ${SY_AUTH} commit configdocs --force
${SHIPYARD} ${SY_AUTH} create action update_software --allow-intermediate-commits
cd ${CURRENT_DIR}
