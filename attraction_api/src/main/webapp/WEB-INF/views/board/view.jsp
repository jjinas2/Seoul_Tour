<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<%
    // index 값을 가져옴
    int index = Integer.parseInt(request.getParameter("index"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>

    <meta charset="UTF-8">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/css.css">
	<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
	
	<script src="https://kit.fontawesome.com/df4bde20cc.js" crossorigin="anonymous"></script>
</head>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelector('.board_title').classList.add('loaded');
    });
</script>
<body>
    <div class="board_wrap">
        <div class="board_title">
            <strong>게시판</strong>
            <p>게시판 입니다. - 글 보기</p>
        </div>
        <div class="board_view_wrap">
            <div class="board_view">
                <div class="title">
                <c:out value="${boardWrite.title}"></c:out></div>
                <div class="info">
                    <dl>
                        <dt>번호</dt>
                        <dd>
                        <c:out value="${param.index}"></c:out>
                        <input type="hidden" name="boardNum" value="${boardWrite.num}"/>
                        </dd>
                    </dl>
                    <dl>
                        <dt>글쓴이</dt>
                        <dd><c:out value="${boardWrite.id}"></c:out></dd>
                    </dl>
                    <dl>
                        <dt>작성일</dt>
                        <dd><c:out value="${boardWrite.postdate}"></c:out></dd>
                    </dl>
                    <dl>
                        <dt>조회</dt>
                        <dd><c:out value="${boardWrite.visitcount}"></c:out></dd>
                    </dl>
                    
                    
                    <button class="like__btn" onclick="updateLike(event);">
					    <span id="likeCount">${boardWrite.likecount}</span> Like
					    <span id="icon">
					        <c:if test="${likeCheck eq 1}">
					            <i class="fa-solid fa-heart"></i>
					        </c:if>
					        <c:if test="${likeCheck eq 0}">
					            <i class="fa-regular fa-heart"></i>
					        </c:if>
					    </span>
					</button>
					
                    
                    
                </div>
                <div class="cont"><c:out value="${boardWrite.content}"></c:out></div>
 
            </div>
                 <div class="row">
			      	<div class="col-lg-12">
			      		<div class="card shadow mb-4">
			      			<div class="card-header py-3">
			      				<h4 class="m-0 font-weight-bold text-primary">파일 첨부</h4>
			      			</div>
			      			<div class="card-body">
			      				<div class="uploadResult">
			      					<ul></ul>
			      				</div>
			      			</div>
			      		</div>
			      	</div>
			      </div>
			      <div class='bigPictureWrapper'>
						<div class='bigPicture'></div>
					</div>
            <div class="bt_wrap">
                <a href="list" class="on">목록</a>
            <c:if test="${not empty user && user.userID eq boardWrite.id || user.userID == admindbID}">
      			<a href='<c:url value="edit"><c:param name="boardNum" value="${boardWrite.num}" /></c:url>'>
                    	수정
    				</a>
      		</c:if>
                
    			
            </div>
           <div class="comment_wrap">
    		<form id="commentForm" action="/board/view" method="post">
    		<!-- 게시글 ID와 댓글의 boardId가 일치하는 경우에만 표시 -->
	        		<div>
                    <div >작성자 <c:out value="${user.userID}" ></c:out></div>
                    <!-- 게시판 넘버와 로그인한 아이디 받아옴 -->
                    <input type="hidden" name="board_num" value="${boardWrite.num}">
                    <input type="hidden" name="index" value="${param.index}" />
                    <input type="hidden" name="id" value="${user.userID}"  />
                    <!-- 댓글 내용 입력 -->
                    <input type="text" name="co_content" placeholder="댓글을 입력하세요" />
                    
                  <a href="" class="comment_btn">입력</a>
                  
                          
                 </div>
        		</form>
        		<div class="comment_list">
        		
        		<c:forEach items="${comments}" var="comments">
        		<div class="comment" data-comments-num="${comments.co_num}">
        		
        			<div class="co_num" style="display: none" ><c:out value="${comments.co_num}"></c:out>
        			</div>
        			<div class="id">
        			<c:out value="${comments.id}"/>
        			</div>
        			<div class="co_content">
        			<c:out value="${comments.co_content}"></c:out>
        			</div>
        			<div class="co_date">
        			<c:out value="${comments.co_date}"></c:out>
        			<c:if test="${not empty user and (user.userID eq comments.id or user.userID eq admindbID)}">
				        <a href="" class="edit-comment-btn">수정</a>
				        <a href="" class="delete-comment-btn">삭제</a>
			        </c:if>
        			</div>
        		</div>
        		</c:forEach>
        		
        		</div>
        		
    		
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
function confirm(mgs, callback) {
	Swal.fire({
        title: mgs,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes',
        cancelButtonText: 'No',
    }).then((result) => {
        if (result.isConfirmed) {
            callback(true);  // Yes 버튼이 클릭된 경우 콜백 함수 호출
        } else if (result.dismiss === Swal.DismissReason.cancel) {
            callback(false);  // No 버튼이 클릭된 경우 콜백 함수 호출
        }
    });
  }
