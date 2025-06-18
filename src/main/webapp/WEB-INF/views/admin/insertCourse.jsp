<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 등록</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
.container {
	display: flex;
	flex-direction: row;
	align-items: flex-start;
}
.sidebar {
	min-width: 200px;
	margin-right: 30px;
}
.main-content {
	flex: 1;
	padding: 32px 24px 24px 300px;
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
			<form id="courseInsertForm" method="post">
				<table border="1">
					<tr>
						<th>담당 강사</th>
						<td>
							<select name="teacherNo" required>
								<option value="">강사 선택</option>
								<c:forEach var="teacherList" items="${teacherList}">
									<option value="${teacherList.teacherNo}">${teacherList.name}</option>
								</c:forEach>
							</select>
						</td>
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
							<select name="classNo" id="classNo" required>
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
							<input type="text" name="maxPerson" id="maxPerson" readonly>
						</td>
					</tr>
				</table>
				<button type="button" id="insertBtn">강의 등록</button>
			</form>
		</div>
	</div>
<script>
	// 강의실 선택 시 수강정원 자동입력
	$('#classNo').change(function(){
		var classNo = $(this).val();
		if(classNo) {
			$.ajax({
				url: '/admin/getMaxPerson',
				type: 'get',
				data: {classNo: classNo},
				success: function(data){
					$("#maxPerson").val(data);
				}
			});
		} else {
			$("#maxPerson").val("");
		}
	});

	// 강의 등록 버튼 클릭 시
	$("#insertBtn").click(function() {
		const courseName = $("#courseName").val().trim();
		const description = $("#description").val().trim();
		const startDate = $("#startDate").val().trim();
		const endDate = $("#endDate").val().trim();

		if(!courseName || !description || !startDate || !endDate) {
			alert("공백 없이 작성 부탁드립니다.");
			return;
		}

		$.ajax({
			url: "insertCourse",
			type: "POST",
			data: $("#courseInsertForm").serialize(),
			success: function(result){
				if(result === "overlap"){
					alert("이미 해당 강의실에서 진행 중인 강의와 일정이 겹칩니다.");
				}else{
					alert("등록 완료");
					location.href = "/admin/courseList";
				}
			},
			error: function(){
				alert("등록 중 오류가 발생했습니다.");
			}
		});
	});
</script>
</body>
</html>
