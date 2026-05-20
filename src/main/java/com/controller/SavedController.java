package com.controller;

import com.dao.userdao;
import com.model.UserModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/SaveJobServlet")
public class SavedController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserModel u = (UserModel) request.getSession().getAttribute("Model");
        if (u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String jobIdStr = request.getParameter("jobId");
        String act      = request.getParameter("action");

        // ✅ Null/empty check
        if (jobIdStr == null || jobIdStr.trim().isEmpty()) {
            response.sendRedirect("saved-jobs.jsp?msg=error");
            return;
        }

        int jobId = Integer.parseInt(jobIdStr.trim());

        userdao dao = new userdao();

        if ("save".equals(act)) {
            dao.saveJob(u.getUserid(), jobId);
            response.sendRedirect("Saved-jobs.jsp?msg=saved");
        } else if ("remove".equals(act)) {
            dao.removeSavedJob(u.getUserid(), jobId);
            response.sendRedirect("Saved-jobs.jsp?msg=removed");
        } else {
            response.sendRedirect("saved-jobs.jsp");
        }
    }
}