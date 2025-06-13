package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
	}