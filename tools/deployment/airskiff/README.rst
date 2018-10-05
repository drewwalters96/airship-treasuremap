========
Airskiff
========

| Skiff (n): a shallow, flat-bottomed open boat
| Airskiff (n): A learning and dev environment for Airship

Purpose
-------

Airskiff is an easy way to get started with the software delivery components
of Airship:

* Armada
* Deckhand
* Pegleg
* Shipyard

Airskiff is packaged with a set of deployment scripts modeled after the
`OpenStack-Helm project`_ for seamless, quick developer setup.

These scripts:

* Download, build, and containerize the Airship projects above from source
* Stand-up a Kubernetes cluster using KubeADM
* Deploy Armada, Deckhand, and Shipyard using the latest Armada image
* Deploy OpenStack using Airship, declarative YAMLs, and OpenStack-Helm charts

.. warning:: Airskiff is not safe for production use. These scripts are
  only intended to deploy a minimal development environment.

Proxy Configuration
-------------------

.. note:: This section assumes you have properly defined the standard
``http_proxy``, ``https_proxy``, and ``no_proxy`` environment variables and
have followed the `Docker proxy guide`_ to create a systemd drop-in unit.

In order to deploy Airskiff behind proxy servers, define the following
environment variables:

.. code-block:: bash

  export USE_PROXY=true
  export PROXY=${http_proxy}

Setup
-----


.. note:: Scripts should be run from the root of ``airship-treasuremap``
  repository.


.. code-block:: bash

  ./tools/deployment/airskiff/developer/000-install-packages.sh
  NOTE: You will need to start a new shell session at this point.
  ./tools/deployment/airskiff/developer/005-make-airship.sh
  ./tools/deployment/airskiff/developer/010-deploy-k8s.sh
  ./tools/deployment/airskiff/developer/020-setup-client.sh
  ./tools/deployment/airskiff/developer/030-armada-bootstrap.sh
  ./tools/deployment/airskiff/developer/040-deploy-osh.sh

Usage
-----

Once you have successfully deployed a running cluster, changes can be deployed
to the cluster by re-building the targeted component and executing Shipyard's
``update software`` action.

Below is an example of deploying local Armada changes:

.. code-block:: bash

  # Executed from the cloned Armada repository
  make images

  # Executed from the root of the airship-treasuremap repository
  ./tools/deployment/developer/airskiff/030-armada-bootstrap.sh

.. _Docker proxy guide: https://docs.docker.com/config/daemon/systemd/
    #httphttps-proxy

.. _OpenStack-Helm project: https://docs.openstack.org/openstack-helm/latest/
    install/developer/requirements-and-host-config.html
