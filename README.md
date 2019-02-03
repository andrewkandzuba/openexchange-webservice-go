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