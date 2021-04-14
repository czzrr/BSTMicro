# BSTMicro
SmartConnect coding challenge

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