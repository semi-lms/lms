<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>강사 리스트</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<style>
	body {
	font-family: 'Segoe UI', sans-serif;
	background-color: #f9f9f9;
	margin: 0;
	padding: 0;
}

.container {
	margin-left: 260px; /* sidebar 너비 + 여백 */
	padding: 30px 40px;
}

h1 {
	  margin-bottom: 20px;
  font-weight: 700;
  color: #2c3e50;
  text-align: center;
}

table {
	width: 100%;
	border-collapse: collapse;
	background-color: #fff;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

th, td {
	border: 1px solid #ccc;
	padding: 10px;
	text-align: center;
	font-size: 14px;
}

th {
	background-color: #2c3e50;
	color: white;
}


input[type="checkbox"] {
	transform: scale(1.2);
	cursor: pointer;
}

/* 공통 버튼 스타일 - 흰 배경 + 검은 테두리 */
button {
	margin-right: 8px;
	padding: 6px 14px;
	font-size: 14px;
	cursor: pointer;
	border: 1px solid #333;
	border-radius: 6px;
	background-color: #fff;
	color: #333;
	transition: background-color 0.2s ease;
}

button:hover {
	background-color: #eaeaea;
}

/* 버튼 영역 정렬 */
div[style*="text-align: right"] {
	width: 100%;
	text-align: right;
	margin-top: 10px;
}

/* 모달 스타일 */
#teacherModal {
	display: none;
	position: fixed;
	left: 50%;
	top: 20%;
	transform: translate(-50%, 0);
	background-color: #fff;
	border: 1px solid #aaa;
	padding: 30px;
	box-shadow: 0 0 12px rgba(0, 0, 0, 0.2);
	z-index: 999;
	width: 480px;
}

#teacherModal table {
	width: 100%;
	border-collapse: collapse;
}

#teacherModal th,
#teacherModal td {
	padding: 8px;
	text-align: left;
}

