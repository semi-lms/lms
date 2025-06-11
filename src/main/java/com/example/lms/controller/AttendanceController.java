package com.example.lms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.lms.service.impl.AttendanceServiceImpl;

@Controller
public class AttendanceController {
	@Autowired AttendanceServiceImpl attendanceService;
	
	@GetMapping("/admin/attendanceStatistics")
	public String getAttendanceStatistics(Model model) {
	    String startDate = "2025-06-01";
	    String endDate = "2025-07-01";
	    int attendanceCount = attendanceService.getAttendanceCount();
	    int studentCount = attendanceService.getStudentCount();  // ← 학생 수 구하는 메서드 추가 필요

	    int attendanceTotalCount = attendanceService.getAttendanceTotalCount(startDate, endDate, studentCount);
	    int actual = attendanceService.getActualAttendance(startDate, endDate);

	    model.addAttribute("attendanceTotalCount", attendanceTotalCount);
	    model.addAttribute("actual", actual);
	    model.addAttribute("attendanceCount", attendanceCount);

	    return "/admin/attendanceStatistics";
	}

}
