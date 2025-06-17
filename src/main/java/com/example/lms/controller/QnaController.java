package com.example.lms.controller;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.Page;
import com.example.lms.dto.QnaCommentDTO;
import com.example.lms.dto.QnaDTO;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.service.AdminService;
import com.example.lms.service.MypageService;
import com.example.lms.service.QnaCommentService;
import com.example.lms.service.QnaService;
import com.example.lms.service.StudentService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/qna")
public class QnaController {
		@Autowired
		private QnaService qnaService;
		@Autowired
		private MypageService mypageService;
		@Autowired
		private AdminService adminService;
		@Autowired
		private QnaCommentService qnaCommentService;
		@Autowired
		private PasswordEncoder passwordEncoder; // 암호화 필드 받기 // com.example.lms.config.SecurityConfig
		
		// qna 리스트
		@GetMapping("/qnaList")
		public String qnaList(Model model,
				@RequestParam(defaultValue = "1") int currentPage,
				@RequestParam(value="searchOption", required=false, defaultValue="all") String searchOption,
				@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
				@RequestParam(defaultValue = "10") int rowPerPage) {
			
			int totalCount = qnaService.totalCount(searchOption, keyword);
			Page page = new Page(rowPerPage, currentPage, totalCount, searchOption, keyword);
			int startRow = (currentPage - 1) * rowPerPage;
			
			Map<String, Object> param = new HashMap<>();
			param.put("searchOption", searchOption);
			param.put("keyword", keyword);
			param.put("startRow", (currentPage - 1) * rowPerPage);
			param.put("rowPerPage", rowPerPage);
			
			List<QnaDTO> qnaList = qnaService.selectQnaList(param);
			
			// 페이징 계산
			int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);
			int pageSize = 10;
			int startPage = ((currentPage - 1) / pageSize) * pageSize + 1;
			int endPage = Math.min(startPage + pageSize - 1, lastPage);
			
	        model.addAttribute("qnaList", qnaList);
	        model.addAttribute("currentPage", currentPage);
	        model.addAttribute("searchOption", searchOption);
	        model.addAttribute("keyword", keyword);
	        model.addAttribute("rowPerPage", rowPerPage);
	        model.addAttribute("startPage", startPage);
	        model.addAttribute("endPage", endPage);
	        model.addAttribute("lastPage", lastPage);
	        

