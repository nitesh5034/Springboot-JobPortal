package com.controller;

import com.Repository.ApplyRepository;
import com.Repository.JobRepository;
import com.Repository.UserRepository;
import com.model.Postjob;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class JobController {

    @Autowired
    private JobRepository jobRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ApplyRepository applyRepository;

    // Open Post Job Page
    @GetMapping("/JobController")
    public String doGet(Model model) {
        try {
            long liveCandidates = userRepository.count();
            long totalApps = applyRepository.count();

            model.addAttribute("liveCandidates", liveCandidates);
            model.addAttribute("totalApps", totalApps);
        } catch (Exception e) {
            model.addAttribute("liveCandidates", 0);
            model.addAttribute("totalApps", 0);
        }

        return "postjob.jsp";
    }

    // Save Job
    @PostMapping("/JobController")
    public String doPost(HttpServletRequest request) {
        Postjob job = new Postjob();

        try {
            // Safe parameter extraction with fallbacks
            String email = getParam(request, "email", "email");
            String companyName = getParam(request, "company_name", "companyName");
            String jobTitle = getParam(request, "jobTitle", "Job_Title");
            String category = getParam(request, "category", "job_Region");
            String jobType = getParam(request, "jobType", "job_Type");
            String salary = getParam(request, "salary", "salary");
            String experience = getParam(request, "experience", "experience");
            String location = getParam(request, "location", "Location");
            String skills = getParam(request, "skillsReq", "skills_req");
            String description = getParam(request, "description", "job_Description");

            String openingStr = request.getParameter("opening");
            int opening = 1;
            if (openingStr != null && !openingStr.trim().isEmpty()) {
                opening = Integer.parseInt(openingStr.trim());
            }

            // Bind values to Postjob Entity
            job.setEmail(email);
            job.setCompany_name(companyName);
            job.setJob_title(jobTitle);
            job.setJob_region(category);
            job.setJob_type(jobType);
            job.setSalary(salary);
            job.setExperience(experience);
            job.setLocation(location);
            job.setSkills_req(skills);
            job.setJob_description(description);
            job.setOpening(opening);
            job.setAppliedCount(0);

            // Save to DB
            Postjob savedJob = jobRepository.save(job);

            if (savedJob != null) {
                return "redirect:/compny-home.jsp?msg=success";
            } else {
                return "redirect:/postjob.jsp?msg=error";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/postjob.jsp?msg=invalid_input";
        }
    }

    // Helper method to check primary and fallback parameter names
    private String getParam(HttpServletRequest request, String primary, String fallback) {
        String val = request.getParameter(primary);
        if (val == null || val.trim().isEmpty()) {
            val = request.getParameter(fallback);
        }
        return val != null ? val.trim() : "";
    }
}