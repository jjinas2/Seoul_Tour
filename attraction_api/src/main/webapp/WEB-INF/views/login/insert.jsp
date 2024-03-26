<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> title here</title>
</head>

<script
	src="https://cdn.jsdelivr.net/npm/@fullcalendar/core@4.2.0/main.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid@4.2.0/main.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/@fullcalendar/interaction@4.2.0/main.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://d3js.org/d3.v6.min.js"></script>
<script src="https://d3js.org/topojson.v3.min.js"></script>

<link
	href="https://cdn.jsdelivr.net/npm/@fullcalendar/core@4.2.0/main.min.css"
	rel="stylesheet" />

<link href="<c:url value="/resources/css/bootstrap.min.css" />"
	rel="stylesheet" />

<link rel="stylesheet"
	href="<c:url value="/resources/css/fontawesome.css" />" />
<link rel="stylesheet"
	href="<c:url value="/resources/css/templatemo-villa-agency.css" />" />
<link rel="stylesheet" href="<c:url value="/resources/css/owl.css" />" />
<link rel="stylesheet"
	href="<c:url value="/resources/css/animate.css" />" />
<link rel="stylesheet"
	href="https://unpkg.com/swiper@7/swiper-bundle.min.css" />

<style>
	.content {
		width: 100%;
		height: 100%;
		text-align: center;
		position: relative;
		z-index: 1;
	}
	
	.content::after {
		width: 100%;
		height: 100%;
		content: "";
		background:
			url(https://cdn.pixabay.com/photo/2017/12/18/18/37/christmas-3026685_1280.jpg);
		position: absolute;
		top: 0;
		left: 0;
		z-index: -1;
		opacity: 0.3;
	}
	
	.highlight {
		background-color: red;
		opacity: 0.5;
		position: relative;
		z-index: 2
	}
	
	.tooltip {
		position: absolute;
		text-align: center;
		width: 100px;
		height: 80px;
		padding: 2px;
		font: 13px sans-serif;
		background: lightsteelblue;
		border: 0px;
		border-radius: 8px;
		pointer-events: none;
	}
	/* Flexbox를 사용하여 열 배치 */
	.container {
		display: flex;
	}
	
	/* 각각의 열 요소 */
	#calendar, #calendarList {
		width: 50%; /* 2개의 열을 반씩 차지하도록 설정 */
		padding: 20px;
		box-sizing: border-box;
		/* 	border: 1px solid #ccc; */
		padding: 20px;
	}
	
	.fc-left h2 {
		font-size: 15px;
	}
	
	#calendar {
		width: 400px;
		font-size: 10pxs
	}
	
	#mapClick, #hideList {
		width: 50%; /* 2개의 열을 반씩 차지하도록 설정 */
		padding: 20px;
		box-sizing: border-box;
		border: 1px solid #ccc;
		padding: 20px;
	}
	
	.fc-button {
		font-size: 13px;
		margin-left: 10px
	}
	
	.fc table {
		font-size: 13px;
	}

	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	/* p543 수정 */ 
	.uploadResult ul li {
		list-style: none;
		padding: 100px;
		align-content: center;
		text-align: center;
	}
	.uploadResult ul li img {
		width: 100%;
	}
	.uploadResult ul li span {
		color: white;
	}
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255,255,255,0.5)
	}
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img {
		width: 600px;
	}
</style>


