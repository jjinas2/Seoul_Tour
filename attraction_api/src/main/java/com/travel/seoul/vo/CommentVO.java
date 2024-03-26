package com.travel.seoul.vo;

import lombok.Data;

@Data
public class CommentVO {
	private long co_num;
	private String id;
	private String co_content;
	private String co_date;
	private int board_num;
	private int admin_num;
}
