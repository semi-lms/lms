course


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 등록</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #fafbfc;
    margin: 0;
    padding: 0;
    color: #333;
}

h1 {
    font-size: 2rem;
    margin-bottom: 24px;
    color: #2c3e50;
}

table {
  width: 100%;
  max-width: 700px;
  border-collapse: separate; /* 각 셀 간 간격 주기 위해 */
  border-spacing: 0 12px; /* 행 사이 여백 */
  margin-bottom: 32px;
  font-size: 1rem;
  font-weight: 400;
}

th, td {
  padding: 14px 18px;
  vertical-align: middle;
  background-color: white;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  border-radius: 8px;
}

th {
  width: 160px;
  background-color: #e9ecef;
  color: #495057;
  font-weight: 600;
  text-align: left;
  box-shadow: none; /* 헤더는 그림자 제거해서 더 깔끔하게 */
  border-radius: 8px 0 0 8px;
}

td {
  border-radius: 0 8px 8px 0;
}

tr {
  /* 행 전체의 배경은 흰색이고, 아래 여백은 border-spacing으로 처리 */
}

tbody tr:hover td {
  background-color: #f1f3f5;
  transition: background-color 0.3s ease;
}

input[type="text"], input[type="date"], select {
    width: 100%;
    box-sizing: border-box;
    padding: 8px 12px;
    font-size: 1rem;
    border: 1.5px solid #ccc;
    border-radius: 6px;
    transition: border-color 0.3s ease;
}

input[type="text"]:focus, input[type="date"]:focus, select:focus {
    border-color: #3498db;
    outline: none;
    box-shadow: 0 0 8px rgba(52, 152, 219, 0.4);
}

input[readonly] {
    background-color: #f4f6f8;
    color: #777;
    cursor: not-allowed;
}

button#insertBtn {
    display: inline-block;
    background-color: #3498db;
    color: white;
    border: none;
    padding: 6px 14px;
    font-size: 1.1rem;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    user-select: none;
}

button#insertBtn:hover {
    background-color: #2980b9;
}

.container {
    display: flex;
    align-items: center;
    min-height: 100vh;
}

.sidebar {
    width: 280px;
    background-color: #2c3e50;
    min-height: 100vh;
}

.main-content {
    flex: 1;
    padding: 32px 24px 24px 32px;
    overflow-x: auto;
    background: #fafbfc;
    margin-left: 700px;
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
				<table >
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
