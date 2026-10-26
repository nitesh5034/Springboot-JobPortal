package com.controller;

import java.util.List;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.Repository.ApplicationTrackRepository;
import com.model.ApplicationModel;

@Controller
public class applicationtrack {

    @Autowired
    private ApplicationTrackRepository applicationTrackRepository; // DAO ki jagah direct Repository inject ki

    @GetMapping("/TrackingController")
    public String doGet(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login.jsp";
        }

        try {

            List<ApplicationModel> userApps = applicationTrackRepository.findByUserid(userId);
            model.addAttribute("userApps", userApps);
            return "forward:/track-status.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/index.jsp?msg=tracking_error";
        }
    }

    @PostMapping("/TrackingController")
    public String doPost(HttpSession session, Model model) {
        return doGet(session, model);
    }
}