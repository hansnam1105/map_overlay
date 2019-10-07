<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>api2.0_maptest</title>
<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=980584DE-E32E-316C-A0F0-271B354FC1AE"></script>
</head>

<body>
 <div id="vmap" style="width:100%;height:100%;left:0px;top:0px"></div>
  <select id="setMode" onchange="mapController.setMode(this.value)">
 	<option value="2d-map">2d-map</option>
 	<option value="3d-map">3d-map</option>
 </select>
 <script type="text/javascript">
  vw.MapControllerOption = {
   container : "vmap",
   mapMode : "2d-map",
   basemapType : vw.ol3.BasemapType.GRAPHIC,
   controlDensity : vw.ol3.DensityType.EMPTY,
   interactionDensity : vw.ol3.DensityType.BASIC,
   controlsAutoArrange : true,
   homePosition : vw.ol3.CameraPosition,
   initPosition : vw.ol3.CameraPosition,
  };
  
  mapController = new vw.MapController(vw.MapControllerOption);
  
 </script>
</body>
</html>