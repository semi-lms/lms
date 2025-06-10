<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <title>달력</title>
    <style>
        .calendar { border-collapse: collapse; width: 100%; }
        .calendar th, .calendar td { border: 1px solid #ccc; width: 14.28%; height: 80px; vertical-align: top; padding: 5px; }
        .sunday { color: red; }
        .saturday { color: blue; }
        .other-month { color: #999; }
        .memo { font-size: 10px; color: green; margin-top: 5px; }
        a { text-decoration: none; color: inherit; }
    </style>
</head>
<body>

<h2 style="text-align:center;">${year}년 ${month}월</h2>

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
                <c:forEach var="date" items="${week}">
                    <!-- 일(day) -->
                    <c:set var="day">
                        <fmt:formatDate value="${date}" pattern="d" />
                    </c:set>

                    <!-- 월(month) -->
                    <c:set var="dateMonth">
                        <fmt:formatDate value="${date}" pattern="M" />
                    </c:set>

                    <!-- 요일 (1=월 ~ 7=일) -->
                    <c:set var="dayOfWeek">
                        <fmt:formatDate value="${date}" pattern="u" />
                    </c:set>

                    <!-- 현재 달인지 -->
                    <c:set var="isCurrentMonth" value="${dateMonth == month}" />

                    <td class="${dayOfWeek == '7' ? 'sunday' : (dayOfWeek == '6' ? 'saturday' : '')} ${isCurrentMonth ? '' : 'other-month'}">
                        <a href="edit.jsp?date=${date.time}">${day}</a>
                        <c:if test="${dateToMemo[date] != null}">
                            <div class="memo">${dateToMemo[date]}</div>
                        </c:if>
                    </td>
                </c:forEach>
            </tr>
        </c:forEach>
    </tbody>
</table>

<c:if test="${not empty teacherId}">
    <div style="text-align:center; margin-top:20px;">
        <form action="register.jsp" method="get">
            <button type="submit">등록</button>
        </form>
    </div>
</c:if>

</body>
</html>
