<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<c:if test="${loginMember.userID != admindbID }">
	<script>
		alert("관리자만 이용 가능한 페이지 입니다.")
		location.href="/board/list"
	</script>
</c:if>
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
<form id="editForm" action="/board/admin_edit" method="post" enctype="multipart/form-data">
    <div class="board_wrap">
        <div class="board_title">
            <strong>공지사항</strong>
            <p>공지사항을 빠르고 정확하게 안내해드립니다.</p>
        </div>
        <div class="board_write_wrap">
            <div class="board_write">
                <div class="title">
                    <dl>
                        <dt>제목</dt>
                        <dd><input type="hidden" name="admin_num" value="<c:out value="${adminNum.admin_num}"/>">
                        <input type="hidden" name="admin_postdate" value="<c:out value="${adminNum.admin_postdate}"/>">
                        <input type="text" name="admin_title" value="<c:out value="${adminNum.admin_title}"/>"></dd>
                    </dl>
                </div>
                <div class="info">
                    <dl>
                        <dt>글쓴이</dt>
                           <dd>
                              <div><c:out value='${adminNum.admin_id}'/></div>
                           </dd>
                    </dl>
                    <dl>
                        <dt></dt>
                        <dd><input type="hidden"  name="admin_id" value="${adminNum.admin_id}">
                        <input type="hidden"  name="admin_pw" value="${adminNum.admin_pw}"></dd>
                    </dl>
                </div>
                
                <div class="cont">
                    <textarea placeholder="내용 입력" name="admin_content"><c:out value="${adminNum.admin_content}"/></textarea>
                </div>
            </div>
            <div class="row">
			   <div class="col-lg-12">
			      <div class="card shadow mb-4">
			         <div class="card-header py-3">
			            <h4 class="m-0 font-weight-bold text-primary">파일 첨부</h4>
			         </div>
			         <div class="card-body">
			         	<div class="form-group uploadDiv">
			               <input type="file" name="uploadFile" multiple>
			            </div>
			            <div class="uploadResult">
			               <ul></ul>
			            </div>
			         </div>
			      </div>
			   </div>
			</div>
            <div class="bt_wrap">
            	<a href=# id="edit_btn" class="on">수정</a>
            	<a href=# id="delete_btn">삭제</a>
                <a href=# id="cancel_btn" class="on">취소</a>
            </div>
            
        </div>
    </div>
    </form>
    <form id="infoForm" action="/board/admin_edit" method="get">
          <input type="hidden" name="adminNum" value="<c:out value="${adminNum.admin_num}"/>">
    </form>
