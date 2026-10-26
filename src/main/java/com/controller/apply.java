package com.controller;

import java.io.File;
import java.util.Properties;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Repository.ApplyRepository;
import com.model.applymodel;

import jakarta.mail.*;
import jakarta.mail.internet.*;
@Controller
public class apply {

    @Autowired
    private ApplyRepository applyRepository;
    @GetMapping("/ApplyServlet")
    public String doGet() {
        return "redirect:/index.jsp";
    }

    @PostMapping("/ApplyServlet")
    public String doPost(
            @RequestParam("job_id") String jobId,
            @RequestParam("fullname") String name,
            @RequestParam("email") String email,
            @RequestParam("mobileno") String mobileno,
            @RequestParam("city") String city,
            @RequestParam("experience") String experience,
            @RequestParam("resume") MultipartFile resumeFile,
            HttpServletRequest request) {

        try {
            applymodel amodel = new applymodel();
            amodel.setJobId(Integer.parseInt(jobId));
            amodel.setFullname(name);
            amodel.setEmail(email);
            amodel.setMobileno(mobileno);
            amodel.setCity(city);
            amodel.setExperience(experience);
            amodel.setStatus("Pending");

            String fileName = (resumeFile != null && !resumeFile.isEmpty())
                    ? resumeFile.getOriginalFilename()
                    : "no_resume.pdf";
            amodel.setResume(fileName);

            if (resumeFile != null && !resumeFile.isEmpty()) {
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                File destFile = new File(uploadPath + File.separator + fileName);
                resumeFile.transferTo(destFile);
            }

            applymodel savedModel = applyRepository.save(amodel);

            if (savedModel != null) {
                sendEasyEmail(email, name, jobId);
                return "redirect:/Application-track.jsp?msg=success";
            } else {
                return "redirect:/apply.jsp?msg=error";
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/apply.jsp?msg=error";
        }
    }

    private void sendEasyEmail(String to, String name, String jobId) {
        final String myEmail = "niteshchaudhari0623@gmail.com";
        final String myPass = "lxtb gqzv ghde uhld";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
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
}