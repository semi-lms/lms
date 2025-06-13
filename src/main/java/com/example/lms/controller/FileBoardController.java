package com.example.lms.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.lms.dto.AdminDTO;
import com.example.lms.dto.FileBoardDTO;
import com.example.lms.dto.NoticeDTO;
import com.example.lms.dto.Page;
import com.example.lms.dto.SessionUserDTO;
import com.example.lms.service.AdminService;
import com.example.lms.service.FileBoardService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/file")
public class FileBoardController {

	@Autowired
	private FileBoardService fileBoardService;
	@Autowired
	private PasswordEncoder passwordEncoder; // 암호화 필드 받기 // com.example.lms.config.SecurityConfig
	@Autowired
	private AdminService adminService;
	
	// 공지사항 리스트
		@GetMapping("/fileBoardList")
		   public String fileBoardList (Model model,
		            @RequestParam(defaultValue = "1") int currentPage,
		            @RequestParam(value="searchOption", required=false, defaultValue="all") String searchOption,
					@RequestParam(value="keyword", required=false, defaultValue="") String keyword,
		   			@RequestParam(defaultValue = "10") int rowPerPage) {
				
				int totalCount = fileBoardService.totalCount(searchOption, keyword);
			    Page page = new Page(rowPerPage, currentPage, totalCount, searchOption, keyword);
				int startRow = (currentPage - 1) * rowPerPage;
		        
		        Map<String, Object> param = new HashMap<>();
		        param.put("searchOption", searchOption);
		        param.put("keyword", keyword);
		        param.put("startRow", (currentPage - 1) * rowPerPage);
		        param.put("rowPerPage", rowPerPage);

		        List<FileBoardDTO> fileBoardList = fileBoardService.selectFileBoardList(param);

		        // 페이징 계산
		        int lastPage = (int) Math.ceil((double) totalCount / rowPerPage);
		        int pageSize = 10;
		        int startPage = ((currentPage - 1) / pageSize) * pageSize + 1;
		        int endPage = Math.min(startPage + pageSize - 1, lastPage);
		        
		        
		        model.addAttribute("fileBoardList", fileBoardList);
		        model.addAttribute("currentPage", currentPage);
		        model.addAttribute("searchOption", searchOption);
		        model.addAttribute("keyword", keyword);
		        model.addAttribute("rowPerPage", rowPerPage);
		        model.addAttribute("startPage", startPage);
		        model.addAttribute("endPage", endPage);
		        model.addAttribute("lastPage", lastPage);
		        

		        return"file/fileBoardList";
		    }
		
		// 작성
		@GetMapping("/insertFileBoard")
		public String insertFileBoard() {
			// 작성하는페이지로 이동
			// 제목, 내용 입력창
			return "file/insertFileBoard";
		}
		
		@PostMapping("/insertFileBoard")
		public String insertFileBoard(FileBoardDTO fileBoardDto, HttpSession session) {		
			
			SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");		// 현재 로그인한 사용자 정보를 세션에서 꺼냄
			
			fileBoardDto.setAdminId(loginUser.getAdminId());		// 작성자(admin)을 notice 객체에 세팅함
			
			fileBoardService.insertFileBoard(fileBoardDto);		// 작성된 공지사항을 DB에 저장 요청
			
			return "redirect:/file/fileBoardList";		// 작성 후 리다이렉트로 공지사항리스트로
		}
		
		// 상세보기
		@GetMapping("/fileBoardOne")
		public String fileBoardOne(@RequestParam("fileBoardNo") int fileBoardNo, Model model) {
			
			// DB에서 noticeNo와 일치하는 행을 조회하여 DTO에 담아 반환
			FileBoardDTO fileBoardDto = fileBoardService.selectFileBoardOne(fileBoardNo);
			
			model.addAttribute("fileBoard", fileBoardDto);
			
			
			return"file/fileBoardOne";
		}
		
		// 수정
		@GetMapping("/updateFileBoard")
		public String updateFileBoard(@RequestParam("fileBoardNo") int fileBoardNo, Model model) {
			// 기존 공지사항 정보 가져오기
			FileBoardDTO fileBoard = fileBoardService.selectFileBoardOne(fileBoardNo);
			model.addAttribute("fileBoard", fileBoard);
			return "file/updateFileBoard";
		}
		
		@PostMapping("/updateFileBoard")
		public String updateFileBoard(@ModelAttribute FileBoardDTO fileBoardDto) {
			fileBoardService.updateFileBoard(fileBoardDto); //수정 처리
			return "redirect:/file/fileBoardOne?fileBoardNo=" + fileBoardDto.getFileBoardNo(); // 상세보기로 리다이렉트
		}
		
		// 삭제
		@PostMapping("/deletefileBoard")
		public String deleteFileBoard(@RequestParam int fileBoardNo,
		                              @RequestParam String pw,
		                              HttpSession session,
		                              RedirectAttributes ra) {

		    // 로그인한 관리자 세션 정보 가져오기
		    SessionUserDTO loginUser = (SessionUserDTO) session.getAttribute("loginUser");

		    // 로그인 안 되어 있으면 로그인 페이지로
		    if (loginUser == null || loginUser.getAdminId() == null) {
		        ra.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
		        return "redirect:/login";
		    }

		    // 1. 로그인한 관리자 정보 DB에서 조회
		    AdminDTO admin = adminService.getAdminById(loginUser.getAdminId());

		    // 2. 비밀번호 일치 검사
		    if (!passwordEncoder.matches(pw, admin.getPassword())) {
		        ra.addFlashAttribute("errorMsg", "비밀번호가 일치하지 않습니다.");
		        return "redirect:/file/fileBoardOne?fileBoardNo=" + fileBoardNo;
		    }

		    // 3. 삭제 수행
		    fileBoardService.deleteFileBoard(fileBoardNo);

		    return "redirect:/file/fileBoardList";
		}
		
		
}
