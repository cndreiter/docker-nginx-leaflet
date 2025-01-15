#/bin/bash

set -e

if [ -z "$TILESERVER" ]; then
  TILESERVER="http://{s}.tile.osm.org/{z}/{x}/{y}.png"
fi

if [ -z "$ATTRIBUTION" ]; then
  ATTRIBUTION="&copy; <a href=\"http://osm.org/copyright\">OpenStreetMap</a> contributors"
fi

echo "using Tile Server: $TILESERVER"
echo "attribution: $ATTRIBUTION"

cat <<HERE >/usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Leaflet</title>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.css" />
  <style>
    body {
      padding: 0px;
      margin: 0px;
      height: 100%;
      width: 100%;
    }
    #map {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div id="map"></div>

  <script src="//cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.js"></script>
  <script src="//unpkg.com/leaflet.vectorgrid@1.3.0/dist/Leaflet.VectorGrid.bundled.js"></script>
  <script src="//cdnjs.cloudflare.com/ajax/libs/zepto/1.1.4/zepto.min.js"></script>
  <script src="autosize.js"></script>
  <script>
    Autosize.enable();

    const map = L.map('map').setView([48, 13.5], 7);

    L.vectorGrid.protobuf('${TILESERVER}', {
        attribution: '${ATTRIBUTION}'
        vectorTileLayerStyles: {
            'planet_osm_roads': {
      					weight: 0.2,
                color: 'black',
                fill: false
            }
        }
    })
    .addTo(map);
  </script>
</body>
</html>
HERE

nginx -g "daemon off;"
