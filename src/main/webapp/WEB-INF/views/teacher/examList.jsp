<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시험 리스트</title>
<script>
	function enterEditMode(examId) {
		document.getElementById("viewRow-" + examId).style.display = "none";
		document.getElementById("editRow-" + examId).style.display = "table-row";
	}
	
	function cancelEdit(examId) {
		document.getElementById("editRow-" + examId).style.display = "none";
		document.getElementById("viewRow-" + examId).style.display = "table-row";
	}
</script>
</head>
<body>
<h1>시험 리스트</h1>
	<table border="1">
		<tr>
			<th>제목</th>
			<th>진행도</th>
			<th>시작일</th>
			<th>종료일</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
	
		<c:forEach var="exam" items="${exams}">
			<!-- 보기 모드 행 -->
			<tr id="viewRow-${exam.examId}">
				<td>${exam.title}</td>
				<td>${exam.status}</td>
				<td>${exam.examStartDate}</td>
				<td>${exam.examEndDate}</td>
				<td>
					<c:if test="${exam.status eq '예정'}">
						<button type="button" onclick="enterEditMode(${exam.examId})">수정</button>
					</c:if>
				</td>
				<td>
					<c:if test="${exam.status eq '예정'}">
						<button type="button" onclick="deleteExam(${exam.examId})">삭제</button>
					</c:if>
				</td>
			</tr>
	
			<!-- 수정 모드 행 -->
			<tr id="editRow-${exam.examId}" style="display:none;">
				<form method="post" action="/updateExam" onsubmit="return validateEditForm(this)">
					<td><input type="text" name="title" value="${exam.title}" /></td>
					<td>${exam.status}</td>
					<td><input type="date" name="examStartDate" value="${exam.examStartDate}" /></td>
					<td><input type="date" name="examEndDate" value="${exam.examEndDate}" /></td>
					<td>
						<input type="hidden" name="examId" value="${exam.examId}" />
						<button type="submit">저장</button>
						<button type="button" onclick="cancelEdit(${exam.examId})">취소</button>
					</td>
					<td></td>
				</form>
			</tr>
		</c:forEach>
	</table>
	<c:forEach var="i" begin="1" end="${endPage}">
		<c:choose>
			<c:when test="${i == currentPage}">
				<span>[${i}]</span>
			</c:when>
			<c:otherwise>
				<a href="/examList?currentPage=${i}">[${i}]</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<p>
	<button type="button" onclick="openPopup()">시험등록</button>
	
	<!-- 등록용 모달 폼 -->
	<div id="examPopup" style="display:none; position:fixed; top:30%; left:40%; background:white; padding:20px; border:1px solid #ccc; box-shadow: 2px 2px 10px rgba(0,0,0,0.3); z-index:1000;">
		<form method="post" action="/insertExam" onsubmit="return validateInsertForm()">
			<h3>시험 등록</h3>
			<label>제목: <input type="text" name="title" required></label><br><br>
			<label>시작일: <input type="date" name="examStartDate" id="insertStartDate" required></label><br><br>
			<label>종료일: <input type="date" name="examEndDate" id="insertEndDate" required></label><br><br>
			<input type="hidden" name="courseId" value="${courseId}">
			<button type="submit">등록</button>
			<button type="button" onclick="closePopup()">닫기</button>
		</form>
	</div>
	<!-- 삭제 시 post용 폼 -->
	<form id="deleteForm" method="post" action="/removeExam" style="display:none;">
		<input type="hidden" name="examId" id="deleteExamId">
	</form>
	
	<script>
		// 수정 팝업 열고 닫는 JS
		function openPopup() {
			document.getElementById("examPopup").style.display = "block";
		}
		function closePopup() {
			document.getElementById("examPopup").style.display = "none";
		}
		// 삭제
		function deleteExam(examId) {
			if (confirm("정말 삭제하시겠습니까?")) {
				// 숨겨진 폼에 examId 설정 후 제출
				document.getElementById("deleteExamId").value = examId;
				document.getElementById("deleteForm").submit();
			}
		}
		
		// 수정, 등록 유효성 검사
		function validateInsertForm() {
			const start = document.getElementById("insertStartDate").value;
			const end = document.getElementById("insertEndDate").value;
			if (start > end) {
				alert("시작일은 종료일보다 빠르거나 같아야 합니다.");
				return false;
			}
			return true;
		}
	
		function validateEditForm(form) {
			const start = form.querySelector("[name='examStartDate']").value;
			const end = form.querySelector("[name='examEndDate']").value;
			if (start > end) {
				alert("시작일은 종료일보다 빠르거나 같아야 합니다.");
				return false;
			}
			return true;
		}
	</script>
</body>
</html>
