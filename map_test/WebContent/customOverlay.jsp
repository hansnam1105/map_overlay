<!DOCTYPE html>
<html>
  <head>
    <title>Overlaying an Image Map Type</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <script>

      function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 18,
          center: {lat: 38, lng: 127.7669}
        });

        var bounds = {
          17: [[20969, 20970], [50657, 50658]],
          18: [[41939, 41940], [101315, 101317]],
          19: [[83878, 83881], [202631, 202634]],
          20: [[167757, 167763], [405263, 405269]]
        };

        var imageMapType = new google.maps.ImageMapType({
          getTileUrl: function(coord, zoom) {
            if (zoom < 17 || zoom > 20 ||
                bounds[zoom][0][0] > coord.x || coord.x > bounds[zoom][0][1] ||
                bounds[zoom][1][0] > coord.y || coord.y > bounds[zoom][1][1]) {
              return null;
            }

            return ['//www.gstatic.com/io2010maps/tiles/5/L2_',
                zoom, '_', coord.x, '_', coord.y, '.png'].join('');
          },
          tileSize: new google.maps.Size(256, 256)
        });

        map.overlayMapTypes.push(imageMapType);
      }
    </script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg&callback=initMap">
    </script>
  </body>
</html>