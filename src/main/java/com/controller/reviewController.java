package com.controller;

import com.Repository.ReviewRepository;
import com.model.review;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@Controller
public class reviewController {

    @Autowired
    private ReviewRepository reviewRepo;

    @PostMapping("/reviewController")
    public String handleReview(HttpServletRequest request,
                               @RequestParam(value = "action", required = false) String action) {

        // DELETE REVIEW LOGIC
        if ("delete".equals(action)) {
            try {
                String reviewIdStr = request.getParameter("reviewId");
                if (reviewIdStr != null && !reviewIdStr.trim().isEmpty()) {
                    int reviewId = Integer.parseInt(reviewIdStr.trim());
                    reviewRepo.deleteById(reviewId);
                    return "redirect:/review.jsp?msg=deleted";
                }
            } catch (Exception e) {
                e.printStackTrace();
                return "redirect:/review.jsp?msg=error";
            }
        }

        // ADD NEW REVIEW LOGIC
        try {
            String name   = request.getParameter("name");
            String rating = request.getParameter("rating");
            String text   = request.getParameter("text");
            String userEmail = request.getParameter("userEmail");

            review r = new review();
            r.setName(name);
            r.setRating(Integer.parseInt(rating));
            r.setText(text);

            reviewRepo.save(r);

            // ASYNC TRIPLE EMAIL DISPATCH (User, Company Admin & Super Admin)
            new Thread(() -> sendTripleNotificationEmails(name, userEmail, rating, text)).start();

            return "redirect:/review.jsp?msg=success";

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/review.jsp?msg=error";
        }
    }

    /* ================= TRIPLE EMAIL DISPATCHER ================= */
    private void sendTripleNotificationEmails(String userName, String userEmail, String rating, String reviewText) {
        final String systemMail = "niteshchaudhari0623@gmail.com";
        final String systemPass = "lxtb gqzv ghde uhld";

        // Admin & Company Target Email List
        String adminEmail   = "niteshchaudhari0623@gmail.com";
        String companyEmail = "support@jobboard.com";

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
                return new PasswordAuthentication(systemMail, systemPass);
            }
        });

        // 1. Email to Candidate / User
        if (userEmail != null && !userEmail.trim().isEmpty()) {
            sendSingleMail(session, systemMail, userEmail,
                    "Review Received - JobBoard",
                    "Hi " + userName + ",\n\nThank you for posting a " + rating + "-star review on JobBoard!\n\nYour Review:\n\"" + reviewText + "\"\n\nBest Regards,\nJobBoard Team");
        }

        // 2. Email to Admin
        sendSingleMail(session, systemMail, adminEmail,
                "New Candidate Review Posted - JobBoard Admin Alert",
                "Hello Admin,\n\nA new " + rating + "-star review has been posted by " + userName + " (" + userEmail + ").\n\nReview Content:\n\"" + reviewText + "\"\n\nSystem Portal Notification");

        // 3. Email to Company Support / Recruiter
        sendSingleMail(session, systemMail, companyEmail,
                "Platform Feedback Received - JobBoard Company Portal",
                "Hello Employer Team,\n\nCandidate " + userName + " has left a " + rating + "-star feedback on the JobBoard Portal.\n\nReview Text:\n\"" + reviewText + "\"");
    }

    private void sendSingleMail(Session session, String from, String to, String subject, String bodyText) {
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, "JobBoard Portal"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(bodyText);
            Transport.send(message);
            System.out.println("✅ Email notification sent to: " + to);
        } catch (Exception e) {
            System.err.println("❌ Failed to send email to " + to + ": " + e.getMessage());
        }
    }
}