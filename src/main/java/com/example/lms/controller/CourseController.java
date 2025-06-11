package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.lms.dto.CourseDTO;
import com.example.lms.service.impl.CourseServiceImpl;

@Controller
public class CourseController {
	@Autowired CourseServiceImpl course;
	
	
	@GetMapping("/admin/courseList")
	public String courseList(CourseDTO courseDto, Model model) {
	    List<CourseDTO> list = course.selectCourseList(courseDto);
	    model.addAttribute("courseList", list);
	    return "/admin/courseList";
	}
	
	@GetMapping("/admin/insertCourse")
	public String insertCourse() {
		return "/admin/insertCourse";
	}
	
	@PostMapping("/admin/insertCourse")
	public String insertCourse(CourseDTO courseDto) {
		courseDto.setCourseName(courseDto);
		return "redirect:/admin/courseList";
	}
}
