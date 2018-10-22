Airskiff
========

* Skiff (n): a shallow, flat-bottomed, open boat
* Airskiff (n): A learning and development environment for Airship

What is Airskiff
----------------

Airskiff is an easy way to get started with the software delivery components
of Airship:

* `Armada`_
* `Deckhand`_
* `Pegleg`_
* `Shipyard`_

Airskiff is packaged with a set of deployment scripts modeled after the
`OpenStack-Helm project`_ for seamless developer setup.

These scripts:

* Download, build, and containerize the Airship components above from source.
* Deploy a Kubernetes cluster using KubeADM.
* Deploy Armada, Deckhand, and Shipyard using the latest `Armada image`_.
* Deploy OpenStack using the Airskiff site and charts from the
  `OpenStack-Helm project`_.

.. warning:: Airskiff is not safe for production use. These scripts are
  only intended to deploy a minimal development environment.

Common Deployment Requirements
------------------------------

This section covers actions that may be required for some deployment scenarios.

Passwordless sudo
~~~~~~~~~~~~~~~~~
Airskiff relies on scripts that utilize the ``sudo`` command. Deployment may
fail if a password is not provided. To ensure successful deployment, we
recommended granting the install user access to the ``sudo`` command without
requiring a password.

To grant passwordless sudo to a user, ``ubuntu``, append the following lines to
``/etc/sudoers``:

.. code-block:: bash

    ubuntu  ALL=(ALL) NOPASSWD: ALL

Proxy Configuration
~~~~~~~~~~~~~~~~~~~

.. note:: This section assumes you have properly defined the standard
  ``http_proxy``, ``https_proxy``, and ``no_proxy`` environment variables and
  have followed the `Docker proxy guide`_ to create a systemd drop-in unit.

In order to deploy Airskiff behind proxy servers, define the following
environment variables:

.. code-block:: shell

  export USE_PROXY=true
  export PROXY=${http_proxy}
  export no_proxy=${no_proxy},172.17.0.1,.svc.cluster.local
  export NO_PROXY=${NO_PROXY},172.17.0.1,.svc.cluster.local

.. note:: The ``.svc.cluster.local`` address is required to allow the OpenStack
  client to communicate without being routed through proxy servers. The IP
  address ``172.17.0.1`` is the advertised IP address for the Kubernetes API
  server. Replace the addresses if your configuration does not match the one
  defined above.

Deploy Airskiff
---------------

Deploy Airskiff using the deployment scripts contained in the
``tools/deployment/airskiff`` directory of the `airship-treasuremap`_
repository.

.. note:: Scripts should be run from the root of ``airship-treasuremap``
  repository.

Install required packages
~~~~~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/deployment/airskiff/developer/000-install-packages.sh
    :language: shell
    :lines: 1,18-

Alternatively, this step can be performed by running the script directly:

.. code-block:: shell

  ./tools/deployment/airskiff/developer/000-install-packages.sh

Restart your shell session
~~~~~~~~~~~~~~~~~~~~~~~~~~

At this point, restart your shell session to complete adding ``$USER`` to the
``docker`` group.

Build Airship components
~~~~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/deployment/airskiff/developer/005-make-airship.sh
    :language: shell
    :lines: 1,18-

Alternatively, this step can be performed by running the script directly:

.. code-block:: shell

  ./tools/deployment/airskiff/developer/005-make-airship.sh

Deploy Kubernetes with KubeADM
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/deployment/airskiff/developer/010-deploy-k8s.sh
    :language: shell
    :lines: 1,18-

Alternatively, this step can be performed by running the script directly:

.. code-block:: shell

  ./tools/deployment/airskiff/developer/010-deploy-k8s.sh

Setup OpenStack Client
~~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/deployment/airskiff/developer/020-setup-client.sh
    :language: shell
    :lines: 1,18-

Alternatively, this step can be performed by running the script directly:

.. code-block:: shell

  ./tools/deployment/airskiff/developer/020-setup-client.sh

Deploy Airship components using Armada
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/deployment/airskiff/developer/030-armada-bootstrap.sh
    :language: shell
    :lines: 1,18-

Alternatively, this step can be performed by running the script directly:

.. code-block:: shell

  ./tools/deployment/airskiff/developer/030-armada-bootstrap.sh

Deploy OpenStack using Airship
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. literalinclude:: ../../tools/deployment/airskiff/developer/100-deploy-osh.sh
    :language: shell
    :lines: 1,18-

