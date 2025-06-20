<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			<form id="courseInsertForm" action="/admin/insertCourse"
				method="post">
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
						<td><input type="text" name="courseName" id="courseName">
						</td>
					</tr>
					<tr>
						<th>강의 설명</th>
						<td><input type="text" name="description" id="description">
						</td>
					</tr>
					<tr>
						<th>시작일</th>
						<td><input type="date" name="startDate" id="startDate">
						</td>
					</tr>
					<tr>
						<th>종료일</th>
						<td><input type="date" name="endDate" id="endDate"></td>
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
						<td><input type="text" name="maxPerson" id="maxPerson" readonly></td>
					</tr>
				</table>
				<button type="button" id="insertBtn">➕ 강의 등록</button>
			</form>
		</div>
	</div>
<script>
	function validateCourseForm() {
		// 강의명
		var courseName = $("input[name='courseName']").val().trim();
		if (!courseName) {
			alert("강의명을 입력하세요.");
			$("input[name='courseName']").focus();
			return false;
		}
		// 강의 설명
		var description = $("input[name='description']").val().trim();
		if (!description) {
			alert("강의 설명을 입력하세요.");
			$("input[name='description']").focus();
			return false;
		}
		if (description.length < 5) {
			alert("강의 설명은 5자 이상 입력하세요.");
			$("input[name='description']").focus();
			return false;
		}
		// 담당 강사
		var teacherNo = $("select[name='teacherNo']").val();
		if (!teacherNo) {
			alert("담당 강사를 선택하세요.");
			$("select[name='teacherNo']").focus();
			return false;
		}

		// 강의실
		var classNo = $("select[name='classNo']").val();
		if (!classNo) {
			alert("강의실을 선택하세요.");
			$("select[name='classNo']").focus();
			return false;
		}

		// 기간
		var startDate = $("input[name='startDate']").val();
		var endDate = $("input[name='endDate']").val();
		if (!startDate || !endDate) {
			alert("강의 시작일과 종료일을 모두 입력하세요.");
			return false;
		}
		if (startDate > endDate) {
			alert("시작일이 종료일보다 늦을 수 없습니다.");
			return false;
		}

		// 정원
		var maxPerson = $("input[name='maxPerson']").val().trim();
		if (!maxPerson || isNaN(maxPerson) || parseInt(maxPerson) < 1) {
			alert("수강정원은 1 이상의 숫자로 입력하세요.");
			$("input[name='maxPerson']").focus();
			return false;
		}

		return true;
	}
	// 강의실 선택 시 수강정원 자동입력
	$('#classNo').change(function() {
		var classNo = $(this).val();
		if (classNo) {
			$.ajax({
				url : '/admin/getMaxPerson',
				type : 'get',
				data : {
					classNo : classNo
				},
				success : function(data) {
					$("#maxPerson").val(data);
				}
			});
		} else {
			$("#maxPerson").val("");
		}
	});

	// 강의 등록 버튼 클릭 시
	$("#insertBtn").click(function() {
		if (!validateCourseForm()) {
			return;
		}
		$.ajax({
			url : "insertCourse",
			type : "POST",
			data : $("#courseInsertForm").serialize(),
			success : function(result) {
				if (result === "overlap") {
					alert("이미 해당 강의실에서 진행 중인 강의와 일정이 겹칩니다.");
				} else {
					alert("등록 완료");
					location.href = "/admin/courseList";
				}
			},
			error : function() {
				alert("등록 중 오류가 발생했습니다.");
			}
		});
	});
</script>
</body>
</html>