<script>
function alert(mgs, callback) {
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
$(document).ready(function() {
	let form = $("#infoForm");
	let mForm = $("#editForm");
	
	$("#cancel_btn").on("click", function(e){
	    form.find("#admin_num").remove();
	    form.attr("action", "/board/list");
	    form.submit();
	});
	
	$("#edit_btn").on("click", function(e){
		e.preventDefault();
		alert("수정 하시겠습니까?", function(isConfirmed){
			if(isConfirmed){
				var str = "";
		    	$(".uploadResult ul li").each(function(idx, obj){
		    		console.log("obj: ", obj)
		    		var jobj =$(obj)
		    		console.dir("jobj",jobj) // 나중에 hidden 으로 변경예정
		    		str+= "<input type='hidden' name='attachList["+idx+"].fileName' value='"+jobj.data('filename')+"'>"
		    		str+= "<input type='hidden' name='attachList["+idx+"].uuid' value='"+jobj.data('uuid')+"'>"
		    		str+= "<input type='hidden' name='attachList["+idx+"].uploadPath' value='"+jobj.data('path')+"'>"
		    		str+= "<input type='hidden' name='attachList["+idx+"].fileType' value='"+jobj.data('type')+"'>"
		        });
		
		        if (!$("input[name='title']").val() ) {
		            alert("제목을 입력하세요.");
		            e.preventDefault()
		        } else if(!$("textarea[name='content']").val()){
		        	alert("내용을 입력하세요.");
		            e.preventDefault()
		        } else {
		        	mForm.append(str);
		            mForm.submit();
		        }
			}
		});
    });
	
	$("#delete_btn").on("click", function (e) {
	    e.preventDefault();

	    confirm("게시글을 삭제하시겠습니까?", function (isConfirmed) {
	        if (isConfirmed) {
	            form.attr("action", "/board/delete");
	            form.attr("method", "post");
	            form.submit();
	        }
	    });
	});

	$(".uploadResult").on("click", "button", function(e){
		console.log("delete file");
	    var button = $(this);

	    confirm("파일을 삭제하시겠습니까?", function(isConfirmed) {
	        if (isConfirmed) {
	            // 사용자가 확인(Yes)를 선택한 경우 실행할 로직
	            var targetLi = button.closest("li");
	            targetLi.remove();
	        }
	        // No를 선택한 경우에는 추가 로직이 필요하다면 여기에 추가할 수 있습니다.
	    });
	});
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");  //정규식
	var maxSize = 5242880;  //5MB

	function checkExtension(fileName, fileSize) {
	   if (fileSize >= maxSize) {
	      alert("파일 사이즈 초과");
	      return false;
	   }
	   
	   if (regex.test(fileName)) {
	      alert("해당 종류의 파일은 업로드할 수 없습니다.");
	      return false;
	   }
	   return true;
	}
	$("input[type='file']").change(function(e){
		   var formData = new FormData();  //폼 태그에 대응되는 객체
		   var inputFile = $("input[name='uploadFile']");
		   var files = inputFile[0].files;
		   
		   
		   // formData 에 file 추가
		   for (var i = 0; i < files.length; i++) {
		      if (!checkExtension(files[i].name, files[i].size)) {
		    	  console.log("files[i].name : ",files[i].name)
		         return false;
		      }
		      formData.append("uploadFile", files[i]);
		   }
		   
		   console.log("폼데이터 : ",formData.getAll("uploadFile"))
		   
		   $.ajax({
		      url: '/uploadAjaxAction',
		      processData: false,
		      contentType: false,
		      data: formData,
		      type: 'POST',
		      dataType: 'json',  
		      success: function(result){
		         console.log("결과",result); 
		         showUploadResult(result);  //업로드 결과 처리 함수
		      }
		   });
		   
		});
	var uploadResult =$(".uploadResult ul")
	const showUploadResult=(uploadResultArr)=>{
		if(!uploadResultArr || uploadResultArr.length ==0) return
		var str=""
		$(uploadResultArr).each(function(idx, obj){ //p525
			console.log('obj',obj)
			if(obj.fileType) { // 이미지가 맞으면 아래 실행
				var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid+"_"+obj.fileName)
				var originPath = obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName
				originPath = originPath.replace(new RegExp(/\\/g), "/")  // "\\" => "/"  로 대체한다 (global)
				str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.fileType+"'"
				str+= "><div><span>"+obj.fileName+"</span><button type='button' class='delete-button' data-file=\'"+fileCallPath+"\' data-type='fileType' "
				str+= "><i class='fas fa-times-circle'></i></button><br>"
				str += "<img src='/display?fileName=" + fileCallPath + "'>";
				str += "</div>";
				str += "</li>";
			} else { // 이미지가 아니면 아래 실행
				var fileCallPath = encodeURIComponent(obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName)
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
				str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.fileType+"'"
				str+= "><div><span>"+obj.fileName+"</span><button type='button' class='delete-button' data-file=\'"+fileCallPath+"\' data-type='file' "
				str+= "><i class='fas fa-times-circle'></i></button><br>"
				str+= "<img src='/resources/img/attachment.png'></div></li>"
			}
		})
		uploadResult.append(str)
	}
	// 익명함수 정의함과 동시에 호출
	(function(){
		var num = "${adminNum.admin_num}";
		$.getJSON("/board/getAdminAttachList", {num: num}, function(arr){
			console.log("arr : ",arr);
			console.log("num :",num);
			var str="";
			
			$(arr).each(function(i,attach) {
				if (attach.fileType) {
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
					str += "<li style='cursor:pointer' data-path='"+attach.uploadPath+"'";
					str += " data-uuid='"+attach.uuid+"' data-fileName='"+attach.fileName+"'data-type='"+attach.fileType+"'>";
					str += "<span> " + attach.fileName + " </span>";
					str += " <button type='button' class='delete-button'><i class='fas fa-times-circle' data-file='"+fileCallPath+"' data-type='fileType'></i></button>"
					str += " <div>";
					str += "<img src='/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				} else {
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					str += "<li style='cursor:pointer' data-path='"+attach.uploadPath+"'";
					str += " data-uuid='"+attach.uuid+"' data-fileName='"+attach.fileName+"'data-type='"+attach.fileType+"'>";
					str += "<span> " + attach.fileName + " </span>";
					str += " <button type='button' class='delete-button'><i class='fas fa-times-circle' data-file='"+fileCallPath+"' data-type='fileType'></i></button>"
					str += " <div>";
					str += "<img src='/resources/img/attachment.png' style='width: 50px;'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			
			$(".uploadResult ul").append(str);
		});
	})();
});
</script>
</body>
</html>
