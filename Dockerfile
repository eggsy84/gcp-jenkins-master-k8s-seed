FROM jenkins:2.32.2-alpine

MAINTAINER James Heggs james.heggs@closconsultancy.com

# The GCP project is configured on the Jenkins job
ENV GCP_PROJECT "GCP-CD"

# Install Jenkins Plugins
COPY resources/plugin_configs/plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt | tr '\n' ' ')

# Create seed spring boot starter job
COPY resources/jobs /usr/share/jenkins/ref/jobs

# Put config in place ready to go
COPY resources/config.xml /usr/share/jenkins/ref/

# Google Cloud registry config
COPY resources/plugin_configs/com.google.jenkins.plugins.googlecontainerregistryauth.GoogleContainerRegistryCredentialGlobalConfig.xml\
     /usr/share/jenkins/ref/
