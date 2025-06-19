<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<style>
body {
  margin: 0;
  padding: 0;
}
.container {
  display: flex;
  width: 100%;
}
.sidebar {
  min-width: 220px;   /* 필요시 사이드바 너비 늘리세요 */
  background: #fafafa;
  height: 100vh;
}
.chart-container {
  margin-top: 32px;
}
.main-content {
  flex: 1;
  background: #fff;
  padding: 40px 40px 40px 300px; /* 왼쪽 패딩을 140px로 늘림 */
}
</style>
<body>
<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
	<h1>학생 리스트</h1>
		<form action="/admin/studentList" method="get">
			<table border="1">
				<tr>
					<th>이름</th>
					<th>전화번호</th>
					<th>주민번호</th>
					<th>주소</th>
					<th>이메일</th>
					<th>아이디</th>
					<th>수강과목</th>
					<th>선택</th>
				</tr>
				<c:forEach var="sList" items="${studentList}">
					<tr>
						<td>${sList.name }</td>	
						<td>${sList.phone }</td>	
						<td>
							<c:choose>
								<c:when test="${fn:length(sList.sn) == 13}">
								  <c:out value="${fn:substring(sList.sn, 0, 6)}"/>-*******
								</c:when>
								<c:otherwise>
									${sList.sn}
								</c:otherwise>
							</c:choose>
						</td>	
						<td>${sList.address }</td>	
						<td>${sList.email }</td>	
						<td>${sList.studentId }</td>	
						<td>${sList.courseName }</td>
						<td><input type="checkbox" class="selectStudent" value="${sList.studentNo}"></td>
					</tr>
				</c:forEach>
			</table>
			<c:if test="${loginUser.adminId eq 'admin'}">
			  <button type="button" id="insertStudent">학생등록</button>
			  <button type="button" id="modifyBtn">수정</button>
			  <button type="button" id="removeBtn">삭제</button>
			</c:if>
			<br>
			<select name="searchOption">
				<option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
				<option value="studentName" ${searchOption == 'studentName' ? 'selected' : ''}>이름</option>
				<option value="courseName" ${searchOption == 'courseName' ? 'selected' : ''}>수강과목</option>
			</select>
			<input type="text" name="keyword" id="keyword">
			<button type="submit" id="keyword">검색</button>
		</form>
		
		<c:if test="${page.lastPage>1}">
			<c:if test="${startPage>1}">
				<a href="/admin/studentList?currentPage=${startPage-1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[이전]</a>
			</c:if>
		</c:if>
		
		<c:forEach var="i" begin="${startPage}" end="${endPage}">
			<c:choose>
				<c:when test="${i == page.currentPage }">
					<span>[${i}]</span>
				</c:when>
				<c:otherwise>
					<a href="/admin/studentList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[${i}]</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		
		<c:if test="${endPage < page.lastPage}">
			<a href="/admin/studentList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[다음]</a>
		</c:if>
		
<div id="studentModal" style="display:none; position:fixed; left:50%; top:30%; transform:translate(-50%,0); background:#fff; border:1px solid #888; padding:32px; z-index:999;">
    <form id="studentForm">
        <input type="hidden" name="studentNo" id="modalStudentNo">
  	    <input type="hidden" name="studentId" id="modalStudentId">
   		<input type="hidden" name="password" id="modalPassword">
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
            
        </table>
        <button type="button" id="saveStudentBtn">저장</button>
        <button type="button" id="closeStudentModalBtn">닫기</button>
    </form>
</div>
    </div>
</div>
<script>
$(function(){
    $("#insertStudent").click(function(){
        window.location = "insertStudent";
    });

    $("#modifyBtn").click(function () {
        const checked = $(".selectStudent:checked");
        if (checked.length === 0) {
            alert("수정할 학생을 선택하세요.");
            return;
        }
        if (checked.length > 1) {
            alert("하나만 선택 가능합니다.");
            return;
        }
        const studentNo = checked.val();
        console.log("선택한 studentNo =", studentNo);
        
        $.getJSON("/admin/getStudentDetail", {studentNo: studentNo}, function(student) {
        	console.log("조회된 student", student);
        	if(!student) {
                alert("학생 정보를 불러올 수 없습니다.");
                return;
            }
            $("#modalName").val(student.name || "");
            $("#modalPhone").val(student.phone || "");
            $("#modalSn").val(student.sn || "");
            $("#modalAddress").val(student.address || "");
            $("#modalEmail").val(student.email || "");
            $("#modalStudentIdView").val(student.studentId || "");
            $("#modalStudentNo").val(student.studentNo);
            $("#modalStudentId").val(student.studentId || "");
            $("#modalPassword").val(student.password || "");
            $("#studentModal").show();
        });
    });

    $("#saveStudentBtn").off('click').on('click', function(){
    	var email = $("#modalEmail").val().trim();
    	var emailReg = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
        if (!emailReg.test(email)) {
            alert("이메일 형식이 올바르지 않습니다.");
            return;
        }
        
        $.ajax({
            url: "/admin/updateStudent",
            type: "POST",
            data: $("#studentForm").serialize(),
            success: function(result) {
                alert("수정 완료");
                location.reload();
            },
            error: function() {
                alert("수정 실패");
            }
        });
    });

    $("#closeStudentModalBtn").click(function() {
        $("#studentModal").hide();
    });

    // [삭제] 기능 구현
    $("#removeBtn").click(function(){
        const checked = $(".selectStudent:checked");
        if (checked.length === 0) {
            alert("삭제할 학생을 선택하세요.");
            return;
        }
        if(!confirm("정말 삭제하시겠습니까?")) return;

        let studentIds = [];
        checked.each(function(){
            studentIds.push($(this).val());
        });

        $.ajax({
            url: "/admin/deleteStudents",
            type: "POST",
            traditional: true,
            data: {studentIds: studentIds},
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