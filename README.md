# Minecraft Bedrock Dedicated Server Docker Image
This repository contains a Dockerfile for building an Ubuntu Docker image running a Minecraft Bedrock dedicated server. On arm64 targets box64 (see https://github.com/ptitSeb/box64 & https://github.com/ryanfortner/box64-debs) is used to run the x86_64 Minecraft server binary.

## Building the Docker image
First download the latest version of the Minecraft bedrock server for Ubuntu from https://www.minecraft.net/en-us/download/server/bedrock and rename it to `bedrock-server.zip`.

To build the image BuildKit is required (see https://www.docker.com/blog/introduction-to-heredocs-in-dockerfiles/). It can be enabled by setting the environment variable `DOCKER_BUILDKIT=1` or by setting it as the default builder with:

    $ docker buildx install
    
Next, build the image:

    $ docker build -t your_desired_image_name:and_tag
    
## Using the image
The repository contains an example docker-compose.yml file for how one might run/configure a container running the image.

### Volumes
There are two volumes:
  1. `/config`: this contains the configuration files for the dedicated server
  2. `/worlds`: this contains any worlds created on the server
  
### Ports
  By default the server listents on UDP port 19132.
