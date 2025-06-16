<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    .holiday { color: red; font-weight: bold; }
</style>
</head>
<style>
  .container {
    display: flex;
    align-items: flex-start; /* 사이드바와 본문 위쪽 맞춤 */
    min-height: 100vh;
  }
  .sidebar {
    min-width: 220px; /* 사이드바 고정폭 */
    max-width: 260px;
    background: #fff; /* 사이드바 배경색 */
    border-right: 1px solid #ddd;
    z-index: 2;
    height: 100vh;
    position: sticky;
    top: 0;
  }
  .main-content {
    flex: 1;
    padding: 32px 24px 24px 300px; /* 좌우여백 */
    overflow-x: auto;
    background: #fafbfc;
  }
  table {
    background: #fff;
  }
</style>
<body>
<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
    <h1>
        ${year}년 ${month}월
    </h1>
    <div>
        <a href="?courseId=${courseId}&year=${prevYear}&month=${prevMonth}">이전달</a>
        <span style="font-weight:bold;">
            ${year}년 ${month}월
        </span>
        <a href="?courseId=${courseId}&year=${nextYear}&month=${nextMonth}">다음달</a>
    </div>
    <table border="1">
        <thead>
            <tr>
                <th>반</th>
                <th>이름</th>
                <!-- 각 날짜(일) 별로 테이블 헤더 생성 -->
                <c:forEach var="date" items="${dayList}">
                	<!-- 휴일 여부 체크 -->
                    <c:set var="isHoliday" value="false"/>
                    <c:forEach var="hol" items="${holidays}">
                        <c:if test="${date eq hol}">
                            <c:set var="isHoliday" value="true"/>
                        </c:if>
                    </c:forEach>
                    <th>
                    	<!-- 날짜(일)만 출력: yyyy-MM-dd에서 일만 추출 -->
                        <span><c:out value="${fn:substring(date, 8, 10)}"/></span><br>
                        <!-- 요일은 아래 JS에서 동적으로 표시, 휴일은 빨간색 표시 -->
                        <span class="day-text${isHoliday ? ' holiday' : ''}" data-date="${date}"></span>
                    </th>
                </c:forEach>
            </tr>
        </thead>
        <tbody>
        	<!-- 각 학생별 출석 현황 행 생성 -->
            <c:forEach var="student" items="${studentList}">
                <tr>
                    <td>${student.classroom}</td>
                    <td>${student.name}</td>
                    <c:forEach var="date" items="${dayList}">
                        <td>
                        	<!-- 출석 status 상태에 따라 이모티콘 표시 -->
                            <c:choose>
                                <c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '출석'}">●</c:when>
                                <c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '지각'}">△</c:when>
                                <c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '결석'}">✗</c:when>
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
<!-- 요일 정보 및 휴일(토/일) 표시용 -->
    document.querySelectorAll("span.day-text").forEach(function(span) {
        var dateStr = span.getAttribute('data-date'); // yyyy-MM-dd
        var dateObj = new Date(dateStr);
        var weekDay = ["일", "월", "화", "수", "목", "금", "토"][dateObj.getDay()];
        span.textContent = weekDay;
        if(weekDay === "일" || weekDay === "토") {
            span.classList.add("holiday");
        }
    });
</script>
</body>
</html>