function prompt(mgs, initialValue, callback) {
    Swal.fire({
        title: mgs,
        icon: 'warning',
        input: 'text',
        inputValue: initialValue, // 기존 댓글 내용을 기본값으로 설정
        showCancelButton: true,
        inputValidator: (value) => {
            if (!value) {
                return '댓글을 입력하세요!';
            }
        }
    }).then((result) => {
        if (result.isConfirmed) {
            callback(result.value); // 사용자가 입력한 값을 콜백 함수에 전달
        }
    });
}
var board_num = ${boardWrite.num};
var user_id = '${user.userID}';

 function updateLike(e){ 
	 e.preventDefault();
     $.ajax({
            type : "POST",  
            url : "/board/updateLike",       
            dataType : "json",
            data : {'board_num' : board_num, 'user_id' : user_id},
            error : function(error){
               alert("로그인한 사용자만 이용가능합니다.");
               console.log("error",error)
            },
            success : function(likeCheck) {
            	var likeIcon = document.getElementById('icon');
                var likeCount = document.getElementById('likeCount');

                if (likeCheck == 0) {
                    console.log("추천완료.");
                    likeIcon.innerHTML = '<i class="fa-solid fa-heart"></i>';
                    likeCount.textContent = parseInt(likeCount.textContent) + 1;
                } else if (likeCheck == 1) {
                    console.log("추천취소");
                    likeIcon.innerHTML = '<i class="fa-regular fa-heart"></i>';
                    likeCount.textContent = parseInt(likeCount.textContent) - 1;
                }
            }
        });
 }
