<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.model.applymodel" %>
<%@ page import="com.model.companyverify" %>
<%@ page import="com.model.Postjob" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.util.Properties, jakarta.mail.*, jakarta.mail.internet.*" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.Repository.ApplyRepository, com.Repository.JobRepository" %>

<%!
    private void sendStatusEmail(String toEmail, String name, String status, int jobId) {
        if (toEmail == null || toEmail.trim().isEmpty()) return;

        String senderEmail    = System.getenv("MAIL_SENDER_EMAIL");
        String senderPassword = System.getenv("MAIL_SENDER_APP_PASSWORD");
        if (senderEmail == null || senderEmail.trim().isEmpty()) {
            senderEmail = "niteshchaudhari0623@gmail.com";
        }
        if (senderPassword == null || senderPassword.trim().isEmpty()) {
            senderPassword = "lxtb gqzv ghde uhld";
        }

        boolean approved = "shortlisted".equalsIgnoreCase(status);
        String subject = approved ? "✅ Application Shortlisted — JobBoard" : "❌ Application Status Update — JobBoard";

        String body = "Hello " + (name != null ? name : "Candidate") + ",\n\n"
                + (approved
                    ? "Congratulations! Your application for Job Position (ID #" + jobId + ") has been shortlisted by the hiring team. Our recruitment team will connect with you shortly for the next rounds."
                    : "Thank you for taking the time to apply for Job Position (ID #" + jobId + "). We regret to inform you that the hiring team will not be moving forward with your profile at this moment.")
                + "\n\nBest Regards,\nJobBoard Recruitment Team\nsupport@jobboard.com";

        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        final String fSenderEmail = senderEmail;
        final String fSenderPassword = senderPassword;
        try {
            Session mailSession = Session.getInstance(prop, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fSenderEmail, fSenderPassword);
                }
            });
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(fSenderEmail, "JobBoard Careers"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
            System.out.println("✅ Status update email sent to candidate: " + toEmail);
        } catch (Exception e) {
            System.err.println("❌ Email dispatch failed: " + e.getMessage());
        }
    }
%>