	        return"qna/qnaList";
		}
		
		// 작성
		@GetMapping("/insertQna")
		public String insertQna() {
			// 작성하는 페이지로 이동
			// 제목 내용 , 비밀글 입력창
			return "qna/insertQna";
		}
		
		@PostMapping("/insertQna")
		public String insertQna(QnaDTO qnaDto, HttpSession session) {
			// 현재 로그인한 사용자 정보를 세션에서 꺼냄
			SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
			
			if(qnaDto.getIsSecret() == null) {			// 비밀글
				qnaDto.setIsSecret("N");
			}
			System.out.println("isSecret = " + qnaDto.getIsSecret());
			qnaDto.setStudentNo(loginUser.getStudentNo());		// 작성자를 qna 객체에 세팅함
			
			 // 한국 시간 기준으로 createDate 지정
		    LocalDateTime nowKorea = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
		    qnaDto.setCreateDate(Timestamp.valueOf(nowKorea));
			
			qnaService.insertQna(qnaDto);		// 작성된 공지사항을 DB에 저장 요청
			
			return "redirect:/qna/qnaList";		// 작성 후 리다이렉트로 qna리스트로
		}
		
		// 상세보기
		// GET 방식: 관리자, 강사 등 비밀번호 없이 접근하는 경우
		@GetMapping("/qnaOne")
		public String qnaOne(@RequestParam("qnaId") int qnaId,
							 @RequestParam(required = false) Integer editCommentId,
		                     HttpSession session,
		                     Model model,
		                     RedirectAttributes ra) {
			
			// 로그인 한 유저정보 세션에서 꺼냄
		    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

		    String loginUserId = "";
		    if (loginUser != null) {
		        if ("admin".equals(loginUser.getRole())) {
		            loginUserId = loginUser.getAdminId();
		        } else if ("teacher".equals(loginUser.getRole())) {
		            loginUserId = loginUser.getTeacherId();
		        } else if ("student".equals(loginUser.getRole())) {
		            loginUserId = loginUser.getStudentId();
		        }
		    }
		    
		    // 글 번호에 해당하는 qna 글을 DB에서 가져옴
		    QnaDTO qnaDto = qnaService.selectQnaOne(qnaId);
		    
		    // 만약 해당 글이 존재하지 않으면 에러 메시지를 주고 리스트로 되돌린다
		    if (qnaDto == null) {
		        ra.addFlashAttribute("errorMsg", "글을 찾을 수 없습니다.");
		        return "redirect:/qna/qnaList";
		    }

		    Integer loginStudentNo = loginUser.getStudentNo();  // Integer 타입
		    Integer writerStudentNo = qnaDto.getStudentNo();    // Integer 타입
		    // 비밀글인데 로그인한 사용자가 학생이면 접근 불가 -> 차단 후 리스트로 되돌린다
		    if ("Y".equals(qnaDto.getIsSecret())) {
		    	boolean isWriter = loginStudentNo != null && loginStudentNo.equals(writerStudentNo);
		        boolean isAdmin = "admin".equals(loginUser.getRole());
		        boolean isTeacher = "teacher".equals(loginUser.getRole());

		        if (!(isWriter || isAdmin || isTeacher)) {
		            ra.addFlashAttribute("errorMsg", "비밀글은 접근할 수 없습니다.");
		            return "redirect:/qna/qnaList";
		        }
		    }
		    
		    model.addAttribute("loginUserId", loginUserId); // ★ JSP에서 사용 가능하도록 추가
		    // 위 조건을 모두 통과하면 글 내용을 모델에 담아서 jsp로 전달
		    model.addAttribute("qna", qnaDto);
		    model.addAttribute("editCommentId", editCommentId);
		    // 댓글 목록도 함꼐 조회해서 모델에 담는다.
		    List<QnaCommentDTO> commentList = qnaCommentService.selectQnaCommentList(Map.of("qnaId", qnaId));
		    model.addAttribute("commentList", commentList);

		    return "qna/qnaOne";
		}
		
		// POST 방식: 학생이 비밀번호 입력하고 들어오는 경우
		@PostMapping("/qnaOne")
		public String qnaOnePost(@RequestParam("qnaId") int qnaId,
		                         @RequestParam("pw") String pw,
		                         HttpSession session,
		                         Model model,
		                         RedirectAttributes ra) {
			
			// 로그인 한 사용자 정보를 세션에서 가져옴
		    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

		    // 오직 학생만 비밀번호 열람하는방식이라서 관리자나 강사가 접근한경우 get방식으로 리다이렉트
		    if (!"student".equals(loginUser.getRole())) {
		        return "redirect:/qna/qnaOne?qnaId=" + qnaId;
		    }

		    // DB에서 현재 로그인한 학생의 실제 비밀번호를 가져온다(지금은 평문과 비교 /추후에 암호화된 비밀번호로 비교)
		    String dbPw = mypageService.getStudentPasswordById(loginUser.getStudentId());
		    
		    // 사용자가 입력한 비밀번호를 DB 비밀번호와 다르면 -> 접근 차단 후 오류 메시지 전달
		    if (!passwordEncoder.matches(pw, dbPw)) {
		        ra.addFlashAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
		        return "redirect:/qna/qnaList";
		    }

		    // 비밀번호가 일치하면 해당 qna 글을 가져옴
		    QnaDTO qnaDto = qnaService.selectQnaOne(qnaId);
		    model.addAttribute("qna", qnaDto);

		    // 해당 글에 달린 댓글 목록도 함꼐 가져옴
		    List<QnaCommentDTO> commentList = qnaCommentService.selectQnaCommentList(Map.of("qnaId", qnaId));
		    model.addAttribute("commentList", commentList);

		    return "qna/qnaOne";
		}
		
		// 수정
		@GetMapping("/updateQna")
		public String updateQna(@RequestParam("qnaId") int qnaId,
									HttpSession session,
									Model model) {
			
			SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");
			//기존 qna 정보 가져오기
			QnaDTO qna = qnaService.selectQnaOne(qnaId);
			
		    // 작성자 본인이 아니면 차단
		    if (loginUser.getStudentNo() != qna.getStudentNo()) {
		        return "redirect:/qna/qnaList";
		    }
			model.addAttribute("qna", qna);
			return "qna/updateQna";
		}
		
		@PostMapping("/updateQna")
		public String updateQna(@ModelAttribute QnaDTO qnaDto) {
			qnaService.updateQna(qnaDto);
			return "redirect:/qna/qnaOne?qnaId=" + qnaDto.getQnaId();// 상세보기로 리다이렉트
		}
		
		
		// 삭제
		@PostMapping("/deleteQna")
		public String deleteQna(@ModelAttribute QnaDTO qnaDto,
		                        @RequestParam String pw,
		                        @RequestParam int qnaId,
		                        HttpSession session,
		                        RedirectAttributes ra) {

		    // 로그인한 관리자 세션 정보 가져오기
		    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

		    // 로그인 안 되어 있으면 로그인 페이지로
		    if (loginUser == null || loginUser.getStudentId() == null && loginUser.getAdminId() == null) {
		        ra.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
		        return "redirect:/login";
		    }
		    
		   // 1. DB에서 로그인한 학생의 암호화된 비밀번호 가져오기
		    String dbPw = mypageService.getStudentPasswordById(loginUser.getStudentId());

		    // 입력한 비밀번호와 비교
		    if (!passwordEncoder.matches(pw, dbPw)) {
		        ra.addFlashAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
		        return "redirect:/qna/qnaOne?qnaId=" + qnaId;
		    }
		    System.out.println("삭제 시도 qnaId = " + qnaDto.getQnaId());
		    
		    // 5. 삭제할 QnA 정보 준비
		    qnaDto.setQnaId(qnaId);

		    // 6. QnA 삭제 (→ 내부에서 댓글 먼저 삭제함)
		    int result = qnaService.deleteQna(qnaDto);

		    // 7. 결과에 따라 메시지 전달
		    if (result > 0) {
		        ra.addFlashAttribute("msg", "삭제되었습니다.");
		    } else {
		        ra.addFlashAttribute("errorMsg", "삭제에 실패했습니다.");
		    }

		    return "redirect:/qna/qnaList";
		}
	
}

















