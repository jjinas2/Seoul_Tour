package com.travel.seoul.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.travel.seoul.vo.UserVO;


@Controller
@RequestMapping(value = "/live/*")
public class LiveController {
	@GetMapping("/map")
	public String a(HttpServletRequest request,Model model) {
		HttpSession session = request.getSession();
	      UserVO user = (UserVO) session.getAttribute("loginMember");
	      System.out.println("지도 세션:" +user);
	      model.addAttribute("user",user);

		return "live/map";
	}
	@GetMapping("/sample")
	public String b() {
		return "nav";
	}
}
