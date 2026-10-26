package com.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

import com.Repository.CompanyVerifyRepository;
import com.Repository.ApplicationRepository;
import com.model.companyverify;
import com.model.application;

@Controller
public class CompanyController {

    @Autowired
    private CompanyVerifyRepository companyVerifyRepository;
    @Autowired
    private ApplicationRepository applicationRepository;
    @GetMapping("/CompanyController")
    public String doGet(HttpSession session, Model model) {

        companyverify c = (companyverify) session.getAttribute("Model");

        if (c != null) {

            List<application> appList = applicationRepository.findAll();
            model.addAttribute("appList", appList);
            return "forward:/company-home.jsp";
        } else {
            return "redirect:/login.jsp";
        }
    }

    @PostMapping("/CompanyController")
    public String doPost(HttpServletRequest request, @RequestParam(value = "action", required = false) String action, HttpSession session) {

        // ── REGISTER LOGIC ──
        if ("register".equals(action)) {
            companyverify c = new companyverify();
            c.setCompanyname(request.getParameter("companyname"));
            c.setEmail(request.getParameter("email"));
            c.setPassword(request.getParameter("password"));
            c.setWebsite(request.getParameter("website"));
            c.setLocation(request.getParameter("location"));
            c.setIndustry(request.getParameter("industry"));
            c.setCompanysize(request.getParameter("companysize"));
            c.setAbout(request.getParameter("about"));
            c.setStatus("pending");

            companyverify savedCompany = companyVerifyRepository.save(c);

            if (savedCompany != null) {

                System.out.println("🔔 Notification logged for admin: New company request - " + c.getCompanyname());
                return "redirect:/compny-pending.jsp?msg=success";
            } else {
                return "redirect:/company-register.jsp?error=1";
            }

            // ── LOGIN LOGIC ──
        } else if ("login".equals(action)) {
            String email    = request.getParameter("email");
            String password = request.getParameter("password");

            Optional<companyverify> compOpt = companyVerifyRepository.findFirstByEmailAndPassword(email, password);

            if (compOpt.isPresent()) {
                companyverify c = compOpt.get();
                if ("approved".equalsIgnoreCase(c.getStatus())) {
                    session.setAttribute("Model", c);
                    session.setAttribute("role", "employer");
                    return "redirect:/CompanyController";
                } else if ("pending".equalsIgnoreCase(c.getStatus())) {
                    return "redirect:/compny-pending.jsp?msg=waiting";
                } else {
                    return "redirect:/login.jsp?error=rejected";
                }
            } else {
                return "redirect:/login.jsp?error=invalid";
            }
        }
        return "redirect:/index.jsp";
    }
}