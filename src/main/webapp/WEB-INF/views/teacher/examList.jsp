<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시험 리스트</title>
<style>
.container {
	display: flex;
	min-height: 100vh;
	font-family: 'Segoe UI', sans-serif;
	background-color: white;;
}

.main-content {
	margin-left: 300px;
	flex-grow: 1;
	padding: 30px;
	background-color: white;
}

h1 {
	font-size: 24px;
	margin-bottom: 15px;
}

button {
	margin-right: 8px;
	padding: 5px 10px;
	font-size: 14px;
	cursor: pointer;
	border: 1px solid #333;
	border-radius: 4px;
	background-color: white;
	color: #333;
	transition: background-color 0.2s ease;
}

button:hover {
	background-color: white;;
}

table {
	width: 100%;
	max-width: 1000px;
	border-collapse: collapse;
	margin-top: 15px;
	font-size: 14px;
	background-color: #fff;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
}

th, td {
	border: 1px solid #ccc;
	padding: 8px 10px;
	text-align: center;
	word-break: keep-all;
}

th {
	color : white;
	background-color: #2c3e50;
	font-weight: 600;
}

td input[type="text"], td input[type="date"] {
	width: 95%;
	padding: 4px;
	font-size: 13px;
	box-sizing: border-box;
}

a {
	color: #007bff;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
}

.paging {
	position: absolute;
	left: calc(300px + 30%); /* 사이드바 너비 + 절반 위치 */
	transform: translateX(-50%); /* 정확한 중앙 정렬 */
	margin-top: 20px;
	display: flex;
	gap: 6px;
}

.paging a, .paging .current-page {
	
	display: inline-block;
	margin: 0 4px;
	padding: 6px 12px;
	font-size: 14px;
	border-radius: 5px;
	text-decoration: none;
	color: #2c3e50;
	border: 1px solid #2c3e50;
	transition: background-color 0.2s;
}

.paging a:hover {
	background-color: #ecf0f1;
}

.paging .current-page {
	background-color: #2c3e50;
	color: white;
	font-weight: bold;
	cursor: default;
}
/* 상단 메뉴 공통 스타일 */
.top-menu a {
	display: inline-block;
	padding: 8px 16px;
	margin-right: 10px;
	border-radius: 6px;
	text-decoration: none;
	font-weight: bold;
	font-size: 14px;
}

.top-menu a.active {
	background-color: #cce5ff;
	color: #004085;
}

.top-menu a.inactive {
	background-color: #e9ecef;
	color: #333;
}
</style>

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
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
		</div>
		<div class="main-content">
			<!-- 공통 페이지 상단 메뉴 -->
			<div class="top-menu">
				<c:set var="currentPath" value="${pageContext.request.requestURI}" />

				<a href="/attendanceList?courseId=${courseId}"
					style="padding: 8px 16px; 
					margin-right: 10px; 
					border-radius: 6px; 
					text-decoration: none; 
					font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/attendanceList")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/attendanceList")}'>background-color: #e9ecef; color: #333;</c:if>">
					출결 관리 </a> <a href="/studentListFromTeacher?courseId=${courseId}"
					style="padding: 8px 16px; 
				   margin-right: 10px; 
				   border-radius: 6px; 
				   text-decoration: none; 
				   font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/studentListFromTeacher")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/studentListFromTeacher")}'>background-color: #e9ecef; color: #333;</c:if>">
					학생 관리 </a> <a href="/examList?courseId=${courseId}"
					style="padding: 8px 16px; 
					border-radius: 6px; 
					text-decoration: none; 
					font-weight: bold;
				<c:if test='${fn:contains(currentPath, "/examList")}'>background-color: #cce5ff; color: #004085;</c:if>
				<c:if test='${!fn:contains(currentPath, "/examList")}'>background-color: #e9ecef; color: #333;</c:if>">
					시험 관리 </a>
			</div>

				<h2>${courseName}</h2>
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
						<td><a href="/questionList?examId=${exam.examId}">${exam.title}</a></td>
						<td>${exam.status}</td>
						<td>${exam.examStartDate}</td>
						<td>${exam.examEndDate}</td>
						<td><c:if test="${exam.status eq '예정'}">
								<button type="button" onclick="enterEditMode(${exam.examId})">수정</button>
							</c:if></td>
						<td><c:if test="${exam.status eq '예정'}">
								<button type="button" onclick="deleteExam(${exam.examId})">삭제</button>
							</c:if></td>
					</tr>


					<!-- 수정 모드 행 -->
					<tr id="editRow-${exam.examId}" style="display: none;">
						<form method="post" action="/updateExam"
							onsubmit="return validateEditForm(this)">
							<td><input type="text" name="title" value="${exam.title}" /></td>
							<td>${exam.status}</td>
							<td><input type="date" name="examStartDate"
								value="${exam.examStartDate}" /></td>
							<td><input type="date" name="examEndDate"
								value="${exam.examEndDate}" /></td>
							<td><input type="hidden" name="examId"
								value="${exam.examId}" /> <input type="hidden" name="courseId"
								value="${courseId}" />
								<button type="submit">저장</button>
								<button type="button" onclick="cancelEdit(${exam.examId})">취소</button>
							</td>
							<td></td>
						</form>
					</tr>
				</c:forEach>
			</table>
			<div class="paging">
				<c:forEach var="i" begin="1" end="${endPage}">
					<c:choose>
						<c:when test="${i == currentPage}">
							<span class="current-page">${i}</span>
						</c:when>
						<c:otherwise>
							<a href="/examList?courseId=${courseId}&currentPage=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
			<p>
				<button type="button" onclick="openPopup()">➕ 시험등록</button>

				<!-- 등록용 모달 폼 -->
			<div id="examPopup"
				style="display: none; position: fixed; top: 30%; left: 40%; background: white; padding: 20px; border: 1px solid #ccc; box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.3); z-index: 1000;">
				<form method="post" action="/insertExam"
					onsubmit="return validateInsertForm()">
					<h3>시험 등록</h3>
					<label>제목: <input type="text" name="title" required></label><br>
					<br> <label>시작일: <input type="date"
						name="examStartDate" id="insertStartDate" required></label><br>
					<br> <label>종료일: <input type="date" name="examEndDate"
						id="insertEndDate" required></label><br>
					<br> <input type="hidden" name="courseId" value="${courseId}">
					<button type="submit">➕ 등록</button>
					<button type="button" onclick="closePopup()">닫기</button>
				</form>
			</div>
			<!-- 삭제 시 post용 폼 -->
			<form id="deleteForm" method="post" action="/removeExam"
				style="display: none;">
				<input type="hidden" name="examId" id="deleteExamId">
			</form>
		</div>
	</div>
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
			const startDate = new Date(form.examStartDate.value);
			const endDate = new Date(form.examEndDate.value);
			
			if (startDate > endDate) {
				alert("시험 시작일은 종료일보다 빠르거나 같아야 합니다.");
				return false; // 폼 제출 막기
			}
			
			return true; // 유효하면 제출 허용
		}
	</script>
</body>
</html>
