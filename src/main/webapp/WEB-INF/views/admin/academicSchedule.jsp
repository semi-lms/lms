<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar.css">
    <title>학원 일정</title>
 
  	<script>
	    function prevMonth() {
	        let y = ${year}, m = ${month} - 1;
	        if (m < 1) { y--; m = 12; }
	        location.href = '/admin/academicSchedule?year=' + y + '&month=' + m;
	    }
	
	    function nextMonth() {
	        let y = ${year}, m = ${month} + 1;
	        if (m > 12) { y++; m = 1; }
	        location.href = '/admin/academicSchedule?year=' + y + '&month=' + m;
	    }
	    
	    function openPopup() {
		    window.open(
		      '/admin/holidays/insertHolidayForm',  // 이동할 경로
		      'insertHoliday',                              // 팝업 이름(내부 식별용)
		      'width=500,height=300,left=100,top=100'       // 팝업창 크기 및 위치
		    );
		  }
    </script>
    
    <style>
	    .memo.holiday {
			background-color: #f08080;
		}
		
		.memo.clickable {
			cursor: pointer;
			text-decoration: underline;
		}
		
		.memo.disabled {
			opacity: 0.6;
			cursor: default;
		}
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
    <div class="calendar-container">
        <div class="month-nav">
            <button class="btn-month" onclick="prevMonth()">&lt;</button>
            <span class="header">${year}년 ${month}월</span>
            <button class="btn-month" onclick="nextMonth()">&gt;</button>
        </div>
        
        <!-- 휴강 등록 팝업 버튼 -->
	    <div style="text-align: right; margin-bottom: 5px;">
			<button onclick="openPopup()" class="register-button" style="margin-top: 0px;">
				+ 휴강 등록
			</button>
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

                               <c:forEach var="memoDto" items="${dateScheduleMap[day.dateStr]}">
                                   <c:choose>
                                   
                                       <%-- 휴강 --%>
                                       <c:when test="${memoDto.type eq '휴강'}">
                                           <div class="memo holiday clickable"
                                               onclick="location.href='${pageContext.request.contextPath}/admin/holidays/updateHolidayDate?date=${day.dateStr}'">
                                               ${memoDto.memo}
                                           </div>
                                       </c:when>
                                       
                                       <%-- 공휴일 --%>
                                       <c:when test="${memoDto.type eq '공휴일'}">
                                           <div class="memo holiday disabled">
                                               ${memoDto.memo}
                                           </div>
                                       </c:when>
                                       
                                       <%-- 개강/종강 --%>
                                       <c:otherwise>
	                                       <div class="memo">
		                                       ${memoDto.memo}
		                                   </div>
	                                   </c:otherwise>
	                                   
                                   </c:choose>
                               </c:forEach>
                               
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