$(document).ready(function() {
	
	function showImage(fileCallPath){
		$(".bigPictureWrapper").css("display","flex").show();
		$(".bigPicture")
			.html("<img src='/display?fileName="+fileCallPath+"'>")
			.animate({width:'100%', height:'100%'}, 1000);
	}
	
	$(".uploadResult").on("click", "li", function(e){
		console.log("view image");
		var liObj = $(this);
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));

		if (liObj.data("type")) {
			showImage(path.replace(new RegExp(/\\/g), "/"));
		} else {
			self.location = "/download?fileName=" + path
		}
	});
	

    //﻿ 원본 이미지 창 닫기
    $(".bigPictureWrapper").on("click", function(e){
        $(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
        setTimeout(function(){
            $(".bigPictureWrapper").hide();
        }, 1000);
    });
    
	(function(){
		var num = "${boardWrite.num}";
		$.getJSON("/board/getAttachList", {num: num}, function(arr){
			console.log(arr);
			var str="";
	        
			$(arr).each(function(i,attach) {
				if (attach.fileType) {
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
					str += "<li style='cursor:pointer' data-path='"+attach.uploadPath+"'";
					str += " data-uuid='"+attach.uuid+"' data-fileName='"+attach.fileName+"'data-type='"+attach.fileType+"'>";
					str += " <div>";
					str += "<img src='/display?fileName=" + fileCallPath + "'>";
					str += "<span> " + attach.fileName + " </span>";
					str += "</div>";
					str += "</li>";
				} else {
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					str += "<li style='cursor:pointer' data-path='"+attach.uploadPath+"'";
					str += " data-uuid='"+attach.uuid+"' data-fileName='"+attach.fileName+"'data-type='"+attach.fileType+"'>";
					str += " <div>";
					str += "<img src='/resources/img/attachment.png' style='width: 50px;'>";
					str += "<span> " + attach.fileName + " </span>";
					str += "</div>";
					str += "</li>";
				}
			});
	        $(".uploadResult ul").html(str);
	    });
	})();
	$(document).on("click", ".comment_btn", function(e) {
        e.preventDefault();

        var formData = {
            co_content: $("input[name='co_content']").val(),
            co_num: $("input[name='co_conum']").val(),
            id: $("input[name='id']").val(),
            board_num: $("input[name='board_num']").val(),
            admindbID:"${admindbID}"
        };
        
        $.ajax({
            type: "POST",
            url: "/board/view",
            data: JSON.stringify(formData),    
            dataType: "json",
            contentType: "application/json",
            success: function(data) {
            	console.log("서버 응답:", data);
                if (data && data.length > 0) {
                	// 상준 : data.length가 여기서 undefined임 그래서 data == true일 경우에만 실행하게 함 (무조건)
                    // 새로운 댓글 리스트를 동적으로 갱신
                    console.log("data2 : ",data)
                    $(".comment_list").empty();
                    for (var i = 0; i < data.length; i++) {
                        var commentHtml = '<div class="comment">' +
                        	'<div class="co_num" style="display: none">' + data[i].co_num + '</div>'+
                            '<div class="id">' + data[i].id + '</div>' +
                            '<div class="co_content">' + data[i].co_content + '</div>' +
                            '<div class="co_date">' + data[i].co_date;
                            commentHtml += (formData.id === data[i].id || formData.id === formData.admindbID) ?
                                    '<a href="" class="edit-comment-btn">수정</a>' +
                                    '<a href="" class="delete-comment-btn">삭제</a>' :
                                    '';
                            commentHtml +=
                            '</div>'+
                            '</div>';
                        $(".comment_list").append(commentHtml);
                        console.log(commentHtml); // 여기는 안됨
                    }
                    // 입력 필드 초기화
                    // 상준 : 3줄이 실행이 안됨 => 1번 
                    $("input[name='co_content']").val("");
                    alert("댓글이 성공적으로 등록되었습니다.");
                    console.log("댓글이 성공적으로 등록되었습니다.");
                } else {
                	// 처음에 else문이 실행
                    alert("댓글 등록에 실패했습니다.");
                }
            	
            	
            },
            error: function(error) {
                alert("댓글 등록에 실패했습니다. Error: " + error);
                console.log("Error:", error);
            }
        });
    });
	
	// 수정하는 부분이에요 :)
    $(document).on("click", ".edit-comment-btn", function(e) {
    	e.preventDefault();
        var coNum = $(this).closest(".comment").find(".co_num").text();
        var coContent = $(this).closest(".comment").find(".co_content").text();
        console.log( coNum, coContent)

        // 사용자에게 새로운 코멘트 내용을 입력받습니다.
        prompt("댓글을 수정하세요:", coContent, function (newCoContent) {
		    // 사용자가 내용을 입력했을 경우에만 댓글을 업데이트합니다.
		    if (newCoContent !== null) {
		        var formData = {
		            id: $("input[name='id']").val(),
		            co_num: coNum,
		            co_content: newCoContent,
		            board_num: $("input[name='board_num']").val()
		        };
		            $.ajax({
		                type: "POST",
		                url: "/board/comment/update",
		                data: JSON.stringify(formData),
		                dataType: "json",
		                contentType: "application/json",
		                success: function(data) {
		                	console.log("updatedComments",formData.admindbID)
		                    // 업데이트된 코멘트 리스트로 화면을 갱신합니다.
		                    $(".comment_list").empty();
		                    for (var i = 0; i < data.length; i++) {
		                    	console.log('data[i].id : ',data[i].id)
		                        var commentHtml = '<div class="comment">' +
		                            '<div class="co_num" style="display: none;">' + data[i].co_num + '</div>' +
		                            '<div class="id">' + data[i].id + '</div>' +
		                            '<div class="co_content">' + data[i].co_content + '</div>' +
		                            '<div class="co_date">' + data[i].co_date ;
		                            commentHtml += (formData.id === data[i].id || formData.id === formData.admindbID) ?
		                                    '<a href="" class="edit-comment-btn">수정</a>' +
		                                    '<a href="" class="delete-comment-btn">삭제</a>' :
		                                    '';
		                            commentHtml +=
		                            '</div>'+
		                            '</div>';
		                        $(".comment_list").append(commentHtml);
		
		                    }
		                    
		                    alert("댓글이 성공적으로 수정되었습니다.");
		                    console.log("댓글이 성공적으로 수정되었습니다.")
		                },
		                error: function(error) {
		                    alert("댓글 수정에 실패했습니다. Error: " + error);
		                    console.log("Error:", error);
		                }
		            });
		        }
		    });
    });

 // 삭제 버튼에 대한 이벤트 리스너
   $(document).on("click", ".delete-comment-btn", function (e) {
    e.preventDefault();
    var coNum = $(this).closest(".comment").find(".co_num").text();
    var deletedCommentElement = $(this).closest(".comment");
    // 사용자에게 확인을 받습니다.
    confirm("정말로 이 댓글을 삭제하시겠습니까?", function(isConfirmed) {
        if (isConfirmed) {
            var formData = {
                co_num: coNum
            };

            $.ajax({
                type: "POST",
                url: "/board/comment/delete",
                data: JSON.stringify(formData),
                dataType: "json",
                contentType: "application/json",
                success: function () {
                    // 삭제된 코멘트만 화면에서 제거합니다.
                    deletedCommentElement.remove();
                    alert("댓글이 성공적으로 삭제되었습니다.");
                },
                error: function (error) {
                    alert("코멘트 삭제에 실패했습니다. Error: " + error);
                }
            });
        }
    });
});
});
</script>
</body>
</html>