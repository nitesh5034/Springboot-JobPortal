package com.controller;

import com.model.UserModel;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.Properties;
import java.util.Random;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class ForgotController {

    @Autowired
    private UserController uc;

    @GetMapping("/ForgotController")
    public String doGet() {
        return "forward:/forgotpassword.jsp";
    }

    @PostMapping("/ForgotController")
    public String doPost(HttpServletRequest request, HttpSession session) {

        String step = request.getParameter("step");

        // ============ STEP 1 — EMAIL CHECK & OTP SEND ============
        if ("1".equals(step)) {

            String email = request.getParameter("email");

            UserModel u = uc.getUserByEmail(email);

            if (u == null) {
                return "redirect:/forgotpassword.jsp?step=1&error=notfound";
            }

            String otp = String.valueOf(new Random().nextInt(9000) + 1000);

            // Session ma save karo
            session.setAttribute("reset_email", email);
            session.setAttribute("reset_otp",   otp);
            session.setAttribute("otp_time",     System.currentTimeMillis()); // ⏱ time save

            sendEmail(u.getEmail(), u.getFirstname(), otp);

            return "redirect:/forgotpassword.jsp?step=2";
        }

        // ============ STEP 2 — OTP VERIFY ============
        else if ("2".equals(step)) {

            String enteredOtp = request.getParameter("otp");
            String savedOtp   = (String) session.getAttribute("reset_otp");
            Long   otpTime    = (Long)   session.getAttribute("otp_time");

            // ⏱ 5 minute = 300000 ms
            long EXPIRE_MS = 5 * 60 * 1000;

            if (otpTime == null || (System.currentTimeMillis() - otpTime) > EXPIRE_MS) {
                // OTP expire thai gayo
                session.removeAttribute("reset_otp");
                session.removeAttribute("otp_time");
                return "redirect:/forgotpassword.jsp?step=1&error=otpexpired";
            }

            if (savedOtp == null || !savedOtp.equals(enteredOtp)) {
                return "redirect:/forgotpassword.jsp?step=2&error=invalidotp";
            }

            // OTP sacho che
            session.setAttribute("otp_verified", "true");
            return "redirect:/forgotpassword.jsp?step=3";
        }

        // ============ STEP 3 — NEW PASSWORD SAVE ============
        else if ("3".equals(step)) {

            String verified = (String) session.getAttribute("otp_verified");

            if (!"true".equals(verified)) {
                return "redirect:/forgotpassword.jsp?step=1";
            }

            String newPass     = request.getParameter("newpass");
            String confirmPass = request.getParameter("confirmpass");

            if (!newPass.equals(confirmPass)) {
                return "redirect:/forgotpassword.jsp?step=3&error=mismatch";
            }

            String email = (String) session.getAttribute("reset_email");

            boolean updated = uc.updatePassword(email, newPass);

            if (updated) {
                // Session clean karo
                session.removeAttribute("reset_email");
                session.removeAttribute("reset_otp");
                session.removeAttribute("otp_time");
                session.removeAttribute("otp_verified");

                return "redirect:/forgotpassword.jsp?step=4";
            } else {
                return "redirect:/forgotpassword.jsp?step=3&error=failed";
            }
        }
        
        return "redirect:/forgotpassword.jsp";
    }

    // ============ EMAIL SEND METHOD ============
    private void sendEmail(String toEmail, String username, String otp) {

        final String senderEmail    = "niteshchaudhari0623@gmail.com";
        final String senderPassword = "lxtb gqzv ghde uhld";

        Properties prop = new Properties();
        prop.put("mail.smtp.host",                  "smtp.gmail.com");
        prop.put("mail.smtp.port",                  "465");           // ✅ 587 nahi — 465
        prop.put("mail.smtp.auth",                  "true");
        prop.put("mail.smtp.socketFactory.port",    "465");           // ✅ aa umelo
        prop.put("mail.smtp.socketFactory.class",   "javax.net.ssl.SSLSocketFactory"); // ✅ aa umelo
        prop.put("mail.smtp.socketFactory.fallback","false");         // ✅ aa umelo
        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        try {
            Session session = Session.getInstance(prop, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Password Reset OTP - JobBoard");
            message.setText("Hello " + username + ",\n\n"
                    + "Your OTP is: " + otp + "\n"
                    + "This OTP is valid for 5 minutes only.\n\n"
                    + "Ignore if not requested.");

            Transport.send(message);
            System.out.println("Email sent successfully!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}