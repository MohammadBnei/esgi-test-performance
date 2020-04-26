#!/bin/bash

echo "GET http://nginx:80" | vegeta attack -name=50qps -rate=50 -duration=5s > results.50qps.bin && cat results.50qps.bin | vegeta plot > plot.50qps.html