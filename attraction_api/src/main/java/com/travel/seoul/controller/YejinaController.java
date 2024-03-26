package com.travel.seoul.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.travel.seoul.service.AdminService;
import com.travel.seoul.service.BoardAttachService;
import com.travel.seoul.service.BoardService;
import com.travel.seoul.service.CommentService;
import com.travel.seoul.service.TransService;
import com.travel.seoul.vo.AdminVO;
import com.travel.seoul.vo.BoardAttachVO;
import com.travel.seoul.vo.BoardVO;
import com.travel.seoul.vo.CommentVO;
import com.travel.seoul.vo.Criteria;
import com.travel.seoul.vo.TransVO;
import com.travel.seoul.vo.UserVO;
import com.travel.seoul.vo.pageMakerVO;

import lombok.Setter;


@Controller
@RequestMapping(value = "/board/*")
public class YejinaController {
	@Setter(onMethod_=@Autowired)
	private BoardService service;
	
	@Setter(onMethod_=@Autowired)
	private CommentService cService; 
	
	@Setter(onMethod_=@Autowired)
	private TransService tService;
	
	@Setter(onMethod_=@Autowired)
	private AdminService aService;
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachService baService;
	
	@GetMapping("/sample")
	public String a(Model model) {
		List<BoardVO> a = service.getBoardList();
		model.addAttribute("a",a);
		return "board/sample";
	}
	@GetMapping("/list")
	public String GetBoardList(HttpServletRequest request, Model model, Criteria cri) {
		model.addAttribute("lists",service.getListPaging(cri));
		List<AdminVO> admin = aService.getAdminList();
		model.addAttribute("admin",admin);
		int total = service.getListPaingTotal();
		pageMakerVO pageMake = new pageMakerVO(cri, total);
		model.addAttribute("pageMaker",pageMake);
		HttpSession session = request.getSession();
	      UserVO user = (UserVO) session.getAttribute("loginMember");
	      model.addAttribute("user",user);
		return "board/list";
	}
	@GetMapping("/write")
	   public String GetBoardWrite(HttpServletRequest request, BoardVO board, UserVO vo, Model model)  {
	      System.out.println("컨트롤에서 추가 vo : "+ board);

	      HttpSession session = request.getSession();
	      UserVO user = (UserVO) session.getAttribute("loginMember");
	      model.addAttribute("user",user);
	      
	      return "board/write";
	   }
	@PostMapping("/write")
	public String postBoardWrite(BoardVO board, RedirectAttributes rttr) {
		System.out.println("컨트롤러 작성 post" + board);
	    
	    long newBoardNum = service.getNextNum(); // 새로 등록된 게시글의 num
	    
	    if(board.getAttachList() != null) {
	    	board.getAttachList().forEach(attach -> System.out.println(attach));
	    }
	    
	    service.write(board);
	    System.out.println("컨틀롤러에서 마지막 게시글 번호 : " +newBoardNum );
	    rttr.addAttribute("boardNum", newBoardNum);
	    rttr.addFlashAttribute("result", "write success");
	    return "redirect:/board/list";
	}

	@GetMapping("/admin_write")
	   public String GetAdminWrite(HttpServletRequest request, AdminVO admin, UserVO vo, Model model)  {
	      System.out.println("컨트롤에서 추가 vo : "+ admin);

	      HttpSession session = request.getSession();
	      UserVO user = (UserVO) session.getAttribute("loginMember");
	      model.addAttribute("user",user);
	      //관리자 세션 필요
	      return "board/admin_write";
	   }
	@PostMapping("/admin_write")
	public String postAdminWrite(AdminVO admin, RedirectAttributes rttr) {
		System.out.println("컨트롤러 작성 admin post" + admin);
	    long newAdminNum = aService.getNextNum(); // 새로 등록된 게시글의 num
	    
	    if(admin.getAttachList() != null) {
	    	admin.getAttachList().forEach(attach -> System.out.println(attach));
	    }
	    aService.adminWrite(admin);
	    System.out.println("컨틀롤러에서 마지막 게시글 번호 : " +newAdminNum );
	    rttr.addAttribute("adminNum", newAdminNum);
	    rttr.addFlashAttribute("result", "write success");
	    return "redirect:/board/list";
	}
	@GetMapping("/view")
	   public String getBoardView(HttpServletRequest request, long boardNum, Model model) {
	      service.visitCount(boardNum);
	      System.out.println("boardNum:" +boardNum);
	       BoardVO boardWrite = service.getBoardByNum(boardNum);
	       System.out.println("컨트롤러 view boardWirte : "+boardWrite);
	       model.addAttribute("boardWrite", boardWrite);
	       
	       List<CommentVO> comments = cService.getCommentListByBoardNum(boardNum);
	       System.out.println("컨트롤러 댓글 리스트"+comments);
	       model.addAttribute("comments",comments);
	   
	       HttpSession session = request.getSession();
	      UserVO user = (UserVO) session.getAttribute("loginMember");
	      
	      String userID = (user != null) ? user.getUserID() : null;
	      int likeCheck = service.likeCheck(boardWrite.getNum(), userID);
	      model.addAttribute("likeCheck",likeCheck);
	      model.addAttribute("user",user);
	      return "board/view";
	   }
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(long num) {
		System.out.println("getAttachList " + num);
		return new ResponseEntity<>(service.getAttachList(num), HttpStatus.OK);
	}
	
