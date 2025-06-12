package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.lms.dto.AcademicScheduleDTO;
import com.example.lms.service.impl.AcademicScheduleServiceImpl;

@Controller
public class AcademicScheduleController {
	@Autowired AcademicScheduleServiceImpl academicScheduleService;
	
	@GetMapping("/admin/academicSchedule")
	public String academicSchedule(Model model) {
		List<AcademicScheduleDTO> list = academicScheduleService.getAcademicSchedules();
		model.addAttribute("list", list);
		return "/admin/academicSchedule";
	}
}
