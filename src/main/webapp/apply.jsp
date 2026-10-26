<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel, com.model.Postjob" %>
<%@ page import="com.Repository.JobRepository" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.Optional" %>

<%
    // 1. Session Guard Check (Redirect if not logged in)
    UserModel u = (UserModel) session.getAttribute("Model");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Extract Candidate Details from Session
    String userEmail   = u.getEmail() != null ? u.getEmail().trim() : "";
    String firstName   = u.getFirstname() != null ? u.getFirstname() : "";
    String lastName    = u.getLastname() != null ? u.getLastname() : "";
    String fullName    = (firstName + " " + lastName).trim();
    String userContact = u.getContact() != null ? u.getContact() : "";
    String userCity    = u.getCity() != null ? u.getCity() : "";
    String initial     = !firstName.isEmpty() ? String.valueOf(firstName.charAt(0)).toUpperCase() : "U";

    // 3. Extract Job ID (Support both job_id and jobId parameters)
    String jobIdParam = request.getParameter("job_id");
    if (jobIdParam == null || jobIdParam.trim().isEmpty()) {
        jobIdParam = request.getParameter("jobId");
    }

    // 4. Fetch Job Details from Repository for Banner Display
    Postjob targetJob = null;
    if (jobIdParam != null && !jobIdParam.trim().isEmpty()) {
        try {
            int jobId = Integer.parseInt(jobIdParam.trim());
            WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
            JobRepository jobRepo = ctx.getBean(JobRepository.class);
            Optional<Postjob> jobOpt = jobRepo.findByJobId(jobId);
            if (jobOpt.isPresent()) {
                targetJob = jobOpt.get();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Apply for Job | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Tailwind CSS & Google Fonts -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm: ['DM Sans', 'sans-serif'],
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    body { font-family: 'DM Sans', sans-serif; background-color: #f8fafc; }
    .font-sora { font-family: 'Sora', sans-serif; }

    /* Hero Gradient Background */
    .hero-mesh {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%);
      position: relative; overflow: hidden;
    }
    .hero-mesh::before {
      content: ''; position: absolute; inset: 0;
      background-image:
        radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.25) 0%, transparent 70%),
        radial-gradient(ellipse 40% 40% at 20% 70%, rgba(245,158,11,0.10) 0%, transparent 60%);
    }
    .hero-mesh::after {
      content: ''; position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
    }

    .navbar-blur {
      background: rgba(15, 23, 42, 0.92);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
    }

    /* Input Field Custom Styling */
    .field-wrapper { position: relative; }
    .input-icon {
      position: absolute; left: 14px; top: 50%;
      transform: translateY(-50%); color: #94a3b8;
      font-size: 14px; transition: color 0.2s ease;
    }
    .custom-input {
      width: 100%; background-color: #ffffff;
      border: 1.5px solid #e2e8f0; border-radius: 12px;
      padding: 11px 16px 11px 42px; font-size: 14px;
      color: #0f172a; font-weight: 500; outline: none;
      transition: all 0.2s ease;
    }
    .custom-input:focus {
      border-color: #1a56db;
      box-shadow: 0 0 0 4px rgba(26, 86, 219, 0.12);
    }
    .custom-input:focus + .input-icon,
    .field-wrapper:focus-within .input-icon { color: #1a56db; }

    /* Static Locked Field Style */
    .custom-input-readonly {
      background-color: #f1f5f9 !important;
      border-color: #cbd5e1 !important;
      color: #475569 !important;
      cursor: not-allowed;
      user-select: none;
    }

    .glass-card {
      background: #ffffff; border-radius: 24px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05), 0 20px 25px -5px rgba(0, 0, 0, 0.02);
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-up { animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
  </style>
</head>
<body class="antialiased text-slate-800">

<!-- ===== HEADER NAVBAR ===== -->
<header class="navbar-blur sticky top-0 z-50 border-b border-white/10">
  <div class="max-w-6xl mx-auto px-5 py-3.5 flex items-center justify-between">
    <a href="user-home.jsp" class="font-sora font-bold text-xl text-white tracking-tight">
      Job<span class="text-yellow-400">Board</span>
    </a>
    <div class="flex items-center gap-3">
      <a href="user-home.jsp" class="inline-flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-all">
        <i class="fas fa-arrow-left text-[11px]"></i> Back to Jobs
      </a>
    </div>
  </div>
</header>

<!-- ===== HERO BANNER ===== -->
<section class="hero-mesh pt-10 pb-20 relative">
  <div class="max-w-4xl mx-auto px-5 relative z-10 text-center">
    <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-4">
      <span class="w-2 h-2 rounded-full bg-emerald-400 inline-block animate-pulse"></span>
      Official Application Portal
    </div>
    <h1 class="font-sora text-3xl md:text-4xl font-bold text-white tracking-tight mb-2">
      Apply for <span class="text-yellow-400"><%= targetJob != null && targetJob.getJob_Title() != null ? targetJob.getJob_Title() : "Position" %></span>
    </h1>
    <p class="text-white/60 text-sm max-w-lg mx-auto">
      <%= targetJob != null && targetJob.getCompany_name() != null ? "@ " + targetJob.getCompany_name() : "Job ID #" + (jobIdParam != null ? jobIdParam : "—") %>
    </p>
  </div>
</section>

<!-- ===== MAIN FORM CONTENT ===== -->
<main class="max-w-3xl mx-auto px-5 -mt-12 pb-20 relative z-20">

  <!-- ERROR ALERT -->
  <% if ("error".equals(msg)) { %>
    <div class="bg-rose-50 border border-rose-200 text-rose-800 px-5 py-4 rounded-2xl text-sm mb-6 flex items-center justify-between shadow-sm animate-fade-up">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-rose-500 text-white flex items-center justify-center font-bold text-xs">
          <i class="fas fa-exclamation-triangle"></i>
        </div>
        <div>
          <p class="font-semibold text-rose-900">Application Failed!</p>
          <p class="text-xs text-rose-700 mt-0.5">Something went wrong while submitting. Please try again.</p>
        </div>
      </div>
      <button onclick="this.parentElement.remove()" class="text-rose-500 hover:text-rose-700 text-sm p-1">
        <i class="fas fa-times"></i>
      </button>
    </div>
  <% } %>

  <!-- CARD CONTAINER -->
  <div class="glass-card overflow-hidden animate-fade-up">

    <!-- JOB INFO BANNER STRIP -->
    <div class="bg-slate-900 border-b border-slate-800 px-8 py-5 flex items-center justify-between flex-wrap gap-4">
      <div class="flex items-center gap-4">
        <div class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-blue-600 to-indigo-500 text-white font-sora font-extrabold text-xl flex items-center justify-center shadow-lg shadow-blue-500/30">
          <%= initial %>
        </div>
        <div>
          <h2 class="font-sora font-bold text-base text-white">
            <%= targetJob != null && targetJob.getJob_Title() != null ? targetJob.getJob_Title() : "Job Application" %>
          </h2>
          <p class="text-xs text-slate-400 mt-0.5">
            <i class="fas fa-building mr-1 text-blue-400"></i>
            <%= targetJob != null && targetJob.getCompany_name() != null ? targetJob.getCompany_name() : "JobBoard Verified" %>
            <span class="mx-1.5 text-slate-600">•</span>
            <i class="fas fa-hashtag mr-1 text-yellow-400"></i> ID: <%= jobIdParam != null ? jobIdParam : "N/A" %>
          </p>
        </div>
      </div>
      <span class="inline-flex items-center gap-1.5 bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold px-3 py-1.5 rounded-full">
        <i class="fas fa-shield-alt text-[10px]"></i> Verified Posting
      </span>
    </div>

    <!-- APPLICATION FORM -->
    <form action="ApplyServlet" method="post" enctype="multipart/form-data" class="p-8 space-y-8">

      <!-- Hidden Parameters -->
      <input type="hidden" name="action" value="apply">
      <input type="hidden" name="job_id" value="<%= jobIdParam != null ? jobIdParam : "" %>">
      <input type="hidden" name="jobId" value="<%= jobIdParam != null ? jobIdParam : "" %>">

      <!-- SECTION 1: APPLICANT PROFILE -->
      <div class="space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <div class="w-7 h-7 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center text-xs font-bold">
            <i class="fas fa-user"></i>
          </div>
          <h3 class="font-sora text-sm font-bold text-slate-900 uppercase tracking-wider">Applicant Identity</h3>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <!-- Full Name -->
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Full Name <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="fullname" value="<%= fullName %>" class="custom-input" placeholder="e.g. John Doe" required>
              <i class="fas fa-user input-icon"></i>
            </div>
          </div>

          <!-- STATIC LOCKED EMAIL FIELD -->
          <div>
            <div class="flex items-center justify-between mb-1.5">
              <label class="block text-xs font-bold uppercase tracking-wider text-slate-600">Registered Email</label>
              <span class="text-[10px] font-bold text-slate-400 bg-slate-100 px-2 py-0.5 rounded-md flex items-center gap-1">
                <i class="fas fa-lock text-[9px]"></i> Non-editable
              </span>
            </div>
            <div class="field-wrapper">
              <!-- Readonly attribute ensures email cannot be changed -->
              <input type="email" name="email" value="<%= userEmail %>" class="custom-input custom-input-readonly" readonly required>
              <i class="fas fa-lock input-icon text-slate-400"></i>
            </div>
            <p class="text-[11px] text-slate-400 mt-1">Application will be linked to your logged-in email address.</p>
          </div>
        </div>
      </div>

      <!-- SECTION 2: CONTACT & LOCATION -->
      <div class="space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <div class="w-7 h-7 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center text-xs font-bold">
            <i class="fas fa-address-book"></i>
          </div>
          <h3 class="font-sora text-sm font-bold text-slate-900 uppercase tracking-wider">Contact & Location</h3>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <!-- Mobile Number -->
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Mobile Number <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="mobileno" value="<%= userContact %>" class="custom-input" placeholder="10-digit mobile number" required>
              <i class="fas fa-phone-alt input-icon"></i>
            </div>
          </div>

          <!-- Current City -->
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Current City <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="city" value="<%= userCity %>" class="custom-input" placeholder="e.g. Ahmedabad" required>
              <i class="fas fa-map-marker-alt input-icon"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- SECTION 3: QUALIFICATION & RESUME -->
      <div class="space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <div class="w-7 h-7 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center text-xs font-bold">
            <i class="fas fa-file-pdf"></i>
          </div>
          <h3 class="font-sora text-sm font-bold text-slate-900 uppercase tracking-wider">Experience & Resume</h3>
        </div>

        <div class="space-y-5 pt-1">
          <!-- Experience -->
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Experience (Years) <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="experience" class="custom-input" placeholder="e.g. 2 or Freshers" required>
              <i class="fas fa-briefcase input-icon"></i>
            </div>
          </div>

          <!-- Resume Upload Box -->
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Upload PDF Resume <span class="text-rose-500">*</span></label>
            <div onclick="document.getElementById('resumeFile').click()"
                 class="border-2 border-dashed border-slate-200 hover:border-blue-500 bg-slate-50/50 hover:bg-blue-50/30 rounded-2xl p-6 text-center cursor-pointer transition-all duration-200 group">

              <input type="file" id="resumeFile" name="resume" accept=".pdf,.doc,.docx" required class="hidden"
                     onchange="document.getElementById('fileNameText').textContent = this.files[0].name; document.getElementById('fileBox').classList.add('border-blue-500','bg-blue-50/40');">

              <div id="fileBox" class="w-12 h-12 rounded-2xl bg-white shadow-sm border border-slate-200 text-blue-600 flex items-center justify-center mx-auto mb-3 group-hover:scale-110 transition-transform">
                <i class="fas fa-cloud-upload-alt text-xl"></i>
              </div>
              <p class="font-bold text-slate-800 text-sm" id="fileNameText">Click to select PDF or DOC file</p>
              <p class="text-xs text-slate-400 mt-1">Maximum file size: 10MB • Format: PDF, DOC, DOCX</p>
            </div>
          </div>
        </div>
      </div>

      <!-- ACTION BUTTONS -->
      <div class="pt-6 border-t border-slate-100 flex flex-col-reverse sm:flex-row items-center justify-end gap-3">
        <a href="user-home.jsp" class="w-full sm:w-auto px-6 py-3 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 text-xs font-bold tracking-wide transition-all text-center">
          Cancel
        </a>
        <button type="submit" class="w-full sm:w-auto px-8 py-3 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white text-xs font-bold tracking-wide shadow-lg shadow-blue-500/25 hover:shadow-blue-500/40 hover:-translate-y-0.5 transition-all flex items-center justify-center gap-2">
          <i class="fas fa-paper-plane text-xs"></i> Submit Application
        </button>
      </div>

    </form>
  </div>
</main>

<!-- ===== FOOTER ===== -->
<footer class="bg-slate-900 py-8 border-t border-slate-800 text-center text-xs text-slate-500">
  <div class="max-w-6xl mx-auto px-5">
    <p>&copy; 2026 <span class="text-slate-300 font-semibold">JobBoard</span>. All rights reserved.</p>
  </div>
</footer>

</body>
</html>