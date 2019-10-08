<!DOCTYPE html>
<html>
<head>
	<title>Leaflet debug page</title>

<!--  <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY" async defer></script> -->
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg" async defer></script>

	<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!--  <link rel="stylesheet" href="../Leaflet/dist/leaflet.css" />
	<script type="text/javascript" src="../Leaflet/dist/leaflet-src.js"></script>-->

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.4/dist/leaflet.css"
  integrity="sha512-puBpdR0798OZvTTbP4A8Ix/l+A4dHDD0DGqYW6RQ+9jxkRFclaxxQb/SJAWZfWAkuyeQUytO7+7N4QKrDh+drA=="
  crossorigin=""/>
<script src="https://unpkg.com/leaflet@1.3.4/dist/leaflet-src.js"
  integrity="sha512-+ZaXMZ7sjFMiCigvm8WjllFy6g3aou3+GZngAtugLzrmPFKFK7yjSri0XnElvCTu/PrifAYQuxZTybAEkA8VOA=="
  crossorigin=""></script>
<script src='https://unpkg.com/leaflet.gridlayer.googlemutant@latest/Leaflet.GoogleMutant.js'></script>
<script type="text/javascript" src="http://map.vworld.kr/js/apis.do?type=Base&apiKey=980584DE-E32E-316C-A0F0-271B354FC1AE"></script>

	<style>
	#map {
/*    margin: 32px; */
/*    width: auto; */
/*    overflow: visible; */
		width: calc( 100vw - 64px );
		height: calc( 100vh - 64px );
	}
	body { margin: 0 }

	</style>
</head>
<body>

	Leaflet's Google demo

	<div id="map" class="map"></div>

	<script type="text/javascript">

		

		var map = L.map('map').setView([37.5,127], 6);

		var roadMutant = L.gridLayer.googleMutant({
			maxZoom: 19,
			type:'roadmap'
		}).addTo(map);
		var corner1 = L.latLng(32, 123);
		var corner2 = L.latLng(41, 135);
		var bounds = L.latLngBounds(corner1, corner2);
		//var vmap = L.tileLayer('http://xdworld.vworld.kr:8080/2d/Base/201802/{z}/{x}/{y}.png').addTo(map);
		var vmap = L.tileLayer('http://api.vworld.kr/req/wmts/1.0.0/980584DE-E32E-316C-A0F0-271B354FC1AE/Base/{z}/{y}/{x}.png', {
			attribution: '@<a href="http://www.vworld.kr/dev/v4dv_apicla_a001.do">Vworld</a> contributors',
			maxZoom: 19,
			bounds : bounds,
		}).addTo(map);

		var styleMutant = L.gridLayer.googleMutant({
			styles: [
				{elementType: 'labels', stylers: [{visibility: 'off'}]},
				{featureType: 'water', stylers: [{color: '#444444'}]},
				{featureType: 'landscape', stylers: [{color: '#eeeeee'}]},
				{featureType: 'road', stylers: [{visibility: 'off'}]},
				{featureType: 'poi', stylers: [{visibility: 'off'}]},
				{featureType: 'transit', stylers: [{visibility: 'off'}]},
				{featureType: 'administrative', stylers: [{visibility: 'off'}]},
				{featureType: 'administrative.locality', stylers: [{visibility: 'off'}]}
			],
			maxZoom: 19,
			type:'roadmap'
		});


		L.control.layers(roadMutant, vmap).addTo(map);


	</script>
</body>
</html>
