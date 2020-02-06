<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>tableauTest</title>
<script src="https://YOUR-SERVER/javascripts/api/tableau-2.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script>
function initViz() {
    var containerDiv = document.getElementById("vizContainer"),
    url = "https://YOUR-SERVER/views/YOUR-VISUALIZATION";

    var viz = new tableau.Viz(containerDiv, url);
}
initViz();

</script>
</head>
<body>
<div id="vizContainer"></div>

</body>
</html>