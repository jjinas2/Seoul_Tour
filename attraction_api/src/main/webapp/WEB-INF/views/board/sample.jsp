<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
	<tbody>
		<c:forEach items="${a}" var = "data">
			<tr>
				<td><c:out value="${data.id}"></c:out></td>
			</tr>
		</c:forEach>
	</tbody>
	
</table>
</body>
</html>