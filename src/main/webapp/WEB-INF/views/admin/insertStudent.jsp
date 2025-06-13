<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>학생 등록 페이지</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<style>
body { margin: 0; padding: 0; }
.container { display: flex; width: 100%; }
.sidebar { min-width: 220px; background: #fafafa; height: 100vh; }
.chart-container { margin-top: 32px; }
.main-content { flex: 1; background: #fff; padding: 40px 40px 40px 300px; }
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
        <form action="/admin/insertStudent" method="post">
            <select name="studentList[0].courseId" required>
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
                    <tr>
                        <td></td>
                        <td><input type="text" name="studentList[0].name"></td>
                        <td><input type="text" name="studentList[0].phone" class="phone-input"></td>
                        <td><input type="text" name="studentList[0].sn"></td>
                        <td><input type="text" name="studentList[0].address"></td>
                        <td><input type="email" name="studentList[0].email"></td>
                        <td><input type="text" name="studentList[0].studentId" readonly></td>
                        <td><input type="text" name="studentList[0].password" readonly></td>
                    </tr>
                </tbody>
            </table>
            <button type="button" id="insertRowBtn">행 추가</button>
            <button type="submit">등록하기</button>
        </form>
    </div>
</div>
<script>
let rowIdx = 1;

function randomId(len = 6) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    let result = "";
    for(let i=0; i<len; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
}

$(function() {
    // 행 추가 버튼
    $("#insertRowBtn").click(function(){
        let html = `
            <tr>
                <td><button type="button" class="remove-row-btn" title="행 삭제">&times;</button></td>
                <td><input type="text" name="studentList[${rowIdx}].name"></td>
                <td><input type="text" name="studentList[${rowIdx}].phone" class="phone-input"></td>
                <td><input type="text" name="studentList[${rowIdx}].sn"></td>
                <td><input type="text" name="studentList[${rowIdx}].address"></td>
                <td><input type="email" name="studentList[${rowIdx}].email"></td>
                <td><input type="text" name="studentList[${rowIdx}].studentId" readonly></td>
                <td><input type="text" name="studentList[${rowIdx}].password" readonly></td>
            </tr>
        `;
        $("#studentTableBody").append(html);
        rowIdx++;
    });

    // 삭제 버튼 이벤트 위임
    $("#studentTableBody").on("click", ".remove-row-btn", function() {
        $(this).closest("tr").remove();
    });

    // 자동 아이디/비번
    $("#studentTableBody").on('input', '.phone-input', function() {
        const $row = $(this).closest('tr');
        const phone = this.value.replace(/[^0-9]/g, "");
        if (phone.length >= 4) {
            let pw = phone.slice(-4);
            $row.find("input[name$='.password']").val(pw);
            $row.find("input[name$='.studentId']").val(randomId(6));
        } else {
            $row.find("input[name$='.password']").val('');
            $row.find("input[name$='.studentId']").val('');
        }
    });

    // 등록 전 빈 칸 체크
    $("form").on("submit", function(e) {
        let isEmpty = false;
        $("#studentTableBody tr").each(function() {
            $(this).find("input[type='text']:not([readonly]), input[type='email']").each(function() {
                if (!$(this).val().trim()) {
                    isEmpty = true;
                    $(this).css("border", "2px solid red");
                } else {
                    $(this).css("border", "");
                }
            });
        });
        if (isEmpty) {
            alert("어허! 공백이 생기면 쓰나!! 뗶!!");
            e.preventDefault();
        }
    });
});
</script>
</body>
</html>
