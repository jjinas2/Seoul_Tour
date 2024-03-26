<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.Date" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/css.css">
	<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
</head>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelector('.board_title').classList.add('loaded');
    });
</script>
<script type="text/javascript">

</script>
<body>
<% request.setCharacterEncoding("UTF-8"); %>

    <div class="board_wrap">
        <div class="board_title">
            <strong>게시판</strong>
            <p>게시판 입니다.</p>
        </div>
        <div class="board_list_wrap">
            <div class="board_list">

                <div class="top">
                    <div class="num">번호</div>
                    <div class="title">제목</div>
                    <div class="writer">글쓴이</div>
                    <div class="date">작성일</div>
                    <div class="count">조회</div>
                </div>
                <c:forEach items="${admin}" var="admin" varStatus="status">
                <c:if test="${not empty admin.admin_title}">
	                <div class="admin_num">
	                	<div style="display: none">${status.index+1+(pageMaker.cri.pageNum - 1) * pageMaker.cri.amount}</div>
	                		<div style="display: none"><c:out value='${admin.admin_num}'/></div>
	                		<div class="num">📢</div>
	                		<div class="title">
	                    	<a href='<c:url value="admin_view">
		                    	<c:param name="adminNum" value='${admin.admin_num}' />
		                    	<c:param name="index" value="${status.index+1+(pageMaker.cri.pageNum - 1) * pageMaker.cri.amount}" />
	                    	</c:url>'>
	                    	<c:out value='${admin.admin_title}'></c:out>
		    				</a>
	    				</div>
	    				<div class="writer"><c:out value="${admin.admin_id}"></c:out></div>
                    	<div class="date"><c:out value="${admin.admin_postdate}"></c:out></div>
                    	<div class="count"><c:out value="${admin.admin_visitcount}"></c:out></div>
		                	</div>
		                	</c:if>
                	</c:forEach>
            <c:forEach items="${lists}" var="lists" varStatus="status">
                <div class="board_num">
                	<div class="num">${status.index+1+(pageMaker.cri.pageNum - 1) * pageMaker.cri.amount}</div>
                    <div style="display: none" ><c:out value="${lists.num}"></c:out></div>
                    <div class="title">
                    <a href='<c:url value="view">
                    <c:param name="boardNum" value="${lists.num}" />
                    <c:param name="index" value="${status.index+1+(pageMaker.cri.pageNum - 1) * pageMaker.cri.amount}" />
                    </c:url>'>
                    	<c:out value="${lists.title}"></c:out>
    				</a></div>
                    <div class="writer"><c:out value="${lists.id}"></c:out></div>
                    <div class="date"><c:out value="${lists.postdate}"></c:out></div>
                    <div class="count"><c:out value="${lists.visitcount}"></c:out></div>
                </div>
             </c:forEach>
            </div>
            <div class="board_page">
	            <ul id="pageInfo" class="pageInfo">
	                <c:if test="${pageMaker.prev}">
	                    <a href="${pageMaker.startPage-1}" class="bt first"><<</a>
	                </c:if>
	                
	            	<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
	                    <a href="${num}" class="num">${num}</a>
	                </c:forEach>

	                <c:if test="${pageMaker.next}">
	                    <a href="${pageMaker.endPage + 1 }" class="bt prev">>></a>
	                </c:if>
                </ul>
            </div>
        <form id="moveForm" method="get">
        	 <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
        	<input type="hidden" name="amount" value="${pageMaker.cri.amount }"> 
        </form>

            <div class="bt_wrap">
            	<c:if test="${!empty user }">
                <a href="write" id="user_write" class="on">등록</a></c:if>
                <c:if test="${!empty user && user.userID == admindbID}">
                <a href="admin_write" id="">공지사항 등록</a></c:if>
            </div>
            
        </div>
    </div>
<script>
function alert(message) {
    Swal.fire({
        text: message,
        icon: 'info',
        confirmButtonText: '확인'
    });
}
$(document).ready(function(){
	let result = '<c:out value="${result}"/>';
	checkAlert(result);
	console.log(result);
	
	function checkAlert(result){
		if(result===""){
			return;
		}
		if(result==="write success"){
			alert("등록이 완료되었습니다.");
		}
		if(result==="edit success"){
			alert("수정이 완료되었습니다.");
		}
		if(result==="delete success"){
			alert("삭제가 완료되었습니다.");
		}
	}
});

let moveForm = $("#moveForm");
$(".pageInfo a").on("click", function(e){
	 
    e.preventDefault();
    moveForm.find("input[name='pageNum']").val($(this).attr("href"));
    moveForm.attr("action", "/board/list");
    moveForm.submit();
    
});


</script>
</body>
</html>