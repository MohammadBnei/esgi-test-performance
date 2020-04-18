#!/bin/bash

docker-compose run --rm vegeta bash -c "echo 'GET http://nginx:80' | vegeta attack -rate=10 -duration=30s | tee results.bin | vegeta report"