<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seoul Map</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/map.css">
    <link href="/resources/css/nav.css" rel="stylesheet" type="text/css" />
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <style>
    /* 위치 목록 컨테이너 스타일 */
    #locationListContainer {
       position: absolute;
       top: 90px; /* 조절 가능한 값 */
       right: 10px; /* 조절 가능한 값 */
       background-color: white;
       padding: 10px;
       border: 1px solid #ccc;
       border-radius: 5px;
       z-index: 1;
       max-height: 80vh;
       overflow-y: auto;
  }
  	/* 목록 항목 스타일 */
    .list-item {
        cursor: pointer;
        padding: 5px;
        margin: 5px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
     /* 목록 항목 이름 스타일 */
    .list-name {
        color: black;
    }
</style>
</head>
<link rel="stylesheet" type="text/css" href="/resources/css/btn.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/loding.css" />
<body>

	<!-- 지도 컨테이너 -->
    <div id="map" style="width: 100vw; height: 89vh"></div>
    
    <!-- 로딩 오버레이 컨테이너 -->
    <div id="loadingOverlay" style="display: none;">
        <div class="loading-spinner"></div>
    </div>

    <!-- 리스트를 표시할 컨테이너 추가 -->
    <div id="locationListContainer"></div>
    
    <!-- 카카오 지도 JavaScript SDK 포함 -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3e8a6e5ea32f64e7db8062b80bca6e21"></script>
    
    <!-- 지도 초기화 및 위치 처리를 위한 JavaScript 블록 -->
    <script>
        var locations = [
            {   
               kind: '문화유산',
                name: '경복궁',
                x: 126.976924,
                y: 37.577644,
                imageUrl: '/resources/img/gyoung.jpg',
                link: '/map2?place=경복궁&name=경복궁'
            },
            {
               kind:'공원',
                name: '서울숲',
                x: 127.037531,
                y: 37.544314,
                imageUrl: '/resources/img/Kidspark.jpg',
                link: '/map2?place=서울숲공원&name=서울숲'
            },
            {
               kind:'공원',
                name: '어린이대공원',
                x: 127.081881,
                y: 37.549355,
                imageUrl: '/resources/img/seoulforest.jpg',
                link: '/map2?place=어린이대공원&name=어린이대공원'
            },
            {
               kind: '발달상권',
                name: '동대문DDP',
                x: 127.009801,
                y: 37.567203,
                imageUrl: '/resources/img/DDP.jpg',
                link: '/map2?place=DDP(동대문디자인플라자)&name=동대문DDP'
            },
            {
               kind: '발달상권',
                name: '코엑스',
                x: 127.059108,
                y: 37.511815,
                imageUrl: '/resources/img/coex.jpg',
                link: '/map2?place=강남 MICE 관광특구&name=코엑스'
            },
            {
               kind: '문화유산',
                name: '선사유적지',
                x: 127.129902,
                y: 37.560183,
                imageUrl: '/resources/img/Historicalsite.jpg',
                link: '/map2?place=서울 암사동 유적&name=선사유적지'
            },
            {
               kind: '공원',
                name: '북한산둘레길',
                x: 126.994268,
                y: 37.661346,
                imageUrl: '/resources/img/Road.jpg',
                link: '/map2?place=북한산우이역&name=북한산둘레길'
            },
            {
               kind: '공원',
                name: '낙성대공원',
                x: 126.959951,
                y: 37.471162,
                imageUrl: '/resources/img/Nakseongdae.jpg',
                link: '/map2?place=서울대입구역&name=낙성대공원'
            },
            {
               kind: '식물원',
                name: '푸른수목원',
                x: 126.825612,
                y: 37.483990,
                imageUrl: '/resources/img/Arboretum.jpg',
                link: '/map2?place=고척돔&name=푸른수목원'
            },
            {
               kind: '휴양림',
                name: '호암산 산림욕장',
                x: 126.924878,
                y: 37.450346,
                imageUrl: '/resources/img/aforestbath.jpg',
                link: '/map2?place=구로디지털단지역&name=호암산 산림욕장'
            },
            {
               kind: '공원',
                name: '화랑대 철도공원',
                x: 127.093313,
                y: 37.624266,
                imageUrl: '/resources/img/Hwarangdae.jpg',
                link: '/map2?place=북서울꿈의숲&name=화랑대 철도공원'
            },
            {
               kind: '산',
                name: '도봉산',
                x: 127.015714,
                y: 37.700013,
                imageUrl: '/resources/img/MountDobong.jpg',
                link: '/map2?place=창동 신경제 중심지&name=도봉산'
            },
            {
               kind: '공원',
                name: '보라매공원',
                x: 126.919794,
                y: 37.493253,
                imageUrl: '/resources/img/BoramaePark.jpg',
                link: '/map2?place=신림역&name=보라매공원'
            },
            {
               kind: '인구밀집지역',
                name: '홍대거리',
                x: 126.924230,
                y: 37.555849,
                imageUrl: '/resources/img/Hongdae.JPG',
                link: '/map2?place=홍대 관광특구&name=홍대거리'
            },
            {
               kind: '박물관',
                name: '서대문 형무소',
                x: 126.956099,
                y: 37.574311,
                imageUrl: '/resources/img/prison.jpg',
                link: '/map2?place=서촌&name=서대문 형무소'
            },
            {
               kind: '공원',
                name: '반포 한강공원',
                x: 126.996013,
                y: 37.510651,
                imageUrl: '/resources/img/HanRiverPark.jpg',
                link: '/map2?place=반포한강공원&name=반포한강공원'
            },
            {
               kind: '유적지',
                name: '정릉',
                x: 127.006430,
                y: 37.602279,
                imageUrl: '/resources/img/aroyaltomb.jpg',
                link: '/map2?place=성신여대입구역&name=정릉'
            },
            {
               kind: '발달상권,빌딩',
                name: '롯데타워',
                x: 127.102559,
                y: 37.512454,
                imageUrl: '/resources/img/LotteTower.jpg',
                link: '/map2?place=잠실 관광특구&name=롯데타워'
            },
            {
               kind: '공원',
                name: '서서울호수공원',
                x: 126.829856,
                y: 37.527728,
                imageUrl: '/resources/img/LakePark.jpg',
                link: '/map2?place=오목교역·목동운동장&name=서서울호수공원'
            },
            {
               kind: '백화점',
                name: '더현대 서울',
                x: 126.928523,
                y: 37.525856,
                imageUrl: '/resources/img/DepartmentStore.jpg',
                link: '/map2?place=여의도&name=더현대 서울'
            },
            {
               kind: '복합문화공간',
                name: '남산서울타워',
                x: 126.988304,
                y: 37.551183,
                imageUrl: '/resources/img/NamsanTower.jpg',
                link: '/map2?place=남산공원&name=남산서울타워'
            },
            {
               kind: '체험마을',
                name: '은평한옥마을',
                x: 126.939105,
                y: 37.641674,
                imageUrl: '/resources/img/HanokVillage.jpg',
                link: '/map2?place=연신내역&name=은평한옥마을'
            },
            {
               kind: '발달상권',
                name: '명동',
                x: 126.984513,
                y: 37.563769,
                imageUrl: '/resources/img/Myeongdong.jpg',
                link: '/map2?place=명동 관광특구&name=명동'       
            },
            {
               kind: '놀이공원',
                name: '용마랜드',
                x: 127.105436,
                y: 37.594833,
                imageUrl: '/resources/img/YongmaLand.jpg',
                link: '/map2?place=아차산&name=용마랜드'
            },
            {
                kind: '식물원',
                 name: '서울식물원',
                 x: 126.835049,
                 y: 37.569396,
                 imageUrl: '/resources/img/Botanicalgarden.jpg',
                 link: '/map2?place=발산역&name=서울식물원'
             }
        ];
    	 // 지도 컨테이너 요소를 DOM에서 찾아서 변수에 할당
        var mapContainer = document.getElementById('map');
     	// 초기 지도 중심 좌표를 설정 (첫 번째 위치로)
        var mapCenter = new kakao.maps.LatLng(locations[0].y, locations[0].x);
     	// 지도 옵션 설정
     	var mapOption = {
            center: mapCenter,// 중심 좌표 설정
            level: 3// 지도 확대 레벨 설정
        };
     	
     	// Kakao Maps API를 사용하여 새로운 지도 객체를 생성
        var map = new kakao.maps.Map(mapContainer, mapOption);
     	
     	// 마커를 저장할 배열
        var markers = [];
     	
     	// 커스텀 오버레이를 생성할 객체
        var infoOverlay = new kakao.maps.CustomOverlay({
            xAnchor: 0.5,// 오버레이 위치의 가로 방향 앵커 설정
            yAnchor: 1.1// 오버레이 위치의 세로 방향 앵커 설정
        });
     
     	// 현재 선택된 위치를 저장할 변수 초기화
        var currentLocation = null;

     // 컨테이너에 리스트 내용을 업데이트하는 함수
        function updateLocationList() {
            // 위치 목록을 표시할 컨테이너 요소를 DOM에서 찾아 변수에 할당
            var listContainer = document.getElementById('locationListContainer');
            
            // 컨테이너 내부의 HTML을 초기화 (이전 목록 삭제)
            listContainer.innerHTML = '';

            // 위치 목록을 반복하여 리스트 항목을 생성하고 이벤트 리스너를 등록
            for (var i = 0; i < locations.length; i++) {
                // 새로운 리스트 항목 요소를 생성
                var listItem = document.createElement('div');
                
                // 리스트 항목의 클래스를 지정
                listItem.className = 'list-item';

                // 리스트 항목의 내용을 설정 (위치의 이름)
                listItem.innerHTML = '<span class="list-name">' + locations[i].name + '</span>';
                
                // 리스트 항목에 클릭 이벤트 리스너를 등록하고, 해당 위치 정보를 전달하는 함수를 연결
                listItem.addEventListener('click', createListClickFunction(locations[i]));

                // 리스트 컨테이너에 새로운 리스트 항목을 추가
                listContainer.appendChild(listItem);
            }
        }

     	// 리스트 항목 클릭을 처리하는 함수를 생성
        function createListClickFunction(location) {
            return function () {
                // 클릭한 리스트에 해당하는 마커로 지도 이동
                moveToMarker(location);

                // 선택한 위치에 대한 정보를 표시
                displayInfo(location);
            };
        }

        function moveToMarker(location) {
            var markerPosition = new kakao.maps.LatLng(location.y, location.x);

            // 선택한 위치의 마커로 지도 이동
            map.setCenter(markerPosition);
        }

        // 초기에 리스트를 채우기 위해 함수를 호출합니다
        updateLocationList();
        
     	// 위치 목록에 대응하는 마커 생성 및 지도에 표시
        for (var i = 0; i < locations.length; i++) {
            var markerPosition = new kakao.maps.LatLng(locations[i].y, locations[i].x);

            var marker = new kakao.maps.Marker({
                position: markerPosition
            });
			
            // 마커 클릭 시 정보 표시 함수 등록
            kakao.maps.event.addListener(marker, 'click', createDisplayInfoFunction(locations[i]));

            markers.push(marker);
			
         	// 마커를 지도에 추가
            marker.setMap(map);
        }
		
    	 // 마커 클릭 시 정보 표시 함수를 생성
        function createDisplayInfoFunction(location) {
            return function () {
                displayInfo(location);
            };
        }
    	 // 선택한 위치에 대한 정보를 표시하는 함수
        function displayInfo(location) {
            if (currentLocation === location) {
            	// 이미 선택된 위치를 다시 클릭하면 정보 오버레이 제거
                infoOverlay.setMap(null);
                currentLocation = null;
            } else {
            	// 선택한 위치의 정보를 오버레이에 표시
                var content = '<div class="overlay_info" style="width: 340px; height: 275px; padding:1px">';
                content += '<h5 style="color: #00D369; margin-top: 10px; margin-bottom: 5px; margin-left: 10px">' + location.kind +'</h5>';
                content += '<strong style="display: flex; justify-content: space-between; align-items: center;">' +
                    '<span style="margin-left: 10px">' + location.name + '</span>' +
                    '<button class="custom-btn btn" style="margin-left: auto; margin-right: 20px;" onclick="redirectToLink(\'' + encodeURI(location.link) + '\');">실시간 인구 ' + location.name + '</button>' +
                    '</strong>';
                content += '<div class="desc">';
                content += '<img src="' + location.imageUrl + '" alt="' + location.name + '" style="width:305px; height:200px;">';
				
             	// 오버레이 설정 및 지도에 추가
                infoOverlay.setContent(content);
                infoOverlay.setPosition(markers[locations.indexOf(location)].getPosition());
                infoOverlay.setMap(map);

                currentLocation = location;
            }
        }
		
     	// 특정 링크로 리다이렉션하는 함수
        function redirectToLink(link) {
           var name = currentLocation ? currentLocation.name : '';
            window.location.href = link + '?name=' + encodeURIComponent(name);
        }

    </script>
    <script src="/resources/js/loding.js"></script>
</body>
</html>