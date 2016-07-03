FROM jenkins:1.651.2-alpine
MAINTAINER James Heggs eggsy@eggsylife.co.uk

USER jenkins

# The GCP project is configured on the Jenkins job
ENV GCP_PROJECT "GCP-CD"

# Configure jenkins and scripts for creating jobs
COPY resources/config.xml /var/jenkins_home/config.xml
COPY resources/jobs/create-jenkins-jobs.sh /usr/local/bin/create-jenkins-jobs.sh

# Create seed spring boot starter job
COPY resources/jobs/spring-boot-pipeline/config.xml /var/jenkins_job_templates/spring-boot-pipeline/config.xml

# Replace GCP Project with the environment variable
RUN sed -i.bak 's#GCP_PROJECT_DEFAULT_VALUE#${GCP_PROJECT}#' /var/jenkins_job_templates/spring-boot-pipeline/config.xml

# Install Jenkins Plugins
COPY resources/plugin_configs/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Google Cloud registry config
COPY resources/plugin_configs/com.google.jenkins.plugins.googlecontainerregistryauth.GoogleContainerRegistryCredentialGlobalConfig.xml\
     /var/jenkins_home/com.google.jenkins.plugins.googlecontainerregistryauth.GoogleContainerRegistryCredentialGlobalConfig.xml

USER root

RUN apk add --update supervisor

RUN chmod +x /usr/local/bin/create-jenkins-jobs.sh

COPY resources/supervisord.conf /etc/supervisord.conf


USER root

CMD ["/usr/bin/supervisord"]
