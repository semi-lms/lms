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
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.Page;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.service.impl.CourseServiceImpl;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CourseController {
	@Autowired CourseServiceImpl course;
	
	
	@GetMapping("/admin/courseList")
	public String courseList(Model model
							,@RequestParam(defaultValue = "1") int currentPage
							,@RequestParam(defaultValue = "10") int rowPerPage
							,@RequestParam(value="searchOption", required=false, defaultValue="all") String searchOption
							,@RequestParam(value="keyword", required=false, defaultValue="") String keyword) {
	    int totalCount = course.getTotalCount(searchOption, keyword);
	    Page page = new Page(rowPerPage, currentPage, totalCount, searchOption, keyword);
		
	    int pageSize = 5;
	    int startPage = ((currentPage-1) / pageSize) * pageSize + 1;
	    int endPage = startPage + pageSize -1;
	    if(endPage > page.getLastPage()) {
	    	endPage = page.getLastPage();
	    }
	    int startRow = (currentPage - 1) * rowPerPage;
	    
		Map<String, Object> param = new HashMap<>();
	    param.put("searchOption", searchOption);
	    param.put("keyword", keyword);
	    param.put("startRow", startRow);      // ★추가
	    param.put("rowPerPage", rowPerPage);  // ★추가
	    
		List<CourseDTO> list = course.selectCourseList(param);
	    model.addAttribute("courseList", list);
	    model.addAttribute("page", page);
	    model.addAttribute("searchCourse", keyword);
	    model.addAttribute("searchCourseOption", searchOption);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    log.info("searchCourseOption : "+searchOption);
	    log.info("searchCourse : "+keyword);
	    return "/admin/courseList";
	}
	
	@GetMapping("/admin/insertCourse")
	public String insertCourse(Model model) {
		List<TeacherDTO> teacherList = course.selectTeacherList();
		for (TeacherDTO t : teacherList) {
		    System.out.println("teacherNo: " + t.getTeacherNo() + ", name: " + t.getName());
		}
		List<ClassDTO> classList = course.selectClassList();
		model.addAttribute("teacherList", teacherList);
		model.addAttribute("classList", classList);
		System.out.println("class테스트"+classList);
		return "/admin/insertCourse";
	}
	
	@GetMapping("/admin/getMaxPerson")
	@ResponseBody
	public int getMaxPerson(@RequestParam("classNo") int classNo) {
	    ClassDTO classDto = course.selectClassByNo(classNo);
	    if (classDto == null) return 0;
	    return classDto.getMaxPerson();
	}
	
	
	@PostMapping("/admin/insertCourse")
	public String insertCourse(CourseDTO courseDto) {
		course.insertCourse(courseDto);
	    System.out.println("넘어온 teacherNo = " + courseDto.getTeacherNo());
		return "redirect:/admin/courseList";
	}
}
