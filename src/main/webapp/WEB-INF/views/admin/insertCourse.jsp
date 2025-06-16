<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
.container {
	display: flex;
	flex-direction: row;
	align-items: flex-start;
}

.sidebar {
	min-width: 200px; /* 메뉴 폭은 취향껏 */
	margin-right: 30px;
}

.main-content {
	flex: 1;
	padding: 32px 24px 24px 300px; /* 좌우여백 */
	overflow-x: auto;
	background: #fafbfc;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
		</div>
		<div class="main-content">
			<h1>강의 등록</h1>
			<form action="insertCourse" method="post" onsubmit="return validateForm()">
				<table border="1">
					<tr>
						<th>담당 강사</th>
						<td><select name="teacherNo" required>
								<option value="">강사 선택</option>
								<c:forEach var="teacherList" items="${teacherList}">
									<option value="${teacherList.teacherNo}">${teacherList.name}</option>
								</c:forEach>
						</select></td>
					</tr>
					<tr>
						<th>강의명</th>
						<td>
							<input type="text" name="courseName" id="courseName">
						</td>
					</tr>
					<tr>
						<th>강의 설명</th>
						<td>
							<input type="text" name="description" id="description">
						</td>
					</tr>
					<tr>
						<th>시작일</th>
						<td>
							<input type="date" name="startDate" id="startDate">
						</td>
					</tr>
					<tr>
						<th>종료일</th>
						<td>
							<input type="date" name="endDate" id="endDate">
						</td>
					</tr>
					<tr>
						<th>강의실</th>
						<td>
							<select name="classNo" required>
								<option value="">강의실 선택</option>
								<c:forEach var="classroom" items="${classList}">
									<option value="${classroom.classNo}">${classroom.classroom}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>수강정원</th>
						<td>
							<input type="text" name="maxPerson" id="maxPerson">
						</td>
					</tr>
				</table>
				<button type="submit">강의 등록</button>
			</form>
		</div>
	</div>
<script>
	// 강의실 선택 시 강의실 별 수강 정원을 DB에서 가져와서 자동으로 입력
	$('select[name="classNo"]').change(function(){
		var classNo = $(this).val();
		if(classNo) {
			$.ajax({
				url: '/admin/getMaxPerson',
				type: 'get',
				data: {classNo: classNo},
				success: function(data){
					console.log(data);
					$("#maxPerson").val(data);
				}
			})
		} else {
			$("#maxPerson").val("");
		}
	})
	
	// 강의 등록 시 공백 확인
	function validateForm() {
		const courseName = document.getElementById("courseName").value.trim();
		const description = document.getElementById("description").value.trim();
		const startDate = document.getElementById("startDate").value.trim();
		const endDate = document.getElementById("endDate").value.trim();
		
		if(!courseName || !description || !startDate || !endDate) {
			alert("공백 없이 작성 부탁드립니다.")
			return false;
		}
	}
</script>
</body>
</html>