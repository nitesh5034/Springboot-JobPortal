package com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.dao.CompanyDao;
import com.model.companyverify;
import com.model.application;

@WebServlet("/CompanyController")
public class CompanyController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CompanyController() {
        super();
    }

    // ── SHOW DATA (GET METHOD) ──
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        companyverify c = (companyverify) session.getAttribute("Model");

        if (c != null) 
        {
            CompanyDao dao = new CompanyDao();
            List<application> appList = dao.getApplicationsForCompany();
            request.setAttribute("appList", appList);
            request.getRequestDispatcher("company-home.jsp").forward(request, response);
        } 
        else 
        {
            response.sendRedirect("login.jsp");
        }
    }

    // ── REGISTER & LOGIN (POST METHOD) ──
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");

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

            CompanyDao dao = new CompanyDao();
            boolean success = dao.registerCompany(c);

            if (success) 
            {
                dao.addNotification("admin@jobboard.com", "New company request: " + c.getCompanyname());
                response.sendRedirect("compny-pending.jsp?msg=success");
            } 
            else 
            {
                response.sendRedirect("company-register.jsp?error=1");
            }

        // ── LOGIN LOGIC ──
        } else if ("login".equals(action)) {
            String email    = request.getParameter("email");
            String password = request.getParameter("password");

            CompanyDao dao = new CompanyDao();
            companyverify c = dao.loginCompany(email, password);

            if (c != null) {
                if ("approved".equalsIgnoreCase(c.getStatus())) {
                    HttpSession session = request.getSession();
                    session.setAttribute("Model", c);
                    session.setAttribute("role", "employer");
                  
                    response.sendRedirect("CompanyController"); 
                } else if ("pending".equalsIgnoreCase(c.getStatus())) {
                    response.sendRedirect("compny-pending.jsp?msg=waiting");
                } else {
                    response.sendRedirect("login.jsp?error=rejected");
                }
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }
        }
    }
}