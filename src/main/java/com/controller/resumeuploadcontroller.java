package com.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import com.dao.ResumeDAO;
import com.model.resumemodel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/UploadServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class resumeuploadcontroller extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uploadPath = request.getServletContext().getRealPath("")
                + File.separator + "uploads";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try {
            Part part = request.getPart("resume");
            String fileName = part.getSubmittedFileName();

            if (fileName != null && !fileName.isEmpty()) {

                String uniqueName = UUID.randomUUID().toString() + "_" + fileName;

                
                part.write(uploadPath + File.separator + uniqueName);

                
                resumemodel rm = new resumemodel();
                rm.setFilename(fileName);
                rm.setFilepath(uniqueName);

               
                ResumeDAO dao = new ResumeDAO();
                dao.saveResume(rm);

                response.getWriter().print("✅ File uploaded & data saved successfully!");
            } else {
                response.getWriter().print("❌ No file selected");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("❌ Error: " + e.getMessage());
        }
    }
}