<link rel="stylesheet" th:href="@{/css/board.css}"/>
<script src="https://code.jquery.com/jquery-3.6.3.js"></script>
<script>

	$(document).ready(function(){ ///// 전체 추가
		var formObj=$("form[role='form']")
		$("button[type='submit']").click(function(e){
			e.preventDefault()
			console.log("전송버튼이 눌렸어요")
			var str=""
			$(".uploadResult ul li").each(function(idx, obj){
				console.log("obj: ", obj)
				var jobj =$(obj)
				console.dir(jobj) // 나중에 hidden 으로 변경예정
				str+= "<input type='hidden' name='attachList["+idx+"].fileName' value='"+jobj.data('filename')+"'>"
				str+= "<input type='hidden' name='attachList["+idx+"].uuid' value='"+jobj.data('uuid')+"'>"
				str+= "<input type='hidden' name='attachList["+idx+"].uploadPath' value='"+jobj.data('path')+"'>"
				str+= "<input type='hidden' name='attachList["+idx+"].fileType' value='"+jobj.data('type')+"'>"
			})
			console.log("들어와라")
			console.log(str)
			formObj.append(str).submit()
		})
		
		//p506
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
		
		//var cloneObj = $(".uploadDiv").clone()
		$("input[type='file']").change(function(e){ // 파일 업로드 버튼이 선택되면 호출되는 함수
			var formData = new FormData()
			var inputFile = $("input[name='uploadFile']")
			var files = inputFile[0].files // 여러개의 파일을 선택하면 0번 배열에 파일명의 정보가 저장됨
			console.log(files)
			//formData 에 파일 추가
			for(var i of files) {
				if(!checkExtension(i.name, i.size)) return false;
				formData.append("uploadFile", i)
			}
			
			var uploadResult =$(".uploadResult ul")
			const showUploadedFile=(uploadResultArr)=>{
				if(!uploadResultArr || uploadResultArr.length ==0) return
				var str=""
				$(uploadResultArr).each(function(idx, obj){ //p525
					
					var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid+"_"+obj.fileName)
					var originPath = obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName
					originPath = originPath.replace(new RegExp(/\\/g), "/")  // "\\" => "/"  로 대체한다 (global)
					str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.fileType+"'"
					str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"+fileCallPath+"\' data-type='fileType' "
					str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
					str+= "<img src='/display?fileName=" + fileCallPath +"'></div></li>"
				})
				uploadResult.append(str)
			}
			$.ajax({
				url: '/uploadAjaxAction',
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
		

	}) // ready
</script>
            <head>
	 	<title>게시판</title>
	</head>
	<body>
	
<!-- ***** Header Area Start ***** -->
    <header class="header-area header-sticky">
      <div class="container">
        <div class="row">
          <div class="col-12">
            <nav class="main-nav">
              <!-- ***** Logo Start ***** -->
 
              <a href="main" class="logo" style="margin-left:10px">			             
                <h1>Seoul</h1>
              </a>
              <div style='position: relative;  size:50%'>
			            <img src='/resources/images/003.png'>
			        </div>

              <!-- ***** Menu Start ***** -->
              <ul class="nav" style="margin-left:500px">
         			<li><a href="/seoul/main"  >메인</a></li>
					<li><a href="/seoul/event">행사/맛집</a></li>
					<li><a href="/seoul/recommend">추천일정</a></li>
					<li><a href="/board/list"  class="active">게시판</a></li>
					<c:choose>
					    <c:when test="${not empty user}">
					        <li><a href="/seoul/login">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${user.name_}&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
					    </c:when>
					    <c:otherwise>
					        <li><a href="/seoul/login">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;로그인&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
					    </c:otherwise>
					</c:choose>
			</ul>

						
              <a class="menu-trigger">
                <span>Menu</span>
              </a>
              <!-- ***** Menu End ***** -->
            </nav>
          </div>
        </div>
      </div>
    </header>
    <!-- ***** Header Area End ***** -->
	
	<!-- Main Content -->
		<div id="root" style="margin-left:620px; margin-top:30px">
	        <div class="card shadow mb-4" style="width:40rem; height:47rem; text-align: center;">
                       <div class="card-header py-3">
			<header><br/>
				<h4> 게시글 등록</h4><br/>
			</header>

			<hr />
	
        <div id="content" >
                <!-- DataTables Example -->
              
                    <div class="card-body" >
                    	<form action="/board/insert" role="form" method="post">
                    		<div class="form-group">
                    			<label>제목</label> <input class="form-control" name='title'/>
                    		</div><br/>
                    		<div class="form-group">
                    			<label>내용</label>
                    			<textarea class="form-control" rows="7" name='content'></textarea>
                    		</div><br/>
                    		<div class="form-group">
                    			<label>작성자</label> <input class="form-control" name='writer'/>
                    		</div><br/>
                    		
                    	</form>
                    </div><br/>
                    <div class="row">
                    	<div class="col-lg-12">
                    		<div class="panel panel-default">
                    			<div class="panel-body">
                    				<div class="uploadDiv">
                    					<input class="form-control" type="file" name="uploadFile" multiple/>
                    				</div>
                    				<div class="uploadResult">
                    					<ul></ul>
                    				</div>
                    			</div>
                    		</div>
                    	</div>
                    </div><br/>
                    <button type="submit" class="btn btn-dark">등록</button><br/>
                    <br/>&nbsp;<br/>
                </div>

            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- End of Main Content -->



	</body>
</html>
            

