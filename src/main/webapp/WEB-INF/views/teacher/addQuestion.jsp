<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>시험 문제 등록</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f0f0f0;
            padding: 30px;
        }
        .question-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .question-btn {
            padding: 10px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-blue {
            background-color: #007bff;
            color: white;
        }
        .btn-red {
            background-color: #dc3545;
            color: white;
        }
        .card {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .submit-btn {
            display: block;
            margin: 30px auto 0;
            padding: 12px 24px;
            background-color: #28a745;
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">시험 문제 입력</h2>

<div class="question-buttons" id="questionButtons"></div>

<div class="card">
    <form id="questionForm">
        <div class="form-group">
            <label>문제 제목</label>
            <input type="text" id="questionTitle">
        </div>
        <div class="form-group">
            <label>문제 지문 (선택)</label>
            <textarea id="questionText" rows="3"></textarea>
        </div>
        <div class="form-group">
            <label>보기 1</label>
            <input type="text" id="option1">
        </div>
        <div class="form-group">
            <label>보기 2</label>
            <input type="text" id="option2">
        </div>
        <div class="form-group">
            <label>보기 3</label>
            <input type="text" id="option3">
        </div>
        <div class="form-group">
            <label>보기 4</label>
            <input type="text" id="option4">
        </div>
        <div class="form-group">
            <label>정답 번호 (1~4)</label>
            <select id="correctNo">
                <option value="">선택</option>
                <option value="1">1번</option>
                <option value="2">2번</option>
                <option value="3">3번</option>
                <option value="4">4번</option>
            </select>
        </div>
    </form>
</div>

<button class="submit-btn" onclick="submitAll()">➕ 등록</button>

<script>
	

    const totalQuestions = 10;
    let currentIndex = 0;
    let questions = Array.from({ length: totalQuestions }, () => ({
        questionTitle: '',
        questionText: '',
        options: ['', '', '', ''],
        correctNo: ''
    }));
	
    // 문제 번호 버튼 생성
    const questionButtons = document.getElementById('questionButtons');

    for (let q = 0; q < totalQuestions; q++) {
    	console.log(`버튼 생성 중: ${q + 1}`);
    	const btn = document.createElement('button');
        btn.type = 'button';
        btn.textContent = '' + (q + 1); // 번호 정상 출력
        btn.className = 'question-btn btn-red';
        btn.dataset.index = q; // 인덱스 저장

        btn.addEventListener('click', (e) => {
            const idx = parseInt(e.target.dataset.index);
            loadQuestion(idx);
        });

        questionButtons.appendChild(btn);
    }
	
 	// 현재 문제 번호 표시용 요소 추가
    const currentLabel = document.createElement('div');
    currentLabel.id = 'currentLabel';
    currentLabel.style.textAlign = 'center';
    currentLabel.style.marginTop = '10px';
    document.body.insertBefore(currentLabel, document.querySelector('.card'));
    
    
    function loadQuestion(index) {
        saveCurrentQuestion();
        currentIndex = index;
        
        // 입력값 채우기
        const q = questions[index];
        document.getElementById('questionTitle').value = q.questionTitle;
        document.getElementById('questionText').value = q.questionText;
        document.getElementById('option1').value = q.options[0];
        document.getElementById('option2').value = q.options[1];
        document.getElementById('option3').value = q.options[2];
        document.getElementById('option4').value = q.options[3];
        document.getElementById('correctNo').value = q.correctNo;
        
    	// 버튼 활성화 표시
        Array.from(questionButtons.children).forEach((btn, idx) => {
            if (idx === index) {
                btn.style.border = '2px solid black';
            } else {
                btn.style.border = 'none';
            }
        });

        // 현재 문제 번호 출력
        currentLabel.textContent = '현재 ' + (index + 1) + '번 문제 입력 중';
    }
	
 	
    
    function saveCurrentQuestion() {
        const title = document.getElementById('questionTitle').value.trim();
        const text = document.getElementById('questionText').value.trim();
        const opt1 = document.getElementById('option1').value.trim();
        const opt2 = document.getElementById('option2').value.trim();
        const opt3 = document.getElementById('option3').value.trim();
        const opt4 = document.getElementById('option4').value.trim();
        const correct = document.getElementById('correctNo').value;

        questions[currentIndex] = {
            questionTitle: title,
            questionText: text,
            options: [opt1, opt2, opt3, opt4],
            correctNo: correct
        };

        const btn = questionButtons.children[currentIndex];
        if (title && opt1 && opt2 && opt3 && opt4 && correct) {
            btn.classList.remove('btn-red');
            btn.classList.add('btn-blue');
        } else {
            btn.classList.remove('btn-blue');
            btn.classList.add('btn-red');
        }
    }

    function submitAll() {
        saveCurrentQuestion();

        const incomplete = questions.some(q =>
            !q.questionTitle || !q.options[0] || !q.options[1] ||
            !q.options[2] || !q.options[3] || !q.correctNo
        );

        if (incomplete) {
            alert('모든 문제의 필수 항목을 입력해주세요!');
            return;
        }

        const payload = questions.map((q, index) => ({
            questionNo: index + 1,
            questionTitle: q.questionTitle,
            questionText: q.questionText,
            correctNo: parseInt(q.correctNo),
            options: q.options.map((opt, i) => ({
                optionNo: i + 1,
                optionText: opt
            }))
        }));

        fetch('/submitQuestions?examId=${examId}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        })
        .then(response => {
			if (response.ok) {
				alert('등록 성공!');
				window.location.href = `/questionList?examId=${examId}`; // 이동
			} else {
				alert('등록 실패');
			}
		})
        .catch(error => alert('에러 발생: ' + error));
        
        console.log("payload:", JSON.stringify(payload, null, 2));
    }

    loadQuestion(0);
</script>
</body>
</html>