#teacherModal input,
#teacherModal select {
	width: 100%;
	padding: 6px;
	box-sizing: border-box;
	border: 1px solid #ccc;
	border-radius: 4px;
}

	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
	<div class="container">
		<h1>강사 리스트</h1>		
		<form method="get" action="/admin/teacherList">
			<button type="submit" name="filter" value="전체" ${filter == '전체' ? 'disabled' : ''}>전체</button>
			<button type="submit" name="filter" value="예정된 강의" ${filter == '예정된 강의' ? 'disabled' : ''}>예정된 강의</button>
			<button type="submit" name="filter" value="진행중인 강의" ${filter == '진행중인 강의' ? 'disabled' : ''}>진행중인 강의</button>
			<button type="submit" name="filter" value="종료된 강의" ${filter == '종료된 강의' ? 'disabled' : ''}>종료된 강의</button>
			<button type="submit" name="filter" value="미정" ${filter == '미정' ? 'disabled' : ''}>미정</button>
		</form>
		<table border="1">
			<tr>
				<th>이름</th>
				<th>전화번호</th>
				<th>주민번호</th>
				<th>주소</th>
				<th>이메일</th>
				<th>아이디</th>
				<th>담당 강의</th>
				<th>선택</th>
			</tr>
			<c:forEach var="teacher" items="${teacherList}">
				<tr>
					<td>${teacher.name}</td>
					<td>${teacher.phone}</td>
					<td>
						<c:set var="cleanSn" value="${fn:replace(teacher.sn, '-', '')}" />
					    <c:choose>
					      	 <c:when test="${fn:length(cleanSn) == 13}">
					            <c:out value="${fn:substring(cleanSn, 0, 6)}" />-*******
					    	</c:when>
					    	<c:otherwise>
					        	${teacher.sn}
					    	</c:otherwise>
					  	</c:choose>
					</td>
					<td>${teacher.address}</td>
					<td>${teacher.email}</td>
					<td>${teacher.teacherId}</td>
					<td>
						<c:choose>
						    <c:when test="${empty teacher.courseName}">
						    	미정
						    </c:when>
						    <c:otherwise>
						    	${teacher.courseName}
						    </c:otherwise>
					  </c:choose>
					</td>
					<td><input type="checkbox" class="selectTeacher" value="${teacher.teacherNo}"></td>
				</tr>
			</c:forEach>
		</table>
		
		<div style="text-align: right; margin-top: 10px;">
			<button type="button" id="insertTeacher">➕ 강사 등록</button>
			<button type="button" id="modifyBtn">💾 수정</button>
			<button type="button" id="removeBtn">❌ 삭제</button>
		</div>
	</div>
	
	<!-- 모달 영역 -->
	<div id="teacherModal" style="display:none; position:fixed; left:50%; top:30%; transform:translate(-50%,0); background:#fff; border:1px solid #888; padding:32px; z-index:999;">
		<form id="teacherForm">
			<input type="hidden" name="teacherNo" id="modalTeacherNo">
			<table border="1">
				<tr>
					<th>이름</th>
					<td><input type="text" name="name" id="modalName" required></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="phone" id="modalPhone" required></td>
				</tr>
				<tr>
					<th>주민번호</th>
					<td><input type="text" name="sn" id="modalSn" required></td>
				</tr>
				<tr>
					<th>주소</th>
					<td><input type="text" name="address" id="modalAddress" required></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td><input type="email" name="email" id="modalEmail" required></td>
				</tr>
				<tr>
					<th>담당 강의</th>
					<td>
						<select name="courseId" id="modalCourseSelect" required>
							<!-- 종료된 강의 -->
							<option value="" id="placeholderOption" disabled>강의를 선택하세요</option>
							
							<!-- 미정 -->
							<option value="0">미정</option>
							
							<!-- 진행 중 / 예정 강의 -->
							<c:forEach var="course" items="${courseList}">
								<option value="${course.courseId}">${course.courseName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
			<button type="button" id="saveTeacherBtn">저장</button>
			<button type="button" id="closeTeacherModalBtn">닫기</button>
		</form>
	</div>
	
	<script>
		$(function() {
			// 강사 등록
			$("#insertTeacher").click(function () {
				window.location = "insertTeacher";
			});
			
			
			// 강사 정보 수정
			$("#modifyBtn").click(function () {
				const checked = $(".selectTeacher:checked");
				if (checked.length == 0) {
					alert("수정할 강사를 선택하세요.");
					return;
				}
				if (checked.length > 1) {
					alert("하나만 선택 가능합니다.")
					return;
				}
				
				// 선택한 강사의 번호(PK)
				const teacherNo = checked.val();
				
				// 선택한 강사의 상세 정보 불러오기
				$.getJSON("/admin/getTeacherDetail", { teacherNo: teacherNo }, function (teacher) {
					console.log("조회된 강사", teacher);
					console.log("teacher.courseId:", teacher.courseId);

					if (!teacher) {
						alert("강사 정보를 불러올 수 없습니다.");
						return;
					}
					
					// 모달에 정보 채우기
					$("#modalTeacherNo").val(teacher.teacherNo || "");
					$("#modalName").val(teacher.name || "");
					$("#modalPhone").val(formatPhone(teacher.phone || ""));
					$("#modalSn").val(formatSn(teacher.sn || ""));
					$("#modalAddress").val(teacher.address || "");
					$("#modalEmail").val(teacher.email || "");
					
					// 하이픈 붙이기
					function formatPhone(p) {
						let v = p.replace(/[^0-9]/g, "");
						if (v.length < 4) return v;
						else if (v.length < 8) return v.substr(0, 3) + "-" + v.substr(3);
						else if (v.length <= 11) return v.substr(0, 3) + "-" + v.substr(3, 4) + "-" + v.substr(7);
						else return v.substr(0, 3) + "-" + v.substr(3, 4) + "-" + v.substr(7, 4);
					}

					function formatSn(s) {
						let val = s.replace(/[^0-9]/g, "");
						if (val.length <= 6) return val;
						else return val.substr(0, 6) + "-" + val.substr(6, 7);
					}
					
					
					// 담당 강의
					const select = $("#modalCourseSelect");
					if (!teacher.courseId || teacher.courseId == 0) {
						// courseId가 null, '', 또는 0일 경우 -> 미정
						select.val("0");
					} else if (select.find("option[value='" + teacher.courseId + "']").length == 0) {
						// 종료된 강의라 드롭다운에 없는 경우
						select.val(""); // value="" 선택
						select.find("option[value='']").text("강의를 선택하세요");
					} else {
						select.val(teacher.courseId);
					}
					
					$("#teacherModal").show();  // 모달창 보이기
				});
			});
		});
		
		
		// 모달 저장 버튼
		$("#saveTeacherBtn").off('click').on('click', function () {

			// 전화번호/주민번호 하이픈 제거 (DB 저장용)
			const rawPhone = $("#modalPhone").val().replace(/-/g, '');
			const rawSn = $("#modalSn").val().replace(/-/g, '');
			$("#modalPhone").val(rawPhone);
			$("#modalSn").val(rawSn);
			
			
			$.ajax({
				url: "/admin/updateTeacher",
				type: "POST",
				data: $("#teacherForm").serialize(),  // 폼 전체 데이터를 문자열로 변환해서 서버로 전송
				success: function (response) {
					if (response.success) {
						alert("수정 완료");
						location.reload();  // 목록 새로고침
					} else {
						alert(response.message);
					}
				},
				error: function () {
					alert("서버 오류 발생");
				}
			});
		});
		
		// 모달 닫기 버튼
		$("#closeTeacherModalBtn").click(function () {
			$("#teacherModal").hide();  // 모달 숨기기
		});
		
		
		// 강사 삭제
		$("#removeBtn").click(function () {
			const checked = $(".selectTeacher:checked");
			if (checked.length == 0) {
				alert("삭제할 강사를 선택하세요.");
				return;
			}
			if (!confirm("정말 삭제하시겠습니까?")) {
				return;
			}
			
			// 선택한 강사 번호들을 배열로 저장
			let teacherNos = [];
			checked.each(function () {
				teacherNos.push($(this).val());
			});
			
			$.ajax({
				url: "/admin/deleteTeachers",
				type: "POST",
				traditional: true,  // 배열을 전달하기 위해 필요한 옵션
				data: { teacherNos: teacherNos },
				success: function () {
					alert("삭제 완료");
					location.reload();  // 목록 새로고침
				},
				error: function () {
					alert("삭제 실패");
				}
			});
		});
	</script>
</body>
</html>