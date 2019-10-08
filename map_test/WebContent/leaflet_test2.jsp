<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCW-rn3iLcHQkN1AKG8hnDUyg8xCJatCdg"></script>
	<script type="text/javascript" src="http://map.vworld.kr/js/apis.do?type=Base&apiKey=980584DE-E32E-316C-A0F0-271B354FC1AE"></script>

</head>
<body>
<div id="map" class="map"></div>

	<script type="text/javascript">
	var map = L.map('map').setView([37.5,127],6);
	
	var baseLayer = L.tileLayer().addTo(map);
	var topLayer = L.tileLayer().addTo(map)
	
	</script>
</body>
</html>