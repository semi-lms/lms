<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 목록</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/course.css">
<style>
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/common/sideBar/adminSideBar.jsp" />
		</div>
		<div class="main-content">
			<h1>강의 목록</h1>
			<form method="get" id="searchForm">

				<div class="search-group">
					<select name="searchOption" id="searchOption">
						<option value="all" ${searchOption == 'all' ? 'selected' : ''}>전체</option>
						<option value="teacherName"
							${searchOption == 'teacherName' ? 'selected' : ''}>강사</option>
						<option value="courseName"
							${searchOption == 'courseName' ? 'selected' : ''}>강의명</option>
					</select> <input type="text" name="keyword" id="keyword" value="${keyword}"
						placeholder="검색">
					<button type="submit" id="searchBtn">검색</button>
				</div>
				<table class="board-table">
					<thead>
						<tr>
							<th>담당 강사</th>
							<th>강의명</th>
							<th>기간</th>
							<th>강의실</th>
							<th>수강 인원</th>
							<th>선택</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="course" items="${courseList}">
							<tr>
								<td><c:choose>
										<c:when test="${empty course.teacherName}">
      미정
    </c:when>
										<c:otherwise>
      ${course.teacherName}
    </c:otherwise>
									</c:choose></td>
								<td>${course.courseName}</td>
								<td>${course.startDate}</td>
								<td><a
									href="/admin/attendanceByClass?courseId=${course.courseId}">
										${course.classroom} </a></td>
								<td>${course.applyPerson}</td>
								<td><input type="checkbox" class="select-course"
									value="${course.courseId}"></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<div class="button-group">
					<button type="button" id="insertCourse">➕ 강의 등록</button>
					<button type="button" id="modifyBtn">💾 수정</button>
					<button type="button" id="removeBtn">❌ 삭제</button>
				</div>

			</form>

			<div class="pagination">
				<c:forEach var="i" begin="${startPage}" end="${endPage}">
					<c:choose>
						<c:when test="${i == currentPage}">
							<span class="current">${i}</span>
						</c:when>
						<c:otherwise>
							<a
								href="?currentPage=${i}&searchOption=${searchOption}&keyword=${keyword}">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
			<!-- 모달 폼 -->
			<div id="courseModal">
				<form id="courseForm">
					<input type="hidden" name="courseId" id="modalCourseId">
					<table class="modal-table">
						<tr>
							<th>담당 강사</th>
							<td><select name="teacherNo" id="modalTeacherNo" required>
									<option value="">강사 선택</option>
									<c:forEach var="teacher" items="${teacherList}">
										<option value="${teacher.teacherNo}">${teacher.name}</option>
									</c:forEach>
							</select></td>
						</tr>
						<tr>
							<th>강의명</th>
							<td><input type="text" name="courseName"
								id="modalCourseName" required></td>
						</tr>
						<tr>
							<th>강의 설명</th>
							<td><input type="text" name="description"
								id="modalDescription" required></td>
						</tr>
						<tr>
							<th>기간</th>
							<td><input type="date" name="startDate" id="modalStartDate"
								required> ~ <input type="date" name="endDate"
								id="modalEndDate" required></td>
						</tr>
						<tr>
							<th>강의실</th>
							<td><select name="classNo" id="modalClassNo" required>
									<option value="">강의실 선택</option>
									<c:forEach var="classroom" items="${classList}">
										<option value="${classroom.classNo}">${classroom.classroom}</option>
									</c:forEach>
							</select></td>
						</tr>
						<tr>
							<th>수강정원</th>
							<td><input type="text" name="maxPerson" id="modalMaxPerson"
								required></td>
						</tr>
					</table>

					<div class="button-group">
						<button type="button" id="saveCourseBtn">저장</button>
						<button type="button" id="closeModalBtn">닫기</button>
					</div>
				</form>
			</div>
			<!-- 모달 폼 끝 -->
		</div>
	</div>
<script>
function reloadClassListForUpdate(courseId, startDate, endDate, originalClassNo) {
    $.getJSON("/admin/selectClassListForUpdate", {
        courseId: courseId,
        startDate: startDate,
        endDate: endDate,
        originalClassNo: originalClassNo // 기존 강의실 번호를 originalClassNo로 넘김
    }, function(classList) {
        var $select = $("#modalClassNo");
        $select.empty();
        $select.append('<option value="">강의실 선택</option>');
        $.each(classList, function(i, classroom) {
            var selected = (classroom.classNo == originalClassNo) ? "selected" : "";
            $select.append('<option value="' + classroom.classNo + '" ' + selected + '>' + classroom.classroom + '</option>');
        });
        // 강의실 옵션 바뀌었으니, maxPerson도 새로고침
        if (originalClassNo) {
            $.get('/admin/getMaxPerson', { classNo: originalClassNo }, function(data) {
                $("#modalMaxPerson").val(data);
            });
        } else {
            $("#modalMaxPerson").val("");
        }
    });
}

