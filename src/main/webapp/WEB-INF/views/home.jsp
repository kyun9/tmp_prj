<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ page session="true" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	tmp  
</h1>
<%
if(session.getAttribute("loginUser")!=null){
%>
<h2>로그인아이디 : ${ sessionScope.loginUser.user}</h2>
<form method="get" action="/mini/logout">
<input type="submit" value="로그아웃">
<input onclick="goMypage(); return false;" type="button" value="마이페이지">
<input onclick="goBoard(); return false;" type="button" value="게시판">
<input onclick="goGroup(); return false;" type="button" value="그룹">
</form>
<%
}else{
%>
<button onclick="goLogin()">로그인화면</button>
<button onclick="goRegister()">회원가입화면</button>
<button onclick="goBoard()">게시판</button>
<button onclick="goGroup()">그룹</button>
<%
}
%>
<script>
	function goLogin(){
		location.href="/mini/login/"
	}
	function goRegister(){
		location.href="/mini/register/"
	}
	function goMypage(){
		location.href="/mini/mypage/"
	}
	function goBoard(){
		location.href="/mini/board/"
	}
	function goGroup(){
		location.href="/mini/group/"
	}
</script>
</body>
</html>
