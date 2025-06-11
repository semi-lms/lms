<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>강의 일정 등록/수정</title>
</head>
<body>
    <h2>강의 일정 등록/수정</h2>
	<p>디버그용: dateNo = ${schedule.dateNo}</p>
    <form action="/lectureSchedule/save" method="post">
      
        <input type="hidden" name="dateNo" value="${schedule.dateNo}" />

        <input type="hidden" name="courseId" value="${schedule.courseId}" />

        <label>시작 날짜: </label>
        <input type="date" name="startDate" value="${schedule.startDate}" required /><br/>

        <label>종료 날짜: </label>
        <input type="date" name="endDate" value="${schedule.endDate}" required /><br/>

        <label>메모: </label>
        <textarea name="memo" rows="3" cols="30">${schedule.memo}</textarea><br/>

        <button type="submit">저장</button>
    </form>

    <br/>
    <a href="/lectureSchedule?courseId=${courseId}&year=${year}&month=${month}">← 달력으로 돌아가기</a>
</body>
</html>
