package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.FileBoardDTO;
import com.example.lms.dto.NoticeDTO;
import com.example.lms.dto.QnaDTO;
import com.example.lms.service.AttendanceService;
import com.example.lms.service.FileBoardService;
import com.example.lms.service.NoticeService;
import com.example.lms.service.QnaService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping({ "/", "/main" })
public class MainController {

	@Autowired private NoticeService noticeService;
	@Autowired private QnaService qnaService;
	@Autowired private FileBoardService fileBoardService;
	@Autowired private AttendanceService attendanceService;
	
	@GetMapping
	public String main(Model model) {
		// 푸터용 리스트 데이터
        // 공지사항 5개만 가져오기
        List<NoticeDTO> noticeList = noticeService.selectLatestNotices(5);
        model.addAttribute("noticeList", noticeList);
        
        // qna 5개만 가져오기
        List<QnaDTO> qnaList = qnaService.selectLatestQna(5);
        model.addAttribute("qnaList", qnaList);
        
        // 자료실 5개만 가져오기
        List<FileBoardDTO> fileBoardList = fileBoardService.selectLatestFileBoard(5);
        model.addAttribute("fileBoardList", fileBoardList);
        
        
        // 오늘의 출석 통계 (관리자)
        List<AttendanceDTO> list = attendanceService.getTodayAttendance();
        model.addAttribute("list", list);
        
        return "main";
	}
		
}
