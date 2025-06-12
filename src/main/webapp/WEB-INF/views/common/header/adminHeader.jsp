<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 관리자 상단헤더부분 -->
<div class="header">
  <div><img src="<c:url value='/img/logo.png'/>" width="50"> <strong>LMS</strong></div>
  <div class="nav">
    	<a href="/admin/academicSchedule">전체일정</a>
    	<a href="/admin/studentList">학생관리</a>
    	<a href="/admin/teacherList">강사관리</a>
    	<a href="/admin/courseList">강의관리</a>
    	<a href="/admin/attendanceStatistics">출석통계</a>
    	<a href="/notice">공지사항</a>
		<a href="/qna">QNA</a>
		<a href="/fileBoard">자료실</a>
  </div>
</div>