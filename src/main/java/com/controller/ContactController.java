package com.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@Controller
public class ContactController {

    @PostMapping("/ContactServlet")
    public String handleContactForm(
            @RequestParam("firstname") String fname,
            @RequestParam("lastname") String lname,
            @RequestParam("email") String email,
            @RequestParam("subject") String subject,
            @RequestParam("message") String message,
            HttpServletRequest request) {

        try {
            // Background thread to send email acknowledgment
            new Thread(() -> sendSupportEmail(email, fname + " " + lname, subject, message)).start();
            return "redirect:/contact.jsp?msg=success";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/contact.jsp?msg=error";
        }
    }

    private void sendSupportEmail(String userEmail, String fullName, String sub, String msgText) {
        final String senderEmail = "niteshchaudhari0623@gmail.com";
        final String senderPass  = "lxtb gqzv ghde uhld";

        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(prop, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail, "JobBoard Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
            message.setSubject("We received your inquiry: " + sub);
            message.setText("Hi " + fullName + ",\n\nThank you for reaching out to us. We have received your message:\n\n\""
                    + msgText + "\"\n\nOur team will contact you shortly.\n\nRegards,\nJobBoard Support Team");

            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}