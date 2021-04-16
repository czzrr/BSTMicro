# SmartConnect coding challenge

The app was tested and built on Ubuntu 20.04.2 with Elixir 1.9.1 and OTP 22.0.

I used GitHub Actions for CI, hence the test results can be seen in the GitHub repository under the Actions tab.

### How to build

The first step is cloning the project:

```
git clone https://github.com/czzrr/BSTMicro
```

Navigate to the project directory with `cd BSTMicro/` and get the project dependencies:

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

Requests can now be sent to localhost:8080.
An example is:

```
curl -X POST -H "Content-Type: application/json" -d '{"value": 7, "data":{"value":4,"right":null,"left":null}}' localhost:8080/insert
```

This inserts 7 into the binary search tree containing a single node of value 4.

The response is `{"status":200,"data":{"value":4,"right":{"value":7,"right":null,"left":null},"left":null}}`.

### Running the app in a Docker container

Build the image from the provided Dockerfile:

```
docker build --tag webserver:focal .
```

Run the container:

```
docker run --name webserver -d -p 8080:8080 webserver:focal
```

HTTP requests can now be sent in the same way as above.

### Deploying the app with Kubernetes

The following instructions are for deploying the app in a local kind cluster with ingress.

Create the cluster with the provided `config.yaml` file:

```
kind create cluster --config=config.yaml
```

Load the docker image we built earlier into the cluster:

```
kind load docker-image webserver:focal
```

You can check if the cluster is ready by running `kubectl get nodes`.

Make sure you have an ingress controller. Ingress NGINX is setup with

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

When the process for setting up Ingress NGINX is done, the webserver and ingress can be started with:

```
kubectl apply -f webserver-config.yaml
```

Requests can now be sent the to the webserver by sending them to `localhost/insert`. Example:

curl -X POST -H "Content-Type: application/json" -d '{"value": 7, "data":{"value":4,"right":null,"left":null}}' localhost/insert


The `curl` call above returns `{"status":200,"data":{"value":4,"right":{"value":7,"right":null,"left":null},"left":null}}`.

### Sending requests more easily

`lib/Service.ex` can be used for convenience when sending requests:

```
iex> Service.request_insert(BSTNode.from_list([7, 5]), 19)
%{
  "data" => %{
    "left" => %{"left" => nil, "right" => nil, "value" => 5},
    "right" => %{"left" => nil, "right" => nil, "value" => 19},
    "value" => 7
  },
  "status" => 200
}

%BSTNode{
  left: %BSTNode{left: nil, right: nil, value: 5},
  right: %BSTNode{left: nil, right: nil, value: 19},
  value: 7
}
```

Make sure to change the url in `lib/Service.ex` in the `HTTPoison.post` call to `localhost/insert` if the webserver runs in Kubernetes.