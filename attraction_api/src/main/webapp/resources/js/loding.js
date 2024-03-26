// 마커를 클릭했을 때 호출되는 함수를 생성
function createDisplayInfoFunction(location) {
    return function () {
        // 로딩 오버레이를 표시
        showLoadingOverlay();
        
        // setTimeout 함수를 사용하여 일정 시간 후에 displayInfo 함수 호출
        setTimeout(function () {
            displayInfo(location);
            
            // 로딩 오버레이를 숨김
            hideLoadingOverlay();
        }, 1000); // 지연을 시뮬레이션하며 필요에 따라 조절
    };
}

// 로딩 오버레이를 화면에 표시하는 함수
function showLoadingOverlay() {
    $('#loadingOverlay').css('display', 'flex');
}

// 로딩 오버레이를 화면에서 숨기는 함수
function hideLoadingOverlay() {
    $('#loadingOverlay').css('display', 'none');
}

// 페이지 리다이렉션을 수행하는 함수
function redirectToLink(link) {
    // 로딩 오버레이를 표시
    showLoadingOverlay();
    
    // 페이지 리다이렉션
    window.location.href = link;
}
