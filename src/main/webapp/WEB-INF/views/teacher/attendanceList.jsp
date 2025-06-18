<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출결관리</title>
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
		table-layout: fixed
	}
</style>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
		</div>
		<div class="main-content">
			<!-- 공통 페이지 상단 메뉴 -->
			<div style="margin-bottom: 20px;">
				<c:set var="currentPath" value="${pageContext.request.requestURI}" />

				<a href="/attendanceList?courseId=${courseId}" 
					style="padding: 8px 16px; 
						margin-right: 10px; 
						border-radius: 6px; 
						text-decoration: none; 
						font-weight: bold;
					<c:if test='${fn:contains(currentPath, "/attendanceList")}'>background-color: #cce5ff; color: #004085;</c:if>
					<c:if test='${!fn:contains(currentPath, "/attendanceList")}'>background-color: #e9ecef; color: #333;</c:if>">
					출결 관리
				</a>

				<a href="/studentListFromTeacher?courseId=${courseId}" 
					style="padding: 8px 16px; 
					   margin-right: 10px; 
					   border-radius: 6px; 
					   text-decoration: none; 
					   font-weight: bold;
					<c:if test='${fn:contains(currentPath, "/studentListFromTeacher")}'>background-color: #cce5ff; color: #004085;</c:if>
					<c:if test='${!fn:contains(currentPath, "/studentListFromTeacher")}'>background-color: #e9ecef; color: #333;</c:if>">
					학생 관리
				</a>

				<a href="/examList?courseId=${courseId}" 
					style="padding: 8px 16px; 
						border-radius: 6px; 
						text-decoration: none; 
						font-weight: bold;
					<c:if test='${fn:contains(currentPath, "/examList")}'>background-color: #cce5ff; color: #004085;</c:if>
					<c:if test='${!fn:contains(currentPath, "/examList")}'>background-color: #e9ecef; color: #333;</c:if>">
					시험 관리
				</a>
			</div>
		
			<h1>${year}년 ${month}월</h1>
			<div>
				<form method="post" action="insertAttendanceAll" onsubmit="return confirmInsert();">
					금일 전체 학생 
					<select name="status" id="bulkStatus">
						<option value="출석">출석</option>
						<option value="결석">결석</option>
					</select>
					<input type="hidden" name="courseId" value="${courseId}">
					<button type="submit">입력</button>
				</form>
			</div>
			<div>
				<!-- 이전달, 다음달 조건을 넣기위한 변수 지정 -->
				<c:set var="courseStartKey" value="${fn:substring(fn:replace(courseStartDate, '-', ''), 0, 6)}" />
				<c:set var="courseEndKey" value="${fn:substring(fn:replace(courseEndDate, '-', ''), 0, 6)}" />
				<c:set var="prevDateKey" value="${prevYear}${prevMonth lt 10 ? '0' : ''}${prevMonth}" />
				<c:set var="nextDateKey" value="${nextYear}${nextMonth lt 10 ? '0' : ''}${nextMonth}" />
				
				<c:if test="${prevDateKey >= courseStartKey}">
					<a href="?courseId=${courseId}&year=${prevYear}&month=${prevMonth}">이전달</a>
				</c:if>
				<span style="font-weight:bold;">${year}년 ${month}월</span>
				<c:if test="${nextDateKey <= courseEndKey}">
					<a href="?courseId=${courseId}&year=${nextYear}&month=${nextMonth}">다음달</a>
				</c:if>
			</div>
			<table border="1">
				<thead>
					<tr>
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
				<!-- 각 학생별 출석 현황 행(row) 생성 -->
					<c:forEach var="student" items="${studentList}">
						<tr>
							<td>${student.name}</td>
							<c:forEach var="date" items="${dayList}">
								<td class="attendance-cell"
									data-student-no="${student.studentNo}" 
									data-date="${date}" 
									data-status="${attendanceMap[student.studentNo][date]}" 
									data-has-doc="${attendanceDocMap[student.studentNo][date] != null}">
									<c:choose>
										<c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '출석'}">●</c:when>
										<c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '지각'}">지각</c:when>
										<c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '조퇴'}">조퇴</c:when>
										<c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '결석'}">✗</c:when>
										<c:when test="${attendanceMap[student.studentNo][date] != null && attendanceMap[student.studentNo][date] eq '공결'}">공결</c:when>
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
	<!-- 출결 등록 -->
	<div id="attendanceModal" style="display:none; position:fixed; top:20%; left:35%; background:#fff; border:1px solid #ccc; padding:20px; z-index:10;">
		<form id="attendanceForm" method="post" action="/manageAttendance" enctype="multipart/form-data">
			<input type="hidden" name="studentNo" value="${studentNo}">
			<input type="hidden" name="date" value="${date}">
			<input type="hidden" name="courseId" value="${courseId}">
			<label>상태:
				<select name="status">
					<option value="출석">출석</option>
					<option value="지각">지각</option>
					<option value="조퇴">조퇴</option>
					<option value="결석">결석</option>
					<option value="공결">공결</option>
				</select>
			</label>
			<br><br>
			<!-- 공결일 경우에만 보이는 섹션 -->
			<div id="fileUploadSection" style="display:none;">
				<label>첨부자료: <input type="file" name="proofDoc" /></label>
				<span id="currentDocIcon" style="margin-left: 10px;"></span>
			</div>
			<br>
			<button type="submit">저장</button>
			<button type="button" onclick="$('#attendanceModal').hide()">취소</button>
		</form>
	</div>
	<script>
	<!-- 요일 정보 및 휴일(토/일) 표시용 JS -->
	document.querySelectorAll("span.day-text").forEach(function(span) {
		var dateStr = span.getAttribute('data-date'); // yyyy-MM-dd
		var dateObj = new Date(dateStr);
		var weekDay = ["일", "월", "화", "수", "목", "금", "토"][dateObj.getDay()];
		span.textContent = weekDay;
		if(weekDay === "일" || weekDay === "토") {
			span.classList.add("holiday");
		}
	});
	// 출결
	$('.attendance-cell').on('click', function() {
		const studentNo = $(this).data('student-no');
		const date = $(this).data('date');
		const status = $(this).data('status');
		const hasDoc = $(this).data('has-doc');
		
		// 모달 초기화
		$('#attendanceForm input[name="studentNo"]').val(studentNo);
		$('#attendanceForm input[name="date"]').val(date);
		$('#attendanceForm select[name="status"]').val(status);
		
		if (status === '공결') {
			$('#fileUploadSection').show();
			if (hasDoc) {
				$('#currentDocIcon').html('&#128196;'); // 첨부 있음
			} else {
				$('#currentDocIcon').html('&#10060;');   // 첨부 없음
			}
		} else {
			$('#fileUploadSection').hide();
		}
		
		$('#attendanceModal').show();
	});
	
	// 공결에서 다른걸 선택하거나 다른 상태에서 공결을 선택할 시 바로 첨부파일 첨부창
	$('#attendanceForm select[name="status"]').on('change', function() {
		const status = $(this).val();
		if (status === '공결') {
			$('#fileUploadSection').show();
		} else {
			$('#fileUploadSection').hide();
		}
	});
	
	// 한번에 입력 버튼
	function confirmInsert() {
		const status = document.getElementById("bulkStatus").value;
		return confirm("이미 입력된 학생들을 제외한 학생들이 '" + status + "'으로 입력됩니다. 진행하시겠습니까?");
	}
	</script>
	
</body>
</html>
