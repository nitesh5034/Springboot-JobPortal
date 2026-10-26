package com.controller;

import com.model.UserModel;
import com.Repository.UserRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.Optional;
import java.util.Properties;

import jakarta.mail.*;
import jakarta.mail.internet.*;

@Controller
public class AdminVerifyController {

    @Autowired
    private UserRepository userRepository;


    // =====================================================
    // ADMIN LOGIN (GET - show the login page)
    // =====================================================

    @GetMapping("/admin/admin-login")
    public String showLogin() {
        return "admin-login";
    }


    // =====================================================
    // ADMIN LOGIN (POST - handle form submit)
    // The JSP's own scriptlet checks request.getMethod() == "POST"
    // and does the username/password check, so this just needs to
    // forward back to the same view so that logic actually runs.
    // =====================================================

    @PostMapping("/admin/admin-login")
    public String processLogin() {
        return "admin-login";
    }


    // =====================================================
    // ADMIN DASHBOARD
    // =====================================================

    @GetMapping("/admin/admin-dashboard")
    public String showDashboard() {
        return "admin-dashboard";
    }


    // =====================================================
    // ADMIN APPLICATION
    // =====================================================

    @GetMapping("/admin/admin-application")
    public String showApplications() {
        return "admin-application";
    }


    // =====================================================
    // ADMIN COMPANIES
    // =====================================================

    @GetMapping("/admin/admin-companies")
    public String showCompanies() {
        return "admin-companies";
    }


    // =====================================================
    // ADMIN JOBS
    // =====================================================

    @GetMapping("/admin/admin-jobs")
    public String showJobs() {
        return "admin-jobs";
    }


    // =====================================================
    // ADMIN USERS
    // =====================================================

    @GetMapping("/admin/admin-users")
    public String showUsers() {
        return "admin-users";
    }



    // =====================================================
    // OLD URL SUPPORT
    // =====================================================

    @GetMapping("/admin/AdminVerifyController")
    public String doGet() {
        return "redirect:/admin/admin-dashboard";
    }


    // =====================================================
    // APPROVE / REJECT COMPANY
    // =====================================================

    @PostMapping("/AdminVerifyController")
    public String doPost(
            HttpServletRequest request,
            HttpSession session) {

        // ---------------------------------------------
        // Session Check
        // ---------------------------------------------

        if (session.getAttribute("Model") == null) {
            return "redirect:/admin/admin-login";
        }


        // ---------------------------------------------
        // Get Parameters
        // ---------------------------------------------

        String userid = request.getParameter("userid");
        String action = request.getParameter("action");


        // ---------------------------------------------
        // Validate User ID
        // ---------------------------------------------

        if (userid == null || userid.trim().isEmpty()) {
            return "redirect:/admin/admin-dashboard?msg=invalidaction";
        }


        try {

            int id = Integer.parseInt(userid.trim());


            // ---------------------------------------------
            // Find User
            // ---------------------------------------------

            Optional<UserModel> userOpt =
                    userRepository.findById(id);


            if (userOpt.isEmpty()) {

                return "redirect:/admin/admin-dashboard?msg=usernotfound";
            }


            UserModel u = userOpt.get();


            // =================================================
            // APPROVE
            // =================================================

            if ("approve".equalsIgnoreCase(action)) {

                u.setIsVerified(1);

                userRepository.save(u);


                // Send Email
                new Thread(() ->
                        sendVerificationEmail(
                                u.getEmail(),
                                u.getFirstname(),
                                true
                        )
                ).start();


                return "redirect:/admin/admin-dashboard?msg=approved";
            }


            // =================================================
            // REJECT
            // =================================================

            else if ("reject".equalsIgnoreCase(action)) {

                u.setIsVerified(2);

                userRepository.save(u);


                // Send Email
                new Thread(() ->
                        sendVerificationEmail(
                                u.getEmail(),
                                u.getFirstname(),
                                false
                        )
                ).start();


                return "redirect:/admin/admin-dashboard?msg=rejected";
            }


            // =================================================
            // INVALID ACTION
            // =================================================

            else {

                return "redirect:/admin/admin-dashboard?msg=invalidaction";
            }


        } catch (NumberFormatException e) {

            e.printStackTrace();

            return "redirect:/admin/admin-dashboard?msg=invalidaction";
        }
    }


    // =====================================================
    // EMAIL
    // =====================================================

    private void sendVerificationEmail(
            String toEmail,
            String name,
            boolean approved) {


        if (toEmail == null || toEmail.trim().isEmpty()) {
            return;
        }


        final String senderEmail =
                "niteshchaudhari0623@gmail.com";

        final String senderPassword =
                "lxtb gqzv ghde uhld";


        String subject;

        String body;


        // =================================================
        // APPROVED EMAIL
        // =================================================

        if (approved) {

            subject =
                    "Company Account Verified — JobBoard";


            body =
                    "Hello "
                            + (name != null ? name : "Employer")
                            + ",\n\n"
                            + "Your company account has been verified "
                            + "by the JobBoard Admin Team.\n"
                            + "You can now login and start posting jobs.\n\n"
                            + "Login: http://localhost:8080/login\n\n"
                            + "Regards,\n"
                            + "JobBoard Admin";

        }


        // =================================================
        // REJECTED EMAIL
        // =================================================

        else {

            subject =
                    "Company Verification Update — JobBoard";


            body =
                    "Hello "
                            + (name != null ? name : "Employer")
                            + ",\n\n"
                            + "Your company verification was declined.\n"
                            + "Please contact support for more details.\n\n"
                            + "Regards,\n"
                            + "JobBoard Admin";
        }


        // =================================================
        // SMTP CONFIGURATION
        // =================================================

        Properties prop = new Properties();

        prop.put(
                "mail.smtp.host",
                "smtp.gmail.com"
        );

        prop.put(
                "mail.smtp.port",
                "587"
        );

        prop.put(
                "mail.smtp.auth",
                "true"
        );

        prop.put(
                "mail.smtp.starttls.enable",
                "true"
        );

        prop.put(
                "mail.smtp.ssl.trust",
                "smtp.gmail.com"
        );


        try {

            Session mailSession =
                    Session.getInstance(
                            prop,
                            new Authenticator() {

                                @Override
                                protected PasswordAuthentication
                                getPasswordAuthentication() {

                                    return new PasswordAuthentication(
                                            senderEmail,
                                            senderPassword
                                    );
                                }
                            }
                    );


            Message message =
                    new MimeMessage(mailSession);


            message.setFrom(
                    new InternetAddress(
                            senderEmail,
                            "JobBoard Admin"
                    )
            );


            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(
                            toEmail.trim()
                    )
            );


            message.setSubject(subject);

            message.setText(body);


            Transport.send(message);


            System.out.println(
                    "Status email sent to: "
                            + toEmail
            );


        } catch (Exception e) {

            e.printStackTrace();
        }
    }
}