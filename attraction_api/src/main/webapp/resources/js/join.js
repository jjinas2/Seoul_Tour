var cnt=0
var selectedArea=[]
$(document).ready(function(){
   var $checkboxes = $("#interestCheckboxes")
   console.log("지역 선택됨 : "+interestAreas)
   var str=""
    $.each(interestAreas,(idx,area) => {
   		str+="<div><label>"+ area +"</lable><input type='checkbox'></input></div>"
    });
    console.log(str)
    $checkboxes.html(str)


    $("#interestCheckboxes  [type=checkbox]").each((idx, area)=>{
    	$(area).change(function(){
    		console.log("여기 이벤트 발생")
	        var isChecked = $(this).is(":checked");
	        console.log("지역 선택됨 : "+isChecked)
	        if (isChecked){
	        	cnt++;
	        	selectedArea.push(interestAreas[idx]);
	        	
	        }
	        else {
	        	cnt--;
	        	console.log("문자");
            // 배열에서 해당 지역 제거
            const indexToRemove = selectedArea.indexOf(interestAreas[idx]);
            if (indexToRemove !== -1) {
                selectedArea.splice(indexToRemove, 1);
	        }
	        
	        console.log("선택 해제 : "+interestAreas[idx]);
        }
    });
     
    // 클릭한 옵션의 텍스트를 라벨 안에 넣음
    	$("button#age").click(function(e){
  		e.preventDefault();
	    // 옵션 클릭시 클릭한 옵션을 넘김
	    const options = $('.optionList');
	    options.toggle()
		
	})
})
})