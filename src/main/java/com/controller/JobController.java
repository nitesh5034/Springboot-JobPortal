package com.controller;

import java.io.IOException;

import com.dao.postjobdao;
import com.model.Postjob;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/JobController")
public class JobController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Postjob job = new Postjob();

        try {
            
            job.setEmail(request.getParameter("email"));
            job.setJob_Title(request.getParameter("Job_Title"));
            job.setOpening(Integer.parseInt(request.getParameter("opening")));
            job.setLocation(request.getParameter("Location"));
            job.setExperience(request.getParameter("experience"));
            job.setSkills_req(request.getParameter("skills_req"));
            job.setJob_Region(request.getParameter("job_Region"));
            job.setJob_Type(request.getParameter("job_Type"));
            job.setJob_Description(request.getParameter("job_Description"));
            job.setCompany_name(request.getParameter("company_name"));
            job.setSalary(request.getParameter("salary"));
           

            postjobdao dao = new postjobdao();
            int result = dao.saveJob(job);

            if(result > 0) {
                response.sendRedirect("comjob.jsp?msg=success");
            } else {
                response.sendRedirect("postjob.jsp?msg=error");
            }

        } catch (NumberFormatException e) {
           
            response.sendRedirect("postjob.jsp?msg=invalid_input");
        }
    }
}