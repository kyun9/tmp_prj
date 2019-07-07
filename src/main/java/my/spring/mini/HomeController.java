package my.spring.mini;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import dao.UsersDAO;
import vo.UsersVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	@Autowired
	UsersDAO dao;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "home";
	}
	
	@RequestMapping(value="/login", method= RequestMethod.GET)
	public String login() {
		System.out.println("login");
		return "login";
	}
	@RequestMapping(value="/login", method= RequestMethod.POST)
	public ModelAndView doLogin(String idVal, String pwdVal,HttpSession session) {
		ModelAndView mav = new ModelAndView();
		UsersVO user = dao.loginUser(idVal, pwdVal);
		String url;
		if(user!=null) {
			mav.addObject("msg", "로그인 성공");
			session.setAttribute("loginUser", user);
			url = "redirect:/";
		}
		else {
			mav.addObject("msg","로그인 실패");
			url="redirect:/login";
		}
		mav.setViewName(url);
		return mav;
	}
	@RequestMapping(value="/register", method= RequestMethod.GET)
	public String register() {
		System.out.println("register");
		return "register";
	}
	@RequestMapping(value="/register", method=RequestMethod.POST)
	public ModelAndView doRegister(UsersVO vo) {
		ModelAndView mav = new ModelAndView();
		boolean result= dao.insert(vo);
		if(result)
			mav.addObject("msg","성공적으로 가입되었습니다.");
		else
			mav.addObject("msg","가입에 실패하였습니다.");
		
		mav.setViewName("redirect:/");
		return mav;
	}
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String doLogout(HttpSession session) {
		session.invalidate();
		return "home";
	}
}
