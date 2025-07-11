package com.example.lms.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.lms.dto.ClassDTO;
import com.example.lms.dto.CourseDTO;
import com.example.lms.dto.TeacherDTO;

@Mapper
public interface CourseMapper {
	List<CourseDTO> selectCourseList(Map<String, Object> param);

	int insertCourse(CourseDTO courseDto);

	List<TeacherDTO> selectTeacherList();
	
	List<ClassDTO> selectClassList();

	ClassDTO selectClassByNo(int classNo);

	int getTotalCount(String searchOption, String keyword);
	
	// 강사별 강의리스트
	List<CourseDTO> selectCourseListByTeacherNo(Map<String, Object> params);
	// 페이징
	int getCountCourseListByTeacherNo(int teacherNo, String filter);

	List<CourseDTO> selectCourseListNotEnded(String now);

	CourseDTO getCourseOne(int courseId);

	int updateCourse(CourseDTO dto);

	int deleteCourses(List<Integer> courseIds);

	// 등록용(3개)
	int getOverlapCount(@Param("classNo") int classNo, @Param("startDate") String startDate, @Param("endDate") String endDate);

	// 수정용(4개)
	int getOverlapCountForUpdate(@Param("classNo") int classNo, @Param("startDate") String startDate, @Param("endDate") String endDate, @Param("courseId") Integer courseId);
	
	// 강사 등록 시 선택할 강의명 조회
	List<CourseDTO> getCourseNameNotEnded();
	
	int updateTeacherCourseId(@Param("teacherNo") int teacherNo,
            @Param("courseId") Integer courseId);
	
	// course 테이블에서 해당 강사의 연결 해제
	void unassignTeacher(int teacherNo);
	
	// course 테이블에 강사 연결
	void assignTeacher(@Param("courseId") int courseId,
            @Param("teacherNo") int teacherNo);
	
	List<ClassDTO> selectClassListForUpdate(Map<String, Object> param);
}
