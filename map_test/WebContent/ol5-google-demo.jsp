<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<meta name="referrer" content="no-referrer">
<title>OpenLayers 5 Google Maps and OpenStreetMap with geology</title>
<link rel="icon" href="favicon-osm.ico" type="image/x-icon" />

<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg" ></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d0fc5d72e25a0b546486f2b3f388779b"></script>
<link rel="stylesheet" href="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/css/ol.css" type="text/css">
<script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://cdn.rawgit.com/openlayers/openlayers.github.io/master/en/v5.3.0/build/ol.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.4.4/proj4.js"></script>

<link rel="stylesheet" href="ol-layerswitcher.css" type="text/css">
<script type= "text/javascript" src="ol-layerswitcher.js"></script>

<!-- Setting the .map style to height: 100% along with the html and body creates a fullscreen map -->  

<style>
    html, body, .map, div.fill {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        overflow: hidden;
    }
    .olmap {
        font: initial;
    }
</style>

<style id="gm-style-cc">
</style>

</head>

<body onload="init()">

<div id="map" class="map">
    <div id="gmap" class="fill"></div>
    <div id="olmap" class="fill olmap"></div>
</div>

<script type="text/javascript">

// This function creates the map and is called by the div in the HTML

function init() {

    var osmAttrib = "&copy; <a href='http://www.openstreetmap.org/copyright' target='_blank'>OpenStreetMap</a> contributors";

    var bgsAttrib = "Contains British Geological Survey materials &copy; NERC " + (new Date).getFullYear();

    proj4.defs('EPSG:27700', '+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs ');

    if (ol.proj.proj4 && ol.proj.proj4.register) { ol.proj.proj4.register(proj4); }

// Create new map

    var proj3857 = ol.proj.get('EPSG:3857');
    var extent = proj3857.getExtent();
    var maxResolution = ol.extent.getWidth(extent) / 256;

    var resolutions = [];
    for (var i = 0; i < 21; i++) {
        resolutions[i] = maxResolution / Math.pow(2, i);
    }

    var gmap = new google.maps.Map(document.getElementById('gmap'), {
        disableDefaultUI: true,
        keyboardShortcuts: false,
        draggable: false,
        disableDoubleClickZoom: true,
        scrollwheel: false,
        streetViewControl: false,
        zoomControl: false,
        animatedZoom: false            // to reduce lag, requires ?v=3.31 (or earlier)
    });

    var view = new ol.View({
        // make sure the view doesn't go beyond the 22 zoom levels of Google Maps
        maxZoom: 21
    });

    view.on('change:center', function() {
        var center = ol.proj.transform(view.getCenter(), 'EPSG:3857', 'EPSG:4326');
        gmap.setCenter(new google.maps.LatLng(center[1], center[0]));
    });

    var map, gvisible;

    view.on('change:resolution', function() {
        if (gvisible) {
            //var mapContainer = document.getElementById('gmap');
            var mapContainer = map.getViewport().getElementsByTagName("canvas")[0];
            var overlays = map.getViewport().getElementsByClassName("ol-overlay-container");
            google.maps.event.addListenerOnce(
                gmap, 
                "idle", 
                function() {
                    mapContainer.style.visibility = "";
                    for (var i=0; i<overlays.length; i++) {
                        overlays[i].style.visibility = "";
                    }
                }
            );
            mapContainer.style.visibility = "hidden";
            for (var i=0; i<overlays.length; i++) {
                overlays[i].style.visibility = "hidden";
            }
        }
        gmap.setZoom(view.getZoom());
    });

    var olMapDiv = document.getElementById('olmap');

    var osmLayer = new ol.layer.Tile({

        title: "OpenStreetMap",
        type: "base",
        source: new ol.source.XYZ({
                    attributions: osmAttrib,
                    urls: [
                            "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            "https://b.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            "https://c.tile.openstreetmap.org/{z}/{x}/{y}.png"
                          ],
                    tileGrid: new ol.tilegrid.TileGrid({ resolutions: resolutions.slice(0,20),
                                                         extent: extent }),
                    transition: 0
                }),
        useInterimTilesOnError: false

    });
    osmLayer.on("change:visible", gChanged);

    var gLayerR = new ol.layer.Vector({ title: "Google Roadmap",
                                        type: "base",
                                        MapTypeId: google.maps.MapTypeId.ROADMAP,
                                        source: new ol.source.Vector({})
    });
    gLayerR.on("change:visible", gChanged);


    // Use default zoom duration when google maps not displayed

    var dControls = ol.control.defaults({
        attributionOptions: { collapsible: false }
    }).getArray();

    var dInteractions = ol.interaction.defaults({
        constrainResolution: true,
        altShiftDragRotate: false,
        dragPan: false,
        rotate: false
    }).extend([new ol.interaction.DragPan({kinetic: null})]).getArray();

    // Set OL zoom duration to zero for google maps to avoid delay before the gmap responds

    var gControls = ol.control.defaults({
        attributionOptions: { collapsible: false },
        zoomOptions: { duration: 0 }
    }).getArray();

    var gInteractions = ol.interaction.defaults({
        constrainResolution: true,
        altShiftDragRotate: false,
        dragPan: false,
        rotate: false,
        zoomDuration: 0
    }).extend([new ol.interaction.DragPan({kinetic: null})]).getArray();

    function gChanged(event) {

        if (event.target.getVisible()) {

            var mapType = event.target.get("MapTypeId");

            gvisible = mapType ? true : false;

            // update default controls and interactions according to zoom duration required

            (mapType ? gControls : dControls).forEach( function(control,index) {
                map.getControls().setAt(index,control)
            });

            (mapType ? gInteractions : dInteractions).forEach( function(interaction,index) {
                map.getInteractions().setAt(index,interaction)
            });

            // show or hide the Google logo and attributions

            var elems = document.getElementById('gmap').getElementsByTagName("a");
            var href = "https://maps.google.com/maps?ll="

            for (var i = 0; i < elems.length; i++) {
                if (elems[i].href.slice(0,href.length) == href) {
                    elems[i].style.display = ( mapType ? "inline" : "none" )
                }
            }

            var ccStyle = document.getElementById('gm-style-cc')
            var css =
                ".gm-style-cc {" +
                "    display: " + ( mapType ? "block;": "none;" ) +
                "}" +
                ".ol-attribution.ol-uncollapsible {" +
                "    margin-bottom: " + ( mapType ? "14px;": "0;" ) +
                "}";
            ccStyle.innerHTML = css;

            if (mapType) {
                gmap.setMapTypeId(mapType);
            }

        }

    }

    var bgs625layer = new ol.layer.Tile({
        title: "BGS 625k",
        source: new ol.source.TileWMS({
            url: "http://ogc.bgs.ac.uk/cgi-bin/BGS_Bedrock_and_Superficial_Geology/wms",
            params: {
                FORMAT: "image/png",
                LAYERS: "GBR_BGS_625k_BLS,GBR_BGS_625k_SLS",
                TRANSPARENT: "TRUE"
            },
            attributions: bgsAttrib,
            transition: 0
        }),
        useInterimTilesOnError: false,
        opacity: 0.5
    });
    

    map = new ol.Map({
        layers: [ gLayerR, osmLayer, bgs625layer ],
        target: olMapDiv,
        logo: false,
        controls: gControls.slice(),
        interactions: gInteractions.slice(),
        keyboardEventTarget: document,
        view: view
    });

    map.on("precompose",function(evt) {
        // if gmap isn't selected set opaque background so it can't be seen though other layers
        if (!gvisible) {
            evt.context.fillStyle = "white";
            evt.context.fillRect(0, 0, evt.context.canvas.width, evt.context.canvas.height);
        }
    });

// Set map centre to centre of GB mainland and select zoom level 7

    view.setCenter(ol.proj.transform([373500, 436500], ol.proj.get('EPSG:27700'), proj3857)); // reproject OS coords
    view.setZoom(7);

    olMapDiv.parentNode.removeChild(olMapDiv);
    gmap.controls[google.maps.ControlPosition.TOP_LEFT].push(olMapDiv);

    setTimeout(function(){ osmLayer.once("change", gChanged); osmLayer.changed(); }, 2000);

    var layerSwitcher = new ol.control.LayerSwitcher();
    map.addControl(layerSwitcher);

  }

</script>
</body>
</html>
