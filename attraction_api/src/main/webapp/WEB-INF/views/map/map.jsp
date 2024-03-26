<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.JSONObject"%>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Map Page</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<link rel="stylesheet" type="text/css" href="/resources/css/btn2.css" />
<body>

    <%
        String jsonStr = (String) request.getAttribute("jsonStr");
      String name = request.getParameter("name");
      if (jsonStr != null) {
          JSONObject jsonData = new JSONObject(jsonStr);
          JSONObject cityData = jsonData.getJSONObject("SeoulRtd.citydata");
          JSONObject livePpltnStta = cityData.getJSONObject("CITYDATA");
          JSONObject livePpltnStts = cityData.getJSONObject("CITYDATA").getJSONObject("LIVE_PPLTN_STTS").getJSONObject("LIVE_PPLTN_STTS");
          JSONObject livePpltnSttw = cityData.getJSONObject("CITYDATA").getJSONObject("WEATHER_STTS").getJSONObject("WEATHER_STTS");
          String ppltnTime = livePpltnStts.getString("PPLTN_TIME");
          String ppcongest = livePpltnStts.getString("AREA_CONGEST_LVL");
          String ppcongestmsg = livePpltnStts.getString("AREA_CONGEST_MSG");
          String pcpmsg = livePpltnSttw.getString("PCP_MSG");
          String pm10msg = livePpltnSttw.getString("PM10_INDEX");
          double AREA_MIN = livePpltnStts.getDouble("AREA_PPLTN_MIN");
          double AREA_MAX = livePpltnStts.getDouble("AREA_PPLTN_MAX");
          double[] pprateValues = new double[7];
          for (int i = 1; i <= 7; i++) {
              pprateValues[i-1] = livePpltnStts.getDouble("PPLTN_RATE_" + (i * 10));
          }
          double sensible = livePpltnSttw.getDouble("SENSIBLE_TEMP");
          double max_w = livePpltnSttw.getDouble("MAX_TEMP");
          double max_y = livePpltnSttw.getDouble("MIN_TEMP");
          double wheather = livePpltnSttw.getDouble("TEMP");
          double pm10 =  livePpltnSttw.getDouble("PM10");
          String place = request.getParameter("place");
          
          // 텍스트를 선택하기 위한 조건 추가
          String weathermsg = "";
          if (wheather >= 30) {
          	weathermsg = "날씨가 더움으로 수분섭취를 많이 해주세요"; 
          } else if (wheather>= 20) {
          	weathermsg = "날씨가 따뜻하므로 야외활동하기 좋은 날씨입니다"; 	
          } else if (wheather >= 10) {
          	weathermsg = "날씨가 시원하긴 하지만 반팔입고는 추울수 있으므로 긴팔입고 외출하시기 바랍니다.";   	
          } else if (wheather >= 0) {
          	weathermsg = "날씨가 쌀쌀하므로 겉에 외투를 걸치고 외출하시기 바랍니다";   	
          } else {
          	weathermsg = "날씨가 많이 추움으로 따뜻하게 입고 외출하시기 바랍니다"; 
          }
    %>
    
    <div class="frame" style="text-align: center;">
        <p class="custom-paragraph" style="font-size: 15px; font-family: 'noto-regular';">※ <%= ppltnTime %> 기준</p>
        <p style= "font-weight: 600; font-size: 25px;" ><%= name %></p>
        <!-- 차트 유형 변경 버튼 추가 -->
        <button class = "custom-btn btn-8"onclick="updateChart('bar')">Bar 차트</button>
        <button class = "custom-btn btn-8"onclick="updateChart('line')">Line 차트</button>
        <button class = "custom-btn btn-8"onclick="updateChart('pie')">Pie 차트</button>
        <button class = "custom-btn btn-8"onclick="updateChart('doughnut')">Doughnut 차트</button>
        <button class = "custom-btn btn-8"onclick="updateChart('polarArea')">Polar Area 차트</button>
        <canvas id="myChart" style="max-width: 1000px; max-height: 500px; width: 100%; height: auto; display: block; box-sizing: border-box;  margin: 0 auto;"></canvas>
        <p>혼잡도: <%= ppcongestmsg %></p>
		<div style="text-align: center;">
			<div class="rectangle-container">
				<div class="rectangle rectangle1">
					<% if ("여유".equals(ppcongest)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">여유</div>
			</div>

			<div class="rectangle-container">
				<div class="rectangle rectangle2">
					<% if ("보통".equals(ppcongest)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">보통</div>
			</div>

			<div class="rectangle-container">
				<div class="rectangle rectangle3">
					<% if ("약간 붐빔".equals(ppcongest)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">약간 붐빔</div>
			</div>

			<div class="rectangle-container">
				<div class="rectangle rectangle4">
					<% if ("붐빔".equals(ppcongest)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">붐빔</div>
			</div>
		</div>
		<P>유동 인구 : <%= Math.round(AREA_MIN) %>명 ~ <%= Math.round(AREA_MAX) %>명</P>
		<p style="font-size: 20px; font-weight: 700">미세먼지</p>
		<div style="text-align: center;">
			<div class="rectangle-container">
				<div class="rectangle rectangle1">
					<% if ("좋음".equals(pm10msg)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">좋음</div>
			</div>

			<div class="rectangle-container">
				<div class="rectangle rectangle2">
					<% if ("보통".equals(pm10msg)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">보통</div>
			</div>

			<div class="rectangle-container">
				<div class="rectangle rectangle3">
					<% if ("나쁨".equals(pm10msg)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">나쁨</div>
			</div>

			<div class="rectangle-container">
				<div class="rectangle rectangle4">
					<% if ("매우나쁨".equals(pm10msg)) { %>
                		<div class="position-indicator">&#x2713;</div>
            		<% } %>
				</div>
				<div class="textBeside">매우나쁨</div>
			</div>
		</div>
		<p>미세먼지농도:<%= pm10 %> ㎍/㎥</p></p>
		<p>최고온도: <span style="color: blue; font-weight: 400"><%=max_w%>°C</span> 최저온도: <span style="color: blue;font-weight: 400"><%= max_y %>°C</span>  | 온도: <span style="color: blue;font-weight: 400"><%= wheather %>°C</span> 체감온도: <span style="color: blue;font-weight: 400"><%= sensible %>°C</span></p>
        <p>일기예보: <%= pcpmsg %></p>
        <p><%= weathermsg%></p>  
    </div>

    <script>
        var ctx = document.getElementById('myChart').getContext('2d');
        var myChart; // 전역 변수로 선언
        createChart('bar');
        async function fetchData() {
            try {
                const response = await fetch('https://api.example.com/data');
                const data = await response.json();
                return data;
            } catch (error) {
                console.error('Error fetching data:', error);
                throw error;
            }
        }

        // 차트 업데이트 함수
        function updateChart(chartType) {
            if (myChart) {
                myChart.destroy(); // 기존 차트 제거
            }
            createChart(chartType);
        }
        
        async function loadData() {
            try {
                const data = await fetchData();
                // 데이터 처리 로직
                processData(data);
                // 차트 업데이트
                updateChart('bar');
            } catch (error) {
                // 에러 처리 로직
                console.error('Error loading data:', error);
            }
        }

        function createChart(type) {
            myChart = new Chart(ctx, {
                type: type,
                data: {
                    labels: ['10대', '20대', '30대', '40대', '50대', '60대', '70대'],
                    datasets: [{
                        label: '인구 비율',
                        data: [<%= pprateValues[0] %>, <%= pprateValues[1] %>, <%= pprateValues[2] %>, <%= pprateValues[3] %>, <%= pprateValues[4] %>, <%= pprateValues[5] %>, <%= pprateValues[6] %>],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)',
                            'rgba(75, 192, 192, 0.2)',
                            'rgba(153, 102, 255, 0.2)',
                            'rgba(255, 159, 64, 0.2)',
                            'rgba(0, 0, 0, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(75, 192, 192, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 159, 64, 1)',
                            'rgba(0, 0, 0, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    maintainAspectRatio: false, // Set to false to adjust the size
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        loadData();
    </script>
    <%
        } else {
    %>
    <div>
        No JSON content available.
    </div>
    <%
        }
    %>
</body>
</html>