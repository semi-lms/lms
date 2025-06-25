<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
<!-- 관리자 상단헤더부분 -->
<div class="header">
<div class="logo-group" style="display: flex; align-items: center; gap: 10px;">
    <img src="/img/logo.png" width="240" height="140" />
    <img src="/img/고용노동부.png" width="63" height="53" />
    <img src="/img/우수훈련기관.png" width="63" height="56" />
  </div>
  <div class="nav">
    	<a href="/admin/academicSchedule">전체일정</a>
    	<a href="/admin/studentList">학생관리</a>
    	<a href="/admin/teacherList">강사관리</a>
    	<a href="/admin/courseList">강의관리</a>
    	<a href="/admin/attendanceStatistics">출석통계</a>
    	<a href="/notice/noticeList">공지사항</a>
		<a href="/qna/qnaList">QNA</a>
		<a href="/file/fileBoardList">자료실</a>
  </div>
</div>