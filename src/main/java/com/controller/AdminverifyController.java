package com.controller;

import com.dao.userdao;
import com.model.UserModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/AdminVerifyController")
public class AdminverifyController extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String userid = request.getParameter("userid");
	    String action = request.getParameter("action");

	    userdao dao = new userdao();
	    UserModel u = dao.getUserById(Integer.parseInt(userid));

	    if (u == null) {
	        response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp?msg=usernotfound");
	        return;
	    }

	    if ("approve".equals(action)) {
	        boolean updated = dao.updateVerification(Integer.parseInt(userid), 1);
	        if (updated) {
	            sendVerificationEmail(u.getEmail(), u.getFirstname(), true);
	            response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp?msg=approved");
	        } else {
	            response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp?msg=failed");
	        }

	    } else if ("reject".equals(action)) {
	        boolean updated = dao.updateVerification(Integer.parseInt(userid), 2);
	        if (updated) {
	            sendVerificationEmail(u.getEmail(), u.getFirstname(), false);
	            response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp?msg=rejected");
	        } else {
	            response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp?msg=failed");
	        }

	    } else {
	        response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp?msg=invalidaction");
	    }
	}

    /* ================= SEND EMAIL ================= */
    private void sendVerificationEmail(String toEmail, String name, boolean approved) {

        final String senderEmail    = "niteshchaudhary3570@gmail.com";
        final String senderPassword = "ftfj aeas afzb lrhu";  

        String subject = approved
                ? "✅ Company Verified - JobBoard"
                : "❌ Verification Rejected - JobBoard";

        String body = approved
                ? "Hello " + name + ",\n\n"
                + "Congratulations! Your company has been verified on JobBoard.\n"
                + "You can now login and start posting jobs.\n\n"
                + "Login here: http://localhost:8080/jobportal/login.jsp\n\n"
                + "Regards,\nJobBoard Team"

                : "Hello " + name + ",\n\n"
                + "Sorry, your company verification was rejected by our admin team.\n"
                + "Please contact support or register again with correct details.\n\n"
                + "Regards,\nJobBoard Team";

        Properties prop = new Properties();
        prop.put("mail.smtp.host",                   "smtp.gmail.com");
        prop.put("mail.smtp.port",                   "587");
        prop.put("mail.smtp.auth",                   "true");
        prop.put("mail.smtp.starttls.enable",        "true");
        prop.put("mail.smtp.starttls.required",      "true");
        prop.put("mail.smtp.ssl.protocols",          "TLSv1.2");    
        prop.put("mail.smtp.ssl.trust",              "smtp.gmail.com");
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
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            System.out.println("✅ Verification email sent to: " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("❌ Email send failed: " + e.getMessage());
        }
    }
}