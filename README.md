# Introduction 

Developing WebService in Golang! Inspired by Marko Luksa "Kubernetes in Action".

## Chapter 1

Run primitive, naive web service in Docker

- Build Docker image
  - Run build script: `$build/docker_build.sh`
  - Check for new Docker image: `$docker images | grep webservice`
- Run container: `$docker run --name webservice-container -p 8080:8080 -d webservice`
  - Hit in a browser: `localhost:8080`
  - Alternatively run: `curl -v -i localhost:8080`
  
  
## Chapter 2 

Deploy to Kubernetes

- Optional. If you run behind a corporate proxy set following environment variables as FQND resources with authorization:
 - HTTP_PROXY 
 - HTTPS_PROXY 

- Spin up new cluster in Kubernetes: 
```bash
$ gcloud container clusters create edu --machine-type=f1-micro --num-nodes=3 --zone=us-central1-a 
``` 
- Optional. Create dedicated namespace and switch local context:
    - `kubectl create -f documentation/edu-namespace.yaml`
    - `kubectl config set-context $(kubectl config current-context) --namespace=edu-namespace`
    
- Login docker to remote registry like Docker Hub. In my case it is [andrewkandzuba](https://cloud.docker.com/repository/docker/andrewkandzuba)`
 
- Run deployment script ending with the image name in Docker Registry.
```bash
$ ./build/deploy.sh andrewkandzuba/webservice
```  

- Wait until after service **webservice** receives EXTERNAL-IP:
```bash
$ kubectl get svc -n edu-namespace
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
webservice   LoadBalancer   10.55.254.157   35.184.166.36   8080:30553/TCP   2m
```
- Hit in a browser: `<EXTERNAL-IP>:8080`
- Alternatively run: `curl -v -i <EXTERNAL-IP>:8080` 

## Chapter 3

Additional handlers

- Liveness probe handler is available by `<EXTERNAL-IP>:8080/health`
- To restart container(s) randomly hit: `<EXTERNAL-IP>:8080/stop` 

Enjoy!