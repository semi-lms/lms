<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">
    <title>강의 일정</title>
   
    <script>
    const studentId = '${studentId}'; 
    console.log('학생아이디' , ${studnentId})
	
        function prevMonth() {
            let y = ${year}, m = ${month} - 1;
            if (m < 1) { y--; m = 12; }
            location.href = '/student/myAttendance?studentId=' + studentId + '&year=' + y + '&month=' + m;
       
        }

        function nextMonth() {
            let y = ${year}, m = ${month} + 1;
            if (m > 12) { y++; m = 1; }
            location.href = '/student/myAttendance?studentId=' + studentId+ '&year=' + y + '&month=' + m;
        }

    </script>
</head>
<body>


    <div class="calendar-container">
    
        <div class="month-nav">
            <button class="btn-month" onclick="prevMonth()">&lt;</button>
            <span class="header">${year}년 ${month}월</span>
            <button class="btn-month" onclick="nextMonth()">&gt;</button>
        </div>

        <table class="calendar">
            <thead>
                <tr>
                    <th class="sunday">일</th>
                    <th>월</th>
                    <th>화</th>
                    <th>수</th>
                    <th>목</th>
                    <th>금</th>
                    <th class="saturday">토</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="week" items="${weeks}">
                    <tr>
                        <c:forEach var="day" items="${week.days}">
                           <td class="${day.dayOfWeek == 1 ? 'sunday' : day.dayOfWeek == 7 ? 'saturday' : ''} ${!day.isCurrentMonth ? 'other-month' : ''}">
    <div>${day.day}</div>

    <c:if test="${not empty attendanceMap[day.dateStr]}">
        <div class="memo">
            출석: ${attendanceMap[day.dateStr]}
        </div>
    </c:if>
</td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

 
    </div>
</body>
</html>
