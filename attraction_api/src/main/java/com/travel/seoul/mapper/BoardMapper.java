package com.travel.seoul.mapper;
import com.travel.seoul.vo.BoardVO;
import com.travel.seoul.vo.Criteria;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface BoardMapper {
	public List<BoardVO> getBoardList();
	public void getBoardByID(String id);
	public void insert(BoardVO boardVO);
	public int update(BoardVO boardVO);
	public void boardInsert(BoardVO board);
	public BoardVO getBoardByNum(long num);
	public int getNextNum();
	public int delete(long num);
	public void userdelete(String id);
	public int visitCount(long num);
	public int likeCount(@Param("board_num") long board_num);
	public int likeCountCancel(@Param("board_num") long board_num);
	
	public void insertLike(@Param("board_num") long board_num, @Param("user_id") String user_id);
	public int deleteLike(@Param("board_num") long board_num, @Param("user_id") String user_id);
	public int likeCheck(@Param("board_num") long board_num, @Param("user_id") String user_id);
	
	public List<BoardVO> getListPaging(Criteria cri);
	public int getListPaingTotal();
	public void fileInsert(BoardVO board);
	public void fileSelect(BoardVO board);
	public void insertSelectKey(BoardVO boardVO);
	
}
