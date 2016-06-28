# vagrant-jenkins
A vagrant (Vagrantfile) installation of Jenkins based on the Jenkins docker official image.

# start jenkins

```
$ vagrant up
$ vagrant ssh

vagrant@vagrant-ubuntu-trusty-64:~$ sudo su - jenkins
jenkins@vagrant-ubuntu-trusty-64:~$ jenkins.sh 
Running from: /usr/share/jenkins/jenkins.war
webroot: EnvVars.masterEnvVars.get("JENKINS_HOME")
Jun 27, 2016 2:16:54 AM winstone.Logger logInternal
INFO: Beginning extraction from war file
(...)
INFO: Jenkins is fully up and running
```

Using provision, the service can be started automatically. Jenkins can be registered as a service too.

# stop jenkins

```
jenkins@vagrant-ubuntu-trusty-64:~$ ^C
jenkins@vagrant-ubuntu-trusty-64:~$ exit
vagrant@vagrant-ubuntu-trusty-64:~$ exit

czbarcea$ vagrant halt 
```

### TODO

* HEREDOC for ENV variables
* get a list of jenkins plugins
* automatic backup - /var/lib/jenkins (maybe)
* automatic restore - /var/lib/jenkins (maybe)
* `jenkins-test01` 
* setup jenkins CNAME (to prepare for crowd integration)
* deploy jenkins
* setup a Jenkins HTTP proxy (nginx/httpd)
* define a list of jenkins plugins to be used
* create wiki pages for tutorials expected by developers/users
* integrate with the Development process/procedures
** integrate with pivotal tracker
** define a list of jenkins plugins to be used
* enable SSL
** get a CRT (cetificate) for your domain, if you want to have SSL
