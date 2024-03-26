package com.travel.seoul.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.travel.seoul.service.BoardService;

import lombok.Setter;

@Controller
public class LikeController {
	
	@Setter(onMethod_=@Autowired)
	private BoardService service;
	
	@ResponseBody
	@PostMapping("/board/updateLike")
	public int updateLike(long board_num, String user_id)throws Exception{
		System.out.println("updateLike : "+board_num+user_id);
		int likeCheck = service.likeCheck(board_num,user_id);
		System.out.println("likeCheck : "+likeCheck);
		if(likeCheck == 0) {
			service.insertLike(board_num, user_id);
			service.likeCount(board_num);
		}else if(likeCheck == 1) {
			service.likeCountCancel(board_num);
			service.deleteLike(board_num, user_id);
		}
		return likeCheck;
	}
}