	@GetMapping(value = "/getAdminAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAdminAttachList(long num) {
		System.out.println("getAdminAttachList " + num);
		return new ResponseEntity<>(aService.getAdminAttachList(num), HttpStatus.OK);
	}
	
	@PostMapping("/view")
	@ResponseBody
	public ResponseEntity<List<CommentVO>> postCommentView(@RequestBody CommentVO comment) {
	    System.out.println("컨트롤러 ajax 댓글" + comment);
	    cService.commentInsert(comment);

	    List<CommentVO> comments = cService.getCommentListByBoardNum(comment.getBoard_num());
	    System.out.println("컨트롤러 comments : "+comments);
	    if (comments != null) {
	        return new ResponseEntity<>(comments, HttpStatus.OK);
	    } else {
	        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
    @GetMapping("/edit")
    public String GetBoardEdit(HttpServletRequest request, long boardNum, Model model)  {
       BoardVO boardEdit = service.getBoardByNum(boardNum);
       
       System.out.println("컨트롤러 edit : "+boardEdit);
       model.addAttribute("boardNum", boardEdit);
        
       HttpSession session = request.getSession();
       UserVO user = (UserVO) session.getAttribute("loginMember");
       model.addAttribute("user",user);
       return "board/edit";
    }
	@PostMapping("/edit")
	public String PostBoardEdit(BoardVO board, RedirectAttributes rttr) {
		System.out.println("컨트롤러 포스트 edit 수정 : "+board);
		
		if(board.getAttachList() != null) {
	    	board.getAttachList().forEach(attach ->System.out.println(attach));
	    }
		
	    service.edit(board);
		rttr.addFlashAttribute("result", "edit success");
	    return "redirect:/board/list";
	}
	@GetMapping("/admin_view")
	   public String getAdminView(HttpServletRequest request, long adminNum, Model model) {
	      aService.adminVisitcount(adminNum);
	      System.out.println("adminNum:" +adminNum);
	      AdminVO admin = aService.getAdminByNum(adminNum);
	      System.out.println("컨트롤러 view admin : "+admin);
	      model.addAttribute("admin",admin);
	       
	      List<CommentVO> comments = cService.getCommentListByAdminNum(adminNum);
	      System.out.println("컨트롤러 공지사항 댓글 리스트"+comments);
	      model.addAttribute("comments",comments);
	       
	      HttpSession session = request.getSession();
	      UserVO user = (UserVO) session.getAttribute("loginMember");
	      model.addAttribute("user",user);
	      //여기 관리자 아이디 세션 받아오기
	      return "board/admin_view";
	   }
	@PostMapping("/admin_view")
	@ResponseBody
	public ResponseEntity<List<CommentVO>> postAdminCommentView(@RequestBody CommentVO comment) {
	    System.out.println("컨트롤러 ajax 댓글" + comment);
	    cService.commentAdminInsert(comment);

	    // 새로운 댓글 리스트를 가져옴
	    List<CommentVO> comments = cService.getCommentListByAdminNum(comment.getAdmin_num());

	    if (comments != null) {
	        // 새로운 댓글 리스트를 반환
	        return new ResponseEntity<>(comments, HttpStatus.OK);
	    } else {
	        // 실패 시에는 에러 응답 반환
	        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}


	// 댓글 수정
    @PostMapping("/comment/update")
    @ResponseBody
    public ResponseEntity<List<CommentVO>> updateComment(@RequestBody CommentVO comment) {
        try {
            cService.updateComment(comment);
            System.out.println("comment.getBoard_num()"+comment.getBoard_num());
            List<CommentVO> updatedComments = cService.getCommentListByBoardNum(comment.getBoard_num());
            return new ResponseEntity<>(updatedComments, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 댓글 삭제
    @PostMapping("/comment/delete")
    @ResponseBody
    public ResponseEntity<List<CommentVO>> deleteComment(@RequestBody CommentVO comment) {
        try {
            cService.deleteComment(comment.getCo_num());
            List<CommentVO> deletedComment = cService.getCommentListByBoardNum(comment.getBoard_num());
            return new ResponseEntity<>(deletedComment, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
	// 댓글 수정
    @PostMapping("/comment/admin_update")
    @ResponseBody
    public ResponseEntity<List<CommentVO>> updateAdminComment(@RequestBody CommentVO comment) {
        try {
            cService.updateAdminComment(comment);
            System.out.println("comment.getAdmin_num()"+comment.getAdmin_num());
            List<CommentVO> updatedComments = cService.getCommentListByAdminNum(comment.getAdmin_num());
            return new ResponseEntity<>(updatedComments, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 댓글 삭제
    @PostMapping("/comment/admin_delete")
    @ResponseBody
    public ResponseEntity<List<CommentVO>> deleteAdminComment(@RequestBody CommentVO comment) {
        try {
            cService.deleteAdminComment(comment.getCo_num());
            List<CommentVO> deletedComment = cService.getCommentListByAdminNum(comment.getAdmin_num());
            return new ResponseEntity<>(deletedComment, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


	@GetMapping("/admin_edit")
    public String GetAdminEdit(HttpServletRequest request, long adminNum, Model model)  {
       
       AdminVO adminEdit = aService.getAdminByNum(adminNum);
       System.out.println("컨트롤러 adminEdit : "+adminEdit);
        model.addAttribute("adminNum", adminEdit);
        
        HttpSession session = request.getSession();
       UserVO user = (UserVO) session.getAttribute("loginMember");
       model.addAttribute("user",user);
       //관리자 세션 추가 필요
       return "board/admin_edit";
    }
	@PostMapping("/admin_edit")
	public String PostAdminEdit(AdminVO admin, RedirectAttributes rttr) {
		System.out.println("컨트롤러 포스트수정 : "+admin);
		
		if(admin.getAttachList() != null) {
			admin.getAttachList().forEach(attach ->System.out.println(attach));
	    }
		aService.adminEdit(admin);
		rttr.addFlashAttribute("result", "edit success");
	    return "redirect:/board/list";
	}

	@PostMapping("/delete")
	public String boardDeletePost(long boardNum, RedirectAttributes rttr) {
		service.delete(boardNum);
		System.out.println("컨트롤러 delete : "+boardNum);
		rttr.addFlashAttribute("result","delete success");
		return "redirect:/board/list";
	}
	
	@PostMapping("/admin_delete")
	public String AdminDeletePost(long adminNum, RedirectAttributes rttr) {
		aService.adminDelete(adminNum);
		System.out.println("컨트롤러 delete : "+adminNum);
		rttr.addFlashAttribute("result","delete success");
		return "redirect:/board/list";
	}
	
	@RequestMapping("/test")
	public String test() {		
		
		return "test";
	}

	@PostMapping("/translate")
	@ResponseBody
	public ResponseEntity<Map<String, String>> translate(@RequestBody Map<String, String> translationRequest) {
	    try {
	    	 String lang = translationRequest.get("lang");
	    	 String translatedStrong="";
	    	 System.out.println("translationRequest 과연? "+translationRequest.size());
		        Map<String, String> result = new HashMap<>();
	    	 if ("chinese".equals(lang)) {
		    	for(String i : translationRequest.keySet()) {
		    		 String strong = translationRequest.get(i);
		    		 translatedStrong = tService.getChinese(new TransVO(strong, null, null, null,null));
		    		 result.put(i, translatedStrong);
		    	}
		    	System.out.println("result 는 ?? "+result);
	        } else if ("japanese".equals(lang)) {
	        	for(String i : translationRequest.keySet()) {
		    		 String strong = translationRequest.get(i);
		    		 translatedStrong = tService.getJapanese(new TransVO(strong, null, null, null,null));
		    		 result.put(i, translatedStrong);
		    	}
		    	System.out.println("result 는 ?? "+result);
	        } else if ("english".equals(lang)) {
	        	for(String i : translationRequest.keySet()) {
		    		 String strong = translationRequest.get(i);
		    		 translatedStrong = tService.getEnglish(new TransVO(strong, null, null, null,null));
		    		 result.put(i, translatedStrong);
		    	}
		    	System.out.println("result 는 ?? "+result);
	        } else if ("language".equals(lang)){
	        	//언어감지

	        }
	        return new ResponseEntity<>(result, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

}
