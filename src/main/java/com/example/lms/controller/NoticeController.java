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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.lms.dto.NoticeDTO;
import com.example.lms.dto.Page;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.mapper.NoticeMapper;
import com.example.lms.service.NoticeService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/notice") // 내부 모든 url 앞에 "/notice"가 붙음
public class NoticeController {
	@Autowired
	private NoticeService noticeService; 
	
	// 공지사항 리스트
	@GetMapping("/noticeList")
	   public String noticeList (Model model,
	            @RequestParam(defaultValue = "1") int currentPage,
	            @RequestParam(defaultValue = "title") String searchOption,
	            @RequestParam(defaultValue = "") String keyword,
	   			@RequestParam(defaultValue = "10") int rowPerPage) {
			
			int totalCount = noticeService.totalCount(searchOption, keyword);
		    Page page = new Page(rowPerPage, currentPage, totalCount, searchOption, keyword);
			int startRow = (currentPage - 1) * rowPerPage;
	        
	        Map<String, Object> param = new HashMap<>();
	        param.put("searchOption", searchOption);
	        param.put("keyword", keyword);
	        param.put("startRow", (currentPage - 1) * rowPerPage);
	        param.put("rowPerPage", rowPerPage);

	        List<NoticeDTO> noticeList = noticeService.selectNoticeList(param);

	        // 페이징 계산
	        int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);
	        int pageSize = 10;
	        int startPage = ((currentPage - 1) / pageSize) * pageSize + 1;
	        int endPage = Math.min(startPage + pageSize - 1, lastPage);
	        
	        
	        model.addAttribute("noticeList", noticeList);
	        model.addAttribute("currentPage", currentPage);
	        model.addAttribute("searchOption", searchOption);
	        model.addAttribute("keyword", keyword);
	        model.addAttribute("rowPerPage", rowPerPage);
	        model.addAttribute("startPage", startPage);
	        model.addAttribute("endPage", endPage);
	        model.addAttribute("lastPage", lastPage);
	        

	        return"notice/noticeList";
	    }
	
	// 작성
	@GetMapping("/insertNotice")
	public String insertNotice() {
		// 작성하는페이지로 이동
		// 제목, 내용 입력창
		return "notice/insertNotice";
	}
	
	@PostMapping("/insertNotice")
	public String insertNotice(NoticeDTO noticeDto, HttpSession session) {		
		
		SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");		// 현재 로그인한 사용자 정보를 세션에서 꺼냄
		
		noticeDto.setAdminId(loginUser.getAdminId());		// 작성자(admin)을 notice 객체에 세팅함
		
		noticeService.insertNotice(noticeDto);		// 작성된 공지사항을 DB에 저장 요청
		
		return "redirect:/notice/noticeList";		// 작성 후 리다이렉트로 공지사항리스트로
	}
	
	// 상세보기
	@GetMapping("/noticeOne")
	public String noticeOne(@RequestParam("noticeId") int noticeId, Model model) {
		
		// DB에서 noticeNo와 일치하는 행을 조회하여 DTO에 담아 반환
		NoticeDTO noticeDto = noticeService.selectNoticeOne(noticeId);
		
		model.addAttribute("notice", noticeDto);
		
		
		return"notice/noticeOne";
	}
	
	// 수정
	@GetMapping("/updateNotice")
	public String updateNotice(@RequestParam("noticeId") int noticeId, Model model) {
		// 기존 공지사항 정보 가져오기
		NoticeDTO notice = noticeService.selectNoticeOne(noticeId);
		model.addAttribute("notice", notice);
		return "notice/updateNotice";
	}
	
	@PostMapping("/updateNotice")
	public String updateNotice(@ModelAttribute NoticeDTO noticeDto) {
		noticeService.updateNotice(noticeDto); //수정 처리
		return "redirect:/notice/noticeOne?noticeId=" + noticeDto.getNoticeId(); // 상세보기로 리다이렉트
	}
	
	// 삭제
	@PostMapping("/deleteNotice")
	public String deleteNotice(@RequestParam("noticeId") int noticeId) {
		// 파라미터로 전달된 noticeId 값을 받아 int 타입 변수에 저장
		
		// noticeService를 호출해서 해당 Id의 공지사항을 삭제함
		noticeService.deleteNotice(noticeId);
		
		// 삭제 완료 후 공지사항리스트로 이동
		return "redirect:/notice/noticeList";
	}
}