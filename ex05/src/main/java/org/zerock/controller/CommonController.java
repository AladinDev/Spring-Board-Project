package org.zerock.controller;

import org.springframework.*;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.MemberVO;
import org.zerock.service.MemberJoinService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class CommonController {

	private MemberJoinService member;

	
	 @GetMapping("/accessError") public void accessDenied(Authentication auth, Model model) {
	  
	 log.info("access Denied : " + auth);
	 
	 model.addAttribute("msg", "Access Denied"); }
	 

	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {

		log.info("error: " + error);
		log.info("logout: " + logout);

		if (error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		
		if (logout != null) {
			model.addAttribute("logout", "Logout!");
		}
	}

	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}

	@GetMapping("/join")
	public String joinPage() {

		log.info("user join page");

		return "join";
	}

	@PostMapping("/join")
	public void join(MemberVO vo, RedirectAttributes rttr) {
		log.info("유저 회원가입");
		
		log.info("유저 join : " + vo);
		member.join(vo);

		rttr.addAttribute("success", "success");

	}
}
