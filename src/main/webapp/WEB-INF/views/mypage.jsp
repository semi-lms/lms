<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- mypage.jsp (메인 틀 + AJAX 로딩 담당) -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" type="text/css" href="<c:url value='/css/info.css'/>">
</head>
<body>
<div class="container">
  <!-- 왼쪽 메뉴 -->
  <div class="sidebar">
    <c:choose>
      <c:when test="${loginUser.role eq 'admin'}">
        <jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
      </c:when>
      <c:when test="${loginUser.role eq 'teacher'}">
        <jsp:include page="/WEB-INF/views/common/sideBar/teacherSideBar.jsp" />
      </c:when>
      <c:when test="${loginUser.role eq 'student'}">
        <jsp:include page="/WEB-INF/views/common/sideBar/studentSideBar.jsp" />
      </c:when>
    </c:choose>
  </div>

  <!-- 오른쪽 콘텐츠 영역 -->
  <div class="content" id="contentArea"></div>
</div>

<script>

function loadContent(url) {
	  $('#contentArea').load(url);
	}
	
$(document).ready(function () {
	  $('#contentArea').load('/mypage/info', function () {
		 const role = '${loginUser.role}'; // JSP에서 세션 정보 출력
		 const updateUrl = role === 'student' ? '/mypage/updateStudentInfo' : '/mypage/updateInfo';

	    let idCleared = false;

	    // 아이디 수정 가능하게 (최초 클릭 시에만)
	    $('#userIdInput').on('click', function () {
	      if (!idCleared) {
	        $(this).removeAttr("readonly").val("").css({
	          color: "black",
	          backgroundColor: "#fff"
	        }).focus();
	        idCleared = true;
	      }
	    });

	    // 아이디 중복 확인
		$('#checkBtn').on('click', function () {
		  const id = $('#userIdInput').val();
		  if (!id) {
		    alert("아이디를 입력하세요.");
		    return;
		  }
		
		  $.ajax({
		    url: '/mypage/check-id',
		    type: 'POST',
		    contentType: 'application/json',
		    data: JSON.stringify({ teacherId: id }),
		    success: function (data) {
		      alert(data.exists ? "이미 존재하는 아이디입니다." : "사용 가능한 아이디입니다.");
		    }
		  });
		});

		// 비밀번호 실시간 유효성 검사
		$('#newPassword, #confirmPassword, #currentPassword').on('input', function () {
		  const pw = $('#newPassword').val();
		  const confirm = $('#confirmPassword').val();
		  const currentPw = $('#currentPassword').val();

		  $('#pwError').text('');
		  $('#confirmError').text('');
		  $('#currentPwError').text('');

		  // 현재 비밀번호 입력 여부
		  if (!currentPw) {
		    $('#currentPwError').text('현재 비밀번호를 입력하세요.');
		    return;
		  }

		  // 현재 비밀번호와 동일한지 비교
		  if (pw && pw === currentPw) {
		    $('#pwError').text('기존 비밀번호와 동일합니다.');
		  }

		  // 길이 검사
		  if (pw.length > 0 && pw.length < 4) {
		    $('#pwError').text('비밀번호는 최소 4자 이상이어야 합니다.');
		  }

		  // 확인 비밀번호 일치 검사
		  if (confirm.length > 0 && pw !== confirm) {
		    $('#confirmError').text('비밀번호가 일치하지 않습니다.');
		  }
		});

	    // 수정 버튼 클릭 시 최종 유효성 검사
	    $('#submitBtn').on('click', function () {
	      const pw = $('#newPassword').val();
	      const confirm = $('#confirmPassword').val();
	      $('#pwError').text('');
	      $('#confirmError').text('');
	      let hasError = false;

	      if (pw || confirm) {
	        if (pw.length < 4) {
	          $('#pwError').text('비밀번호는 최소 4자 이상이어야 합니다.');
	          hasError = true;
	        }
	        if (pw !== confirm) {
	          $('#confirmError').text('비밀번호가 일치하지 않습니다.');
	          hasError = true;
	        }
	      }

	      if (hasError) return;

	      $.ajax({
	    	  url: updateUrl,
	    	  method: 'POST',
	    	  data: $('#updateForm').serialize(),
	    	  success: function (data) {
	    	    if (data.success) {
	    	      alert("수정 완료!");
	    	      location.reload();
	    	    } else {
	    	      if (data.message === "기존 비밀번호와 동일합니다.") {
	    	        $('#pwError').text(data.message);
	    	      } else {
	    	        alert(data.message);
	    	      }
	    	    }
	    	  },
	    	  error: function () {
	    	    alert("수정 실패");
	    	  }
	    	});
	      
	    });
	  });
	});
	
	
</script>
</body>
</html>
