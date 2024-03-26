<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
        $(function() {
            $("#chinese").click(function(){
                var ko = $("#korean").val();
                console.log("차이나 버튼이 눌렸다 ", ko)
                $.ajax({
                    url:"/board/translate",
                    type:"POST",
                    dataType:"json",
                    contentType: "application/json",
                    data: JSON.stringify({text: ko, lang: "chinese"}),
                    success:function(v){
                        console.log("성공",JSON.parse(v.translatedText).message.result.translatedText)
                        var translatedText = JSON.parse(v.translatedText).message.result.translatedText
                        $("#china").text(translatedText);
                        console.log(translatedText);
                    },
                    error:function(e){
                        console.log(e);
                    }
                });
            });
            $("#japanese").click(function(){
                var ko = $("#korean").val();
                $.ajax({
                    url:"/board/translate",
                    type:"POST",
                    dataType:"json",
                    contentType: "application/json",
                    data: JSON.stringify({text: ko, lang: "japanese"}),
                    success:function(v){
                        console.log("성공",v)
                        var translatedText = JSON.parse(v.translatedText).message.result.translatedText
                        $("#japan").text(translatedText);
                        console.log(translatedText);
                    },
                    error:function(e){
                        console.log(e);
                    }
                });
            });
            $("input#english").click(function(){
            	console.log("영어 눌렸다")
                var ko = $("#korean").val();
                $.ajax({
                    url:"/board/translate",
                    type:"POST",
                    dataType:"json",
                    contentType: "application/json",
                    data: JSON.stringify({text: ko, lang: "english"}),
                    success:function(v){
                        console.log("성공",v)
                        var translatedText = JSON.parse(v.translatedText).message.result.translatedText
                        $("#english").text(translatedText);
                        console.log(translatedText);
                    },
                    error:function(e){
                        console.log("오류",e);
                    }
                });
            });
        });
    </script>
    <title>번역 테스트</title>
</head>
<body>
    <h1>번역 테스트</h1>
    <table border="1">
        <thead>
            <tr>
                <th>한국어</th>
                <th>중국어</th>
                <th>일본어</th>
                <th>영어</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><input type="text" id="korean" name="korean"></td>
                <td width="200" height="30" id="china"></td>
                <td width="200" height="30" id="japan"></td>
                <td width="200" height="30" id="english"></td>
            </tr>
        </tbody>
    </table>
    <input type="button" id="chinese" value="중국어">
    <input type="button" id="japanese" value="일본어">
    <input type="button" id="english" value="영어">
</body>
</html>
