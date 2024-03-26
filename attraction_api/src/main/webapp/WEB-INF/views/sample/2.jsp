<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>2</title>
</head>
<body>
페이지 2
<body>
<form action="/sample/insert" method="post">
	<div>
		<label>이름</label>
		<input type="text" value="${i.userName}" name="userName">
	</div>
	<div>
		<label>id</label>
		<input type="text" value="${i.userID}" name="userID">
	</div>
	<div>
		<label>비밀번호</label>
		<input type="text" value="${i.userPassword}" name="userPassword">
	</div>
	<div>
		<label>연령대</label>
		<input type="text" value="${i.userAge}" name="userAge">
	</div>
	<div>
		<label>성별</label>
		<input type="text" value="${i.userSex}" name="userSex">
	</div>
	<div>
		<label>지역</label>
		<input type="text" value="${i.userArea}" name="userArea">
	</div>
	<input type="submit" value="회원 가입">
</form>
		
</body>
</body>
</html>