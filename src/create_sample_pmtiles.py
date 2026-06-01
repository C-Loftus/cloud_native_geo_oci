from pathlib import Path
from subprocess import run
import urllib.request

import geopandas as gpd

TEST_DATA = (
    "https://www.hydroshare.org/resource/94da03d9ea4d4815b4de6bdd29da6fb4/data/contents/hydrobasins_lvl5_context.gpkg"
)

script_dir = Path(__file__).resolve().parent / "output_data"

gpkg = script_dir / "hydrobasins_lvl5_context.gpkg"
fgb = script_dir / "hydrobasins_lvl5_context.fgb"
tiles = script_dir / "hydrobasins_lvl5.pmtiles"

# Download if needed
if not gpkg.exists():
    print("Downloading GeoPackage...")
    urllib.request.urlretrieve(TEST_DATA, gpkg)

# Convert GPKG -> FGB
if not fgb.exists():
    print("Converting GeoPackage to FlatGeobuf...")

    gdf = gpd.read_file(gpkg)

    # Optional: normalize CRS for web maps
    if gdf.crs is not None:
        gdf = gdf.to_crs("EPSG:4326")

    gdf.to_file(
        fgb,
        driver="FlatGeobuf",
    )

# Build tiles
print("Running tippecanoe...")

run(
    [
        "tippecanoe",
        "-o",
        str(tiles),
        "-l",
        "hydrobasins_lvl5",
        "-zg",
        "--drop-densest-as-needed",
        "--extend-zooms-if-still-dropping",
        "--force",
        str(fgb),
    ],
    check=True,
)

print(f"Created {tiles}")
