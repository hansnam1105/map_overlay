<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.6.0/dist/leaflet.css" />
 <style>
        html, body, #map {
            height: 100%;
            padding: 0;
            margin: 0;
        }
</style>


</head>
<body>
<div id="map"></div>
<script src="https://unpkg.com/leaflet@1.6.0/dist/leaflet.js"></script>
<script type="text/javascript" src="/map_test/leaflet-echarts-master/src/leaflet-echarts.js"></script>
<script type="text/javascript" src="/map_test/leaflet-echarts-master/lib/echarts.source.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<script>
    var map = L.map('map');

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);

    map.setView(L.latLng(37.550339, 104.114129), 4);

    var overlay = new L.echartsLayer(map, echarts);
    var chartsContainer=overlay.getEchartsContainer();
    var myChart=overlay.initECharts(chartsContainer);
    window.onresize = myChart.onresize;
    var option = {
    color: ['gold','aqua','lime'],
    title : {
        text: 'test',
        subtext:'for all countries',
        x:'center',
        textStyle : {
            color: '#fff'
        }
    },
    tooltip : {
        trigger: 'item',
        formatter: '{b}'
    },
    legend: {
        orient: 'vertical',
        x:'right',
        data:['korea Top10', 'china Top10', 'us Top10'],
        selectedMode: 'single',
        selected:{
            'china Top10' : false,
            'us Top10' : false
        },
        textStyle : {
            color: '#fff'
        }
    },
    dataRange: {
        min : 0,
        max : 100,
        calculable : true,
        color: ['#ff3333', 'orange', 'yellow','lime','aqua'],
        textStyle:{
            color:'#fff'
        }
    },
    series : [
        {
            name: 'Nation',
            type: 'map',
            roam: true,
            hoverable: false,
            mapType: 'none',
            itemStyle:{
                normal:{
                    borderColor:'rgba(100,149,237,1)',
                    borderWidth:0.5,
                    areaStyle:{
                        color: '#1b1b1b'
                    }
                }
            },
            data:[],
            markLine : {
                smooth:true,
                symbol: ['none', 'circle'],  
                symbolSize : 1,
                itemStyle : {
                    normal: {
                        color:'#fff',
                        borderWidth:1,
                        borderColor:'rgba(30,144,255,0.5)'
                    }
                },
                data : [
                    [{name:'KR'},{name:'US'}],
                    [{name:'KR'},{name:'CN'}],
                    [{name:'CN'},{name:'KR'}],
                    [{name:'CN'},{name:'US'}],
                    [{name:'US'},{name:'KR'}],
                    [{name:'US'},{name:'CN'}]
                ],
            },
            geoCoord: {
                'CN': [104.195397,35.86166],
                'US': [-95.712891,37.09024],
                'KR': [127.766922,35.907757]
               
            }
        },
        {
            name: 'korea Top10',
            type: 'map',
            mapType: 'none',
            data:[],
            markLine : {
                smooth:true,
                effect : {
                    show: true,
                    scaleSize: 1,
                    period: 30,
                    color: '#fff',
                    shadowBlur: 10
                },
                itemStyle : {
                    normal: {
                        borderWidth:1,
                        lineStyle: {
                            type: 'solid',
                            shadowBlur: 10
                        }
                    }
                },
                data : [
                    [{name:'KR'}, {name:'CN',value:95}],
                    [{name:'KR'}, {name:'US',value:90}]
                   
                ]
            },
            markPoint : {
                symbol:'emptyCircle',
                symbolSize : function (v){
                    return 10 + v/10
                },
                effect : {
                    show: true,
                    shadowBlur : 0
                },
                itemStyle:{
                    normal:{
                        label:{show:false}
                    },
                    emphasis: {
                        label:{position:'top'}
                    }
                },
                data : [
                    {name:'CN',value:90},
                    {name:'US',value:80}
                ]
            }
        },
        {
            name: 'china Top10',
            type: 'map',
            mapType: 'none',
            data:[],
            markLine : {
                smooth:true,
                effect : {
                    show: true,
                    scaleSize: 1,
                    period: 30,
                    color: '#fff',
                    shadowBlur: 10
                },
                itemStyle : {
                    normal: {
                        borderWidth:1,
                        lineStyle: {
                            type: 'solid',
                            shadowBlur: 10
                        }
                    }
                },
                data : [
                    [{name:'CN'},{name:'KR',value:95}],
                    [{name:'CN'},{name:'US',value:90}]
                ]
            },
            markPoint : {
                symbol:'emptyCircle',
                symbolSize : function (v){
                    return 10 + v/10
                },
                effect : {
                    show: true,
                    shadowBlur : 0
                },
                itemStyle:{
                    normal:{
                        label:{show:false}
                    },
                    emphasis: {
                        label:{position:'top'}
                    }
                },
                data : [
                    {name:'KR',value:95},
                    {name:'US',value:90}
                    
                ]
            }
        },
        {
            name: 'us Top10',
            type: 'map',
            mapType: 'none',
            data:[],
            markLine : {
                smooth:true,
                effect : {
                    show: true,
                    scaleSize: 1,
                    period: 30,
                    color: '#fff',
                    shadowBlur: 10
                },
                itemStyle : {
                    normal: {
                        borderWidth:1,
                        lineStyle: {
                            type: 'solid',
                            shadowBlur: 10
                        }
                    }
                },
                data : [
                    [{name:'US'},{name:'KR',value:95}],
                    [{name:'US'},{name:'CN',value:90}]
                    
                ]
            },
            markPoint : {
                symbol:'emptyCircle',
                symbolSize : function (v){
                    return 10 + v/10
                },
                effect : {
                    show: true,
                    shadowBlur : 0
                },
                itemStyle:{
                    normal:{
                        label:{show:false}
                    },
                    emphasis: {
                        label:{position:'top'}
                    }
                },
                data : [
                    {name:'KR',value:95},
                    {name:'CN',value:90}
                    
                ]
            }
        }
    ]
};                   
overlay.setOption(option);
</script>
</body>
</html>