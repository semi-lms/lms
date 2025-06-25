 <%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">
    <title>강의 일정</title>
 
  <script>
    const courseId = '${courseId}';
    const isTeacher = '${sessionScope.loginUser.role}' === 'teacher';

    function prevMonth() {
        let y = ${year}, m = ${month} - 1;
        if (m < 1) { y--; m = 12; }
        location.href = '/lectureSchedule?courseId=' + courseId + '&year=' + y + '&month=' + m;
    }

    function nextMonth() {
        let y = ${year}, m = ${month} + 1;
        if (m > 12) { y++; m = 1; }
        location.href = '/lectureSchedule?courseId=' + courseId + '&year=' + y + '&month=' + m;
    }

    function goToForm(dateNo) {
        if (!isTeacher) return;  // teacher가 아니면 아무 동작도 하지 않음
        location.href = '/lectureSchedule/lectureScheduleForm?courseId=' + courseId + '&dateNo=' + dateNo;
    }

    function deleteMemo(event, dateNo) {
        event.stopPropagation();
        if (!isTeacher) return;
        if (!confirm('정말 삭제하시겠습니까?')) return;
        fetch('/lectureSchedule/delete?dateNo=' + dateNo + '&courseId=' + courseId, { method: 'POST' })
            .then(res => {
                if (res.ok) {
                    alert('삭제 되었습니다');
                    location.reload();
                } else {
                    alert('삭제 실패하였습니다');
                }
            });
    }
</script>

</head>
<body>
<c:choose>
  <c:when test="${loginUser.role == 'teacher'}">
    <jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
  </c:when>
  <c:when test="${loginUser.role == 'student'}">
    <jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
  </c:when>
</c:choose>
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

                               <c:forEach var="memoDto" items="${dateToMemoList[day.dateStr]}">
    <div class="memo"
         <c:if test="${loginUser.role == 'teacher'}">
             onclick="goToForm(${memoDto.dateNo})" style="cursor: pointer;"
         </c:if>>
        ${memoDto.memo}

        <c:if test="${loginUser.role == 'teacher'}">
            <button class="delete-btn" onclick="deleteMemo(event, ${memoDto.dateNo})">삭제</button>
        </c:if>
    </div>
</c:forEach>

                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
	
					
      
         <c:if test="${loginUser.role == 'teacher'}">
    <button class="register-button" onclick="location.href='/lectureSchedule/lectureScheduleForm?courseId=${courseId}'">➕ 일정 등록</button>
</c:if>
   
    </div>
</body>
</html>
