# majdigital-node-ci
The Jenkins docker image for our Node.js projects

## Build and publish the image

```sh
# Build the image
$ docker image build --progress plain -t majdigital/majdigital-node-ci .

# Add desired tags (e.g.: node v16 + chromium 99)
$ docker tag majdigital/majdigital-node-ci majdigital/majdigital-node-ci:node-16_chromium-99


# Publish the image
$ docker image push --all-tags majdigital/majdigital-node-ci
```

## Macbook M1

Building the image from a computer with an ARM architecture like the new M1 chip will build the image using the platform linux/arm64.
The image needs to be built for linux/amd64:

```sh
# Create a custom builder
$ docker buildx create --name custom-builder

# Use the new builder
$ docker buildx use custom-builder

# Build the image
$ docker buildx build --progress plain --tag majdigital/majdigital-node-ci -o type=image --platform=linux/amd64 .

# Use default builder
$ docker buildx use default
```