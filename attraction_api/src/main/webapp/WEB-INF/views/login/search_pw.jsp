<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>pw search</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" type="text/css" href="/resources/css/login.css" />
    <link rel="stylesheet" type="text/css" href="/resources/css/agebox.css" />

    <script>
      $(document).ready(function () {
        var str = "/register/find_PW?";
        var selectedAge = "";
        var age = "";

        // userAge 파라미터를 추가하는 이벤트 핸들러를 click 이벤트 밖에서 정의
        $(".optionList").change(function (e) {
          age = $(this).val();
          console.log(age);
        });
        $("#search_pw").click(function (e) {
          console.log("버튼이 눌렸어요");
          e.preventDefault();
          var id = $("[name='userID']").val();
          var name = $("[name='userName']").val();
          var sex = $('input[name="userSex"]:checked').val();
          console.log(sex);

          $.ajax({
            url: "/register/find_PW", // 호출할 주소
            method: "POST",
            data: JSON.stringify({
              userID: id,
              userName: name,
              userSex: sex,
              userAge: age,
            }), // 넘길 데이터
            dataType: "json", // 데이터 타입 json으로 설정 <- 이걸 안하면 밑에 처럼 JSON.parse를 해야함
            contentType: "application/json; charset=utf-8",
            success: function (data) {
              // 결과 받기
              //data = JSON.parse(data); // JSON 형태로 파싱
              alert("비밀번호 : " + data.userPassword);
              console.log(data);
            },
          });

          //$("form").append(str).submit(); // form 제출
        });
      });

      function alert(mgs) {
        Swal.fire(mgs);
      }
    </script>
  </head>
  <body>
    <% request.setCharacterEncoding("UTF-8"); %>
    <div class="login-box" style="color: white">
      <header class="form-header">
        <h1 style="text-align: center">┗|｀O′|┛</h1>
        <h1 style="text-align: center">비밀번호 내놔</h1>
      </header>
      <form class="form-row">
        <div class="user-box">
          <input type="text" name="userName" required="" />
          <label>이름</label>
        </div>
        <div class="user-box">
          <input type="text" name="userID" required="" />
          <label>아이디</label>
        </div>
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
          <span class="icoArrow"
            ><img
              src="https://freepikpsd.com/media/2019/10/down-arrow-icon-png-7-Transparent-Images.png"
              alt=""
          /></span>
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
        <div>
          <a
            href="#"
            id="search_pw"
            style="margin-top: 10px; margin-left: 190px"
          >
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            번호내놔!
          </a>
        </div>
      </form>
    </div>
    <script src="/resources/js/bar.js"></script>
  </body>
</html>
