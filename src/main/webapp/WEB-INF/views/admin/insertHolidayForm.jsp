<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴강 등록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<h2 style="text-align: center;">📅 휴강 등록</h2>
	
	<form id="insertForm" action="${pageContext.request.contextPath}/admin/holidays/insertHoliday" method="post" style="text-align: center;">
		<p>
			<!-- 비활성화 버튼 -->
			<button type="button" disabled style="background-color: green; color: white; padding: 5px 10px; border-radius: 5px;">✔ 학원 휴강</button>
		</p>
		<p>
			<input type="date" name="date" id="holidayDate" required>
		</p>
		<p>
			<button type="submit">등록</button>
		</p>
	</form>
	
	
	<script>
		// 선택한 날짜가 이미 휴강 또는 공휴일인지 확인
		$(document).ready(function() {
			$('#insertForm').on('submit', function(e) {
				e.preventDefault()  // 기본 등록 막기
			
				const date = $('#holidayDate').val();
				if(!date) return;
				
				$.get("${pageContext.request.contextPath}/admin/holidays/dateType", {date: date}, function(type) {
					if(type == "휴강") {
						alert("이미 휴강으로 등록된 날짜입니다.");
					} else if(type == "공휴일") {
						alert("공휴일에는 휴강을 등록할 수 없습니다.");
					} else {	
						document.getElementById('insertForm').submit();  // '일정 없음'인 경우에만 등록
					}	
				});
			});
		});
	</script>
	
	<c:if test="${not empty success}">
	    <script>
	        // 부모 창 새로고침 후 팝업창 닫기
	        opener.location.reload();  // 부모 창 새로고침
	        window.close();            // 현재 팝업창 닫기
	    </script>
	</c:if>
</body>
</html>
