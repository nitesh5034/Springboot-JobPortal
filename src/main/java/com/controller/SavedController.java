package com.controller;

import com.Repository.JobRepository;
import com.model.UserModel;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class SavedController {

    @Autowired
    private JobRepository jobRepo;

    @PostMapping("/SaveJobServlet")
    public String handleSaveJob(HttpServletRequest request, HttpSession session) {
        UserModel u = (UserModel) session.getAttribute("Model");
        if (u == null) {
            return "redirect:/login.jsp";
        }

        String actionStr = request.getParameter("action");
        String jobIdStr  = request.getParameter("jobId");
        if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
            jobIdStr = request.getParameter("job_id");
        }

        try {
            if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
                int jobId  = Integer.parseInt(jobIdStr.trim());
                int userId = u.getUserid();

                if ("remove".equalsIgnoreCase(actionStr)) {
                    jobRepo.deleteSavedJob(userId, jobId);
                    return "redirect:/Saved-jobs.jsp?msg=removed";
                } else if ("save".equalsIgnoreCase(actionStr)) {
                    try {
                        jobRepo.saveJobForUser(userId, jobId);
                    } catch (Exception ignored) {
                        // Job is already saved
                    }
                    return "redirect:/Saved-jobs.jsp?msg=saved";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/Saved-jobs.jsp";
    }
}