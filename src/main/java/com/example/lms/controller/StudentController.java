package com.example.lms.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.example.lms.dto.AttendanceDTO;
import com.example.lms.dto.ExamAnswerDTO;
import com.example.lms.dto.ExamQuestionDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.service.AttendanceService;
import com.example.lms.service.ExamService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class StudentController {
	
	@Autowired 
	
	private AttendanceService attendanceService;
	private ExamService examService;
	 @InitBinder
	    public void initBinder(WebDataBinder binder) {
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        sdf.setLenient(false);
	        binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, true));
	    }
	 
	@GetMapping("/student/myAttendance")
	public String getMyAttendance(@RequestParam String studentId,
	                              @RequestParam(required = false) Integer year,
	                              @RequestParam(required = false) Integer month,
	                              HttpSession session,
	                              Model model) {

	    Calendar cal = Calendar.getInstance();
	    int displayYear = (year != null) ? year : cal.get(Calendar.YEAR);
	    int displayMonth = (month != null) ? month : cal.get(Calendar.MONTH) + 1;

	    cal.set(displayYear, displayMonth - 1, 1);
	    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
	    int startOffset = (firstDayOfWeek == Calendar.SUNDAY) ? 0 : firstDayOfWeek - 2;
	    if (startOffset < 0) startOffset = 6;
	    cal.add(Calendar.DATE, -startOffset);

	    List<Map<String, Object>> weeks = new ArrayList<>();

	    for (int w = 0; w < 6; w++) {
	        List<Map<String, Object>> days = new ArrayList<>();
	        boolean hasCurrentMonthDate = false;

	        for (int d = 0; d < 7; d++) {
	            Date date = cal.getTime();
	            Calendar tmpCal = Calendar.getInstance();
	            tmpCal.setTime(date);

	            int y = tmpCal.get(Calendar.YEAR);
	            int m = tmpCal.get(Calendar.MONTH) + 1;
	            int day = tmpCal.get(Calendar.DAY_OF_MONTH);

	            boolean isCurrentMonth = (m == displayMonth);
	            if (isCurrentMonth) hasCurrentMonthDate = true;

	            String dateStr = String.format("%04d-%02d-%02d", y, m, day);

	            Map<String, Object> dayMap = new HashMap<>();
	            dayMap.put("dateStr", dateStr);
	            dayMap.put("day", day);
	            dayMap.put("isCurrentMonth", isCurrentMonth);
	            dayMap.put("dayOfWeek", d + 1);
	            days.add(dayMap);

	            cal.add(Calendar.DATE, 1);
	        }

	        if (hasCurrentMonthDate) {
	            weeks.add(Map.of("days", days));
	        }
	    }

	    // 출석 정보 조회 후 날짜별로 매핑
	    List<AttendanceDTO> attendanceList = attendanceService.getAttendanceListByStudentId(studentId);
	    Map<String, String> attendanceMap = new HashMap<>();

	    for (AttendanceDTO dto : attendanceList) {
	        if (dto.getDate() != null && dto.getStatus() != null) {
	            String dateStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(dto.getDate());
	            attendanceMap.put(dateStr, dto.getStatus());
	        }
	    }

	    model.addAttribute("year", displayYear);
	    model.addAttribute("month", displayMonth);
	    model.addAttribute("weeks", weeks);
	    model.addAttribute("attendanceMap", attendanceMap);

	    return "student/myAttendance";
	}
	 // 문제 페이지 보여주기
    @GetMapping("/take")
    public String takeExam(@RequestParam int examId, @RequestParam int page, Model model) {
        List<ExamQuestionDTO> questions = examService.getQuestionsByPage(examId, page);
        model.addAttribute("questions", questions);
        model.addAttribute("examId", examId);
        model.addAttribute("page", page);
        return "exam/takeExam"; 
    }

    // 최종 제출 처리
    @PostMapping("/submit")
    public String submitExam(@ModelAttribute ExamSubmissionDTO submission,
                             @RequestParam List<ExamAnswerDTO> answers,
                             Model model) {
        int score = examService.submitExam(submission, answers);
        model.addAttribute("score", score);
        return "exam/submitResult";
    }
	
}
