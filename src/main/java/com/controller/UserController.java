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
import com.dao.userdao;
import com.model.UserModel;
import com.model.companyverify;

@WebServlet("/UserController")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UserController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("Action Received: " + action); 

        /* ================= REGISTER LOGIC ================= */
        if ("register".equalsIgnoreCase(action)) {

            UserModel rmodel = new UserModel();
            rmodel.setFirstname(request.getParameter("fname"));
            rmodel.setLastname(request.getParameter("lname"));
            rmodel.setEmail(request.getParameter("email"));
            rmodel.setContact(request.getParameter("contact"));
            rmodel.setAddress(request.getParameter("address"));
            rmodel.setCity(request.getParameter("city"));
            rmodel.setState(request.getParameter("state"));
  
            try 
            {
                rmodel.setPincode(Integer.parseInt(request.getParameter("pincode")));
            } 
            catch (Exception e)
            { 
            	rmodel.setPincode(0); 
          }
            
            rmodel.setPassword(request.getParameter("password"));
            rmodel.setRole(request.getParameter("role"));
            if ("EMPLOYER".equalsIgnoreCase(rmodel.getRole())) {
                rmodel.setIsVerified(0); 
            } else {
                rmodel.setIsVerified(1);
            }

            int x = new userdao().userregistration(rmodel);

            if (x > 0) {
                if ("EMPLOYER".equalsIgnoreCase(rmodel.getRole())) {
                    response.sendRedirect("verfi.jsp?status=pending");
                } else {
                    response.sendRedirect("login.jsp?msg=registered");
                }
            } else {
                response.sendRedirect("registration.jsp?msg=failed");
            }
        } 
        
        /* ================= LOGIN LOGIC ================= */
     else if ("login".equalsIgnoreCase(action)) {

        String email = request.getParameter("email");
        String pass  = request.getParameter("password");
        CompanyDao cdao = new CompanyDao();
        companyverify compModel = cdao.loginCompany(email, pass);

        if (compModel != null) {
            HttpSession session = request.getSession();
            session.setAttribute("Model", compModel);
            session.setAttribute("role", "EMPLOYER"); 
            session.setAttribute("companyname", compModel.getCompanyname());
            String status = compModel.getStatus();
            if ("pending".equalsIgnoreCase(status)) {
                response.sendRedirect("verfi.jsp?status=pending");
            } else if ("rejected".equalsIgnoreCase(status)) {
                response.sendRedirect("verfi.jsp?status=rejected");
            } else {
                response.sendRedirect("compny-home.jsp"); 
            }
            return; 
        } 
        UserModel lmodel = new UserModel();
        lmodel.setEmail(email);
        lmodel.setPassword(pass);
        UserModel model = new userdao().UserLogin(lmodel);

        if (model != null) {
            HttpSession session = request.getSession();
            session.setAttribute("Model", model);
            session.setAttribute("role", model.getRole());
            
            if ("JOBSEEKER".equalsIgnoreCase(model.getRole())) {
                response.sendRedirect("user-home.jsp");
            } 
            else
            {
                response.sendRedirect("login.jsp?msg=invalid_role");
            }
        } 
        else 
        {
            
            response.sendRedirect("login.jsp?msg=error");
        }
    }
        /* ================= UPDATE PROFILE LOGIC ================= */
        else if ("updateProfile".equalsIgnoreCase(action)) {

            UserModel umodel = new UserModel();
            umodel.setUserid(Integer.parseInt(request.getParameter("userid")));
            umodel.setFirstname(request.getParameter("fname"));
            umodel.setLastname(request.getParameter("lname"));
            umodel.setEmail(request.getParameter("email"));
            umodel.setContact(request.getParameter("contact"));
            umodel.setAddress(request.getParameter("address"));
            umodel.setCity(request.getParameter("city"));
            umodel.setState(request.getParameter("state"));
            umodel.setPincode(Integer.parseInt(request.getParameter("pincode")));

            int x = new userdao().updateUser(umodel);

            if (x > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("Model", umodel);
                response.sendRedirect("viewprofile.jsp?msg=updated");
            } else {
                response.sendRedirect("edit-profile.jsp?msg=failed");
            }
        }
    }

    public UserModel getUserByEmail(String email) {
        return new userdao().getUserByEmail(email);
    }

    public boolean updatePassword(String email, String newPassword) {
        return new userdao().updatePassword(email, newPassword);
    }
}