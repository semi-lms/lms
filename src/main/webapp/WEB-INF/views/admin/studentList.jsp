<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>학생 리스트</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
  /* 공통 폰트 및 기본 스타일 */
 

  /* 컨테이너: sidebar + main-content */
  .container {
    display: flex;
    width: 100%;
  }



  /* 메인 컨텐츠 영역 */
.main-content {
  margin-left: 300px; /* 사이드바 너비와 동일하게 */
  padding: 40px;
  background-color: #fff;
  min-height: 100vh;
  box-sizing: border-box;
  position: relative;
}

  /* 제목 */
  h1 {
   margin-bottom: 20px;
  font-weight: 700;
  color: #2c3e50;
  text-align: center;
  }

  /* 검색영역 */
  .search-container {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    margin-bottom: 16px;
    gap: 8px;
  }

  .search-container select,
  .search-container input[type="text"] {
    padding: 8px 12px;
    font-size: 14px;
    border: 1px solid #bbb;
    border-radius: 4px;
  }

  .search-container button {
    padding: 8px 14px;
    font-size: 14px;
    border: none;
    background-color: #2c3e50;
    color: white;
    border-radius: 4px;
    cursor: pointer;
  }

  .search-container button:hover {
     background-color: #1a252f;
  }

  /* 테이블 스타일 (공지/자료실과 동일) */
  table {
    width: 100%;
    border-collapse: collapse;
    background-color: #fff;
    margin-bottom: 16px;
  }

  table th,
  table td {
    border: 1px solid #ddd;
    padding: 12px 10px;
    text-align: center;
    font-size: 14px;
  }
  

  table th {
    background-color: #2c3e50;
    font-weight: 600;
    color : white;
  }

  /* 버튼 영역 - 오른쪽 아래 고정 */
.button-group {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 30px;
  margin-right: 60px;
  flex-wrap: wrap;
}

  .button-group button {
    background-color: white;
    border: 1px solid black;
    color: black;
    padding: 10px 16px;
    margin-left: 8px;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
  }

  .button-group button:hover {
    background-color: #0056b3;
  }

  /* 페이징 스타일 (공지/자료실 스타일 참고) */
  .pagination {
    text-align: center;
    margin-top: 40px;
    user-select: none;
  }

  .pagination a,
  .pagination span {
    display: inline-block;
    margin: 0 4px;
    padding: 6px 12px;
    color: #2c3e50;
    border: 1px solid #ddd;
    border-radius: 4px;
    text-decoration: none;
    font-size: 14px;
  }

  .pagination a:hover {
    background-color: #2c3e50;
    color: white;
  }

  .pagination span {
    background-color: #2c3e50;
    color: white;
    border-color: #2c3e50;
    font-weight: 600;
    cursor: default;
  }
  #studentModal {
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

#studentModal table {
	width: 100%;
	border-collapse: collapse;
}

#studentModal th,
#studentModal td {
	padding: 8px;
	text-align: left;
}

