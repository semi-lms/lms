package com.example.lms.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.ExamDTO;
import com.example.lms.dto.ExamSubmissionDTO;
import com.example.lms.dto.StudentDTO;
import com.example.lms.service.CourseService;
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
	@Autowired
	private CourseService courseService;
	
	// 강의 리스트
	@GetMapping("/courseListFromTeacher")
	public String courseListFromTeacher(@RequestParam(name = "teacherNo", required = false, defaultValue = "7") int teacherNo
										, @RequestParam(defaultValue = "1") int currentPage
										, @RequestParam(defaultValue = "10") int rowPerPage
										, @RequestParam(value = "filter", required = false, defaultValue = "전체") String filter
										, Model model) {
		// 페이징
		int totalCnt = courseService.getCountCourseListByTeacherNo(teacherNo, filter);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		// 조회
		Map<String, Object> courseMap = new HashMap<>();
	    courseMap.put("teacherNo", teacherNo);
	    courseMap.put("filter", filter);
	    courseMap.put("startRow", startRow);
	    courseMap.put("rowPerPage", rowPerPage);
		
	    List<CourseDTO> courses = courseService.getCourseListByTeacherNo(courseMap);
	    
	    model.addAttribute("courses", courses);
	    model.addAttribute("teacherNo", teacherNo);
	    model.addAttribute("filter", filter);
	    model.addAttribute("currentPage", currentPage);
	    model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
	    
		return "teacher/courseListFromTeacher";
	}
	
	// 학생 리스트
	@GetMapping("/studentListFromTeacher")
	public String studentListFromTeacher(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
										, @RequestParam(defaultValue = "1") int currentPage
										, @RequestParam(defaultValue = "10") int rowPerPage
										, Model model) {
		// 페이징
		int totalCnt = studentService.getStudentCntByCourseId(courseId);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		// 조회
		Map<String, Object> studentMap = new HashMap<>();
		studentMap.put("courseId", courseId);
		studentMap.put("startRow", startRow);
		studentMap.put("rowPerPage", rowPerPage);
		
		List<StudentDTO> students = studentService.getStudentListByCourseId(studentMap);
		
		model.addAttribute("students", students);
		model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("courseId", courseId);
		
		return "teacher/studentListFromTeacher";
	}
	
	// 성적 리스트
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
	
	// 시험 리스트
	@GetMapping("/examList")
	public String examList(@RequestParam(name = "courseId", required = false, defaultValue = "1") int courseId
							, @RequestParam(defaultValue = "1") int currentPage
							, @RequestParam(defaultValue = "10") int rowPerPage
							, Model model) {
		
		// 페이징
		int totalCnt = examService.getExamCnt(courseId);
		int lastPage = totalCnt / rowPerPage;
		if(totalCnt % rowPerPage != 0) {
			lastPage += 1;
		};
		int startRow = (currentPage - 1) * rowPerPage;
		int startPage = ((currentPage-1) / rowPerPage) * rowPerPage + 1;
		int endPage = startPage + rowPerPage -1;
		if(endPage >lastPage) {
			endPage = lastPage;
		};
		
		Map<String, Object> examMap = new HashMap<>();
		examMap.put("courseId", courseId);
		examMap.put("startRow", startRow);
		examMap.put("rowPerPage", rowPerPage);
		
		// 리스트 조회
		List<ExamDTO> exams = examService.getExamList(examMap);
		
		// 진행도 표시
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
		model.addAttribute("startPage", startPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("courseId", courseId);
		
		return "teacher/examList";
		}
	
	@PostMapping("/updateExam")
	public String updateExam(@ModelAttribute ExamDTO examDto) {
		examService.modifyExam(examDto);
		return "redirect:/examList";
	}
	
	@PostMapping("/removeExam")
	public String removeExam(@RequestParam("examId") int examId) {
		examService.removeExam(examId);
		return "redirect:/examList";
	}
	
	@PostMapping("/insertExam")
	public String insertExam(@ModelAttribute ExamDTO examDto) {
		examService.addExam(examDto);
		return "redirect:/examList";
	}
	
	
}
