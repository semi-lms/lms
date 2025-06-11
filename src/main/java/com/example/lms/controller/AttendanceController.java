package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.lms.dto.AttendanceDTO;
import com.example.lms.service.AttendanceService;

@Controller
@RequestMapping("/admin")
public class AttendanceController {
	@Autowired AttendanceService attendanceService;
	
	@GetMapping("/attendance")
	public String getTodayAttendance(Model model) {
		List<AttendanceDTO> list = attendanceService.getTodayAttendance();
		model.addAttribute("list", list);
		return "admin/attendance";
	}
}
