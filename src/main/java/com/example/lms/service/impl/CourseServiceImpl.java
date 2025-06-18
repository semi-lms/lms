package com.example.lms.service.impl;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;
import com.example.lms.mapper.CourseMapper;
import com.example.lms.service.CourseService;

@Service
public class CourseServiceImpl implements CourseService{

	@Autowired
	private CourseMapper courseMapper;
	
	@Override
	public List<CourseDTO> selectCourseList(Map<String, Object> param) {
		
		return courseMapper.selectCourseList(param);
	}
	
	@Override
	public int insertCourse(CourseDTO courseDto) {
		
		return courseMapper.insertCourse(courseDto);
	}
	
	@Override
	public List<TeacherDTO> selectTeacherList() {

		return courseMapper.selectTeacherList();
	}
	
	@Override
	public List<ClassDTO> selectClassList() {

		return courseMapper.selectClassList();
	}
	
	@Override
	public ClassDTO selectClassByNo(int classNo) {
		
		return courseMapper.selectClassByNo(classNo);
	}
	
	@Override
	public int getTotalCount(String searchOption, String keyword) {

		return courseMapper.getTotalCount(searchOption, keyword);
	}
	
	// 강사별 강의리스트
	@Override
	public List<CourseDTO> getCourseListByTeacherNo(Map<String, Object> params) {
		return courseMapper.selectCourseListByTeacherNo(params);
	}
	// 페이징
	@Override
	public int getCountCourseListByTeacherNo(int teacherNo, String filter) {
		return courseMapper.getCountCourseListByTeacherNo(teacherNo, filter);
	}
	
	@Override
	public List<CourseDTO> selectCourseListNotEnded(String now) {

		return courseMapper.selectCourseListNotEnded(now);
	}

	@Override
	public CourseDTO getCourseOne(int courseId) {

		return courseMapper.getCourseOne(courseId);
	}

	@Override
	public int updateCourse(CourseDTO dto) {

		return courseMapper.updateCourse(dto);
	}

	@Override
	public int deleteCourses(List<Integer> courseIds) {
		// TODO Auto-generated method stub
		return courseMapper.deleteCourses(courseIds);
	}

	@Override
	public int getOverlapCount(int classNo, LocalDate localDate, LocalDate localDate2) {
	    return courseMapper.getOverlapCount(classNo, localDate, localDate2);
	}

	@Override
	public List<CourseDTO> getCourseNameNotEnded() {
		return courseMapper.getCourseNameNotEnded();
	}
}