$(function() {
    $("#insertCourse").click(function() {
        window.location = "insertCourse";
    });

    // 강의실 변경 시 수강정원 자동 입력
    $('#modalClassNo').change(function() {
        const classNo = $(this).val();
        if (classNo) {
            $.get('/admin/getMaxPerson', {
                classNo: classNo
            }, function(data) {
                $("#modalMaxPerson").val(data);
            });
        } else {
            $("#modalMaxPerson").val("");
        }
    });

    // 수정 버튼 클릭 - 강의실 목록 동적 로딩
    $("#modifyBtn").click(function() {
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

        $.getJSON("/admin/getCourseDetail", { courseId: courseId }, function(course) {
            if (!course) {
                alert("강의 정보를 불러올 수 없습니다.");
                return;
            }
            $("#modalCourseId").val(course.courseId || "");
            $("#modalCourseName").val(course.courseName || "");
            $("#modalDescription").val(course.description || "");
            $("#modalStartDate").val(course.startDate || "");
            $("#modalEndDate").val(course.endDate || "");
            $("#modalTeacherNo").val(course.teacherNo || "");
            $("#modalMaxPerson").val(course.maxPerson || "");

            // 강의실 목록 동적 로딩 (기존 강의실 번호를 originalClassNo로 넘김)
            reloadClassListForUpdate(
                course.courseId,
                course.startDate,
                course.endDate,
                course.classNo
            );

            // 강의실 번호를 hidden input에 임시 저장
            $("#modalClassNo").data("originalClassNo", course.classNo);

            $("#courseModal").show();
        });
    });

    // 시작일/종료일이 바뀔 때마다 강의실 목록 새로고침
    $("#modalStartDate, #modalEndDate").on("change", function() {
        var courseId = $("#modalCourseId").val();
        var startDate = $("#modalStartDate").val();
        var endDate = $("#modalEndDate").val();
        // 현재 선택된 강의실 번호 (원본을 계속 넘겨야 함)
        var originalClassNo = $("#modalClassNo").data("originalClassNo") || $("#modalClassNo").val();
        if (courseId && startDate && endDate && originalClassNo) {
            reloadClassListForUpdate(courseId, startDate, endDate, originalClassNo);
        }
    });

    // 저장 버튼 클릭(유효성 검사 포함)
    $("#saveCourseBtn").click(function() {
        // 값 읽기
        var teacherNo = $("#modalTeacherNo").val();
        var courseName = $("#modalCourseName").val().trim();
        var description = $("#modalDescription").val().trim();
        var startDate = $("#modalStartDate").val();
        var endDate = $("#modalEndDate").val();
        var classNo = $("#modalClassNo").val();
        var maxPerson = $("#modalMaxPerson").val().trim();

        // 유효성 검사
        if (!teacherNo) {
            alert("담당 강사를 선택하세요.");
            $("#modalTeacherNo").focus();
            return;
        }
        if (!courseName) {
            alert("강의명을 입력하세요.");
            $("#modalCourseName").focus();
            return;
        }
        if (!description) {
            alert("강의 설명을 입력하세요.");
            $("#modalDescription").focus();
            return;
        }
        if (description.length < 5) {
            alert("강의 설명은 5자 이상 입력하세요.");
            $("#modalDescription").focus();
            return;
        }
        if (!startDate) {
            alert("시작일을 선택하세요.");
            $("#modalStartDate").focus();
            return;
        }
        if (!endDate) {
            alert("종료일을 선택하세요.");
            $("#modalEndDate").focus();
            return;
        }
        if (endDate < startDate) {
            alert("종료일은 시작일보다 빠를 수 없습니다.");
            $("#modalEndDate").focus();
            return;
        }
        if (!classNo) {
            alert("강의실을 선택하세요.");
            $("#modalClassNo").focus();
            return;
        }
        if (!maxPerson || isNaN(maxPerson) || parseInt(maxPerson) <= 0) {
            alert("수강정원은 1명 이상의 숫자로 입력하세요.");
            $("#modalMaxPerson").focus();
            return;
        }

        // 통과 시 AJAX 저장
        $.ajax({
            url : "/admin/updateCourse",
            type : "POST",
            data : $("#courseForm").serialize(),
            success : function(result) {
                if(result == "overlap") {
                    alert("해당 기간에 이미 사용 중인 강의실입니다.");
                    return;
                }
                alert("수정 완료");
                location.reload();
            },
            error : function() {
                alert("수정 실패");
            }
        });
    });

    // 모달 닫기
    $("#closeModalBtn").click(function() {
        $("#courseModal").hide();
    });

    // 삭제 버튼 클릭
    $("#removeBtn").click(function() {
        const checked = $(".select-course:checked");
        if (checked.length === 0) {
            alert("삭제할 강의를 선택하세요.");
            return;
        }
        if (!confirm("정말 삭제하시겠습니까?"))
            return;

        const courseIds = checked.map(function() {
            return $(this).val();
        }).get();

        $.ajax({
            url : "/admin/deleteCourses",
            type : "POST",
            traditional : true,
            data : {
                courseIds : courseIds
            },
            success : function() {
                alert("삭제 완료");
                location.reload();
            },
            error : function() {
            	alert("담당 강사가 배정된 강의는 삭제할 수 없습니다.");
            }
        });
    });
});
	</script>
</body>
</html>
