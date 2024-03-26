package com.travel.seoul.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.travel.seoul.vo.BoardAttachVO;
import com.travel.seoul.vo.BoardVO;
import com.travel.seoul.vo.Criteria;

public interface BoardService {
	public List<BoardVO> getBoardList();
	public void getBoardByID(String id);
	public void insert(BoardVO board);
	public int update(BoardVO board);
	public int delete(long num);
	public void userdelete(String id);
	public BoardVO getBoardByNum(long num);
	public int getNextNum();
	public int visitCount(long num);
	public int likeCount(@Param("board_num") long board_num);
	public int likeCountCancel(@Param("board_num") long board_num);
	
	public void insertLike(@Param("board_num") long board_num, @Param("user_id") String user_id);
	public int deleteLike(@Param("board_num") long board_num, @Param("user_id") String user_id);
	public int likeCheck(@Param("board_num") long board_num, @Param("user_id") String user_id);
	
	
	public List<BoardVO> getListPaging(Criteria cri);
	public int getListPaingTotal();
	
	public void write(BoardVO board);
	public List<BoardAttachVO> getAttachList(long num);
	public boolean edit(BoardVO board);
	

	
}
