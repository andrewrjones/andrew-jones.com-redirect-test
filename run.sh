#!/bin/bash

#docker run -it --rm --name redirect.t -v "$PWD":/usr/src/redirect -w /usr/src/redirect \
# perl:5.20 prove redirect.t

docker build -t redirect .
docker run -it --rm --name redirect redirect
