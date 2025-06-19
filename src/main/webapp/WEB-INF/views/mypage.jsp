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
	  $('#contentArea').load(url, function () {
	    setTimeout(initMypageHandlers, 0); // DOM 완전히 로드 후 바인딩
	  });
	}

	$(document).ready(function () {
	  loadContent('/mypage/info');
	});
	
	$(document).on('input', '#currentPassword', function () {
		  $('#currentPwError').text('');
		});

	function initMypageHandlers() {
	  const role = '${loginUser.role}';
	  const updateUrl = role === 'student' ? '/mypage/updateStudentInfo' : '/mypage/updateTeacherInfo';
	  let idCleared = false;

	  // 아이디 클릭 시 수정 가능
	  $('#userIdInput').on('click', function () {
	    if (!idCleared) {
	      $(this).removeAttr("readonly").val("").css({
	        color: "black",
	        backgroundColor: "#fff"
	      }).focus();
	      idCleared = true;
	    }
	  });

	  // 아이디 중복 검사
	  $('#checkBtn').on('click', function () {
	    const id = $('#userIdInput').val().trim();
	    if (!id) return alert("아이디를 입력하세요.");

	    $.ajax({
	      url: '/mypage/check-id',
	      type: 'POST',
	      contentType: 'application/json',
	      data: JSON.stringify({ teacherId: id }),
	      success: (data) => {
	        alert(data.exists ? "이미 존재하는 아이디입니다." : "사용 가능한 아이디입니다.");
	      },
	      error: () => alert("중복 확인 중 오류 발생")
	    });
	  });

	  // 실시간 비밀번호 검사
	  $('#newPassword, #confirmPassword').on('input', validatePasswords);

	  // 수정 버튼
	  $('#submitBtn').on('click', function () {
	    if (!validateFinal()) return;

	    const currentPw = $('#currentPassword').val().trim();

	    if (isPwChanging()) {
	      // 현재 비밀번호 서버 검증
	      $.ajax({
	        url: '/mypage/checkCurrentPw',
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify({ currentPassword: currentPw }),
	        success: function (data) {
	          if (!data.valid) {
	            setError('#currentPwError', '현재 비밀번호가 일치하지 않습니다.');
	            return;
	          }
	          $('#currentPwError').text('');
	          sendUpdate();
	        },
	        error: () => setError('#currentPwError', '비밀번호 확인 중 오류 발생')
	      });
	    } else {
	      sendUpdate();
	    }
	  });

	  function sendUpdate() {
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
	            setError('#pwError', data.message);
	          } else {
	            alert(data.message);
	          }
	        }
	      },
	      error: () => alert("수정 실패")
	    });
	  }
	}

	// 에러 메세지 출력 유틸
	function setError(selector, message) {
	  $(selector).text(message);
	}

	// 비밀번호 변경 여부 확인
	function isPwChanging() {
	  return $('#newPassword').val().trim() !== "" || $('#confirmPassword').val().trim() !== "";
	}

	// 실시간 비밀번호 검사
	function validatePasswords() {
	  const pw = $('#newPassword').val().trim();
	  const confirm = $('#confirmPassword').val().trim();
	  const currentPw = $('#currentPassword').val().trim();

	  clearErrors();

	  if (!isPwChanging()) return;

	  if (pw.length < 4) setError('#pwError', '비밀번호는 최소 4자 이상이어야 합니다.');
	  if (pw === currentPw && currentPw !== "") setError('#pwError', '기존 비밀번호와 동일합니다.');
	  if (pw && confirm && pw !== confirm) setError('#confirmError', '비밀번호가 일치하지 않습니다.');
	}

	// 최종 유효성 검사
	function validateFinal() {
	  const pw = $('#newPassword').val().trim();
	  const confirm = $('#confirmPassword').val().trim();
	  const currentPw = $('#currentPassword').val().trim();

	  clearErrors();
	  let hasError = false;

	  if (isPwChanging()) {
	    if (!currentPw) {
	      setError('#currentPwError', '현재 비밀번호를 입력하세요.');
	      return false;
	    }
	    if (pw.length < 4) {
	      setError('#pwError', '비밀번호는 최소 4자 이상이어야 합니다.');
	      hasError = true;
	    }
	    if (pw !== confirm) {
	      setError('#confirmError', '비밀번호가 일치하지 않습니다.');
	      hasError = true;
	    }
	    if (pw === currentPw) {
	      setError('#pwError', '기존 비밀번호와 동일합니다.');
	      hasError = true;
	    }
	  }

	  return !hasError;
	}

	// 에러 초기화
	function clearErrors() {
	  $('#pwError').text('');
	  $('#confirmError').text('');
	  $('#currentPwError').text('');
	}
</script>
</body>
</html>
