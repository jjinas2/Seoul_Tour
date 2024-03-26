<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Image Gallery</title>
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .image-container {
            display: flex;
            overflow: hidden;
            width: 600px; /* 이미지 전체 너비 조절 */
        }

        .image-item {
            flex: 0 0 200px; /* 이미지 개별 너비 조절 */
            transition: transform 0.5s ease-in-out; /* 이미지 슬라이드 애니메이션 설정 */
        }

        .image {
            width: 100%; /* 이미지 100% 너비로 조절 */
            height: auto;
            object-fit: cover; /* 이미지 비율 유지 */
        }
    </style>
</head>
<body>

<div class="image-container">
    <% 
    String[] imageLinks = {
        "https://www.newsis.com/view/?id=NISX20231208_0002550750&cID=10201&pID=10200",
        "https://www.edaily.co.kr/news/read?newsId=01190646635836880&mediaCodeNo=257&OutLnkChk=Y",
        "https://www.dailian.co.kr/news/view/1304448/?sc=Naver",
        "https://www.ytn.co.kr/_ln/0108_202312090832475629",
        "https://news.jtbc.co.kr/article/article.aspx?news_id=NB12155143",
        "https://www.news1.kr/articles/5255003"
    };
    
    for (int i = 0; i < 6; i++) { %>
        <div class="image-item" data-link="<%= imageLinks[i] %>">
            <img class="image" src="<%= request.getContextPath() %>/resources/img/미세먼지<%= i+1 %>.jpg" alt="Image <%= i+1 %>">
        </div>
    <% } %>
</div>

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script>
    $(document).ready(function() {
        var currentIndex = 0;
        var itemWidth = $('.image-item').outerWidth();
        var totalItems = $('.image-item').length;
        var intervalId;
        var direction = 1; // 1: 다음 방향, -1: 이전 방향

        function cloneLastImage() {
            var lastImageClone = $('.image-item:first-child').clone();
            $('.image-container').append(lastImageClone);
        }

        cloneLastImage();

        function slideNext() {
            currentIndex = (currentIndex + 1) % (totalItems + 1);
            var newPosition = -currentIndex * itemWidth;
            $('.image-item').css('transform', 'translateX(' + newPosition + 'px)');
        }

        function slidePrev() {
            currentIndex = (currentIndex - 1 + totalItems + 1) % (totalItems + 1);
            var newPosition = -currentIndex * itemWidth;
            $('.image-item').css('transform', 'translateX(' + newPosition + 'px)');
        }

        function startAutoSlide() {
            intervalId = setInterval(function() {
                direction === 1 ? slideNext() : slidePrev();
            }, 2000);
        }

        startAutoSlide();

        $('#prevBtn').click(function() {
            clearInterval(intervalId);
            direction = -1;
            slidePrev();
            startAutoSlide();
        });

        $('#nextBtn').click(function() {
            clearInterval(intervalId);
            direction = 1;
            slideNext();
            startAutoSlide();
        });

        // Click event handler for image items
        $('.image-item').click(function () {
            var link = $(this).data('link');
            window.location.href = link;
        });
    });
</script>

<button id="prevBtn">이전</button>
<button id="nextBtn">다음</button>

</body>
</html>