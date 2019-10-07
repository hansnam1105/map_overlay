<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <meta charset="utf-8">
    <title>Ground Overlays</title>
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
      // This example uses a GroundOverlay to place an image on the map
      // showing an antique map of Newark, NJ.

      var historicalOverlay;

      function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 6,
          center: {lat: 37.5, lng: 127}
        });

        var imageBounds = {
          north: 43.0039,
          south: 33.0640,
          east: 131.5242,
          west: 124.1100
        };
        /*var imageBounds = {
                north: 45,
                south: 30,
                east: 141,
                west: 117
        };*/
        
        historicalOverlay = new google.maps.GroundOverlay(
        'https://upload.wikimedia.org/wikipedia/commons/7/79/Korean_Peninsula_topographic_map.png',
        imageBounds);
     /*    historicalOverlay = new google.maps.GroundOverlay(
        './vworld.jsp',
        imageBounds);  */
        historicalOverlay.setMap(map);
      }
      
    </script>
    <script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg&callback=initMap">
    </script>
  </body>
</html>