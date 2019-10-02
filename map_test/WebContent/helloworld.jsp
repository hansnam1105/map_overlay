<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>구글지도사용하기</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg" ></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d0fc5d72e25a0b546486f2b3f388779b"></script>
<style>
#map_ma {width:100%; height:700px; clear:both; border:solid 1px red;}
#wrap { position:fixed; /*감싸는 레이어에 포지션 속성을 잡아주는 게 필수!(relative, absolute, fixed 중 택1*/ width:100%; height:700px;}
#over { position:absolute; top:100px; left:100px;/*위에 올라가는 레이어의 포지션은 top, bottom 둘 중 하나, left, right 둘 중 하나의 속성을 선택하여 잡아준다.*/ width:500px; height:400px;}
</style>
</head>
<body>

<script type="text/javascript">
		$(document).ready(function() {
	var myLatlng = new google.maps.LatLng(35.9078,127.7669); // 위치값 위도 경도
	var Y_point			= 35.9078;		// Y 좌표
	var X_point			= 127.7669;		// X 좌표
	var zoomLevel		= 5;				// 지도의 확대 레벨 : 숫자가 클수록 확대정도가 큼

	var container = document.getElementById('over');
	var options = {
		center: new kakao.maps.LatLng(Y_point, X_point),
		level: 15
	}

	var map2 = new kakao.maps.Map(container, options);
	
	
	var myLatlng = new google.maps.LatLng(Y_point, X_point);
	var mapOptions = {
						zoom: zoomLevel,
						center: myLatlng,
						mapTypeId: google.maps.MapTypeId.ROADMAP
					}
	var map = new google.maps.Map(document.getElementById('wrap'), mapOptions);


});

	
		</script>
		<div id="wrap">
			<div id="over"></div>
		</div>
		<div id="map" style="height:600px;"></div>
</body>
</html>