package com.travel.seoul.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.travel.seoul.mapper.BoardAttachMapper;
import com.travel.seoul.vo.BoardAttachVO;

import lombok.Setter;

@Service
@Transactional
public class BoardAttachServiceImpl implements BoardAttachService{
	
	@Setter(onMethod_ = @Autowired)
	BoardAttachMapper bamapper;
	
	@Override
	public void insert(List<BoardAttachVO> attachFiles) {
		for (BoardAttachVO attachFile : attachFiles) {
			bamapper.insert(attachFile);
        }
	}

	@Override
	public void delete(String uuid) {
		bamapper.delete(uuid);
	}

	@Override
	public List<BoardAttachVO> findByUserSerial(long userSerial) {
		return bamapper.findByUserSerial(userSerial);
	}

	@Override
	public List<BoardAttachVO> findByBoard_num(long board_num) {
		return bamapper.findByBoard_num(board_num);
	}

	@Override
	public List<BoardAttachVO> findByAdmin_num(long admin_num) {
		return bamapper.findByAdmin_num(admin_num);
	}

	@Override
	public void deleteAllUserSerial(long userSerial) {
		bamapper.deleteAllUserSerial(userSerial);
	}

	@Override
	public void deleteAllBoard_num(long board_num) {
		bamapper.deleteAllBoard_num(board_num);
	}

	@Override
	public void deleteAllAdmin_num(long admin_num) {
		bamapper.deleteAllAdmin_num(admin_num);
	}

}