<%
    // 1. Session Verification
    Object sessionModel = session.getAttribute("Model");
    if (sessionModel == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String employerEmail = "";
    String companyName = "";

    if (sessionModel instanceof UserModel) {
        UserModel um = (UserModel) sessionModel;
        employerEmail = um.getEmail();
        companyName = (um.getFirstname() != null ? um.getFirstname() : "") + " " + (um.getLastname() != null ? um.getLastname() : "");
    } else if (sessionModel instanceof companyverify) {
        companyverify cv = (companyverify) sessionModel;
        employerEmail = cv.getEmail();
        companyName = cv.getCompanyname();
    }

    companyName = (companyName != null && !companyName.trim().isEmpty()) ? companyName.trim() : "Employer Partner";
    employerEmail = (employerEmail != null) ? employerEmail.trim() : "";

    // 2. Fetch Spring Context & Repositories
    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    ApplyRepository applyRepo = ctx.getBean(ApplyRepository.class);
    JobRepository jobRepo     = ctx.getBean(JobRepository.class);

    String jobIdParam = request.getParameter("job_id");

    // 3. Handle Status Update Action
    String updateAction = request.getParameter("action");
    if ("updateStatus".equals(updateAction)) {
        String applyId = request.getParameter("id");
        String status  = request.getParameter("status");

        if (applyId != null && status != null) {
            try {
                int id = Integer.parseInt(applyId.trim());
                applymodel applicant = applyRepo.findById(id).orElse(null);

                if (applicant != null) {
                    applicant.setStatus(status);
                    applyRepo.save(applicant);

                    final String cMail = applicant.getEmail();
                    final String cName = applicant.getFullname();
                    final String cStat = status;
                    final int jId      = applicant.getJobId();

                    // Asynchronous background email
                    new Thread(() -> sendStatusEmail(cMail, cName, cStat, jId)).start();
                }

                String redirectUrl = "companyappview.jsp"
                        + (jobIdParam != null && !jobIdParam.trim().isEmpty() ? "?job_id=" + jobIdParam + "&msg=" + status : "?msg=" + status);
                response.sendRedirect(redirectUrl);
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    // 4. Safe Fetch of Employer's Applications
    List<Postjob> allJobsList = new ArrayList<>();
    try {
        allJobsList = jobRepo.findAll();
    } catch(Exception e) {}

    List<Integer> employerJobIds = new ArrayList<>();
    for (Postjob pj : allJobsList) {
        boolean matchEmail = (pj.getEmail() != null && pj.getEmail().trim().equalsIgnoreCase(employerEmail));
        boolean matchComp  = (pj.getCompany_name() != null && pj.getCompany_name().trim().equalsIgnoreCase(companyName));
        if (matchEmail || matchComp) {
            employerJobIds.add(pj.getJobId());
        }
    }

    List<applymodel> appList = new ArrayList<>();
    List<applymodel> allApplications = new ArrayList<>();
    try {
        allApplications = applyRepo.findAll();
        for (applymodel a : allApplications) {
            if (jobIdParam != null && !jobIdParam.trim().isEmpty()) {
                if (a.getJobId() == Integer.parseInt(jobIdParam.trim())) {
                    appList.add(a);
                }
            } else {
                if (employerJobIds.contains(a.getJobId()) || employerJobIds.isEmpty()) {
                    appList.add(a);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 5. Stat Counts Calculation
    int totalApps = appList.size();
    int shortlisted = 0, rejected = 0, pending = 0;
    for (applymodel app : appList) {
        String st = app.getStatus() != null ? app.getStatus().trim().toLowerCase() : "pending";
        if ("shortlisted".equals(st) || "approved".equals(st)) shortlisted++;
        else if ("rejected".equals(st)) rejected++;
        else pending++;
    }

    String initial = (!companyName.isEmpty()) ? String.valueOf(companyName.charAt(0)).toUpperCase() : "C";
    String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Applications Hub | JobBoard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Tailwind CSS & Google Fonts -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            fontFamily: {
              sora: ['Sora', 'sans-serif'],
              sans: ['Plus Jakarta Sans', 'sans-serif'],
              mono: ['JetBrains Mono', 'monospace']
            }
          }
        }
      }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #f8fafc; color: #0f172a; overflow-x: hidden; }
        .font-sora { font-family: 'Sora', sans-serif; }
        .font-mono { font-family: 'JetBrains Mono', monospace; }

        /* ===== HERO MESH GRADIENT ===== */
        .hero-glow-mesh {
          background: linear-gradient(-45deg, #030712, #0f172a, #1e1b4b, #090d16);
          background-size: 400% 400%;
          animation: gradientShift 12s ease infinite;
          position: relative;
          overflow: hidden;
        }

        @keyframes gradientShift {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
        }

        .hero-glow-mesh::before {
          content: ''; position: absolute; inset: 0;
          background-image: linear-gradient(to right, rgba(255, 255, 255, 0.04) 1px, transparent 1px),
                            linear-gradient(to bottom, rgba(255, 255, 255, 0.04) 1px, transparent 1px);
          background-size: 40px 40px;
          z-index: 1;
        }

        #particleCanvas {
          position: absolute; top: 0; left: 0; width: 100%; height: 100%;
          z-index: 2; pointer-events: none;
        }

        .text-glow-gradient {
          background: linear-gradient(135deg, #a855f7 0%, #6366f1 50%, #38bdf8 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
        }

        /* ===== CANDIDATE APPLICATION CARDS ===== */
        .candidate-card-clean {
          background: #ffffff;
          border: 1.5px solid #e2e8f0;
          border-radius: 24px;
          transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .candidate-card-clean:hover {
          border-color: #6366f1;
          box-shadow: 0 16px 35px -5px rgba(99, 102, 241, 0.12);
          transform: translateY(-3px);
        }

        /* ===== DROPDOWN ANIMATION ===== */
        .dropdown-custom {
          display: none; position: absolute; top: calc(100% + 12px); right: 0;
          background: #0f172a; border: 1px solid rgba(255, 255, 255, 0.12);
          border-radius: 20px; padding: 10px; min-width: 230px;
          box-shadow: 0 25px 50px rgba(0,0,0,0.6); z-index: 1000;
        }
        .dropdown-custom.show { display: block; animation: floatUp 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
        @keyframes floatUp { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="antialiased">

<!-- ===== HERO NAVBAR ===== -->
<nav class="fixed top-0 inset-x-0 z-50 bg-[#030712]/80 backdrop-blur-xl border-b border-white/10">
  <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">

    <!-- Brand Logo -->
    <a href="compny-home.jsp" class="font-sora font-extrabold text-2xl text-white tracking-tight flex items-center gap-2.5">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 via-indigo-600 to-sky-400 p-[1px] flex items-center justify-center shadow-lg shadow-indigo-500/30">
        <div class="w-full h-full bg-[#030712] rounded-[11px] flex items-center justify-center">
          <i class="fas fa-building text-xs text-indigo-400"></i>
        </div>
      </div>
      Job<span class="text-glow-gradient">Board</span>
      <span class="text-[10px] font-mono uppercase bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 px-2 py-0.5 rounded-md ml-1">Employer</span>
    </a>

    <!-- Navigation Links -->
    <div class="hidden lg:flex items-center gap-2">
      <a href="compny-home.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        <i class="fas fa-chart-pie mr-1.5 text-indigo-400"></i> Dashboard
      </a>
      <a href="postjob.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        <i class="fas fa-plus-circle mr-1.5 text-indigo-400"></i> Post New Job
      </a>
      <a href="companyappview.jsp" class="text-white bg-white/10 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all border border-white/10">
        <i class="fas fa-users mr-1.5 text-indigo-400"></i> Candidate Applications
      </a>
    </div>

    <!-- Right Profile Controls -->
    <div class="flex items-center gap-4">
      <div class="relative">
        <button id="avatarBtn" class="flex items-center gap-3 bg-slate-900/80 hover:bg-slate-800 border border-white/10 rounded-full pl-1.5 pr-4 py-1.5 transition-all shadow-lg">
          <div class="w-8 h-8 rounded-full bg-gradient-to-tr from-purple-500 to-indigo-500 text-white font-sora font-extrabold text-xs flex items-center justify-center shadow-md">
            <%= initial %>
          </div>
          <span class="text-white text-xs font-semibold hidden sm:inline-block max-w-[130px] truncate"><%= companyName %></span>
          <i class="fas fa-chevron-down text-slate-400 text-[10px]"></i>
        </button>

        <div id="avatarMenu" class="dropdown-custom">
          <div class="px-4 py-3 border-b border-white/10 mb-1">
            <p class="text-white font-sora font-bold text-xs truncate"><%= companyName %></p>
            <p class="text-slate-400 font-mono text-[10px] truncate"><%= employerEmail %></p>
          </div>
          <a href="compny-home.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-gauge w-4 text-indigo-400"></i> Employer Hub
          </a>
          <a href="postjob.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-plus w-4 text-indigo-400"></i> Create Job Posting
          </a>
          <div class="border-t border-white/10 mt-1 pt-1">
            <a href="logout" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-rose-400 hover:bg-rose-500/10 text-xs font-medium transition-all">
              <i class="fas fa-power-off w-4"></i> Log Out
            </a>
          </div>
        </div>
      </div>
    </div>

  </div>
</nav>

<!-- ===== HERO HEADER SECTION ===== -->
<section class="hero-glow-mesh pt-36 pb-28 text-center relative">
  <canvas id="particleCanvas"></canvas>

  <div class="max-w-4xl mx-auto px-6 relative z-10 space-y-4">
    <div class="inline-flex items-center gap-2 bg-indigo-500/10 border border-indigo-500/30 rounded-full px-4 py-1.5 text-xs font-semibold text-purple-300 shadow-xl">
      <i class="fas fa-user-check text-indigo-400"></i>
      <span>Applicant Management Pipeline</span>
      <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
    </div>

    <h1 class="font-sora text-3xl md:text-5xl font-extrabold text-white tracking-tight leading-tight">
      Review Your <span class="text-glow-gradient">Candidate Talent</span>
    </h1>

    <p class="text-slate-300 text-xs md:text-sm font-normal max-w-lg mx-auto leading-relaxed">
      Evaluate incoming applications, download candidate resumes, and trigger automated status updates directly to candidates' inboxes.
    </p>
  </div>
</section>

<!-- ===== STATS OVERLAY BANNER ===== -->
<section class="max-w-6xl mx-auto px-6 -mt-12 relative z-20">
  <div class="bg-white border border-slate-200/80 rounded-3xl p-6 md:p-8 shadow-xl">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
      <div class="border-r border-slate-100 last:border-0">
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-indigo-600 mb-1"><%= totalApps %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Total Received</p>
      </div>
      <div class="border-r border-slate-100 last:border-0">
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-emerald-500 mb-1"><%= shortlisted %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Shortlisted</p>
      </div>
      <div class="border-r border-slate-100 last:border-0">
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-amber-500 mb-1"><%= pending %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Pending Review</p>
      </div>
      <div>
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-rose-500 mb-1"><%= rejected %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Rejected</p>
      </div>
    </div>
  </div>
</section>

<!-- ===== MAIN APPLICATIONS PIPELINE SECTION ===== -->
<main class="max-w-6xl mx-auto px-6 py-14">

  <!-- TOAST ALERT NOTIFICATIONS -->
  <% if ("shortlisted".equals(msg)) { %>
    <div class="mb-8 p-4 bg-emerald-50 text-emerald-800 rounded-2xl border border-emerald-200 text-xs font-bold flex items-center justify-between shadow-sm">
      <div class="flex items-center gap-2">
        <i class="fas fa-check-circle text-emerald-600 text-sm"></i> Candidate successfully Shortlisted! An official confirmation email has been dispatched to their inbox.
      </div>
      <button onclick="this.parentElement.remove()" class="text-emerald-500 p-1"><i class="fas fa-times"></i></button>
    </div>
  <% } else if ("rejected".equals(msg)) { %>
    <div class="mb-8 p-4 bg-rose-50 text-rose-800 rounded-2xl border border-rose-200 text-xs font-bold flex items-center justify-between shadow-sm">
      <div class="flex items-center gap-2">
        <i class="fas fa-circle-xmark text-rose-600 text-sm"></i> Candidate application rejected. Status update email sent.
      </div>
      <button onclick="this.parentElement.remove()" class="text-rose-500 p-1"><i class="fas fa-times"></i></button>
    </div>
  <% } %>

  <!-- TOOLBAR & FILTERS -->
  <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4 mb-8">

    <!-- Search Field -->
    <div class="relative flex-1 max-w-md">
      <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
      <input type="text" id="candidateSearch" onkeyup="filterApplications()" placeholder="Search by candidate name, city or job ID..."
             class="w-full bg-white border border-slate-200 rounded-2xl pl-10 pr-4 py-3 text-xs font-semibold outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition-all shadow-sm">
    </div>

    <!-- Status Tabs -->
    <div class="flex items-center gap-1 bg-slate-200/70 p-1 rounded-2xl border border-slate-300/60 self-start sm:self-auto">
      <button onclick="setStatusFilter('all', this)" class="status-tab active-tab px-4 py-2 rounded-xl text-xs font-bold bg-white text-indigo-600 shadow-sm transition-all">All (<%= totalApps %>)</button>
      <button onclick="setStatusFilter('pending', this)" class="status-tab px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:text-slate-900 transition-all">Pending (<%= pending %>)</button>
      <button onclick="setStatusFilter('shortlisted', this)" class="status-tab px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:text-slate-900 transition-all">Shortlisted (<%= shortlisted %>)</button>
      <button onclick="setStatusFilter('rejected', this)" class="status-tab px-4 py-2 rounded-xl text-xs font-semibold text-slate-600 hover:text-slate-900 transition-all">Rejected (<%= rejected %>)</button>
    </div>

  </div>

  <!-- CANDIDATE CARDS GRID -->
  <div id="applicantGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

    <% if (appList.isEmpty()) { %>
      <div class="col-span-full py-16 text-center bg-white rounded-3xl border border-dashed border-slate-200 p-8 space-y-3">
        <div class="w-16 h-16 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto text-2xl border border-indigo-100">
          <i class="fas fa-inbox"></i>
        </div>
        <h3 class="font-sora font-bold text-slate-900 text-lg">No Applications Received Yet</h3>
        <p class="text-xs text-slate-400 max-w-sm mx-auto">Candidates who apply to your active job postings will appear here in real-time.</p>
        <div class="pt-2">
          <a href="postjob.jsp" class="inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-5 py-2.5 rounded-xl transition-all shadow-md shadow-indigo-500/20">
            <i class="fas fa-plus text-[10px]"></i> Post New Job
          </a>
        </div>
      </div>
    <% } else { %>
      <% for (applymodel app : appList) {
          String fullName = (app.getFullname() != null && !app.getFullname().trim().isEmpty()) ? app.getFullname().trim() : "Candidate";
          String email = (app.getEmail() != null) ? app.getEmail().trim() : "—";
          String city = (app.getCity() != null && !app.getCity().trim().isEmpty()) ? app.getCity().trim() : "Not Specified";

          String mobile = "—";
          try {
              mobile = app.getMobileno();
          } catch(Throwable t) {
              try { mobile = (String) app.getClass().getMethod("getContact").invoke(app); } catch(Throwable t2) {}
          }
          if (mobile == null || mobile.trim().isEmpty()) mobile = "—";

          String status = app.getStatus() != null ? app.getStatus().trim().toLowerCase() : "pending";
          String initialLetter = String.valueOf(fullName.charAt(0)).toUpperCase();

          // Safe extraction of Primary Key ID
          int applicantId = 0;
          try {
              applicantId = app.getApp_id();
          } catch(Throwable t1) {
              try {
                  applicantId = (Integer) app.getClass().getMethod("getAppId").invoke(app);
              } catch(Throwable t2) {
                  try {
                      applicantId = (Integer) app.getClass().getMethod("getId").invoke(app);
                  } catch(Throwable t3) {}
              }
          }

          // Fetch Job Title
          Postjob jobObj = null;
          try {
              jobObj = jobRepo.findById(app.getJobId()).orElse(null);
          } catch(Exception ex) {}
          String jobTitle = (jobObj != null && jobObj.getJob_title() != null) ? jobObj.getJob_title() : "Position #" + app.getJobId();

          String statusPill = "bg-amber-50 text-amber-700 border-amber-200/80";
          if ("shortlisted".equals(status) || "approved".equals(status)) {
              statusPill = "bg-emerald-50 text-emerald-700 border-emerald-200/80";
          } else if ("rejected".equals(status)) {
              statusPill = "bg-rose-50 text-rose-700 border-rose-200/80";
          }
      %>
        <!-- Individual Application Card -->
        <div class="candidate-card-clean p-7 flex flex-col justify-between space-y-6 app-card"
             data-name="<%= fullName.toLowerCase() %>"
             data-city="<%= city.toLowerCase() %>"
             data-job="<%= jobTitle.toLowerCase() %> #<%= app.getJobId() %>"
             data-status="<%= status %>">

          <div class="space-y-5">
            <!-- Card Header -->
            <div class="flex items-start justify-between gap-3">
              <div class="flex items-center gap-3.5 min-w-0">
                <div class="w-12 h-12 rounded-2xl bg-slate-900 text-indigo-400 font-sora font-extrabold text-lg flex items-center justify-center flex-shrink-0 shadow-md">
                  <%= initialLetter %>
                </div>
                <div class="min-w-0">
                  <h4 class="font-sora font-bold text-slate-900 text-sm truncate"><%= fullName %></h4>
                  <p class="text-[11px] text-slate-400 font-mono truncate"><%= email %></p>
                </div>
              </div>

              <span class="px-2.5 py-1 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border flex-shrink-0 <%= statusPill %>">
                <%= status %>
              </span>
            </div>

            <!-- Job & Details Info Box -->
            <div class="bg-slate-50 border border-slate-100 rounded-2xl p-4 space-y-2.5 text-xs">
              <div class="flex items-center justify-between">
                <span class="text-slate-400 font-medium">Applied Role:</span>
                <span class="font-bold text-indigo-600 truncate max-w-[170px]"><%= jobTitle %></span>
              </div>
              <div class="flex items-center justify-between">
                <span class="text-slate-400 font-medium">Job Ref ID:</span>
                <span class="font-mono font-semibold text-slate-700">#<%= app.getJobId() %></span>
              </div>
              <div class="flex items-center justify-between">
                <span class="text-slate-400 font-medium">Candidate Contact:</span>
                <span class="font-mono text-slate-700"><%= mobile %></span>
              </div>
              <div class="flex items-center justify-between">
                <span class="text-slate-400 font-medium">Location:</span>
                <span class="text-slate-700 font-semibold"><i class="fas fa-location-dot text-slate-400 mr-1 text-[10px]"></i><%= city %></span>
              </div>
            </div>

            <!-- Resume CV Download Link -->
            <div>
              <% if (app.getResume() != null && !app.getResume().trim().isEmpty()) { %>
                <a href="<%= request.getContextPath() %>/uploads/<%= app.getResume() %>" target="_blank"
                   class="inline-flex items-center justify-center gap-2 w-full bg-slate-100 hover:bg-slate-200/80 text-slate-700 text-xs font-bold py-2.5 px-4 rounded-xl border border-slate-200 transition-all">
                  <i class="fas fa-file-pdf text-rose-500 text-sm"></i> Download / View Resume
                </a>
              <% } else { %>
                <div class="text-center py-2 text-slate-400 text-[11px] font-mono bg-slate-50 rounded-xl border border-dashed border-slate-200">
                  No Resume Attached
                </div>
              <% } %>
            </div>
          </div>

          <!-- Action Buttons Form -->
          <div class="pt-4 border-t border-slate-100">
            <% if ("pending".equals(status)) { %>
              <form action="companyappview.jsp" method="post" class="grid grid-cols-2 gap-3">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="id" value="<%= applicantId %>">
                <% if (jobIdParam != null) { %>
                  <input type="hidden" name="job_id" value="<%= jobIdParam %>">
                <% } %>

                <button type="submit" name="status" value="shortlisted"
                        class="bg-emerald-600 hover:bg-emerald-700 text-white py-2.5 px-3 rounded-xl text-xs font-bold transition-all shadow-md shadow-emerald-500/20 flex items-center justify-center gap-1.5">
                  <i class="fas fa-check text-xs"></i> Shortlist
                </button>
                <button type="submit" name="status" value="rejected"
                        class="bg-white hover:bg-rose-50 border border-rose-200 text-rose-600 py-2.5 px-3 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-1.5">
                  <i class="fas fa-times text-xs"></i> Reject
                </button>
              </form>
            <% } else { %>
              <div class="bg-slate-50 text-center py-2.5 rounded-xl border border-slate-200">
                <span class="text-xs font-bold text-slate-500 uppercase tracking-wider font-mono">
                  <i class="fas fa-lock text-[10px] mr-1 text-slate-400"></i> Status Marked: <%= status.toUpperCase() %>
                </span>
              </div>
            <% } %>
          </div>

        </div>
      <% } %>
    <% } %>

  </div>

</main>

<!-- FOOTER -->
<footer class="bg-slate-900 text-white pt-14 pb-8 border-t border-slate-800">
  <div class="max-w-6xl mx-auto px-6 text-center space-y-2">
    <p class="font-sora font-bold text-base text-white">Job<span class="text-indigo-400">Board</span> Employer Portal</p>
    <p class="text-xs text-slate-500 font-mono">&copy; 2026 JobBoard Inc. All rights reserved.</p>
  </div>
</footer>

<!-- SCRIPT: INTERACTIVE FILTER & SEARCH -->
<script>
  // Avatar Dropdown Toggle
  const avatarBtn = document.getElementById('avatarBtn');
  const avatarMenu = document.getElementById('avatarMenu');
  if (avatarBtn && avatarMenu) {
    avatarBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      avatarMenu.classList.toggle('show');
    });
    document.addEventListener('click', () => {
      avatarMenu.classList.remove('show');
    });
  }

  // Active status filter memory
  let currentStatus = 'all';

  function setStatusFilter(status, btn) {
    currentStatus = status;
    document.querySelectorAll('.status-tab').forEach(t => {
      t.classList.remove('bg-white', 'text-indigo-600', 'shadow-sm', 'font-bold');
      t.classList.add('text-slate-600', 'font-semibold');
    });
    btn.classList.add('bg-white', 'text-indigo-600', 'shadow-sm', 'font-bold');
    btn.classList.remove('text-slate-600');

    filterApplications();
  }

  function filterApplications() {
    const searchVal = document.getElementById('candidateSearch').value.toLowerCase().trim();
    const cards = document.querySelectorAll('.app-card');

    cards.forEach(card => {
      const name = card.getAttribute('data-name');
      const city = card.getAttribute('data-city');
      const job  = card.getAttribute('data-job');
      const cardStatus = card.getAttribute('data-status');

      const matchesSearch = name.includes(searchVal) || city.includes(searchVal) || job.includes(searchVal);
      const matchesStatus = (currentStatus === 'all' || cardStatus === currentStatus);

      if (matchesSearch && matchesStatus) {
        card.style.display = 'flex';
      } else {
        card.style.display = 'none';
      }
    });
  }

  // Particle Canvas Background Script
  const canvas = document.getElementById('particleCanvas');
  if (canvas) {
    const ctx = canvas.getContext('2d');
    let particles = [];

    function resizeCanvas() {
      canvas.width = canvas.parentElement.clientWidth;
      canvas.height = canvas.parentElement.clientHeight;
    }
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    class Particle {
      constructor() { this.reset(); }
      reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 2 + 0.5;
        this.speedX = (Math.random() - 0.5) * 0.4;
        this.speedY = (Math.random() - 0.5) * 0.4;
        this.alpha = Math.random() * 0.5 + 0.2;
      }
      update() {
        this.x += this.speedX;
        this.y += this.speedY;
        if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
          this.reset();
        }
      }
      draw() {
        ctx.fillStyle = 'rgba(168, 85, 247, ' + this.alpha + ')';
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    for (let i = 0; i < 40; i++) { particles.push(new Particle()); }

    function animateParticles() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => { p.update(); p.draw(); });
      requestAnimationFrame(animateParticles);
    }
    animateParticles();
  }
</script>

</body>
</html>