<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴강 등록</title>
</head>
<body>
	<h2 style="text-align: center;">📅 휴강 등록</h2>
	
	<form action="${pageContext.request.contextPath}/admin/academicSchedule/insertHoliday" method="post" style="text-align: center;">
		<p>
			<button type="button" disabled style="background-color: green; color: white; padding: 5px 10px; border-radius: 5px;">✔ 학원 휴강</button>
		</p>
		<p>
			<input type="date" name="date" required>
		</p>
		<p>
			<button type="submit">등록</button>
		</p>
	</form>
	
	<c:if test="${not empty success}">
	    <script>
	        // 부모 창 새로고침 후 팝업창 닫기
	        opener.location.reload();  // 부모 창 새로고침
	        window.close();            // 현재 팝업창 닫기
	    </script>
	</c:if>
</body>
</html>
