<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<style>
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
		padding: 10px;
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
					if(obj.fileType) { // 이미지가 맞으면 아래 실행
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid+"_"+obj.fileName)
						var originPath = obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName
						originPath = originPath.replace(new RegExp(/\\/g), "/")  // "\\" => "/"  로 대체한다 (global)
						str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.fileType+"'"
						str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"+fileCallPath+"\' data-type='fileType' "
						str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
						str+= "<img src='/display?fileName=" + fileCallPath +"'></div></li>"
					} else { // 이미지가 아니면 아래 실행
						var fileCallPath = encodeURIComponent(obj.uploadPath+ "/"+obj.uuid+"_"+obj.fileName)
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/")
						str+= "<li data-path='"+obj.uploadPath+"'data-uuid='"+obj.uuid+"' data-fileName='"+obj.fileName+"'data-type='"+obj.fileType+"'"
						str+= "><div><span>"+obj.fileName+"</span><button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
						str+= "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></br>"
						str+= "<img src='/resources/img/attach.png'></div></li>"
					}
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
            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                    <!-- Sidebar Toggle (Topbar) -->
                    <form class="form-inline">
                        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                            <i class="fa fa-bars"></i>
                        </button>
                    </form>

                    <!-- Topbar Search -->
                    <form
                        class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                        <div class="input-group">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="Search for..."
                                aria-label="Search" aria-describedby="basic-addon2">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="button">
                                    <i class="fas fa-search fa-sm"></i>
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Topbar Navbar -->
                    <ul class="navbar-nav ml-auto">

                        <!-- Nav Item - Search Dropdown (Visible Only XS) -->
                        <li class="nav-item dropdown no-arrow d-sm-none">
                            <a class="nav-link dropdown-toggle" href="#" id="searchDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-search fa-fw"></i>
                            </a>
                            <!-- Dropdown - Messages -->
                            <div class="dropdown-menu dropdown-menu-right p-3 shadow animated--grow-in"
                                aria-labelledby="searchDropdown">
                                <form class="form-inline mr-auto w-100 navbar-search">
                                    <div class="input-group">
                                        <input type="text" class="form-control bg-light border-0 small"
                                            placeholder="Search for..." aria-label="Search"
                                            aria-describedby="basic-addon2">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary" type="button">
                                                <i class="fas fa-search fa-sm"></i>
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </li>

                        <!-- Nav Item - Alerts -->
                        <li class="nav-item dropdown no-arrow mx-1">
                            <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-bell fa-fw"></i>
                                <!-- Counter - Alerts -->
                                <span class="badge badge-danger badge-counter">3+</span>
                            </a>
                            <!-- Dropdown - Alerts -->
                            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="alertsDropdown">
                                <h6 class="dropdown-header">
                                    Alerts Center
                                </h6>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="mr-3">
                                        <div class="icon-circle bg-primary">
                                            <i class="fas fa-file-alt text-white"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="small text-gray-500">December 12, 2019</div>
                                        <span class="font-weight-bold">A new monthly report is ready to download!</span>
                                    </div>
                                </a>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="mr-3">
                                        <div class="icon-circle bg-success">
                                            <i class="fas fa-donate text-white"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="small text-gray-500">December 7, 2019</div>
                                        $290.29 has been deposited into your account!
                                    </div>
                                </a>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="mr-3">
                                        <div class="icon-circle bg-warning">
                                            <i class="fas fa-exclamation-triangle text-white"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="small text-gray-500">December 2, 2019</div>
                                        Spending Alert: We've noticed unusually high spending for your account.
                                    </div>
                                </a>
                                <a class="dropdown-item text-center small text-gray-500" href="#">Show All Alerts</a>
                            </div>
                        </li>

                        <!-- Nav Item - Messages -->
                        <li class="nav-item dropdown no-arrow mx-1">
                            <a class="nav-link dropdown-toggle" href="#" id="messagesDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-envelope fa-fw"></i>
                                <!-- Counter - Messages -->
                                <span class="badge badge-danger badge-counter">7</span>
                            </a>
                            <!-- Dropdown - Messages -->
                            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="messagesDropdown">
                                <h6 class="dropdown-header">
                                    Message Center
                                </h6>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="dropdown-list-image mr-3">
                                        <img class="rounded-circle" src="../resources/img/undraw_profile_1.svg"
                                            alt="...">
                                        <div class="status-indicator bg-success"></div>
                                    </div>
                                    <div class="font-weight-bold">
                                        <div class="text-truncate">Hi there! I am wondering if you can help me with a
                                            problem I've been having.</div>
                                        <div class="small text-gray-500">Emily Fowler · 58m</div>
                                    </div>
                                </a>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="dropdown-list-image mr-3">
                                        <img class="rounded-circle" src="../resources/img/undraw_profile_2.svg"
                                            alt="...">
                                        <div class="status-indicator"></div>
                                    </div>
                                    <div>
                                        <div class="text-truncate">I have the photos that you ordered last month, how
                                            would you like them sent to you?</div>
                                        <div class="small text-gray-500">Jae Chun · 1d</div>
                                    </div>
                                </a>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="dropdown-list-image mr-3">
                                        <img class="rounded-circle" src="../resources/img/undraw_profile_3.svg"
                                            alt="...">
                                        <div class="status-indicator bg-warning"></div>
                                    </div>
                                    <div>
                                        <div class="text-truncate">Last month's report looks great, I am very happy with
                                            the progress so far, keep up the good work!</div>
                                        <div class="small text-gray-500">Morgan Alvarez · 2d</div>
                                    </div>
                                </a>
                                <a class="dropdown-item d-flex align-items-center" href="#">
                                    <div class="dropdown-list-image mr-3">
                                        <img class="rounded-circle" src="https://source.unsplash.com/Mv9hjnEUHR4/60x60"
                                            alt="...">
                                        <div class="status-indicator bg-success"></div>
                                    </div>
                                    <div>
                                        <div class="text-truncate">Am I a good boy? The reason I ask is because someone
                                            told me that people say this to all dogs, even if they aren't good...</div>
                                        <div class="small text-gray-500">Chicken the Dog · 2w</div>
                                    </div>
                                </a>
                                <a class="dropdown-item text-center small text-gray-500" href="#">Read More Messages</a>
                            </div>
                        </li>

                        <div class="topbar-divider d-none d-sm-block"></div>

                        <!-- Nav Item - User Information -->
                        <li class="nav-item dropdown no-arrow">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small">Douglas McGee</span>
                                <img class="img-profile rounded-circle"
                                    src="../resources/img/undraw_profile.svg">
                            </a>
                            <!-- Dropdown - User Information -->
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Profile
                                </a>
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Settings
                                </a>
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Activity Log
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Logout
                                </a>
                            </div>
                        </li>

                    </ul>

                </nav>
                <!-- End of Topbar -->

                <!-- Begin Page Content -->
                <div class="container-fluid">

                    <!-- Page Heading -->
                    <h1 class="h3 mb-2 text-gray-800" style="text-align:center">테이블</h1>
                    <p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below.
                        For more information about DataTables, please visit the <a target="_blank"
                            href="https://datatables.net">official DataTables documentation</a>.</p>

                    <!-- DataTables Example -->
                    <div class="card shadow mb-4" style="text-align:center">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">게시글 등록</h6>
                        </div>
                        <div class="card-body">
                        	<form action="/board/register" role="form" method="post">
                        		<div class="form-group">
                        			<label>제목</label> <input class="form-control" name='title'/>
                        		</div>
                        		<div class="form-group">
                        			<label>내용</label>
                        			<textarea class="form-control" rows="3" name='content'></textarea>
                        		</div>
                        		<div class="form-group">
                        			<label>작성자</label> <input class="form-control" name='writer'/>
                        		</div>
                        		<button type="submit" class="btn btn-default">등록</button>
                        		<button type="reset" class="btn btn-default">취소</button>
                        		<button type="button" class="btn btn-default" onclick="location.href='/board/list'">목록으로</button>
                        	</form>
                        </div>
                        <div class="row">
                        	<div class="col-lg-12">
                        		<div class="panel panel-default">
                        			<div class="panel-heading">파일 등록</div>
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
                        </div> <!-- /row -->
                    </div>

                </div>
                <!-- /.container-fluid -->

            </div>
            <!-- End of Main Content -->
