<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">  
<div class="header">
   <div><img src="<c:url value='/img/logo.png'/>"width="80" height="80"> </div>
  <div class="nav">
    	<a href="/">강의목록</a>
    	<a href="/">관리목록</a>
    	<a href="/lectureSchedule?=${loginuser.courseId }&year=2025&month=6">강의일정</a>
    	<a href="/notice/noticeList">공지사항</a>
		<a href="/qna/qnaList">QNA</a>
		<a href="file/fileBoard">자료실</a>
  </div>
</div>