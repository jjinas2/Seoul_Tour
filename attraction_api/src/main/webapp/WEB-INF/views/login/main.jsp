<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

 <%
  // 세션에서 아이디 가져오기
  String userID = (String)session.getAttribute("userID");
 %> 
<%-- <%
// 아이디가 null이면 로그인이 되어있지 않은 상태
  if (userID == null) {
    response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
  }
%> --%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>메인화면</title>
</head>
<body>
  <h1>환영합니다, <%= userID %>님!</h1>
  <h2>${user.userID}</h2>
</body>
</html>
