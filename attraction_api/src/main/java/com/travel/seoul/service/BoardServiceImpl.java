package com.travel.seoul.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.travel.seoul.mapper.BoardAttachMapper;
import com.travel.seoul.mapper.BoardMapper;
import com.travel.seoul.vo.BoardAttachVO;
import com.travel.seoul.vo.BoardVO;
import com.travel.seoul.vo.Criteria;

import lombok.Setter;

@Service
@Transactional
public class BoardServiceImpl implements BoardService{
	
	@Setter(onMethod_ = @Autowired)
	BoardMapper bmapper;
	
	@Setter(onMethod_ = @Autowired)
	BoardAttachMapper attachMapper;
	
	@Override
	public List<BoardVO> getBoardList() {
		return bmapper.getBoardList();
	}

	@Override
	public void insert(BoardVO board) {
		System.out.println("서비스에서 추가 : "+board);
		bmapper.insert(board);
		
	}


	@Override
	public BoardVO getBoardByNum(long num) {
		System.out.println("서비스에서 게시글 하나 가져오기 :" +num);
		return bmapper.getBoardByNum(num);
	}

	@Override
	public int getNextNum() {
		int maxNo = bmapper.getNextNum();
		System.out.println("여기는 서비스 : 게시글 마지막 번호 :" +maxNo);
		return bmapper.getNextNum();
	}

	@Override
	public int update(BoardVO board) {
		System.out.println("서비스에서 수정 : "+board);
		return bmapper.update(board);
	}

	@Override
	public int delete(long num) {
		System.out.println("서비스에서 삭제 : "+num);
		return bmapper.delete(num);
	}

	@Override
	public int visitCount(long num) {
		return bmapper.visitCount(num);
	}
	@Override
	public int likeCount(long board_num) {
		return bmapper.likeCount(board_num);
	}
	
	@Override
	public int likeCountCancel(long board_num) {
		return bmapper.likeCountCancel(board_num);
	}
	
	@Override
	public void insertLike(long board_num, String user_id) {
		bmapper.insertLike(board_num, user_id);
	}

	
	
	@Override
	public List<BoardVO> getListPaging(Criteria cri) {
		return bmapper.getListPaging(cri);
	}

	@Override
	public int getListPaingTotal() {
		return bmapper.getListPaingTotal();
	}
	@Transactional
	@Override
	public void write(BoardVO board) {
		int boardNum = bmapper.getNextNum();
	    System.out.println("write 서비스에 파일넘버 : "+boardNum);
	    bmapper.insertSelectKey(board);
	    System.out.println("write..." + board);
	    // 첨부파일이 없을 경우, 중지
	    if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
	        return;
	    }
	    
	    board.getAttachList().forEach(attach -> {
	    	attach.setBoard_num(boardNum);
	        attachMapper.insert(attach);
	    });
	}

	@Override
	public List<BoardAttachVO> getAttachList(long num) {
		System.out.println("getAttachList num 서비스"+num);
		return attachMapper.findByBoard_num(num);
	}
	@Transactional
	@Override
	public boolean edit(BoardVO board) {
	   System.out.println("edit......" + board);
	   long num = board.getNum();
	   
	   System.out.println("서비스에서 파일추가번호"+num);
	   
	   attachMapper.deleteAllBoard_num(num);
	   boolean editResult = bmapper.update(board) == 1;
	   System.out.println("서비스 edit 리스트 : "+board.getAttachList());
	   if (editResult && board.getAttachList() != null && board.getAttachList().size() >0) {
	      board.getAttachList().forEach(attach -> {
	    	 System.out.println("서비스 attach edit : "+attach);
	         attach.setBoard_num(num);
	         attachMapper.insert(attach);
	      });
	   }
	   return editResult;
	}

	@Override
	public int deleteLike(long board_num, String user_id) {
		return bmapper.deleteLike(board_num, user_id);
	}

	@Override
	public int likeCheck(long board_num, String user_id) {
		try {
	        System.out.println("서비스 likeCheck - board_num: " + board_num + ", user_id: " + user_id);
	        int result = bmapper.likeCheck(board_num, user_id);
	        System.out.println("결과: " + result);
	        return result;
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}

	@Override
	public void getBoardByID(String id) {
		bmapper.getBoardByID(id);
		
	}

	@Override
	public void userdelete(String id) {
		bmapper.userdelete(id);
	}

	

	

	


}
