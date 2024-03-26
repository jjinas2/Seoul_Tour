<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Insert title here</title>
  </head>
  <body>
    <!-- 카카오 스크립트 -->
    <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>

    <script>
      window.kakao.init("ffdebab42500e233ab43154ad07edccf");

      function kakoLogin() {
        window.Kakao.Auth.login({
          scope: "profile_nickname, profile_image",
          success: function (authObj) {
            window.Kakao.API.request({
              url: "/register/login",
              success: (res) => {
                const nickname = res.kakao_nickname;
                const image = res.kako.image;

                console.log(nickname);
                console.log(image);

                $("kakaonickname").val(nickname);
                $("kakaoimage").val(image);
              },
            });
          },
        });
      }
    </script>
    <div class="form-group-row" id="Kakaologin">
      <div class="kakaobtn">
        <input type="hidden" name="kakaonickname" ,id="kakaonickname" />
        <input type="hidden" name="kakaoimage" ,id="kakaoimage" />
      </div>
    </div>
  </body>
</html>
