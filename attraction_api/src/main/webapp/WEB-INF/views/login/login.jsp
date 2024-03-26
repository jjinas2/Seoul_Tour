<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script
      type="text/javascript"
      src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js"
      charset="utf-8">
    </script>
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
    <script>
      function alert(mgs) {
        Swal.fire(mgs);
      }
      $(document).ready(function () {
    	  
    	  function ajax_face(userID) {
    		    $.ajax({
    		        url: "/face",
    		        type: "get",
    		        dataType: "json",  // 변경: 서버에서 JSON 형태의 응답을 기대합니다.
    		        data: { userID: userID },  // 변경: 직접 객체로 전달
    		        contentType: "application/json",
    		        success: function (vo) {
    		            alert("인증 성공 : " + userID);
    		            console.log(vo);
    		            window.location.href = "/main?userID=" + vo.userID;
    		        },
    		        error: function () {
    		            alert("인증 실패 ㅠ");
    		        }
    		    });
    		}

    		$("#faceBtn").click(function (e) {
    		    console.log('아작스 얼굴 인식 눌렸어');
    		    $.ajax({
    		        url: "http://localhost:5000/face",
    		        type: "get",
    		        dataType: "text",
    		        crossDomain: true,
    		        success: function (name) {
    		            console.log(name);
    		            ajax_face(name);
    		        },
    		        error: function () {
    		            alert("인증 실패");
    		        }
    		    });
    		});
        $("#loginBtn").click(function (e) {
          e.preventDefault(); // 기본 이벤트 방지

          var userID = $("[name=userID]").val();
          var userPassword = $("[name=userPassword]").val();

          var data = {
            userID: userID,
            userPassword: userPassword,
          };
          console.log("로그인 정보", data);
          // Ajax를 이용하여 로그인 시도
          $.ajax({
            type: "POST",
            url: "/register/login", // 로그인 처리를 담당하는 컨트롤러 URL로 변경
            data: JSON.stringify(data),
            //dataType:"json",
            contentType: "application/json",
            success: function (response) {
              alert("로그인 성공");
              // 로그인이 성공하면 서버에서 리다이렉트 URL을 전송
              window.location.href = "/main";
            },
            error: function () {
              alert("로그인 실패");
            },
          });
        });
      });
    </script>
    <script>
      //카카오로그인
      function kakaoLogin() {
        $.ajax({
          url: "/login/getKakaoAuthUrl",
          type: "get",
          async: false,
          dataType: "text",
          success: function (res) {
            location.href = res;
          },
        });
      }

      $(document).ready(function () {
        var kakaoInfo = "${kakaoInfo}";

        if (kakaoInfo != "") {
          var data = JSON.parse(kakaoInfo);

          alert("카카오로그인 성공 \n accessToken : " + data["accessToken"]);
          alert(
            "user : \n" +
              "email : " +
              data["email"] +
              "\n nickname : " +
              data["nickname"]
          );
        }
      });
    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>로그인 화면</title>
    <link href="/resources/css/login.css" rel="stylesheet" type="text/css" />
  </head>
  <body>
    <% request.setCharacterEncoding("UTF-8"); %>
    <div class="login-box">
      <h2>로그인</h2>
      <form method="post" action="login">
        <div class="user-box">
          <input type="text" name="userID" required="" />
          <label>아이디</label>
        </div>
        <div class="user-box">
          <input type="password" name="userPassword" required="" />
          <label>비밀번호</label>
        </div>

        <a href="" class="btn-login" id="loginBtn">
          <span></span>
          <span></span>
          <span></span>
          <span></span>
          로그인
        </a>
        <a href="join" style="margin-left: 45px">
          <span></span>
          <span></span>
          <span></span>
          <span></span>
          회원가입
        </a>
        <a href="find_ID" id="searchBtn">
          <span></span>
          <span></span>
          <span></span>
          <span></span>
          아이디/비밀번호 찾기
        </a>
        <!-- 얼굴 인식 로그인 -->
        <a class="btn-facelogin" id="faceBtn">
          <span></span>
          <span></span>
          <span></span>
          <span></span>
          얼굴 인식 로그인
        </a>

        <!-- 네이버 로그인 -->
        <div id="naver_id_login">
          <a href="/users/naverLogin">
            <img
              width="220"
              src="https://developers.naver.com/doc/review_201802/CK_bEFnWMeEBjXpQ5o8N_20180202_7aot50.png"
            />
          </a>
        </div>

        <!-- 카카오 로그인 -->
        <div onclick="kakaoLogin();">
          <a href="javascript:void(0)">
            <img src="/resources/img/kakao.png" alt="카카오 로그인" />
          </a>
        </div>
      </form>
    </div>
  </body>
</html>
