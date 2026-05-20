<%@page import="com.model.UserModel"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.applyDao, com.model.applymodel, com.model.companyverify, java.util.List" %>
<%@ page import="java.util.Properties, javax.mail.*, javax.mail.internet.*" %>
<%! 
  
    private void sendStatusEmail(String toEmail, String name, String status, int jobId) {
        final String senderEmail    = "niteshchaudhary3570@gmail.com";
        final String senderPassword = "ftfj aeas afzb lrhu";

        boolean approved = "shortlisted".equalsIgnoreCase(status);
        String subject = approved ? "✅ Application Shortlisted - JobBoard" : "❌ Application Update - JobBoard";
        
        String body = "Hello " + name + ",\n\n"
                    + (approved ? "Congratulations! Your application for Job ID #" + jobId + " has been shortlisted." 
                               : "We regret to inform you that your application for Job ID #" + jobId + " was not selected.")
                    + "\n\nRegards,\nJobBoard Team";

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
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<%
    // સેશનમાંથી કંપનીની વિગત મેળવવી
    com.model.companyverify employer = (com.model.companyverify) session.getAttribute("Model");
    if (employer == null) { response.sendRedirect("login.jsp"); return; }

    applyDao dao = new applyDao();
    String jobIdParam = request.getParameter("job_id");

    // --- 🔴 Status Update Logic with Email ---
    String updateAction = request.getParameter("action");
    if ("updateStatus".equals(updateAction)) {
        String applyId = request.getParameter("id");
        String status  = request.getParameter("status");
        
        if (applyId != null && status != null) {
            int id = Integer.parseInt(applyId);
            applymodel applicant = dao.getApplicationById(id);
          
            boolean success = dao.updateStatus(id, status);
          
            if (success && applicant != null) {
                sendStatusEmail(applicant.getEmail(), applicant.getFullname(), status, applicant.getJob_id());
            }

            response.sendRedirect("applicationview.jsp" + (jobIdParam != null ? "?job_id=" + jobIdParam : "") + "&msg=" + status);
            return;
        }
    }
    List<applymodel> appList;
    if (jobIdParam != null && !jobIdParam.trim().isEmpty()) {
        appList = dao.getApplicationsByJobId(Integer.parseInt(jobIdParam));
    } else {
        appList = dao.getApplicationsByEmail(employer.getEmail());
    }

    int totalApps = appList.size();
    int shortlisted = 0, rejected = 0, pending = 0;
    for (applymodel app : appList) {
        if ("shortlisted".equalsIgnoreCase(app.getStatus())) shortlisted++;
        else if ("rejected".equalsIgnoreCase(app.getStatus())) rejected++;
        else pending++;
    }

    String initial = employer.getCompanyname() != null && !employer.getCompanyname().isEmpty()
      ? String.valueOf(employer.getCompanyname().charAt(0)).toUpperCase() : "C";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Applications Hub | JobBoard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { font-family: 'DM Sans', sans-serif; background-color: #f9fafb; }
        h1, h2, h3, .font-sora { font-family: 'Sora', sans-serif; }
        
        .navbar-blur { background: rgba(15,23,42,0.92); backdrop-filter: blur(14px); border-bottom: 1px solid rgba(255,255,255,0.1); }
        
        .hero-mesh { 
            background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%); 
            position: relative; overflow: hidden; padding: 80px 0 120px;
        }
        .hero-mesh::after { content: ''; position: absolute; inset: 0; background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px); background-size: 28px 28px; }

        .stats-section { margin-top: -60px; position: relative; z-index: 10; }

        .candidate-card {
            background: white; border-radius: 20px; border: 1px solid #e5e7eb;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .candidate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05);
            border-color: #3b82f6;
        }

        .dropdown-menu { display: none; position: absolute; top: 110%; right: 0; min-width: 200px; background: #fff; border-radius: 12px; box-shadow: 0 12px 40px rgba(0,0,0,0.14); z-index: 100; }
        .dropdown-parent:hover .dropdown-menu { display: block; }
    </style>
</head>
<body>

<header class="navbar-blur sticky top-0 z-50">
  <div class="max-w-7xl mx-auto px-5 py-3 flex items-center justify-between">
    <a href="companyhome.jsp" class="font-sora font-bold text-xl text-white tracking-tight">
      Job<span class="text-yellow-400">Board</span>
    </a>
    <nav class="hidden xl:flex items-center gap-4 text-sm font-medium text-white/70">
      <a href="compny-home.jsp" class="hover:text-white px-3 py-2">Home</a>
      <a href="companyappview.jsp" class="hover:text-white px-3 py-2">Post Job</a>
      <a href="applicationview.jsp" class="text-white bg-white/10 px-4 py-2 rounded-lg">Applications</a>
      <div class="dropdown-parent relative ml-2">
        <button class="flex items-center gap-2 bg-white/10 border border-white/20 rounded-full pl-1.5 pr-3 py-1.5 text-sm text-white font-medium hover:bg-white/20 transition-all">
          <span class="w-7 h-7 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center"><%= initial %></span>
          <%= employer.getCompanyname() %>
        </button>
        <div class="dropdown-menu p-2">
          <a href="logout" class="flex items-center gap-2 px-4 py-2 text-red-500 hover:bg-red-50 rounded-lg"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
      </div>
    </nav>
  </div>
</header>

<section class="hero-mesh text-center">
  <div class="max-w-7xl mx-auto px-5 relative z-10">
    <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-5">
        <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
        Applications Manager
    </div>
    <h1 class="text-3xl md:text-5xl font-bold text-white mb-4">Review Your <span class="text-yellow-400">Talent</span></h1>
    <p class="text-white/60 text-sm max-w-xl mx-auto">Track and update the status of candidates who applied for your job openings.</p>
  </div>
</section>

<main class="max-w-7xl mx-auto px-5 pb-20">
    
    <div class="stats-section grid grid-cols-2 md:grid-cols-4 gap-4 mb-12">
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-lg">
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Total Received</p>
            <h3 class="text-3xl font-black text-blue-600"><%= totalApps %></h3>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-lg border-l-4 border-l-green-500">
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Shortlisted</p>
            <h3 class="text-3xl font-black text-green-600"><%= shortlisted %></h3>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-lg border-l-4 border-l-red-500">
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Rejected</p>
            <h3 class="text-3xl font-black text-red-600"><%= rejected %></h3>
        </div>
        <div class="bg-white p-6 rounded-2xl border border-gray-100 shadow-lg border-l-4 border-l-yellow-500">
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Pending</p>
            <h3 class="text-3xl font-black text-yellow-600"><%= pending %></h3>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <% if (appList.isEmpty()) { %>
            <div class="col-span-full py-20 text-center bg-white rounded-3xl border-2 border-dashed border-gray-200">
                <i class="fas fa-inbox text-5xl text-gray-200 mb-4"></i>
                <h3 class="text-xl font-bold text-gray-800">No Applications Found</h3>
            </div>
        <% } else { %>
            <% for (applymodel app : appList) { 
                String initialLetter = (app.getFullname() != null) ? app.getFullname().substring(0,1).toUpperCase() : "?";
            %>
            <div class="candidate-card p-8 flex flex-col">
                <div class="flex justify-between items-start mb-6">
                    <div class="flex items-center gap-4">
                        <div class="w-14 h-14 bg-slate-900 text-white rounded-2xl flex items-center justify-center font-bold text-xl shadow-lg">
                            <%= initialLetter %>
                        </div>
                        <div>
                            <h4 class="font-bold text-gray-900 text-lg"><%= app.getFullname() %></h4>
                            <p class="text-xs text-gray-400 font-medium"><%= app.getEmail() %></p>
                        </div>
                    </div>
                    <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest
                        <%= "shortlisted".equals(app.getStatus()) ? "bg-green-100 text-green-700" : ("rejected".equals(app.getStatus()) ? "bg-red-100 text-red-700" : "bg-blue-100 text-blue-700") %>">
                        <%= app.getStatus() != null ? app.getStatus() : "pending" %>
                    </span>
                </div>

                <div class="bg-gray-50 rounded-2xl p-4 mb-6 border border-gray-100 text-sm">
                    <div class="flex items-center gap-3 mb-2">
                        <i class="fas fa-phone text-blue-500 w-4"></i>
                        <span class="text-gray-700"><%= app.getMobileno() %></span>
                    </div>
                    <div class="flex items-center gap-3 mb-2">
                        <i class="fas fa-map-marker-alt text-blue-500 w-4"></i>
                        <span class="text-gray-700"><%= app.getCity() %></span>
                    </div>
                    <div class="flex items-center gap-3">
                        <i class="fas fa-briefcase text-blue-500 w-4"></i>
                        <span class="font-bold text-gray-700">Job ID: #<%= app.getJob_id() %></span>
                    </div>
                </div>

       <div class="mt-auto">
    <% if (app.getResume() != null && !app.getResume().isEmpty()) { %>
        <a href="uploads/<%= app.getResume() %>" target="_blank" class="flex items-center gap-2 text-xs font-bold text-blue-600 mb-4 hover:underline">
            <i class="fas fa-file-pdf"></i> Download Resume
        </a>
    <% } %>

    <% if (app.getStatus() == null || "pending".equalsIgnoreCase(app.getStatus())) { %>
        <form action="companyappview.jsp" method="post" class="flex gap-2">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="id" value="<%= app.getApp_id() %>">
            <% if (jobIdParam != null) { %>
                <input type="hidden" name="job_id" value="<%= jobIdParam %>">
            <% } %>
            
            <button type="submit" name="status" value="shortlisted" class="flex-1 bg-green-500 hover:bg-green-600 text-white py-3 rounded-xl text-[10px] font-bold uppercase shadow-md transition-all">
                Accept
            </button>
            <button type="submit" name="status" value="rejected" class="flex-1 bg-white border border-red-200 text-red-500 hover:bg-red-50 py-3 rounded-xl text-[10px] font-bold uppercase transition-all">
                Reject
            </button>
        </form>
    <% } else { %>
        
        <div class="bg-gray-100 text-center py-2 rounded-xl border border-dashed border-gray-300">
            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Decision Taken</p>
        </div>
    <% } %>
	</div>
            </div>
            <% } %>
        <% } %>
    </div>
</main>

<footer class="bg-slate-900 py-10 text-center border-t border-white/10">
    <p class="text-white/30 text-xs">&copy; 2026 JobBoard. All rights reserved.</p>
</footer>

</body>
</html>