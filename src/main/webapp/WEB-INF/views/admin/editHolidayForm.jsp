<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴강 정보 관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<h2 style="text-align: center;">📅 휴강 정보 관리</h2>
	
	<!-- 날짜 수정 폼 -->
	<form id="updateForm" action="${pageContext.request.contextPath}/admin/holidays/updateHolidayDate" method="post" style="text-align: center;">
		<input type="hidden" name="holidayId" value="${holidayId}" />
		<p>
			<!-- 비활성화 버튼 -->
			<button type="button" disabled style="background-color: green; color: white; padding: 5px 10px; border-radius: 5px;">✔ 학원 휴강</button>
		</p>
		<p>
			<input type="date" name="date" id="holidayDate" required>
		</p>
		<p>
			<button type="submit">💾 날짜 수정</button>
		</p>
	</form>
	
	<!-- 삭제 폼 -->
	<form id="deleteForm" action="${pageContext.request.contextPath}/admin/holidays/deleteHoliday" method="post" style="text-align: center;">
		<input type="hidden" name="holidayId" value="${holidayId}" />
		<input type="hidden" name="date" value="${date}" />
		<p>
			<button type="submit" onclick="return confirmDelete()">❌ 휴강 삭제</button>
		</p>
	</form>
	
	
	<script>
		// 주말 여부 확인
		function isWeekend(dateStr) {
			const day = new Date(dateStr).getDay();  // 0: 일요일, 6: 토요일
			return day == 0 || day == 6;
		}
		
		// 삭제 확인
		function confirmDelete() {
			return confirm("정말 삭제하시겠습니까?");
		}
		
	
		// 선택한 날짜가 주말이거나, 이미 등록된 휴강 또는 공휴일인지 확인
		$(document).ready(function() {
			$('#updateForm').on('submit', function(e) {
				e.preventDefault()  // 기본 등록 막기
			
				const date = $('#holidayDate').val();
				const holidayId = $('input[name="holidayId"]').val();
				
				if(!date) return;
				
				// 1. 주말인지 확인
				if(isWeekend(date)) {
					alert("주말을 휴강으로 등록할 수 없습니다.");
					return;
				}
				
				// 2. 이미 등록된 휴강 또는 공휴일인지 확인
				$.get("${pageContext.request.contextPath}/admin/holidays/dateType", { date: date }, function(type) {
				    if (type === "공휴일") {
				        alert("공휴일을 휴강으로 등록할 수 없습니다.");
				        return;
				    }

				    // 3. 휴강일 경우 → 자기 자신인지 중복 확인
				    $.get("${pageContext.request.contextPath}/admin/holidays/duplicate-check", 
				        { date: date, holidayId: holidayId }, function(isDuplicate) {
				        if (isDuplicate) {
				            alert("이미 해당 날짜에 다른 휴강 일정이 존재합니다.");
				        } else {
				            document.getElementById('updateForm').submit();  // 유효할 때만 전송
				        }
				    });
				});
			});
		});
	</script>
	
	
	<!-- 날짜 수정 성공 시 -->
	<c:if test="${not empty success}">
	    <script>
	        // 부모 창 새로고침 후 팝업창 닫기
	        opener.location.reload();  // 부모 창 새로고침
	        window.close();            // 현재 팝업창 닫기
	    </script>
	</c:if>
	
	<!-- 삭제 성공 시 -->
	<c:if test="${not empty deleted}">
	    <script>
	        // 부모 창 새로고침 후 팝업창 닫기
	        opener.location.reload();  // 부모 창 새로고침
	        window.close();            // 현재 팝업창 닫기
	    </script>
	</c:if>
</body>
</html>
