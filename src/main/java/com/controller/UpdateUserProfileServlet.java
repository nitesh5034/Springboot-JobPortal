package com.controller;

import com.model.UserModel;
import com.Repository.UserRepository;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import java.io.IOException;

@WebServlet("/UpdateUserProfileServlet")
public class UpdateUserProfileServlet extends HttpServlet {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void init() {
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        UserModel currentModel = (UserModel) session.getAttribute("Model");

        if (currentModel == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String firstname = request.getParameter("firstname");
            String lastname  = request.getParameter("lastname");
            String contact   = request.getParameter("contact");
            String address   = request.getParameter("address");
            String city      = request.getParameter("city");
            String state     = request.getParameter("state");
            int pincode      = 0;

            if (request.getParameter("pincode") != null && !request.getParameter("pincode").trim().isEmpty()) {
                pincode = Integer.parseInt(request.getParameter("pincode").trim());
            }

            // Update Model Fields
            currentModel.setFirstname(firstname);
            currentModel.setLastname(lastname);
            currentModel.setContact(contact);
            currentModel.setAddress(address);
            currentModel.setCity(city);
            currentModel.setState(state);
            currentModel.setPincode(pincode);

            // Save to DB via Spring Repository
            userRepository.save(currentModel);

            // Update Session Data
            session.setAttribute("Model", currentModel);

            response.sendRedirect("edit-profile.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit-profile.jsp?msg=error");
        }
    }
}