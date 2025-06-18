<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>강의 일정 등록/수정</title>
    <link rel="stylesheet" href="/css/lecture.css" />
</head>
<body>
    <div class="schedule-container">
        <h2>강의 일정 등록/수정</h2>


        <form action="/lectureSchedule/save" method="post">
            <input type="hidden" name="dateNo" value="${schedule.dateNo}" />
            <input type="hidden" name="courseId" value="${schedule.courseId}" />
			<input type="hidden" name="year" value="${year}" />        
 		   <input type="hidden" name="month" value="${month}" />      
            <div class="form-group">
                <label>시작 날짜</label>
                <input type="date" name="startDate" value="${schedule.startDate}" required />
            </div>

            <div class="form-group">
                <label>종료 날짜</label>
                <input type="date" name="endDate" value="${schedule.endDate}" required />
            </div>

            <div class="form-group">
                <label>메모</label>
                <textarea name="memo" rows="3" cols="30">${schedule.memo}</textarea>
            </div>

            <button type="submit">저장</button>
        </form>

        <div class="back-link">
            <a href="/lectureSchedule?courseId=${courseId}&year=${year}&month=${month}">← 달력으로 돌아가기</a>
        </div>
    </div>
</body>
</html>
