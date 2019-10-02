<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<meta name="referrer" content="no-referrer">
<title>OpenLayers 2 OpenStreetMap and Google Maps</title>

<script src="https://www.openlayers.org/api/2.13/OpenLayers.js" type="text/javascript"></script>
<script type="text/javascript" src="http://map.vworld.kr/js/apis.do?type=Base&apiKey=980584DE-E32E-316C-A0F0-271B354FC1AE"></script>
<script src="https://maps.google.com/maps/api/js?v=3&key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg"></script>

<!-- Setting the #map style to height: 100% along with the html and body creates a fullscreen map -->  

<style>
    html, body, #map, #background { height: 100%; margin: 0;}
    .olMapViewport {
        font: initial;
    }
</style>

</head>

<body onload="init()">

<div id="map"></div>

<script type="text/javascript">

var map;

// This function creates the map and is called by the div in the HTML

function init() {

    var attribOSM = "&copy; <a href='http://www.openstreetmap.org/copyright' target='_blank'>OpenStreetMap</a> contributors";

    var extent = new OpenLayers.Bounds(-10.76418, 49.52842277863497, 1.7800000000000002, 61.33115096548108).transform(
        new OpenLayers.Projection('EPSG:4326'),
        new OpenLayers.Projection("EPSG:900913"));

    var resolutions = [
        156543.03390625,
        78271.516953125,
        39135.7584765625,
        19567.87923828125,
        9783.939619140625,
        4891.9698095703125,
        2445.9849047851562,
        1222.9924523925781,
        611.4962261962891,
        305.74811309814453,
        152.87405654907226,
        76.43702827453613,
        38.218514137268066,
        19.109257068634033,
        9.554628534317017,
        4.777314267158508,
        2.388657133579254,
        1.194328566789627,
        0.5971642833948135,
        0.2985821416974068,
        0.1492910708487034
    ];

    var controls = [new OpenLayers.Control.Navigation(),
                    new OpenLayers.Control.KeyboardDefaults(),
                    new OpenLayers.Control.LayerSwitcher(),
                    new OpenLayers.Control.ArgParser()];

    if (('ontouchstart' in window) || (navigator.maxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0)) {

// Omit map control on touch capable device

    } else {

// Otherwise add a small zoom control unaffected by map resize in case device has no mouse wheel

        controls.push(new OpenLayers.Control.ZoomPanel());

    }

    if (location.hostname == "localhost" || location.hostname == "127.0.0.1" || location.protocol == "file:") {

// Omit attribution if not public facing

    } else {
        controls.push(new OpenLayers.Control.Attribution({ separator: "<br>" }));
    }

// Create new map

    map = new OpenLayers.Map({
        div: "map",
        controls: controls,
        units: "m",
        projection: "EPSG:900913",
        layers: [ 
            new OpenLayers.Layer.XYZ(
                "OpenStreetMap", [
                    "http://a.tile.openstreetmap.org/${z}/${x}/${y}.png",
                    "http://b.tile.openstreetmap.org/${z}/${x}/${y}.png",
                    "http://c.tile.openstreetmap.org/${z}/${x}/${y}.png"
                ], {
                    attribution: attribOSM,
                    serverResolutions: resolutions.slice(0,20),
                    wrapDateLine: true,
                    numZoomLevels: resolutions.length
                }
            ),
            new OpenLayers.Layer.Google(
                "Google Roadmap", {
                    type: google.maps.MapTypeId.ROADMAP,
                    numZoomLevels: resolutions.length
                }
            ),
            //new vworld.Layers.Base('VBASE')
        ]
    });

// Disable any zoom out requests which reset the map centre

    map.zoomToMaxExtent = function() {};

// Adjust attribution position

    function adjustAttribution() {
        if (map.getControlsByClass("OpenLayers.Control.Attribution").length > 0) {
            document.getElementsByClassName("olControlAttribution")[0].style.bottom = map.baseLayer.name.indexOf("Google") < 0 ? "3px" : "17px";
        }
    }
    adjustAttribution();
    map.events.register("changebaselayer", map, adjustAttribution );
}
</script>
</body>
</html>
