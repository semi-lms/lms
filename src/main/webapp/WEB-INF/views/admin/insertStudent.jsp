<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>학생 등록 페이지</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
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
	min-width: 220px;
	background: #fafafa;
	height: 100vh;
}

.chart-container {
	margin-top: 32px;
}

.main-content {
	flex: 1;
	background: #fff;
	padding: 40px 40px 40px 300px;
}

.remove-row-btn {
	background: none;
	border: none;
	color: #f44336;
	font-size: 20px;
	cursor: pointer;
	padding: 0 8px;
	line-height: 1;
}

.remove-row-btn:hover {
	color: #b71c1c;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
		</div>
		<div class="main-content">
			<h1>학생 등록 페이지</h1>
			<form action="/admin/insertStudent" method="post" onsubmit="return validateForm()">
				<select name="courseId" required>
					<!-- 등록된 강의 선택 -->
					<option value="">강의 선택</option>
					<c:forEach var="course" items="${course}">
						<option value="${course.courseId}">${course.courseName}</option>
					</c:forEach>
				</select>
				<table border="1" id="studentTable">
					<thead>
						<tr>
							<th></th>
							<th>이름</th>
							<th>전화번호</th>
							<th>주민번호</th>
							<th>주소</th>
							<th>이메일</th>
							<th>초기 아이디</th>
							<th>초기 비밀번호</th>
						</tr>
					</thead>
					<tbody id="studentTableBody">
						<%
                			for(int i=0; i<5; i++){	
                		%>
							<tr>
								<td></td>
								<td><input type="text" name="studentList[<%=i%>].name"></td>
								<td><input type="text" name="studentList[<%=i%>].phone" class="phone-input"></td>
								<td><input type="text" name="studentList[<%=i%>].sn"></td>
								<td><input type="text" name="studentList[<%=i%>].address"></td>
								<td><input type="email" name="studentList[<%=i%>].email"></td>
								<td><input type="text" name="studentList[<%=i%>].studentId"	readonly></td>
								<td><input type="text" name="studentList[<%=i%>].password" readonly></td>
							</tr>
						<%					
			               	}
						%>
					</tbody>
				</table>
				<button type="button" id="insertRowBtn">행 추가</button>
				<button type="submit">등록하기</button>
			</form>
		</div>
	</div>
<script>
	let rowIdx = 5;

	// 아이디 6자리로 랜덤하게 부여
	function randomId(length = 6) {
	    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
	    let result = "";
	    for (let i = 0; i < length; i++) {
	        result += chars.charAt(Math.floor(Math.random() * chars.length));
	    }
	    return result;
	}
	
	$(function () {
	    // 행 추가 버튼 클릭하면 1행씩 추가
		$("#insertRowBtn").click(function () {
		    let html = `
		        <tr>
		            <td><button type="button" class="remove-row-btn" title="행 삭제">&times;</button></td>
		            <td><input type="text" name="studentList[\${rowIdx}].name"></td>
		            <td><input type="text" name="studentList[\${rowIdx}].phone" class="phone-input"></td>
		            <td><input type="text" name="studentList[\${rowIdx}].sn"></td>
		            <td><input type="text" name="studentList[\${rowIdx}].address"></td>
		            <td><input type="email" name="studentList[\${rowIdx}].email"></td>
		            <td><input type="text" name="studentList[\${rowIdx}].studentId" readonly></td>
		            <td><input type="text" name="studentList[\${rowIdx}].password" readonly></td>
		        </tr>
		    `;
		    $("#studentTableBody").append(html);
		    rowIdx++;
		});
	
	    // 행 삭제
	    $("#studentTableBody").on("click", ".remove-row-btn", function () {
	        $(this).closest("tr").remove();
	    });
	
	    // 전화번호 입력 시 자동 ID/비밀번호 세팅
	    $("#studentTableBody").on("input", ".phone-input", function () {
	        // 1. 자동 하이픈
	        let value = $(this).val().replace(/[^0-9]/g, "");
	        let result = "";

	        if (value.length < 4) {
	            result = value;
	        } else if (value.length < 8) {
	            result = value.substr(0, 3) + "-" + value.substr(3);
	        } else if (value.length <= 11) {
	            result = value.substr(0, 3) + "-" + value.substr(3, 4) + "-" + value.substr(7);
	        } else {
	            result = value.substr(0, 3) + "-" + value.substr(3, 4) + "-" + value.substr(7, 4);
	        }
	        $(this).val(result);
	    	
	        const $row = $(this).closest("tr");
	        const phone = this.value.replace(/[^0-9]/g, "");
	        if (phone.length >= 4) {
				// 휴대폰 번호 뒤 4자리를 비밀번호로 설정
	            let pw = phone.slice(-4);
	            $row.find("input[name$='.password']").val(pw);
	            $row.find("input[name$='.studentId']").val(randomId(6));
	        } else {
	            $row.find("input[name$='.password']").val('');
	            $row.find("input[name$='.studentId']").val('');
	        }
	    });
	});
	$("#studentTableBody").on("input", "input[name$='.sn']", function() {
	    let value = $(this).val().replace(/[^0-9]/g, "");
	    let result = "";

	    if (value.length <= 6) {
	        result = value;
	    } else if (value.length <= 13) {
	        result = value.substr(0, 6) + "-" + value.substr(6);
	    } else {
	        result = value.substr(0, 6) + "-" + value.substr(6, 7);
	    }
	    $(this).val(result);
	});
	
	
	function validateForm() {
	    let isAnyRowInvalid = false;
	    let hasAtLeastOneRow = false;

	    $("#studentTableBody tr").each(function (index) {
	        const $inputs = $(this).find("input[type='text']:not([readonly]), input[type='email']");
	        let rowHasValue = false;
	        let rowIsValid = true;

	        $inputs.each(function () {
	            const val = $(this).val().trim();
	            if (!val) {
	                rowIsValid = false;
	                $(this).css("border", "2px solid red");
	            } else {
	                rowHasValue = true;
	                $(this).css("border", "");
	            }
	        });

	        // 이메일 형식 검사 추가
	        const $emailInput = $(this).find("input[type='email']");
	        if ($emailInput.length && $emailInput.val().trim()) {
	            var email = $emailInput.val().trim();
	            var emailReg = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
	            if (!emailReg.test(email)) {
	                rowIsValid = false;
	                $emailInput.css("border", "2px solid red");
	                alert("이메일 형식이 올바르지 않습니다.");
	            }
	        }

	        // 전화번호 형식 검사 추가 (예: 01012345678 또는 010-1234-5678)
	        const $phoneInput = $(this).find("input[name$='.phone']");
	        if ($phoneInput.length && $phoneInput.val().trim()) {
	            var phone = $phoneInput.val().replace(/-/g, "");
	            var phoneReg = /^01[016789][0-9]{7,8}$/;
	            if (!phoneReg.test(phone)) {
	                rowIsValid = false;
	                $phoneInput.css("border", "2px solid red");
	                alert("전화번호 형식이 올바르지 않습니다.");
	            }
	        }

	        // 주민번호 형식 검사 추가 (예: 6자리-7자리)
	        const $snInput = $(this).find("input[name$='.sn']");
	        if ($snInput.length && $snInput.val().trim()) {
	            var sn = $snInput.val().trim();
	            var snReg = /^[0-9]{6}-?[0-9]{7}$/;
	            if (!snReg.test(sn)) {
	                rowIsValid = false;
	                $snInput.css("border", "2px solid red");
	                alert("주민번호 형식이 올바르지 않습니다.");
	            }
	        }

	        if (rowHasValue && rowIsValid) {
	            hasAtLeastOneRow = true;
	        }
	        if (rowHasValue && !rowIsValid) {
	            isAnyRowInvalid = true;
	        }
	    });

	    if (isAnyRowInvalid) {
	        // 이미 alert로 안내했으므로 추가 alert 생략
	        return false;
	    }

	    if (!hasAtLeastOneRow) {
	        alert("최소 1명의 학생 정보를 모두 입력하세요.");
	        return false;
	    }

	    // ... (이하 기존 코드 동일)
	    // 모든 칸이 비어있는 row는 name 속성 제거 (Spring에서 무시됨)
	    $("#studentTableBody tr").each(function () {
	        let allEmpty = true;
	        $(this).find("input[type='text']:not([readonly]), input[type='email']").each(function () {
	            if ($(this).val().trim()) {
	                allEmpty = false;
	            }
	        });
	        if (allEmpty) {
	            $(this).find("input").removeAttr("name");
	        }
	    });
	    
	    $("#studentTableBody tr").each(function () {
	        $(this).find("input").each(function () {
	            var name = $(this).attr("name");
	            if (name && name.match(/studentList\[\]/)) {
	                $(this).removeAttr("name");
	            }
	        });
	    });
	    return true;
	}
</script>
</body>
</html>
