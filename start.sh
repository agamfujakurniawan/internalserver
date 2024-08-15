#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

id=$(docker images | grep "coach/ajenti" | grep "latest" | awk '{print $3}')

docker kill coach_ajenti
docker rm coach_ajenti
docker rmi $id
docker build -t "coach/ajenti:latest" .

if [ ! -z $1 ]
then
	docker run -d \
		--name coach_ajenti \
		--net=host \
		-e PASSWORD=$1 \
		coach/ajenti
	# docker logs coach_ajenti -f
fi
