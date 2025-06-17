package com.example.lms.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.lms.dto.QnaDTO;
import com.example.lms.mapper.QnaCommentMapper;
import com.example.lms.mapper.QnaMapper;
import com.example.lms.service.QnaService;

@Service
public class QnaServiceImpl implements QnaService {
	@Autowired
	private QnaMapper qnaMapper;
	@Autowired
	private QnaCommentMapper qnaCommentMapper;
	
	@Override
	public List<QnaDTO> selectLatestQna(int count) {
		
		return qnaMapper.selectLatestQna(count);
	}
	
	// 전체개수
	@Override
	public int totalCount(String searchOption, String keyword) {
		return qnaMapper.totalCount(searchOption, keyword);
	}
	
	// 리스트
	@Override
	public List<QnaDTO> selectQnaList(Map<String, Object> param) {
		return qnaMapper.selectQnaList(param);
	}

	// 작성
	@Override
	public int insertQna(QnaDTO qnaDto) {
		return qnaMapper.insertQna(qnaDto);
	}

	// 상세보기
	@Override
	public QnaDTO selectQnaOne(int qnaId) {
		return qnaMapper.selectQnaOne(qnaId);
	}

	// 수정
	@Override
	public int updateQna(QnaDTO qnaDto) {
		return qnaMapper.updateQna(qnaDto);
	}

	// 삭제
	@Override
	@Transactional
	public int deleteQna(QnaDTO qnaDto) {
		   int qnaId = qnaDto.getQnaId();

		    // 1. 대댓글 먼저 삭제
		    qnaCommentMapper.deleteChildCommentsByQnaId(qnaId);

		    // 2. 부모 댓글 삭제
		    qnaCommentMapper.deleteParentCommentsByQnaId(qnaId);

		    // 3. QnA 본문 삭제
		    return qnaMapper.deleteQna(qnaDto);
	}
	// 답변완료 상태 표시
	@Override
	@Transactional	// DB 트랜잭션 안에서 실행되도록 지정함 (중간에 오류 나면 롤백됨)
	public int updateAnswerStatus(int qnaId, String answerStatus) {
		
		// 파라미터들을 담을 Map 객체 생성
		// 파라미터가 2개 이상이면 @Param 또는 Map을 써야 함
	    Map<String, Object> param = new HashMap<>();
	    
	    // qna 글 번호 (답변 상태를 바꿀 대상)
	    param.put("qnaId", qnaId);
	    
	    // 변경할 답변 상태 값 ("답변완료" 또는 "미답변")
	    param.put("answerStatus", answerStatus);
	    
	    // mapper를 통해 실제 db에 update 쿼리 실행
	    // qna 테이블에서 해당 qnaId의 answer_status 컬럼 값을 수정함
	    return qnaMapper.updateAnswerStatus(param);
	}

}
