# Introduction 

Developing WebService in Golang! Inspired by Marko Luksa "Kubernetes in Action".

## Chapter 1

Run primitive, naive web service in Docker

- Build Docker image
  - Run build script: `$build/builder.sh`
  - Check for new Docker image: `$docker images | grep kubia`
- Run container: `$docker run --name kubia-container -p 8080:8080 -d kubia`
  - Hit in a browser: `localhost:8080`
  - Alternatively run: `curl -v -i localhost:8080`
  
  
## Chapter 2 

Run in Kubernetes

- Spin up new cluster in Kubernetes: 
```bash
$ gcloud container clusters create kubia --machine-type=f1-micro --num-nodes=3 --zone=us-central1-a 
``` 
- Export environment variables:
```bash
$ export DOCKER_HUB_USER=<your Docker Hub user>
$ export DOCKER_HUB_PASSWORD=<your Docker Hub password>
``` 
- Run deployment script 
```bash
$ ./build/deploy_run.sh
```  
- Wait until after service **kubia-http** receives EXTERNAL-IP:
```bash
$ kuberctl get svc -n kubia-namespace
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
kubia-http   LoadBalancer   10.55.254.157   35.184.166.36   8080:30553/TCP   2m
```
- Hit in a browser: `<EXTERNAL-IP>:8080`
- Alternatively run: `curl -v -i <EXTERNAL-IP>:8080` 

Enjoy!