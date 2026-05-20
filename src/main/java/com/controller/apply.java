package com.controller;

import java.io.File;
import java.io.IOException;
import java.util.Properties;
import java.util.Scanner;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.dao.applyDao;
import com.model.applymodel;

@WebServlet("/ApplyServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10) // 10MB limit
public class apply extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        try {
            String jobId = getFieldValue(request.getPart("job_id"));
            String name = getFieldValue(request.getPart("fullname"));
            String email = getFieldValue(request.getPart("email"));

            applymodel amodel = new applymodel();
            amodel.setJob_id(Integer.parseInt(jobId));
            amodel.setFullname(name);
            amodel.setEmail(email);
            amodel.setMobileno(getFieldValue(request.getPart("mobileno")));
            amodel.setCity(getFieldValue(request.getPart("city")));
            amodel.setExperience(getFieldValue(request.getPart("experience")));
            amodel.setStatus("Pending");

            // --- 🔴 ફાઈલ સેવ કરવાનું લોજિક ---
            Part filePart = request.getPart("resume");
            String fileName = (filePart != null) ? filePart.getSubmittedFileName() : "no_resume.pdf";
            amodel.setResume(fileName);

            if (filePart != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                // ફાઈલને ડ્રાઈવ પર લખવી
                filePart.write(uploadPath + File.separator + fileName);
            }

            applyDao dao = new applyDao();
            int result = dao.apply(amodel);
            
            if (result > 0) {
                sendEasyEmail(email, name, jobId);
                response.sendRedirect("Application-track.jsp?msg=success");
            } else {
                response.sendRedirect("apply.jsp?msg=error");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("apply.jsp?msg=error");
        }
    }

    private void sendEasyEmail(String to, String name, String jobId) {
        final String myEmail = "niteshchaudhary3570@gmail.com";
        final String myPass = "ftfj aeas afzb lrhu"; 

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(myEmail, myPass);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(myEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject("Application Received - JobBoard");
            msg.setText("Hi " + name + ",\n\nYour application for Job #" + jobId + " has been received successfully.\n\nBest Regards,\nJobBoard Team");
            Transport.send(msg);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    private String getFieldValue(Part part) throws IOException {
        if (part == null) return "";
        try (Scanner s = new Scanner(part.getInputStream())) {
            return s.hasNext() ? s.nextLine().trim() : "";
        }
    }
}