# majdigital-node-ci
The Jenkins docker image for our Node.js projects

## Build and publish the image

```sh
# Build the image
$ docker image build -t majdigital/majdigital-node-ci .

# Add desired tags, e.g.:
$ docker tag majdigital/majdigital-node-ci nodejs:16
$ docker tag majdigital/majdigital-node-ci chromedriver:99

# Publish the image
$ docker image push --all-tags majdigital/majdigital-node-ci
```