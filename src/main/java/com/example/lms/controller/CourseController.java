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
							,@RequestParam(defaultValue = "5") int rowPerPage
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
		List<TeacherDTO> teacherList = course.selectTeacherList();
		List<ClassDTO> classList = course.selectClassList();
		model.addAttribute("teacherList", teacherList);
		model.addAttribute("classList", classList);
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
		List<ClassDTO> classList = course.selectClassList();
		model.addAttribute("teacherList", teacherList);
		model.addAttribute("classList", classList);
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
	@ResponseBody
	public String insertCourse(CourseDTO courseDto) {
	    int overlapCount = course.getOverlapCount(courseDto.getClassNo(), courseDto.getStartDate(), courseDto.getEndDate());
	    if (overlapCount > 0) {
	        return "overlap";
	    }
	    course.insertCourse(courseDto);
	    int courseId = courseDto.getCourseId();
	    int teacherNo = courseDto.getTeacherNo();
	    int result = course.updateTeacherCourseId(teacherNo, courseId);
	    if(result == 0) {
	        return "fail";
	    }
	    return "success";
	}
	
	// 강의 수정 관련 정보 가져오기
	@GetMapping("/admin/getCourseDetail")
	@ResponseBody
	public CourseDTO getCourseDetail(@RequestParam int courseId) {
	    return course.getCourseOne(courseId);
	}

	@PostMapping("/admin/updateCourse")
	@ResponseBody
	public String updateCourse(CourseDTO dto) {
	    // 1. 겹치는 강의실 체크 (본인 courseId는 제외)
	    int overlapCount = course.getOverlapCount(dto.getClassNo(), dto.getStartDate(), dto.getEndDate(), dto.getCourseId());
	    if (overlapCount > 0) {
	        return "overlap"; // 프론트에서 alert 띄우면 됨
	    }
	    // 2. 기존 담당 강사 정보 가져오기 (수정 전)
	    CourseDTO prev = course.getCourseOne(dto.getCourseId());

	    // 3. course 테이블 수정
	    course.updateCourse(dto);

	    Integer prevTeacherNo = prev != null ? prev.getTeacherNo() : null;
	    Integer newTeacherNo = dto.getTeacherNo();

	    if (prevTeacherNo != null && !prevTeacherNo.equals(newTeacherNo)) {
	        // 이전 강사에게 담당 강의 해제
	        course.updateTeacherCourseId(prevTeacherNo, null);
	    }
	    if (newTeacherNo != null) {
	        // 새 강사에게 담당 강의 설정
	        course.updateTeacherCourseId(newTeacherNo, dto.getCourseId());
	    }

	    return "success";
	}
	
	// 강의 삭제
	@PostMapping("/admin/deleteCourses")
	@ResponseBody
	public int deleteCourses(@RequestParam("courseIds") List<Integer> courseIds) {
	    return course.deleteCourses(courseIds);
	}
	
    @GetMapping("/admin/selectClassListForUpdate")
    public List<ClassDTO> selectClassListForUpdate(@RequestParam int courseId
									             ,@RequestParam String startDate
									             ,@RequestParam String endDate
									             ,@RequestParam int originalClassNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("courseId", courseId);
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("originalClassNo", originalClassNo);
        return course.selectClassListForUpdate(param);
    }
}