Alternatively, this step can be performed by running the script directly:

.. code-block:: shell

  ./tools/deployment/airskiff/developer/100-deploy-osh.sh

Use Airskiff
------------

The Airskiff deployment scripts install and configure the OpenStack client for
usage on your host machine.

Airship Examples
~~~~~~~~~~~~~~~~

To use Airship services, set the ``OS_CLOUD`` environment variable to
``airship``.

.. code-block:: shell

  export OS_CLOUD=airship

List the Airship service endpoints:

.. code-block:: shell

  openstack endpoint list

.. note:: ``${SHIPYARD}`` is the path to a cloned `Shipyard`_ repository.

Run Helm tests for all deployed releases:

.. code-block:: shell

  ${SHIPYARD}/tools/shipyard.sh create action test_site

List all `Shipyard`_ actions:

.. code-block:: shell

  ${SHIPYARD}/tools/shipyard.sh get actions

For more information about Airship operations, see the
`Shipyard actions`_ documentation.

OpenStack Examples
~~~~~~~~~~~~~~~~~~

To use OpenStack services, set the ``OS_CLOUD`` environment variable to
``openstack``:

.. code-block:: shell

  export OS_CLOUD=openstack

List the OpenStack service endpoints:

.. code-block:: shell

  openstack endpoint list

List ``Glance`` images:

.. code-block:: shell

  openstack image list

Issue a new ``Keystone`` token:

.. code-block:: shell

  openstack issue token

.. note:: Airskiff deploys identity, network, cloudformation, placement,
  compute, orchestration, and image services. You can deploy more services
  by adding chart groups to
  ``site/airskiff/software/manifests/full-site.yaml``. For more information,
  refer to the `site authoring and deployment guide`_.

Develop with Airskiff
---------------------

Once you have successfully deployed a running cluster, changes to Airship
and OpenStack components can be deployed using `Shipyard actions`_ or the
Airskiff deployment scripts.

Airship Examples
~~~~~~~~~~~~~~~~

This example demonstrates deploying `Armada`_ changes using the Airskiff
deployment scripts.

.. note:: ``${ARMADA}`` is the path to your cloned Armada repository that
  contains the changes you wish to deploy. ``${TREASUREMAP}`` is the path to
  your cloned Treasuremap repository.

Build Armada:

.. code-block:: shell

  cd ${ARMADA}
  make images

Update Airship components:

.. code-block:: shell

  cd ${TREASUREMAP}
  ./tools/deployment/developer/airskiff/030-armada-bootstrap.sh

OpenStack Examples
~~~~~~~~~~~~~~~~~~

Changes to documents and OpenStack services can be re-deployed with
the ``100-deploy-osh.sh`` script:

.. note:: ``${TREASUREMAP}`` is the path to your cloned Treasuremap repository.

.. code-block:: shell

  cd ${TREASUREMAP}
  ./tools/deployment/airskiff/developer/100-deploy-osh.sh

Troubleshooting
---------------

This section is intended to help you through the initial troubleshooting
process. If issues persist after following this guide, please join us on
`IRC`_: #airshipit (freenode)

``Missing value auth-url required for auth plugin password``

If this error message appears when using the OpenStack client, verify your
client is configured for authentication:

.. code-block:: shell

  # For Airship services
  export OS_CLOUD=airship

  # For OpenStack services
  export OS_CLOUD=openstack

.. _Docker proxy guide: https://docs.docker.com/config/daemon/systemd/
    #httphttps-proxy

.. _OpenStack-Helm project: https://docs.openstack.org/openstack-helm/latest/
    install/developer/requirements-and-host-config.html

.. _Armada: https://github.com/openstack/airship-armada
.. _Deckhand: https://github.com/openstack/airship-deckhand
.. _Pegleg: https://github.com/openstack/airship-pegleg
.. _Shipyard: https://github.com/openstack/airship-shipyard

.. _Armada image: https://quay.io/repository/airshipit/armada?tab=tags

.. _airship-treasuremap: https://github.com/openstack/airship-treasuremap

.. _Shipyard actions: https://airship-shipyard.readthedocs.io/en/latest/
    action-commands.html

.. _IRC: irc://chat.freenode.net:6697/airshipit

.. _site authoring and deployment guide: https://
    airship-treasuremap.readthedocs.io/en/latest/authoring_and_deployment.html
