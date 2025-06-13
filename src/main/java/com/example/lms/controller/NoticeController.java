package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
@RequestMapping("/mypage") // 내부 모든 url 앞에 "/mypage"가 붙음
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
		    Page page = new Page(rowPerPage, currentPage, totalCount, null, null, searchOption, keyword, null, null);
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
	        

	        return"mypage/noticeList";
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
