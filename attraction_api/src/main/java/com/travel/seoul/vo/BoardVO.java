package com.travel.seoul.vo;

import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	private long num;
	private String title;
	private String content;
	private String id;
	private String pw;
	private String postdate;
	private long visitcount;
	private long likecount;
	
	private List<BoardAttachVO> attachList;
}
