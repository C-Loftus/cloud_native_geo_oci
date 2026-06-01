include .env

push_to_ghcr:
	echo ${GITHUB_TOKEN} | oras login ghcr.io -u c-loftus --password-stdin &&cd ./src/output_data && echo ${GITHUB_TOKEN} | oras push ghcr.io/c-loftus/cloud_native_geo_oci:latest hydrobasins_lvl5.pmtiles:application/vnd.pmtiles \
	--username c-loftus \
	--annotation 'org.opencontainers.image.source=https://github.com/c-loftus/cloud_native_geo_oci' \
	--annotation 'org.opencontainers.image.description=Cloud native geospatial test data inside an OCI Artifact. Includes PMTiles for Hydrobasins level 5 from https://www.hydroshare.org/resource/94da03d9ea4d4815b4de6bdd29da6fb4' \
	--password-stdin

pull:
	oras pull ghcr.io/c-loftus/cloud_native_geo_oci:latest