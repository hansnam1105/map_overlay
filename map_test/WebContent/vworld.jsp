<!DOCTYPE html>
  <head>
    <title>2DMap</title>
    <script src="https://www.openlayers.org/api/2.13/OpenLayers.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
   <script type="text/javascript" src="http://map.vworld.kr/js/apis.do?type=Base&apiKey=980584DE-E32E-316C-A0F0-271B354FC1AE"></script>
   <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg" ></script>
    
    <script type="text/javascript">
     	var map;
        var mapBounds = new OpenLayers.Bounds(123 , 32, 134 , 43);
        var mapMinZoom = 7;
        var mapMaxZoom = 30;
 
        // avoid pink tiles
        OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
        OpenLayers.Util.onImageLoadErrorColor = "transparent";
         
        function init(){
        var options = {
            controls: [],
            projection: new OpenLayers.Projection("EPSG:900913"),
            displayProjection: new OpenLayers.Projection("EPSG:4326"),
            allOverlays : true,
            units: "m",
            controls : [],
            numZoomLevels:11,
            maxResolution: 156543.0339,
            maxExtent: new OpenLayers.Bounds(-20037508.34, -20037508.34, 20037508.34, 20037508.34)
            };
        map = new OpenLayers.Map('map', options);
         
        var gmap = new OpenLayers.Layer.Google(
                "Google Roadmap", {
                    type: google.maps.MapTypeId.ROADMAP,
                    numZoomLevels: maxResolution
                });
    	
        var osm = new OpenLayers.Layer.OSM("OSM");
        var options = {serviceVersion : "",
            layername: "vBase",
            isBaseLayer: false,
            allOverlays : true,
            opacity : 1,
            type: 'png',
            transitionEffect: 'resize',
            tileSize: new OpenLayers.Size(256,256),
            min_level : 7,
             max_level : 30,
            buffer:0};
        //======================================
        //1. 배경지도 추가하기
        vBase = new vworld.Layers.Base('VBASE');
        //if (vBase != null){map.addLayer(vBase);}
               
        map.addLayers([vBase, gmap]);
 
        var switcherControl = new OpenLayers.Control.LayerSwitcher();
        map.addControl(switcherControl);
        switcherControl.maximizeControl();
 
        map.zoomToExtent( mapBounds.transform(map.displayProjection, map.projection ) );
        map.zoomTo(11);
             
        map.addControl(new OpenLayers.Control.PanZoomBar());
        //map.addControl(new OpenLayers.Control.MousePosition());
        map.addControl(new OpenLayers.Control.Navigation());
        //map.addControl(new OpenLayers.Control.MouseDefaults()); //2.12 No Support
        map.addControl(new OpenLayers.Control.Attribution({separator:" "}))
    }
  
     
    </script>
  </head>
  <body onload="init()">
  <div style="height:100%; width:100%;">
    <div id="map"></div>
  </div>
  </body>
</html>