let page = 0; // 영역 포지션 초기값
const lastPage = 4; // 마지막 페이지

$("body").on("mousewheel", function (e) {
	var wheel = e.originalEvent.wheelDelta;
    if(wheel < 0){
        page++;
    }else if(wheel > 0){
        page--;
    }
    console.log(page);
    if(page <= 0){
        page=0;
        $('#btn_gotop').hide();
    }else if(page > lastPage){
        page = lastPage;
        $('#btn_gotop').show();
    }else{
        $('#btn_gotop').show();
    }
	if (page == 0){
		var offset = $('.container:nth-child(1)').offset();
	}else if (page == 1){
		var offset = $('.container:nth-child(2)').offset();
	}else if (page == 2){
		var offset = $('.container:nth-child(3)').offset();
	}else if (page == 3){
		var offset = $('.container:nth-child(4)').offset();
	}else if (page == 4){
		var offset = $('.container:nth-child(5)').offset();
	}
	$('html').animate({scrollTop : offset.top}, 400);
}); // 디폴트 기능 제거 - 스크롤

$('#btn_gotop').click(function(){ 
//	$('.wrap').css('top','0vh');
	 $('html').animate({scrollTop : 0}, 400);
	page = 0;
    return false;
});
