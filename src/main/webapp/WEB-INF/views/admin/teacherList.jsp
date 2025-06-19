<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>강사 리스트</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<style>
	  .container {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    margin-top: 30px;
	  }
	  
		#teacherModal input,
		#teacherModal select {
		  width: 300px;
		  padding: 5px;
		  box-sizing: border-box;
		}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
	<div class="container">
		<h1>강사 리스트</h1>		
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
					<td>${teacher.sn}</td>
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
							<option value="">미정</option>
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
					$("#modalPhone").val(teacher.phone || "");
					$("#modalSn").val(teacher.sn || "");
					$("#modalAddress").val(teacher.address || "");
					$("#modalEmail").val(teacher.email || "");
					$("#modalCourseSelect").val(teacher.courseId || "");
					$("#teacherModal").show();  // 모달창 보이기
				});
			});
		});
		
		
		// 모달 저장 버튼
		$("#saveTeacherBtn").off('click').on('click', function () {

			// 전화번호/주민번호 하이픈 제거 (DB 저장용)
			const rawPhone = $("modalPhone").val().replace(/-/g, '');
			const rawSn = $("modalSn").val().replace(/-/g, '');
			$("#ModalPhone").val(rawPhone);
			$("#modalSn").val(rawSn);
			
			
			$.ajax({
				url: "/admin/updateTeacher",
				type: "POST",
				data: $("#teacherForm").serialize(),  // 폼 전체 데이터를 문자열로 변환해서 서버로 전송
				success: function () {
					alert("수정 완료");
					location.reload();  // 목록 새로고침
				},
				error: function () {
					alert("수정 실패");
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