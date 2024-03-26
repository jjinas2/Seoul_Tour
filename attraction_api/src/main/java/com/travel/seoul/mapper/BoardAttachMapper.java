package com.travel.seoul.mapper;

import java.util.List;

import com.travel.seoul.vo.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO attachFiles);
	public void delete(String uuid);
	public List<BoardAttachVO> findByUserSerial(long userSerial);
	public List<BoardAttachVO> findByBoard_num(long board_num);
	public List<BoardAttachVO> findByAdmin_num(long admin_num);
	public void deleteAllUserSerial(long userSerial);
	public void deleteAllBoard_num(long board_num);
	public void deleteAllAdmin_num(long admin_num);
}