#studentModal input,
#studentModal select {
	width: 100%;
	padding: 6px;
	box-sizing: border-box;
	border: 1px solid #ccc;
	border-radius: 4px;
}
</style>
</head>
<body>
<div class="container">
  <div class="sidebar">
    <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
  </div>
  <div class="main-content">
    <h1>학생 리스트</h1>

    <!-- 검색 영역 -->
    <form action="/admin/studentList" method="get" class="search-container">
      <select name="searchOption">
        <option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
        <option value="studentName" ${searchOption == 'studentName' ? 'selected' : ''}>이름</option>
        <option value="courseName" ${searchOption == 'courseName' ? 'selected' : ''}>수강과목</option>
      </select>
      <input type="text" name="keyword" id="keyword" value="${keyword != null ? keyword : ''}" />
      <button type="submit">검색</button>
    </form>

    <!-- 학생 리스트 테이블 -->
    <form>
      <table>
        <thead>
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
        </thead>
        <tbody>
          <c:forEach var="student" items="${studentList}">
            <tr>
              <td>${student.name}</td>
              <td>${student.phone}</td>
              <td>
                <c:choose>
                  <c:when test="${fn:length(student.sn) == 13}">
                    <c:out value="${fn:substring(student.sn, 0, 6)}" />-*******
                  </c:when>
                  <c:otherwise>
                    ${student.sn}
                  </c:otherwise>
                </c:choose>
              </td>
              <td>${student.address}</td>
              <td>${student.email}</td>
              <td>${student.studentId}</td>
              <td>${student.courseName}</td>
              <td><input type="checkbox" class="selectStudent" value="${student.studentNo}" /></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </form>

    <!-- 버튼 그룹 -->
    <div class="button-group">
      <c:if test="${loginUser.adminId eq 'admin'}">
        <button type="button" id="insertStudent">➕ 학생등록</button>
        <button type="button" id="modifyBtn">💾 수정</button>
        <button type="button" id="removeBtn">❌ 삭제</button>
      </c:if>
    </div>
	<!-- 모달 -->
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
	
    <!-- 페이징 -->
    <div class="pagination">
      <c:if test="${page.lastPage > 1}">
        <c:if test="${startPage > 1}">
          <a href="/admin/studentList?currentPage=${startPage-1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[이전]</a>
        </c:if>
      </c:if>
      <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <c:choose>
          <c:when test="${i == page.currentPage}">
            <span>${i}</span>
          </c:when>
          <c:otherwise>
            <a href="/admin/studentList?currentPage=${i}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">${i}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>
      <c:if test="${endPage < page.lastPage}">
        <a href="/admin/studentList?currentPage=${endPage+1}&rowPerPage=${page.rowPerPage}&searchOption=${searchOption}&keyword=${keyword}">[다음]</a>
      </c:if>
    </div>
  </div>
</div>

<script>
$(function(){
	// 주민번호 자동 하이픈 + 입력 완료시 다음칸 이동
	$("#modalSn").on("input", function() {
	    let value = $(this).val().replace(/[^0-9]/g, "");
	    if (value.length > 6) {
	        value = value.substr(0, 6) + "-" + value.substr(6, 7);
	    }
	    $(this).val(value);

	    // 14자리(6+1+7) 다 입력하면 다음 칸 이동
	    if ($(this).val().length === 14) {
	        $("#modalAddress").focus();
	    }
	});

	// 전화번호 자동 하이픈 + 입력 완료시 다음칸 이동
	$("#modalPhone").on("input", function() {
	    let value = $(this).val().replace(/[^0-9]/g, "");
	    let formatted = "";
	    if (value.length < 4) {
	        formatted = value;
	    } else if (value.length < 8) {
	        formatted = value.substr(0, 3) + "-" + value.substr(3);
	    } else if (value.length <= 11) {
	        formatted = value.substr(0, 3) + "-" + value.substr(3, 4) + "-" + value.substr(7, 4);
	    } else {
	        formatted = value.substr(0, 3) + "-" + value.substr(3, 4) + "-" + value.substr(7, 4);
	    }
	    $(this).val(formatted);

	    // 휴대폰 번호가 13자리면 자동으로 주민번호로 포커스 이동
	    if ($(this).val().length === 13) {
	        $("#modalSn").focus();
	    }
	});
    
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
        // 1. 값 읽기
        var name = $("#modalName").val().trim();
        var phone = $("#modalPhone").val().replace(/-/g, "").trim();
        var sn = $("#modalSn").val().trim();
        var address = $("#modalAddress").val().trim();
        var email = $("#modalEmail").val().trim();

        // 2. 유효성 검사
        if (!name) {
            alert("이름을 입력하세요.");
            $("#modalName").focus();
            return;
        }
        if (!phone || !/^01[016789][0-9]{7,8}$/.test(phone)) {
            alert("전화번호 형식이 올바르지 않습니다.");
            $("#modalPhone").focus();
            return;
        }
        if (!sn || !/^[0-9]{6}-?[0-9]{7}$/.test(sn)) {
            alert("주민번호 형식이 올바르지 않습니다.");
            $("#modalSn").focus();
            return;
        }     
        if (!address) {
            alert("주소를 입력하세요.");
            $("#modalAddress").focus();
            return;
        }
        if (!email || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) {
            alert("이메일 형식이 올바르지 않습니다.");
            $("#modalEmail").focus();
            return;
        }

        // 3. 통과 시 AJAX로 저장
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
