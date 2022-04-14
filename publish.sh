#!/bin/bash
docker container rm praetoriantechnology/symfony-service-builder -f
docker image rm praetoriantechnology/symfony-service-builder
docker build . -t praetoriantechnology/symfony-service-builder
docker tag praetoriantechnology/symfony-service-builder praetoriantechnology/symfony-service-builder:8.1
docker push praetoriantechnology/symfony-service-builder:8.1