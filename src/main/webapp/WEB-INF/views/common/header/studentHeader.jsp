<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy" var="currentYear" />
<fmt:formatDate value="${now}" pattern="M" var="currentMonth" />
<div class="header">
 <div><img src="<c:url value='/img/logo.png'/>" width="50"> <strong>LMS</strong></div>
 

  <div class="nav">
    <a href="/student/myAttendance?studentId=${loginUser.studentNo}&year=${currentYear}&month=${currentMonth}">출석현황</a>
    	<a href="/">수강과목</a>
    	<a href="/examList?courseId=${loginUser.courseId }">시험문제</a>
    	<a href="/lectureSchedule?courseId=${loginUser.courseId}&year=${currentYear}&month=${currentMonth}">강의일정</a>
    	<a href="/notice/noticeList">공지사항</a>
		<a href="/qna">QNA</a>
		<a href="/fileBoard">자료실</a>
  </div>
</div>