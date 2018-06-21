#!/bin/bash
#
# a simple script for deleting images from a private docker registry
#
host='dockerhub.domain.com'
auth='username:password'
image='namespace/application'

curl -u "${auth}" -v -sSL -X DELETE "http://${host}/v2/${image}/manifests/$(
    curl -sSL -I \
        -u "${auth}" \
        -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        "https://${host}/v2/${image}/manifests/$(
            curl -u "${auth}" -sSL "http://${host}/v2/${image}/tags/list" | jq -r '.tags[0]'
        )" \
    | awk '$1 == "Docker-Content-Digest:" { print $2 }' \
    | tr -d $'\r'
)"

