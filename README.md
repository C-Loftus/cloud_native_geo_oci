# Cloud Native Geospatial OCI Artifact Experiment

OCI artifacts are arbitrary files (often AI/ML models, Helm charts, Software Bill of Materials, etc.) packaged and stored in standard container registries using Open Container Initiative (OCI) specifications.

This repo is a test for ways to package geo native geospatial data inside such an OCI artifact. There are a number of interesting benefits to this:

- Each artifact is a self-contained package of data and metadata
    - An artifact can contain multiple files and each can be downloaded and cached separately without needing to download the entire artifact.
- Artifact registries typically utilize an object store as their underlying storage
    - Since object stores support range requests, it is theoretically possible to use a layer within the OCI artifact to store a PMTiles tileset and use it as a pseudo backend.
- Each push updates historical versions of the artifact and tracks lineage
    - It is trivial to roll back to historical versions without needing to manage a database or messy nested paths an the object store

## This Repo

This repo creates a test pmtiles file [here](./src/create_sample_pmtiles.py) and [pushes it to GHCR](./makefile). The resulting OCI artifact can be found [here](https://github.com/C-Loftus/cloud_native_geo_oci/pkgs/container/cloud_native_geo_oci?tag=latest) and can be pulled to a local filesystem using a tool like [oras](https://oras.land/) pull.

A [shell script](./src/test_http_range_request_for_just_pmtiles.sh) is included to test that the underlying object store powering the OCI registry supports http range requests needed for cloud native geospatial formats like PMTiles. 

In the future, a full web app could be constructed from a particular layer in the OCI artifact. I tried with GitHub and it theoretically could work, but there are no CORS headers and there are a few redirects to an Azure Blob storage endpoint, so it is not naively possible. However, the generally principle of using OCI Artifacts in this way is. 