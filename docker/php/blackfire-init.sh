#!/bin/bash

blackfire-agent --register --server-id=$BLACKFIRE_SERVER_ID --server-token=$BLACKFIRE_SERVER_TOKEN

/etc/init.d/blackfire-agent restart