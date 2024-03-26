package com.travel.seoul.service;

import java.util.List;

import com.travel.seoul.vo.CommentVO;

public interface CommentService {
	public List<CommentVO> getCommentList();
	public void commentInsert(CommentVO comment);
	public int deleteComment(long co_num);
	public void userdeleteComment(String id);
	public void updateComment(CommentVO comment);
	public List<CommentVO> getCommentListByBoardNum(long board_num);
	public List<CommentVO> getCommentListByAdminNum(long admin_num);
	public void commentAdminInsert(CommentVO comment);
	public int deleteAdminComment(long co_num);
	public void updateAdminComment(CommentVO comment);
}
