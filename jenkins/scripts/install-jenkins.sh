#!/bin/bash -eux

# The following procedure to install jenkins is inspired by the official latest
#   documentation from: https://github.com/jenkinsci/docker/blob/master/Dockerfile

# Update system with latest patches
export DEBIAN_FRONTEND=noninteractive 
apt-get --quiet --assume-yes update
# apt-get --assume-yes upgrade
apt-get --assume-yes install git curl zip openjdk-7-jre openjdk-7-jdk

# Install java 8 OpenJDK. For production, you may consider installing Oracle JDK
# FROM java:8-jdk

export BIN=/usr/local/bin

export JENKINS_HOME=/var/lib/jenkins
export JENKINS_SLAVE_AGENT_PORT=50000
export JENKINS_USER=jenkins
export JENKINS_GROUP=jenkins
export JENKINS_UID=998
export JENKINS_GID=998
export JENKINS_INSTALL=/usr/share/jenkins
export JENKINS_REF=$JENKINS_INSTALL/ref/init.groovy.d
export JENKINS_WEBAPP=$JENKINS_INSTALL/jenkins.war
export JENKINS_SERVICE=$JENKINS_INSTALL/jenkins.sh
export COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log

export JENKINS_UC=https://updates.jenkins.io

export JENKINS_VERSION=1.651.3
export JENKINS_SHA=564e49fbd180d077a22a8c7bb5b8d4d58d2a18ce

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
if getent group "$JENKINS_GROUP" >/dev/null 2>&1; then
   echo "group $JENKINS_GROUP already exists ... "
else
   groupadd --gid $JENKINS_GID $JENKINS_GROUP
fi
if getent passwd "$JENKINS_USER" >/dev/null 2>&1; then
   echo "user $JENKINS_USER already exists ... "
else
   useradd --home-dir $JENKINS_HOME --uid $JENKINS_UID --gid $JENKINS_GID --create-home --shell /bin/bash $JENKINS_USER
   cp /vagrant/scripts/bashrc_jenkins $JENKINS_HOME/.bashrc_jenkins
   echo 'source $HOME/.bashrc_jenkins' >> $JENKINS_HOME/.bashrc
fi

# Clean apt so that you let the system as small as possible
#rm --recursive --force /var/lib/apt/lists/*

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
mkdir --parents $JENKINS_REF

# COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

# could use ADD but this one does not check Last-Modified header 
# see https://github.com/docker/docker/issues/8331
if [ ! -f $JENKINS_WEBAPP ]; then
  curl --fail --silent --show-error \
     --location http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war \
     --output $JENKINS_WEBAPP
fi
echo "$JENKINS_SHA  $JENKINS_WEBAPP" | sha1sum -c -

chown --recursive $JENKINS_USER "$JENKINS_HOME" /usr/share/jenkins/ref

# web interface will be exposed on 8080

# slave agents will attach on 50000

# COPY jenkins.sh /usr/local/bin/jenkins.sh
# ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
ln --symbolic --force /vagrant/scripts/jenkins.sh /usr/local/bin/jenkins.sh
ln --symbolic --force /vagrant/scripts/plugins.sh /usr/local/bin/plugins.sh
ln --symbolic --force /vagrant/scripts/install-plugins.sh /usr/local/bin/install-plugins.sh
