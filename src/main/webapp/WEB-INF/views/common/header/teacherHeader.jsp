<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">  
<div class="header">
<div class="logo-group" style="display: flex; align-items: center; gap: 10px;">
    <img src="https://cdn.imweb.me/thumbnail/20250617/0b0d09c937624.png" width="153" height="43" />
    <img src="/img/고용노동부.png" width="63" height="53" />
    <img src="/img/우수훈련기관.png" width="63" height="56" />
  </div>
  <div class="nav">
    	<a href="/">강의목록</a>
    	<a href="/">관리목록</a>
    	<a href="/lectureSchedule?=${loginuser.courseId }&year=2025&month=6">강의일정</a>
    	<a href="/notice/noticeList">공지사항</a>
		<a href="/qna/qnaList">QNA</a>
		<a href="file/fileBoard">자료실</a>
  </div>
</div>