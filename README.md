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