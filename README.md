# BSTMicro
SmartConnect coding challenge

The app was tested and built with Elixir ... and OTP ...

### How to build and run

Clone the project:

```
git clone https://github.com/czzrr/BSTMicro
```

Get project dependencies:

```
mix deps.get
```

Compile the project:

```
mix compile
```

Build the release:

```
mix release
```

You can now start the app by running `_build/dev/rel/bst_micro/bin/bst_micro start`.

If you want to run the app in a container with Docker, you can build an image from the Dockerfile by running

```
docker build --tag webserver:focal .
```

The container can be run by running

```
docker run --name webserver -d -p 8080:8080 webserver:latest ./app/bin/bst_micro start
```

HTTP requests can now be sent to localhost:8080.

### Running the container in Kubernetes

Create a local kind cluster:

```
kind create cluster --config=config.yaml
```

Load the docker image we built earlier into the cluster:

```
kind load docker-image webserver:focal
```

You can check to see if it's ready:

```
kubectl get nodes
```

Start webserver, its service and ingress:

```
kubectl apply -f webserver-config.yaml
```

The connection to the container running the webserver can be tested by port-forwarding:

```
kubectl port-forward webserver-deployment-788f56c75-jvzgd 8080:8080

```

Example request:

```
curl -X POST -H "Content-Type: application/json" -d '{"value": 7, "data":{"value":4,"right":null,"left":null}}' localhost:8080/insert
```

Returns `{"status":200,"data":{"value":4,"right":{"value":7,"right":null,"left":null},"left":null}}`.

Unfortunately I cannot get the API to work through ingress:

```
curl -X POST -H "Content-Type: application/json" -d '{"value": 7, "data":{"value":4,"right":null,"left":null}}' localhost/insert
```

returns `{"status":402,"data":"The server could not handle your request"}`, which seems like Plug is not matching on POST /insert...