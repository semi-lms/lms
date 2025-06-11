<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>달력</title>
   <style>
    body {
        display: flex;
        justify-content: center;
        margin-top: 30px;
    }
    .calendar-container {
        width: 80%;
        text-align: center;
    }
    .calendar {
        border-collapse: collapse;
        width: 100%;
        margin: 0 auto;
    }
   .calendar th, .calendar td {
    border: 1px solid #ccc;
    width: 13%;
    height: 130px;
    vertical-align: top;
    padding: 10px;
    font-size: 24px;
    color: black; /* 기본 검정색 */
    cursor: pointer;
	}
	.sunday { color: red !important; }
	.saturday { color: blue !important; }
	.other-month { color: #999; }
	.memo {
	    font-size: 18px;
	    color: black;
	    margin-top: 8px;
	    word-break: break-word;
	}
    a {
        text-decoration: none;
        color: inherit;
    }
    .header {
        font-size: 24px;
        font-weight: bold;
        color: black;
        margin-bottom: 20px;
    }
    .btn-month {
        font-size: 18px;
        padding: 3px 6px;
        margin: 0 10px;
        cursor: pointer;
         background-color : white;
        border: 1px solid #ccc;
        border-radius: 4px;
        color: black;
    }
    .btn-month:hover {
        background-color: #ddd;
     
    }
    .month-nav {
        margin-bottom: 10px;
        text-align: center;
    }
</style>
 <script>
        var scheduleDates = [
            <c:forEach var="date" items="${dateToMemo.keySet()}" varStatus="status">
                '${date}'<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        function onDateClick(dateStr) {
            const isTeacher = ${not empty teacherId ? 'true' : 'false'};
            if (!isTeacher) {
                alert("강사만 등록/수정할 수 있어.");
                return;
            }
            const hasSchedule = scheduleDates.includes(dateStr);
            if (hasSchedule) {
                location.href = 'edit.jsp?date=' + new Date(dateStr).getTime();
            } else {
                location.href = 'registerSchedule.jsp?date=' + new Date(dateStr).getTime();
            }
        }

        function moveMonth(year, month) {
            // month는 1~12로 넘겨받음
            var courseId = ${courseId};
            var url = '/lectureSchedule?courseId=' + courseId + '&year=' + year + '&month=' + month;
            location.href = url;
        }

        function prevMonth() {
            let year = ${year};
            let month = ${month};
            month--;
            if (month < 1) {
                month = 12;
                year--;
            }
            moveMonth(year, month);
        }

        function nextMonth() {
            let year = ${year};
            let month = ${month};
            month++;
            if (month > 12) {
                month = 1;
                year++;
            }
            moveMonth(year, month);
        }
    </script>
<body>
<div class="calendar-container">

    <div class="month-nav">
        <button class="btn-month" onclick="prevMonth()">&lt; </button>
        <span class="header">${year}년 ${month}월</span>
        <button class="btn-month" onclick="nextMonth()"> &gt;</button>
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
                        <td class="<c:choose>
                                    <c:when test='${day.dayOfWeek == 1}'>sunday</c:when>
                                    <c:when test='${day.dayOfWeek == 7}'>saturday</c:when>
                                    <c:otherwise></c:otherwise>
                                  </c:choose> ${day.isCurrentMonth ? '' : 'other-month'}"
                            onclick="onDateClick('${day.dateStr}')">
                            <div>${day.day}</div>
                            <c:if test="${dateToMemo[day.dateStr] != null}">
                                <div class="memo">${dateToMemo[day.dateStr]}</div>
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
