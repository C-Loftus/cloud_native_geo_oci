#!/bin/bash

# Get an ephemeral, anonymous token
ANONYMOUS_TOKEN=$(curl -s "https://ghcr.io/token?scope=repository:c-loftus/cloud_native_geo_oci:pull" | jq -r .token)

# This sources from one of the layers within the manifest here: 
# https://github.com/C-Loftus/cloud_native_geo_oci/pkgs/container/cloud_native_geo_oci/907586271
echo "Testing http range request"
curl -v -L \
  -H "Authorization: Bearer $ANONYMOUS_TOKEN" \
  -H "Range: bytes=0-511" \
  "https://ghcr.io/v2/c-loftus/cloud_native_geo_oci/blobs/sha256:d6f19caf2b4c2b46daff17865a83a4ea19a19c7c60599a86b711f5639f9c750b"