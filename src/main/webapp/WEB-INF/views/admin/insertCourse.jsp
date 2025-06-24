
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 등록</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
    * {
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        margin: 0;
        padding: 0;
        background-color: #f9f9f9;
    }

    h1 {
        text-align: center;
        margin-top: 30px;
        color: #333;
    }

    form {
        max-width: 700px;
        margin: 30px auto;
        background: #fff;
        padding: 30px 40px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        padding: 14px 10px;
        vertical-align: middle;
    }

    th {
        text-align: left;
        background-color: #f1f1f1;
        font-weight: 600;
        width: 150px;
        color: #444;
        border-bottom: 1px solid #ddd;
    }

    td {
        border-bottom: 1px solid #eee;
    }

    input[type="text"],
    select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 15px;
        transition: border-color 0.3s ease;
    }

    input[type="text"]:focus,
    select:focus {
        border-color: #007bff;
        outline: none;
    }

button[type="submit"] {
    margin-top: 25px;
    padding: 12px 20px;
    width: 100%;
  	background-color : #2c3e50;
    color: white;
    font-size: 17px;
    font-weight: bold;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
    transition: background 0.3s, transform 0.2s;
}

button[type="submit"]:hover {
    background: linear-gradient(135deg, #375ac2, #2e4bb1);
    transform: translateY(-1px);
}



    @media (max-width: 768px) {
        form {
            padding: 20px;
        }

        th {
            width: 120px;
        }
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
				<button type="submit" id="insertBtn">강의 등록</button>
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
