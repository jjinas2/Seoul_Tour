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
<form id="writeForm" action="/board/admin_write" method="post" enctype="multipart/form-data">
    <div class="board_wrap">
        <div class="board_title">
            <strong>게시판</strong>
            <p>게시판 입니다. - 글 작성</p>
        </div>
        <div class="board_write_wrap">
            <div class="board_write">
                <div class="title">
                    <dl>
                        <dt>제목</dt>
                        <dd><input type="text" placeholder="제목 입력" name="admin_title"></dd>
                    </dl>
                </div>
                <div class="info">
                    <dl>
                        <dt>관리자</dt>
                        <dd>${user.userID}</dd> 
                        
                    </dl>
                    <dl>
                        <dt></dt>
                        <dd><input type="hidden"  name="admin_id" value="${user.userID}">
                        <input type="hidden"  name="admin_pw" value="${user.userPassword}"></dd>
                    </dl>
                        
                </div>
                
                <div class="cont">
                    <textarea placeholder="내용 입력" name="admin_content"></textarea>
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
            	<a href=# id="write_btn">등록</a>
            	<a href=# id="cancel_btn" class="on">취소</a>
            </div>
        </div>
    </div>
    </form>
    <form id="infoForm" action="/board/admin_write" method="get">
          <input type="hidden" name="adminNum" value="<c:out value="${adminNum.admin_num}"/>">
    </form>
<script>
function alert(message) {
    Swal.fire({
        text: message,
        icon: 'info',
        confirmButtonText: '확인'
    });
}
$(document).ready(function(){
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$")  // 정규 표현식 (Regular Expression)
	var maxSize = 5242880  //5MB
	const checkExtension=(fileName, fileSize)=>{
		if(fileSize >= maxSize) {
			alert("파일 용량 초과 (제한용량: 5MB)")
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.")
			return false;
		}
		return true;
	}
	
	let form = $("#infoForm");
	let wForm = $("#writeForm");
	
	$("#write_btn").on("click", function (e) {
		e.preventDefault();
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

        if (!$("input[name='admin_title']").val() ) {
            alert("제목을 입력하세요.");
            e.preventDefault()
        } else if(!$("textarea[name='admin_content']").val()){
        	alert("내용을 입력하세요.");
            e.preventDefault()
        } else {
        	wForm.append(str);
            wForm.submit();
        }
        
    });

    $("#cancel_btn").on("click", function (e) {
        form.attr("action", "/board/list");
        form.submit();
    });
	
	
	$("input[type='file']").change(function(e){ // 파일 업로드 버튼이 선택되면 호출되는 함수
		var formData = new FormData()
		var inputFile = $("input[name='uploadFile']")
		var files = inputFile[0].files // 여러개의 파일을 선택하면 0번 배열에 파일명의 정보가 저장됨
		//formData 에 파일 추가
		for(var i of files) {
			if(!checkExtension(i.name, i.size)) return false;
			formData.append("uploadFile", i)
		}
		
		console.log("폼데이터 write : ",formData.getAll("uploadFile"))
		
		var uploadResult =$(".uploadResult ul")
		const showUploadedFile=(uploadResultArr)=>{
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
					str+= "<img src='/display?fileName=" + fileCallPath +"'></div></li>"
				} else { // 이미지가 아니면 아래 실행
					var fileCallPath = encodeURIComponent(obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName)
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
					str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.fileType+"'"
					str+= "><div><span>"+obj.fileName+"</span><button type='button' class='delete-button' data-file=\'"+fileCallPath+"\' data-type='file' "
					str+= "><i class='fas fa-times-circle'></i></button></br>"
					str+= "<img src='/resources/img/attachment.png'></div></li>"
				}
			})
			uploadResult.append(str)
		}
		$.ajax({
			url: '/uploadBoardAction',
			processData: false,
			contentType: false,
			data: formData,
			type: 'POST',
			dataType: 'json',
			success: (result)=>{
				//alert("업로드 성공")
				console.log("업로드 성공", result)
				showUploadedFile(result) // 추가2
				//p521 , 이미지를 계속 반복해서 추가가능
				//$(".uploadDiv").html(cloneObj.html())
			}
		}) // ajax
	}) // button[type='file'] click
	$(".uploadResult").on("click","button", function(e) { ///// 변경
		console.log("이미지 삭제")
		var targetFile = $(this).data('file')
		var type= $(this).data('type')
		console.log(targetFile)
		var targetLi = $(this).closest("li")
		
		$.ajax({
			url: '/deleteFile',
			data: {fileName: targetFile, type:type},
			dataType: 'text',
			type: 'POST',
			success: (result)=>{
				alert(result)
				targetLi.remove()
			}
		}) // ajax
	}) // uploadResult click
	
});
</script>
</body>
</html>