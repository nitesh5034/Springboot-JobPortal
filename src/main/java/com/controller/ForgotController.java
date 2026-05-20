package com.controller;

import com.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;

import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/ForgotController")
public class ForgotController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgotpassword.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String step = request.getParameter("step");
        HttpSession session = request.getSession();

        // ============ STEP 1 — EMAIL CHECK & OTP SEND ============
        if ("1".equals(step)) {

            String email = request.getParameter("email");

            UserController uc = new UserController();
            UserModel u = uc.getUserByEmail(email);

            if (u == null) {
                response.sendRedirect("forgotpassword.jsp?step=1&error=notfound");
                return;
            }

            // 4 digit OTP generate કરો
            String otp = String.valueOf(new Random().nextInt(9000) + 1000);

            // Session માં save કરો
            session.setAttribute("reset_email", email);
            session.setAttribute("reset_otp",   otp);
            session.setAttribute("otp_time",     System.currentTimeMillis()); // ⏱ time save

            // Email મોકલો
            sendEmail(u.getEmail(), u.getFirstname(), otp);

            response.sendRedirect("forgotpassword.jsp?step=2");
        }

        // ============ STEP 2 — OTP VERIFY ============
        else if ("2".equals(step)) {

            String enteredOtp = request.getParameter("otp");
            String savedOtp   = (String) session.getAttribute("reset_otp");
            Long   otpTime    = (Long)   session.getAttribute("otp_time");

            // ⏱ 5 મિનિટ = 300000 ms
            long EXPIRE_MS = 5 * 60 * 1000;

            if (otpTime == null || (System.currentTimeMillis() - otpTime) > EXPIRE_MS) {
                // OTP expire થઈ ગયો
                session.removeAttribute("reset_otp");
                session.removeAttribute("otp_time");
                response.sendRedirect("forgotpassword.jsp?step=1&error=otpexpired");
                return;
            }

            if (savedOtp == null || !savedOtp.equals(enteredOtp)) {
                response.sendRedirect("forgotpassword.jsp?step=2&error=invalidotp");
                return;
            }

            // OTP સાચો છે
            session.setAttribute("otp_verified", "true");
            response.sendRedirect("forgotpassword.jsp?step=3");
        }

        // ============ STEP 3 — NEW PASSWORD SAVE ============
        else if ("3".equals(step)) {

            String verified = (String) session.getAttribute("otp_verified");

            if (!"true".equals(verified)) {
                response.sendRedirect("forgotpassword.jsp?step=1");
                return;
            }

            String newPass     = request.getParameter("newpass");
            String confirmPass = request.getParameter("confirmpass");

            if (!newPass.equals(confirmPass)) {
                response.sendRedirect("forgotpassword.jsp?step=3&error=mismatch");
                return;
            }

            String email = (String) session.getAttribute("reset_email");

            UserController uc = new UserController();
            boolean updated = uc.updatePassword(email, newPass);

            if (updated) {
                // Session clean કરો
                session.removeAttribute("reset_email");
                session.removeAttribute("reset_otp");
                session.removeAttribute("otp_time");
                session.removeAttribute("otp_verified");

                response.sendRedirect("forgotpassword.jsp?step=4");
            } else {
                response.sendRedirect("forgotpassword.jsp?step=3&error=failed");
            }
        }
    }

    // ============ EMAIL SEND METHOD ============
    private void sendEmail(String toEmail, String username, String otp) {

        final String senderEmail    = "niteshchaudhary3570@gmail.com";
        final String senderPassword = "ftfj aeas afzb lrhu"; // App Password

        Properties prop = new Properties();
        prop.put("mail.smtp.host",                  "smtp.gmail.com");
        prop.put("mail.smtp.port",                  "465");           // ✅ 587 નહીં — 465
        prop.put("mail.smtp.auth",                  "true");
        prop.put("mail.smtp.socketFactory.port",    "465");           // ✅ આ ઉમેરો
        prop.put("mail.smtp.socketFactory.class",   "javax.net.ssl.SSLSocketFactory"); // ✅ આ ઉમેરો
        prop.put("mail.smtp.socketFactory.fallback","false");         // ✅ આ ઉમેરો
        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        prop.put("mail.smtp.socketFactory.fallback", "true");

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