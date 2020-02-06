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
          center: {lat: 37.579, lng: 126.990}
        });

        var imageBounds = {
          north: 41,
          south: 32,
          east: 135,
          west: 123
        };
        /*var imageBounds = {
                north: 45,
                south: 30,
                east: 141,
                west: 117
        };*/
        
        historicalOverlay = new google.maps.GroundOverlay(
        'http://api.vworld.kr/req/wmts/1.0.0/980584DE-E32E-316C-A0F0-271B354FC1AE/Base/{z}/{y}/{x}.png',
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