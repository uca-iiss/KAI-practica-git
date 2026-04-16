FROM jenkins/jenkins:lts-jdk17

USER root
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*

USER jenkins
RUN jenkins-plugin-cli --plugins "workflow-aggregator git docker-workflow sonar configuration-as-code"
RUN mkdir -p /usr/share/jenkins/casc_configs && cat > /usr/share/jenkins/casc_configs/jenkins.yaml <<'EOF'
jenkins:
	systemMessage: "Jenkins configured with SonarQube integration via Configuration as Code"

credentials:
	system:
		domainCredentials:
			- credentials:
					- string:
							id: "sonarqube-token"
							scope: GLOBAL
							secret: "sqp_1eb154cddd06f1c09e1625a0f5ebb8dd17a65895"
							description: "Token used by SonarQube Scanner for Jenkins"

unclassified:
	sonarGlobalConfiguration:
		installations:
			- name: "SonarQubeLocal"
				serverUrl: "http://sonarqube:9000"
				credentialsId: "sonarqube-token"
EOF