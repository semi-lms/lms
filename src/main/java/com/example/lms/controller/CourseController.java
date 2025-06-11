package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.service.impl.CourseServiceImpl;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CourseController {
	@Autowired CourseServiceImpl course;
	
	
	@GetMapping("/admin/courseList")
	public String courseList(Model model
							,@RequestParam(value="searchCourseOption", required=false, defaultValue="") String searchCourseOption
							,@RequestParam(value="searchCourse", required=false, defaultValue="") String searchCourse) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("searchCourseOption", searchCourseOption);
	    param.put("searchCourse", searchCourse);
		List<CourseDTO> list = course.selectCourseList(param);
	    model.addAttribute("courseList", list);
	    log.info("searchCourseOption : "+searchCourseOption);
	    log.info("searchCourse : "+searchCourse);
	    return "/admin/courseList";
	}
	
	@GetMapping("/admin/insertCourse")
	public String insertCourse(Model model) {
		List<TeacherDTO> teacherList = course.selectTeacherList();
		List<ClassDTO> classList = course.selectClassList();
		model.addAttribute("teacher", teacherList);
		model.addAttribute("class", classList);
		return "/admin/insertCourse";
	}
	
	@PostMapping("/admin/insertCourse")
	public String insertCourse(CourseDTO courseDto) {
		course.insertCourse(courseDto);
		return "redirect:/admin/courseList";
	}
}
