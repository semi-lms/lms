<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>강의 일정</title>
   <style>
        body {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
        .calendar-container {
            margin-left: 240px;
            width: 70%;
            text-align: center;
        }
        .calendar {
            border-collapse: collapse;
            width: 100%;
            margin: 0 auto;
        }
 
        .calendar thead th {
            border: 1px solid #ccc;
            width: 13%;
            height: 40px;  
            font-size: 18px; 
            color: black;
            background-color: #f9f9f9;
            vertical-align: middle;
            padding: 5px;
        }
   
        .calendar tbody td {
            border: 1px solid #ccc;
            width: 13%;
            height: 130px;
            vertical-align: top;
            padding: 10px;
            font-size: 24px;
            color: black;
            position: relative;
        }
        .sunday { color: red !important; }
        .saturday { color: blue !important; }
        .other-month {
            color: #ccc;
            opacity: 0.5;
        }
        .memo {
            font-size: 16px;
            color: black;
            margin-top: 8px;
            word-break: break-word;
            padding: 4px 6px;
            border-radius: 4px;
            background-color: #f0f0f0;
            text-align: left;
            position: relative;
        }
        .memo:hover {
            background-color: #cce5ff;
            color: #004085;
        }
        .delete-btn {
            position: absolute;
            top: 2px;
            right: 2px;
            font-size: 12px;
            padding: 2px 5px;
            border: none;
            background-color: #ff6b6b;
            color: white;
            border-radius: 3px;
            cursor: pointer;
            display: none;
        }
        .memo:hover .delete-btn {
            display: inline-block;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        .header {
            font-size: 24px;
            font-weight: bold;
            color: black;
            margin-bottom: 10px;
        }
        .btn-month {
            font-size: 18px;
            padding: 5px 10px;
            margin: 0 10px;
            cursor: pointer;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 4px;
            color: black;
        }
        .btn-month:hover {
            background-color: #f0f0f0;
        }
        .month-nav {
            margin-bottom: 10px;
            text-align: center;
        }
        .register-button {
            margin-top: 20px;
            font-size: 18px;
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: white;
            color: black;
            cursor: pointer;
        }
        .register-button:hover {
            background-color: #eee;
        }
    </style>
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
        if (!confirm('정말 삭제할시겠습니까?')) return;
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
    <button class="register-button" onclick="location.href='/lectureSchedule/lectureScheduleForm?courseId=${courseId}'">일정 등록</button>
</c:if>
   
    </div>
</body>
</html>
