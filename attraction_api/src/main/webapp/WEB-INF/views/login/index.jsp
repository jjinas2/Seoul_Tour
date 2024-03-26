<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
  request.setCharacterEncoding("UTF-8");

  // 사용자가 입력한 아이디와 비밀번호를 받아옴
  String userId = request.getParameter("userId");
  String password = request.getParameter("password");

  // 간단한 로그인 검증을 위한 코드 (실제로는 보안에 취약함)
  Map<String, String> userDatabase = new HashMap<>();
  userDatabase.put("user1", "password1");
  userDatabase.put("user2", "password2");

  // 아이디와 비밀번호 검증
  if (userDatabase.containsKey(userId) && userDatabase.get(userId).equals(password)) {
    // 로그인 성공
    session.setAttribute("userId", userId); // 세션에 아이디 저장
    response.sendRedirect("Main.html"); // 로그인 성공 시 이동할 페이지
  } else {
    // 로그인 실패
    out.println("<script>alert('아이디 또는 비밀번호가 올바르지 않습니다.');</script>");
  }
%>
