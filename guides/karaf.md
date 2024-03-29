---
layout: page
title: "Apache Karaf: Getting Started Guide"
permalink: /guides/karaf/
---

## Introduction

[Apache Karaf](https://karaf.apache.org) is an OSGi runtime that runs on top of most OSGi containers like [Apache Felix](https://felix.apache.org) and
[Eclipse Equinox](https://www.eclipse.org/equinox/).  jclouds provides easy integration with Apache Karaf by leveraging the Karaf _"Feature"_ concept.

This section will describe how to install jclouds on Apache Karaf and run some examples that demonstrate the power of jclouds in a dynamic environment such as Karaf.

jclouds provides the following Karaf "features":

  * jclouds-api-byon
  * jclouds-api-chef
  * jclouds-api-cloudstack
  * jclouds-api-ec2
  * jclouds-api-openstack-cinder
  * jclouds-api-openstack-keystone
  * jclouds-api-openstack-nova
  * jclouds-api-rackspace-clouddns
  * jclouds-api-rackspace-cloudidentity
  * jclouds-api-route53
  * jclouds-api-s3
  * jclouds-api-sqs
  * jclouds-api-sts
  * jclouds-api-swift
  * jclouds-aws-cloudwatch
  * jclouds-aws-ec2
  * jclouds-aws-route53
  * jclouds-aws-s3
  * jclouds-aws-sqs
  * jclouds-aws-sts
  * jclouds-azureblob
  * jclouds-chef
  * jclouds-cloudfiles-uk
  * jclouds-cloudfiles-us
  * jclouds-digitalocean
  * jclouds-dynect
  * jclouds-elastichosts-lax-p
  * jclouds-elastichosts-lon-b
  * jclouds-elastichosts-lon-p
  * jclouds-elastichosts-sat-p
  * jclouds-elastichosts-tor-p
  * jclouds-glesys
  * jclouds-go2cloud-jhb1
  * jclouds-gogrid
  * jclouds-hpcloud-compute
  * jclouds-hpcloud-objectstorage
  * jclouds-openhosting-east1
  * jclouds-rackspace-cloudblockstorage-uk
  * jclouds-rackspace-cloudblockstorage-us
  * jclouds-rackspace-clouddns-uk
  * jclouds-rackspace-clouddns-us
  * jclouds-rackspace-cloudfiles-uk
  * jclouds-rackspace-cloudfiles-us
  * jclouds-rackspace-cloudloadbalancers-uk
  * jclouds-rackspace-cloudloadbalancers-us
  * jclouds-rackspace-cloudservers-uk
  * jclouds-rackspace-cloudservers-us
  * jclouds-serverlove-z1-man
  * jclouds-skalicloud-sdg-my
  * jclouds-softlayer


## Installation

1. Get jclouds-karaf from the [jclouds-karaf repository](https://github.com/apache/jclouds-karaf) on GitHub.

As of the jclouds Version 1.0.0 release, the jclouds-karaf feature is available on the central maven repository, so you can skip this step of getting the
source and building it and go directly to the install of the jclouds feature.

{% highlight sh %}
git clone git://github.com/apache/jclouds-karaf.git
cd jclouds-karaf
mvn clean install
{% endhighlight %}

2. Start Karaf and install the jclouds feature.

{% highlight text %}
features:addurl mvn:org.jclouds.karaf/feature/1.0/xml/features
features:install jclouds
{% endhighlight %}

3. Now that the core of jclouds is installed, select any additional jclouds features you wish and install them using the shell:

{% highlight text %}
features:list | grep jclouds
{% endhighlight %}

_*Example*_

4. For installing the module for aws-s3:

{% highlight text %}
features:install jclouds-aws-s3
{% endhighlight %}


## Running the examples

The following example demonstrates how using jclouds inside Karaf can make it easy to use jclouds.  The example leverages the Karaf shell and the
configuration administrator to provide two shell commands that read and write data to a blobstore.  The BlobStore provider and the access information
can change dynamically, and they may be configured or reconfigured using the OSGi configuration administrator.

The first step is to get and build the example:

{% highlight text %}
git clone https://iocanel@github.com/apache/jclouds-examples.git
cd jclouds-examples/blobstore-karaf-shell
mvn clean install
{% endhighlight %}

Then from Karaf shell you can install the example:

{% highlight text %}
osgi:install -s mvn:org.jclouds.examples/blobstore-karaf-shell/1.0-SNAPSHOT
{% endhighlight %}

The command above installs in Karaf two new commands:

  * jclouds:blobstore-write
  * jclouds:blobstore-read

In order to use those commands, you first need to configure the provider. The configuration is done
using the org.jclouds.blobstore PID. You can create the configuration either from inside the shell or
by dropping  a file named org.jclouds.blobstore.cfg under karaf's etc folder.
Let's see how it can be done using the Karaf shell:

{% highlight text %}
config:edit org.jclouds.blobstore
config:propset provider aws-s3
config:propset accessKeyId XXXXXX
config:propset secretKey XXXXXX
config:update
{% endhighlight %}

Now you are ready to use the commands

{% highlight text %}
jclouds:blobstore-write mybucket myblob JCloudsRocks
jclouds:blobstore-write mybucket myblob
{% endhighlight %}

At any point in time, you can edit the configuration, either using the shell or
by editing the configuration file. The commands will pick up the changes immediately.
This way you can even switch providers.


Watch the [demo video](https://www.youtube.com/watch?v=SIvSaGEKrkM).

