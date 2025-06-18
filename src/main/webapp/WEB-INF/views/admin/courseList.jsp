<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 목록</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
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
#courseModal {
	display: none;
	position: fixed;
	left: 50%;
	top: 30%;
	transform: translate(-50%,0);
	background: #fff;
	border: 1px solid #888;
	padding: 32px;
	z-index: 999;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
		</div>
		<div class="main-content">
			<h1>강의 목록</h1>
			<form method="get">
				<table border="1">
					<tr>
						<th>담당 강사</th>
						<th>강의명</th>
						<th>기간</th>
						<th>강의실</th>
						<th>수강 인원</th>
						<th>선택</th>
					</tr>
					<c:forEach var="course" items="${courseList}">
						<tr>
							<td>${course.teacherName}</td>
							<td>${course.courseName}</td>
							<td>${course.startDate}</td>
							<td>
								<a href="/admin/attendanceByClass?courseId=${course.courseId }">
									${course.classroom}
								</a>
							</td>
							<td>${course.applyPerson}</td>
							<td><input type="checkbox" class="select-course" value="${course.courseId}"></td>
						</tr>
					</c:forEach>
				</table>
				<button type="button" id="insertCourse">강의 등록</button>
				<button type="button" id="modifyBtn">수정</button>
				<button type="button" id="removeBtn">삭제</button>
				<br>
				<select name="searchOption" id="searchOption">
					<option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
					<option value="teacherName" ${searchOption == 'teacherName' ? 'selected' : ''}>강사</option>
					<option value="courseName" ${searchOption == 'courseName' ? 'selected' : ''}>강의명</option>
				</select>
				<input type="text" name="keyword" id="keyword" value="${keyword}" placeholder="검색">
				<button type="submit" id="searchBtn">검색</button>
			</form>

			<c:if test="${page.lastPage > 1 }">
				<c:if test="${startPage > 1 }">
					<a href="/admin/courseList?currentPage=${startPage - 1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[이전]</a>
				</c:if>
			</c:if>
			<c:forEach var="i" begin="${startPage}" end="${endPage}">
				<c:choose>
					<c:when test="${i == page.currentPage }">
						<span>[${i}]</span>
					</c:when>
					<c:otherwise>
						<a href="/admin/courseList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[${i}]</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${endPage < page.lastPage }">
				<a href="/admin/courseList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[다음]</a>
			</c:if>

			<!-- ================== 모달 폼 ==================== -->
			<div id="courseModal">
				<form id="courseForm">
					<input type="hidden" name="courseId" id="modalCourseId">
					<table border="1">
						<tr>
							<th>담당 강사</th>
							<td>
								<select name="teacherNo" id="modalTeacherNo" required>
									<option value="">강사 선택</option>
									<c:forEach var="teacher" items="${teacherList}">
										<option value="${teacher.teacherNo}">${teacher.name}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>강의명</th>
							<td>
								<input type="text" name="courseName" id="modalCourseName" required>
							</td>
						</tr>
						<tr>
							<th>강의 설명</th>
							<td>
								<input type="text" name="description" id="modalDescription" required>
							</td>
						</tr>
						<tr>
							<th>기간</th>
							<td>
								<input type="date" name="startDate" id="modalStartDate" required>
								~
								<input type="date" name="endDate" id="modalEndDate" required>
							</td>
						</tr>
						<tr>
							<th>강의실</th>
							<td>
								<select name="classNo" id="modalClassNo" required>
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
								<input type="text" name="maxPerson" id="modalMaxPerson" required>
							</td>
						</tr>
					</table>
					<button type="button" id="saveCourseBtn">저장</button>
					<button type="button" id="closeModalBtn">닫기</button>
				</form>
			</div>
			<!-- ================== 모달 폼 끝 ==================== -->
		</div>
	</div>

<script>
$(function(){
	$("#insertCourse").click(function() {
		window.location = "insertCourse";
	});

	// 강의실 변경시 정원 자동입력
	$('#modalClassNo').change(function() {
		var classNo = $(this).val();
		if (classNo) {
			$.ajax({
				url: '/admin/getMaxPerson',
				type: 'get',
				data: { classNo: classNo },
				success: function(data) {
					$("#modalMaxPerson").val(data);
				}
			});
		} else {
			$("#modalMaxPerson").val("");
		}
	});

	// 수정 버튼 클릭
	$("#modifyBtn").click(function () {
	    const checked = $(".select-course:checked");
	    if (checked.length === 0) {
	        alert("수정할 강의를 선택하세요.");
	        return;
	    }
	    if (checked.length > 1) {
	        alert("하나만 선택 가능합니다.");
	        return;
	    }
	    const courseId = checked.val();

	    $.getJSON("/admin/getCourseDetail", {courseId: courseId}, function(course) {
	    	if(!course) {
				alert("강의 정보를 불러올 수 없습니다.");
				return;
			}
	        $("#modalCourseId").val(course.courseId || "");
	        $("#modalCourseName").val(course.courseName || "");
	        $("#modalDescription").val(course.description || "");
	        $("#modalStartDate").val(course.startDate || "");
	        $("#modalEndDate").val(course.endDate || "");
	        $("#modalTeacherNo").val(course.teacherNo || "");
	        $("#modalClassNo").val(course.classNo || "");
	        $("#modalMaxPerson").val(course.maxPerson || "");
	        $("#courseModal").show();
	    });
	});

	$("#saveCourseBtn").off('click').on('click', function(){
	    $.ajax({
	        url: "/admin/updateCourse",
	        type: "POST",
	        data: $("#courseForm").serialize(),
	        success: function(result) {
	            alert("수정 완료");
	            location.reload();
	        },
	        error: function() {
	            alert("수정 실패");
	        }
	    });
	});

	$("#closeModalBtn").click(function() {
		$("#courseModal").hide();
	});
	$("#removeBtn").click(function(){
	    let checked = $(".select-course:checked");
	    if(checked.length === 0){
	        alert("삭제할 강의를 선택하세요.");
	        return;
	    }
	    if(!confirm("정말 삭제하시겠습니까?")) return;
	    
	    let courseIds = [];
	    checked.each(function(){
	        courseIds.push($(this).val());
	    });

	    $.ajax({
	        url: "/admin/deleteCourses",
	        type: "POST",
	        traditional: true, // List 전송시 필수!
	        data: {courseIds: courseIds},
	        success: function(result){
	            alert("삭제 완료");
	            location.reload();
	        },
	        error: function(){
	            alert("삭제 실패");
	        }
	    });
	});
});
</script>
</body>
</html>
