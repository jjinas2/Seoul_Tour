<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>회원 가입 페이지</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script
      integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
      integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js"
      integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
      crossorigin="anonymous"
    ></script>
    <script>
      $(document).ready(function () {
        $("#checkid").click(function (e) {
          e.preventDefault();
          console.log("아이디 중복 확인 버튼이 눌려요");
          $.ajax({
              url: "/register/confirmId?id=" + $("#id").val(),
              success: function (data) {
                console.log("성공", data);
                alert("중복된 아이디야!")
            },
            error: function (data) {
               
                alert("중복되지 않는 아이디야!")
            },
          });
        });

        $("button#select").click(function (e) {
          e.preventDefault();
          console.log("지역 선택 버튼이 눌려요");
          
          validateInterest();
        });

        $(".btn.button").click(function (e) {
        	console.log(cnt)
        	var hiddenInput=''
        	if(cnt==3) {
        		$.each(selectedArea,function(idx,area){
	        		const fieldName = "userArea"+(idx + 1);
				    const fieldValue = area;
				    console.log(fieldName , fieldValue)
				     hiddenInput+= '<input type="hidden" name="'+ fieldName +'" value="'+fieldValue + '"></input>';
        		})
        		console.log(hiddenInput)
        		//e.preventDefault()
        		$("form").append(hiddenInput);
        		$("form").submit();
        		cnt=0;
        	} else{
        		alert("3개 선택해")
        	}
        	
        }); 
        
      });
      
      function alert(mgs) {
          Swal.fire(mgs);
        }
    </script>
    <script>
      const interestAreas = [
        "도봉구",
        "강북구",
        "노원구",
        "성북구",
        "은평구",
        "종로구",
        "동대문구",
        "중랑구",
        "서대문구",
        "중구",
        "성동구",
        "마포구",
        "용산구",
        "광진구",
        "강동구",
        "송파구",
        "강남구",
        "서초구",
        "동작구",
        "관악구",
        "영등포구",
        "구로구",
        "양천구",
        "강서구",
      ];
    </script>
    <script>
    $(document).ready(function () {
        $("input[name='userPasswordCheck']").keyup(function () {
             var password = $("input[name='userPassword']").val();
             var confirmPassword = $(this).val();
             var passwordMatchMessage = $("#passwordMatchMessage");

             if (password === confirmPassword) {
                 passwordMatchMessage.text("비밀번호 일치").css("color", "green");
             } else {
                 passwordMatchMessage.text("비밀번호 불일치").css("color", "red");
             }
         });
     });
   </script>
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
			$("input[name='fileName']").val(files[0].name)
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
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <link rel="stylesheet" type="text/css" href="/resources/css/login.css" />
    <link rel="stylesheet" type="text/css" href="/resources/css/agebox.css" />
  </head>
  <body>
    <% request.setCharacterEncoding("UTF-8"); %>
    <div class="login-box" style="color: white">
      <header class="form-header">
        <h1 style="text-align: center">(☞ﾟヮﾟ)☞가입해</h1>
      </header>
      <form class="form-row" action="/register/join" method="post">
        <div class="user-box">
          <input type="text" value="${i.userName}" name="userName" />
          <label>이름</label>
        </div>
        <div class="user-box">
          <input
            type="text"
            class="form-control"
            value="${i.userID}"
            id="id"
            aria-describedby="emailHelp"
            name="userID" required
          />
          <label for="exampleInputEmail1">아이디</label>
        </div>

        <a href="#" class="btn-primary" style="left: 200px" id="checkid">
          <span></span>
          <span></span>
          <span></span>
          <span></span>
          중복확인
        </a>

        <div class="user-box">
          <input type="text" value="${i.userPassword}" name="userPassword" />
          <label>비밀번호</label>
        </div>
        <div class="user-box">
          <input type="text" value="${i.userPasswordCheck}" name="userPasswordCheck" />
          <label>비밀번호 확인</label>
        </div>
        <div id="passwordMatchMessage"></div>
        <div class="selectBox">
          <div class="selectBox2">
            <button
              id="age"
              class="label"
              style="color: white; text-align: right"
            >
              나이 (❁´◡`❁)
            </button>
            <select class="optionList" name="userAge">
              <option class="optionItem" id="10" value="10대（⊙ｏ⊙）">
                10대（⊙ｏ⊙）
              </option>
              <option class="optionItem" id="20" value="20대(●'◡'●)">
                20대(●'◡'●)
              </option>
              <option class="optionItem" id="30" value="30대╰(*°▽°*)╯">
                30대╰(*°▽°*)╯
              </option>
              <option class="optionItem" id="40" value="40대(￣ε(#￣)">
                40대(￣ε(#￣)
              </option>
              <option class="optionItem" id="50" value="50대o((>ω< ))o">
                50대o((>ω< ))o
              </option>
              <option class="optionItem" id="60" value="60대（︶^︶）">
                60대（︶^︶）
              </option>
              <option class="optionItem" id="70" value="70대(　TロT)σ">
                70대(　TロT)σ
              </option>
              <option class="optionItem" id="80" value="80대q(≧▽≦q)">
                80대q(≧▽≦q)
              </option>
              <option class="optionItem" id="90" value="90대♪(´▽｀)">
                90대♪(´▽｀)
              </option>
              <option class="optionItem" id="100" value="100대(*￣3￣)╭">
                100대(*￣3￣)╭
              </option>
            </select>
          </div>
		  <span></span>
          <span></span>
          <span></span>
        </div>
        <div>
          <fieldset
            class="legacy-form-row"
            style="border-color: rgb(128, 227, 240)"
          >
            <input
              id="gender-type-1"
              name="userSex"
              type="radio"
              value="남자"
            />
            <label for="gender-type-1" class="radio-label">남자</label>
            <input
              id="gender-type-2"
              name="userSex"
              type="radio"
              value="여자"
              checked
            />
            <label for="gender-type-2" class="radio-label">여자</label>
            <input
              id="gender-type-3"
              name="userSex"
              type="radio"
              value="비공개"
              checked
            />
            <label for="gender-type-3" class="radio-label">비공개</label>
          </fieldset>
        </div>

        <div class="interest">
          <label for="interest_area">관심 지역 (최대 3개 선택)</label>
          <div id="interestCheckboxes"></div>
          </div>
       
        <div>
        <div class="face">
        	<input class="form-control" type="file" name="uploadFile" multiple />
        	<button type="reset" class="btn btn-default">취소</button>
        </div>
          <a
            href="#"
            class="btn button"
            style="margin-top: 10px; margin-left: 200px"
          >
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            가입하기
          </a>
        </div>
        <input type="hidden" value="" name="fileName"/>
      </form>
    </div>
    <script src="/resources/js/join.js"></script>
  </body>
</html>
