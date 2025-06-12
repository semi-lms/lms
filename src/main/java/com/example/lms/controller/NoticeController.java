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
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.mapper.NoticeMapper;
import com.example.lms.service.NoticeService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/mypage") // 내부 모든 url 앞에 "/mypage"가 붙음
public class NoticeController {
	@Autowired
	private NoticeService noticeService; 
	
	// 공지사항 리스트
	@GetMapping("/noticeList")
	   public Map<String, Object> ajaxNoticeList(
	            @RequestParam(defaultValue = "1") int page,
	            @RequestParam(defaultValue = "title") String searchOption,
	            @RequestParam(defaultValue = "") String keyword) {

	        int rowPerPage = 10;
	        int startRow = (page - 1) * rowPerPage;
	        int totalCount = noticeService.totalCount(searchOption, keyword);
	        int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);

	        Map<String, Object> param = new HashMap<>();
	        param.put("searchOption", searchOption);
	        param.put("keyword", keyword);
	        param.put("startRow", startRow);
	        param.put("rowPerPage", rowPerPage);

	        List<NoticeDTO> noticeList = noticeService.selectNoticeList(param);

	        Map<String, Object> result = new HashMap<>();
	        result.put("noticeList", noticeList);
	        result.put("currentPage", page);
	        result.put("lastPage", lastPage);
	        result.put("totalCount", totalCount);

	        return result;
	    }
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
