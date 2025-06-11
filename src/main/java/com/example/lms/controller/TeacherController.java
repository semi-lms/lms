package com.example.lms.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.service.ExamService;
import com.example.lms.service.StudentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TeacherController {
	@Autowired
	private StudentService studentService;
	@Autowired
	private ExamService examService;
	
	@GetMapping("/studentListFromTeacher")
	public String studentListFromTeacher(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
										, Model model) {
		List<StudentDTO> students = studentService.getStudentListByCourseId(courseId);
		model.addAttribute("students", students);
		return "teacher/studentListFromTeacher";
	}
	
	@GetMapping("/scoreList")
	public String scoreList(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
							, @RequestParam(name = "examId", required = false, defaultValue = "1") int examId
							, Model model) {
		Map<String, Object> scoreMap = new HashMap<>();
		scoreMap.put("courseId", courseId);
		scoreMap.put("examId", examId);
		
		log.info("map" + scoreMap.toString());
		List<ExamSubmissionDTO> scores = examService.getScoreList(scoreMap);
		model.addAttribute("scores", scores);
		return "teacher/scoreList";
	}
	
	@GetMapping("/examList")
	public String examList(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
							, Model model) {
		List<ExamDTO> exams = examService.getExamList(courseId);
		
		LocalDate today = LocalDate.now();

		for (ExamDTO exam : exams) {
		    if (today.isBefore(exam.getExamStartDate())) {
		        exam.setStatus("예정");
		    } else if (today.isAfter(exam.getExamEndDate())) {
		        exam.setStatus("완료");
		    } else {
		        exam.setStatus("진행중");
		    }
		}
		
		model.addAttribute("exams", exams);
		
		return "teacher/examList";
		}
}
