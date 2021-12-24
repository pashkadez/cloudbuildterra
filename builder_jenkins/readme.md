
	git clone repo
	cd repo
	docker build -t jenkins:jcasc . 
	docker run --name jenkins --rm -p 8090:8080 --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=admin jenkins:jcasc  
