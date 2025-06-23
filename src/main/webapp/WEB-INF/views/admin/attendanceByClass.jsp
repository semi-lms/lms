<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출결 관리</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
/* ===== 기본 레이아웃 ===== */
.container {
  display: flex;
  min-height: 100vh;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f4f6f9;
}
.main-content {
  margin-left: 300px;
  flex-grow: 1;
  padding: 30px;
  background-color: #fafbfc;
  overflow-x: auto;
}

/* ===== 테이블 공통 ===== */
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  background-color: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  font-size: 14px;
}
th, td {
  border: 1px solid #ddd;
  text-align: center;
  padding: 10px;
  color: #333;
  white-space: nowrap;
  word-break: keep-all;
}
th {
  background-color: #2c3e50;
  color: white;
  font-weight: bold;
}
tr:nth-child(even) {
  background-color: #f9f9f9;
}
tr:hover {
  background-color: #e9f0ff;
}

/* ===== 휴일 텍스트 ===== */
.holiday {
  color: red;
  font-weight: bold;
}
</style>
</head>
<body>
<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
    <h1>${year}년 ${month}월</h1>
    <div>
      <a href="?courseId=${courseId}&year=${prevYear}&month=${prevMonth}">이전달</a>
      <span style="font-weight:bold;">${year}년 ${month}월</span>
      <a href="?courseId=${courseId}&year=${nextYear}&month=${nextMonth}">다음달</a>
    </div>
    <table>
      <thead>
        <tr>
          <th>반</th>
          <th>이름</th>
          <c:forEach var="date" items="${dayList}">
            <c:set var="isHoliday" value="false"/>
            <c:forEach var="hol" items="${holidays}">
              <c:if test="${date eq hol}">
                <c:set var="isHoliday" value="true"/>
              </c:if>
            </c:forEach>
            <th>
              <span><c:out value="${fn:substring(date, 8, 10)}"/></span><br>
              <span class="day-text${isHoliday ? ' holiday' : ''}" data-date="${date}"></span>
            </th>
          </c:forEach>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="student" items="${studentList}">
          <tr>
            <td>${student.classroom}</td>
            <td>${student.name}</td>
            <c:forEach var="date" items="${dayList}">
              <td>
                <c:choose>
                  <c:when test="${attendanceMap[student.studentNo][date] eq '출석'}">✔️</c:when>
                  <c:when test="${attendanceMap[student.studentNo][date] eq '지각'}">지각</c:when>
                  <c:when test="${attendanceMap[student.studentNo][date] eq '결석'}">❌</c:when>
                  <c:when test="${attendanceMap[student.studentNo][date] eq '조퇴'}">조퇴</c:when>
                  <c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '공결'}">
					<span style="color: ${file != null ? 'blue' : 'red'};">공결</span>
				  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
            </c:forEach>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>
<script>
  document.querySelectorAll("span.day-text").forEach(function(span) {
    var dateStr = span.getAttribute('data-date');
    var dateObj = new Date(dateStr);
    var weekDay = ["일", "월", "화", "수", "목", "금", "토"][dateObj.getDay()];
    span.textContent = weekDay;
    if (weekDay === "일" || weekDay === "토") {
      span.classList.add("holiday");
    }
  });
</script>
</body>
</html>
