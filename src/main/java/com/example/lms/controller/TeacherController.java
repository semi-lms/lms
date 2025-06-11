package com.example.lms.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.StudentDTO;
import com.example.lms.service.StudentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TeacherController {
	@Autowired
	private StudentService studentService;
	
	@GetMapping("/studentListFromTeacher")
	public String studentListFromTeacher(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
										, Model model) {
		List<StudentDTO> students = studentService.getStudentListByCourseId(courseId);
		model.addAttribute("students", students);
		return "teacher/studentListFromTeacher";
	}
}
