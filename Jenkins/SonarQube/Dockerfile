FROM jenkins/jenkins:lts-jdk17

USER root
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*

USER jenkins
RUN jenkins-plugin-cli --plugins "workflow-aggregator git docker-workflow sonar configuration-as-code"

COPY casc/jenkins.yaml /usr/share/jenkins/casc_configs/jenkins.yaml