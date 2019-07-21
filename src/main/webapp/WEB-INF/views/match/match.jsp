<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="vo.Login_InfoVO, vo.UsersVO, vo.FieldVO, java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.2.min.js"></script>
 <link rel="stylesheet" href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css"
   integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ=="
   crossorigin=""/>
	<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js"
	   integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og=="
	   crossorigin=""></script>
</head>
<body>
	<%
		Login_InfoVO user = (Login_InfoVO)session.getAttribute("loginUser");
		if(user!=null){
	%>
		<h2>로그인아이디 : ${ sessionScope.loginUser.user}</h2>
	<%}%>
		※ 매칭 서비스를 사용하시려면 반드시 마이페이지에서 추가정보를 입력하셔야합니다.<br>
	<%
		UsersVO userInfo = (UsersVO) request.getAttribute("matchInfo");
		if((userInfo.getLat()==null)&&(userInfo.getField()==0)){
	%>
		추가 정보를 입력하지 않았습니다. 
		<a href="/mini/mypage">추가입력 바로가기</a>
	<%} %>
	<form method="post" action="/mini/match" onsubmit="return check()">
				<input type="hidden" name="action" value="result" />
				<input type="hidden" name="lat" id="mapLat" />
				<input type="hidden" name="lng" id="mapLng" />
				스터디 매칭 분야 : <select name="field">
						<%
							ArrayList<FieldVO> field = (ArrayList<FieldVO>) request.getAttribute("field");
							if (!field.isEmpty()) {
								for (FieldVO type : field) {
						%>
						<option value="<%=type.getFid()%>"><%=type.getType()%></option>
						<%
							}}
						%>
				</select>
				<br>
				원하는 스터디 지역 검색 : 
				<input type="text" name ="location" id="location" placeholder="서울시 강남구 역삼동" required/>
				<input type="button" id="findloc" value="위치찾기" />
				<div id="mapid" style="width: 600px; height: 400px;"></div><br>
				<input type="submit" value="매칭하기" />
			</form>
			
			
			
		<script>
		function check() {
				<%
				if((userInfo.getLat()==null)&&(userInfo.getField()==0)){
				%>
				alert("마이페이지에서 추가정보를 입력해야 이용하실수 있습니다.");
				return false;
				<%}else{%>
				return true;
				<%}%>
			}
			
				
			$(document).ready(function(){
				
				var mymap =L.map('mapid').setView([37.566, 126.978], 13);
				L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
					maxZoom: 18,
					attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
						'<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
						'Imagery <a href="https://www.m/* apbox.com/">Mapbox</a>',
					id: 'mapbox.streets'
				}).addTo(mymap);
				
				function onMapClick(e) {
					$(".leaflet-marker-pane img").remove();
					$(".leaflet-popup-pane").remove();
					$(".leaflet-shadow-pane").remove();
					var lat = (e.latlng.lat);
				    var lng = (e.latlng.lng);
				    L.marker([lat, lng]).addTo(mymap);	
				    
				    $("input#mapLng").val(lng);
				    $("input#mapLat").val(lat);
				    
				    var latlng = encodeURIComponent(lat+","+lng);
				    $.getJSON("https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyD-nx_y7aBlJgfgVZRaIwMbnShQJsxpryY&latlng="+latlng, function(data) {
						$("input#location").val(data.results[0].formatted_address);				
												
					});
				    
				}
				
				$("#findloc").click(function(){
				
					var address = $("#location").val();
					var lat;
					var lng;
					
					if (address) {			
						$.getJSON("https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyD-nx_y7aBlJgfgVZRaIwMbnShQJsxpryY&address="+encodeURIComponent(address), function(data) {
							lat = data.results[0].geometry.location.lat;
							lng = data.results[0].geometry.location.lng;
							
							$("input#mapLng").val(lng);
						    $("input#mapLat").val(lat);
						    
							if(mymap)
								mymap.remove();
							mymap = L.map('mapid').setView([lat, lng], 16)
							L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
								maxZoom: 18,
								attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
									'<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
									'Imagery <a href="https://www.mapbox.com/">Mapbox</a>',
								id: 'mapbox.streets'
							}).addTo(mymap);
			
							 L.marker([lat, lng]).addTo(mymap);
		
							 mymap.on('click', onMapClick);
						
						});
					}		 
				
				});
				
				mymap.on('click', onMapClick);
				
				
			});
	</script>
</body>
</html>