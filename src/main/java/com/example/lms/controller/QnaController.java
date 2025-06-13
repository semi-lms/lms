package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.Page;
import com.example.lms.dto.QnaDTO;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.service.QnaService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/qna")
public class QnaController {
		@Autowired
		private QnaService qnaService;
		
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
			
			qnaDto.setStudentNo(loginUser.getStudentNo());		// 작성자를 qna 객체에 세팅함
			
			qnaService.insertQna(qnaDto);		// 작성된 공지사항을 DB에 저장 요청
			
			return "redirect:/qna/qnaList";		// 작성 후 리다이렉트로 qna리스트로
		}
		
		// 상세보기
		@GetMapping("/qnaOne")
		public String qnaOne(@RequestParam("qnaId") int qnaId, Model model) {
			
			// DB에서 qnaId와 일치하는 행을 조회하여 DTO에 담아 반환
			QnaDTO qnaDto = qnaService.selectQnaOne(qnaId);
			
			model.addAttribute("qna", qnaDto);
			
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
		    if (!loginUser.getStudentId().equals(qna.getStudentName())) {
		        return "qna/qnaList";
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
		public String deleteQna(@RequestParam("qnaId") int qnaId) {
			// 파라미터로 전달된 noticeId 값을 받아 int 타입 변수에 저장
			
			// noticeService를 호출해서 해당 Id의 공지사항을 삭제함
			qnaService.deleteQna(qnaId);
			
			// 삭제 완료 후 공지사항리스트로 이동
			return "redirect:/qna/qnaList";
		}
	
}

















