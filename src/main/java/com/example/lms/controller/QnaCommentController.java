package com.example.lms.controller;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.QnaCommentDTO;
import com.example.lms.dto.QnaDTO;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.service.QnaCommentService;
import com.example.lms.service.QnaService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/qna")
public class QnaCommentController {
	@Autowired
	private QnaCommentService qnaCommentService;
	@Autowired
	private QnaService qnaService;
	
	// 댓글 리스트
	@GetMapping("/qnaCommentList")
	public String qnaCommentList(@RequestParam("qnaId") int qnaId, Model model) {
		
		// 파라미터를 Map 형태로 묶기 (다중 파라미터 넘길 때 사용 가능)
		Map<String, Object> param = new HashMap<>();
		param.put("qnaId", qnaId);	// qna 글 번호를 map에 저장
		
		// 댓글 리스트 조회
		// qnaCommentService에서 댓글 목록을 가져옴(DB에서 select)
		List<QnaCommentDTO> commentList = qnaCommentService.selectQnaCommentList(param);
		
		// 조회한 댓글 리스트를 jsp에서 사용할 수 있도록 모델에 담기
		model.addAttribute("commentList", commentList);
		
		// 현재 글 번호도 함께 전달 (댓글 작성 시 필요)
		model.addAttribute("qnaId", qnaId);
		
		// 댓글 리스트를 보여줄 jsp 페이지로 이동
		return "qna/qnaOne";
	}
	
	// 댓글 작성
	@PostMapping("/insertQnaComment")
	public String insertQnaComment(@RequestParam("qnaId") int qnaId,			// 댓글이 달릴 qna 글 번호를 파라미터로 받음
									@RequestParam("content") String content,	// 사용자가 입력한 댓글 내용
									@RequestParam(value = "parentCommentId", required = false) Integer parentCommentId,
									HttpSession session) {						// 로그인 정보를 가져오기 위해 세션 객체도 함께 받음
			
		// 세션에서 로그인 된 사용자 정보를 꺼냄
		// 로그인 시 저장했떤 "loginUser" 객체를 가져옴
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
		
		// qnaCommentDto 객체를 생성하고 댓글 데이터를 담음
		QnaCommentDTO comment = new QnaCommentDTO();
		
		// 댓글이 어느 qna 글에 달리는 지 지정(글 번호)
		comment.setQnaId(qnaId);
		
		// 댓글 본문 내용 저장
		comment.setContent(content);
		
		// 일반 댓글이면 null, 대댓글이면 부모 ID
		comment.setParentCommentId(parentCommentId);
		
	    // 댓글 작성자 ID를 설정
	    //   - admin이면 adminId,
	    //   - teacher이면 teacherId,
	    //   - student이면 studentId
	    //   - 삼항 연산자를 중첩해서 우선순위대로 검사
	    comment.setWriterId(
	        loginUser.getAdminId() != null ? loginUser.getAdminId() :
	        (loginUser.getTeacherId() != null ? loginUser.getTeacherId() :
	        loginUser.getStudentId())
	    );
	    
	    // 작성자의 역할(권한)을 저장 (ex : "amdin", "teacher", "student")
	    comment.setWriterRole(loginUser.getRole());
	    
	    // 한국 시간 기준으로 createDate 지정
	    LocalDateTime nowKorea = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
	    
	    //	쿼리에 NOW() + 9 HOUR 되어있어서 필요 x
	    // comment.setCreateDate(Timestamp.valueOf(nowKorea));
	    
	    // service를 통해 댓글 DB에 저장 요청
	    qnaCommentService.insertQnaComment(comment);
	    
	    // qna 상태 '답변완료로 변경
	    qnaService.updateAnswerStatus(qnaId, "답변완료");
	    
	    // 저장이 끝난 후 다시 qna 상세 페이지로 리다이렉트
	    // 새로 작성된 댓글이 포함된 상세페이지를 다시 보여주기 위해
	    return "redirect:/qna/qnaOne?qnaId=" + qnaId;
	}    
	 
     //댓글 수정
    @PostMapping("/updateQnaComment")
    public String updateQnaComment(@ModelAttribute QnaCommentDTO qnaCommentDto,
                                   HttpSession session,
                                   RedirectAttributes ra) {
        SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            ra.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
            return "redirect:/login";
        }

        QnaCommentDTO original = qnaCommentService.selectQnaCommentById(qnaCommentDto.getCommentId());
        if (original == null) {
            ra.addFlashAttribute("errorMsg", "댓글을 찾을 수 없습니다.");
            return "redirect:/qna/qnaList";
        }

        boolean isOwner = loginUser.getRole().equals(original.getWriterRole()) &&
                          loginUser.getStudentId().equals(original.getWriterId());
        boolean isAdminOrTeacher = "admin".equals(loginUser.getRole()) || "teacher".equals(loginUser.getRole());

        if (!(isOwner || isAdminOrTeacher)) {
            ra.addFlashAttribute("errorMsg", "수정 권한이 없습니다.");
            return "redirect:/qna/qnaOne?qnaId=" + original.getQnaId();
        }

        qnaCommentService.updateQnaComment(qnaCommentDto);
        return "redirect:/qna/qnaOne?qnaId=" + original.getQnaId();
    }
    
    // 댓글 삭제
    @PostMapping("/deleteQnaComment")
    public String deleteQnaComment(@RequestParam("commentId") int commentId,
						            @RequestParam("qnaId") int qnaId, // 다시 돌아가기 위한 정보
						            HttpSession session,
						            RedirectAttributes ra) {
    	// System.out.println("🟢 deleteQnaComment 들어옴"); // 로그 확인용
	// 로그인 유저 정보 가져오기
	SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
	
	// 로그인 안 돼있으면 로그인 페이지로 이동
	if (loginUser == null) {
	ra.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
	return "redirect:/login";
	}
	
	// 삭제할 댓글 정보 가져오기
	QnaCommentDTO comment = qnaCommentService.selectQnaCommentById(commentId);
	if (comment == null) {
	ra.addFlashAttribute("errorMsg", "댓글을 찾을 수 없습니다.");
	return "redirect:/qna/qnaOne?qnaId=" + qnaId;
	}
	
	// 삭제 권한 확인
	boolean isOwner = loginUser.getRole().equals(comment.getWriterRole()) &&
	   loginUser.getStudentId() != null &&
	   loginUser.getStudentId().equals(comment.getWriterId());
	
	boolean isAdminOrTeacher = "admin".equals(loginUser.getRole()) || "teacher".equals(loginUser.getRole());
	
	if (!(isOwner || isAdminOrTeacher)) {
	ra.addFlashAttribute("errorMsg", "삭제 권한이 없습니다.");
	return "redirect:/qna/qnaOne?qnaId=" + qnaId;
	}
	
	// 삭제 수행
	// 삭제 순서 대댓글 -> 댓글
	qnaCommentService.deleteRepliesByParentId(commentId);
	qnaCommentService.deleteQnaComment(commentId);
	
	// 댓글 삭제 후 원래 QnA 상세 페이지로 리다이렉트
	return "redirect:/qna/qnaOne?qnaId=" + qnaId;
	}
	
}

























