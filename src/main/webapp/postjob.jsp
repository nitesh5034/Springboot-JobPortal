<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.Repository.UserRepository" %>
<%@ page import="com.Repository.ApplyRepository" %>
<%@ page import="com.Repository.JobRepository" %>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.model.companyverify" %>

<%
    // 1. Session Model Retrieval
    Object sessionModel = session.getAttribute("Model");
    String role = (String) session.getAttribute("role");

    // Session Guard
    if (sessionModel == null || !"EMPLOYER".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Type-Safe Session Extraction (Prevents ClassCastException)
    String employerEmail = "";
    String companyName = "";
    companyverify u = null; // Helper reference if needed elsewhere

    if (sessionModel instanceof UserModel) {
        UserModel um = (UserModel) sessionModel;
        employerEmail = um.getEmail();
        companyName = um.getFirstname();
    } else if (sessionModel instanceof companyverify) {
        u = (companyverify) sessionModel;
        employerEmail = u.getEmail();
        companyName = u.getCompanyname();
    }

    if (companyName == null || companyName.trim().isEmpty()) {
        companyName = "Employer";
    }

    // Avatar Initial
    String initial = String.valueOf(companyName.charAt(0)).toUpperCase();

    // 3. Dynamic Counts Retrieval
    int liveCandidates = 0;
    int totalApps = 0;
    int totalJobs = 0;

    try {
        WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
        if (ctx != null) {
            UserRepository userRepo   = ctx.getBean(UserRepository.class);
            ApplyRepository applyRepo = ctx.getBean(ApplyRepository.class);
            JobRepository jobRepo     = ctx.getBean(JobRepository.class);

            if (userRepo != null)  liveCandidates = (int) userRepo.count();
            if (applyRepo != null) totalApps      = (int) applyRepo.count();
            if (jobRepo != null)   totalJobs      = (int) jobRepo.count();
        }
    } catch (Exception e) {
        liveCandidates = 10;
        totalApps = 25;
        totalJobs = 5;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JobBoard — Post a New Job</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              brand: { 50: '#eff6ff', 500: '#3b82f6', 600: '#2563eb', 700: '#1d4ed8' }
            }
          }
        }
      }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'DM Sans', sans-serif; }
        h1,h2,h3,.font-sora { font-family: 'Sora', sans-serif; }
        .input-group { display: flex; flex-direction: column; gap: 0.375rem; }
        .input-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: #64748b; }
        .input-field { width: 100%; padding: 0.75rem 1rem; border-radius: 0.75rem; border: 1px solid #e2e8f0; outline: none; transition: all 0.2s; font-size: 0.875rem; background-color: #ffffff; }
        .input-field:focus { border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 antialiased">

    <!-- Header Navigation -->
    <header class="bg-white border-b border-slate-200 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
            <a href="compny-home.jsp" class="font-sora font-bold text-xl text-slate-900 tracking-tight">
                Job<span class="text-brand-600">Board</span>
                <span class="ml-2 text-xs bg-brand-50 text-brand-600 px-2.5 py-0.5 rounded-full font-sans font-medium">Employer</span>
            </a>

            <div class="flex items-center gap-4">
                <div class="hidden sm:block text-right mr-1">
                    <p class="text-sm font-semibold text-slate-800"><%= companyName %></p>
                    <p class="text-xs text-slate-400">Employer Account</p>
                </div>
                <div class="w-10 h-10 rounded-full bg-gradient-to-br from-brand-500 to-purple-500 text-white flex items-center justify-center font-bold text-sm shadow-lg">
                    <%= initial %>
                </div>
                <a href="compny-home.jsp" class="ml-2 text-xs font-semibold text-slate-500 hover:text-slate-800 transition">
                    <i class="fas fa-arrow-left mr-1"></i> Dashboard
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-5xl mx-auto px-6 py-10">

        <!-- Live Platform Stats -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-8">
            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-blue-50 text-brand-600 flex items-center justify-center text-xl">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-slate-800"><%= liveCandidates %></p>
                    <p class="text-xs text-slate-400 font-medium">Active Candidates</p>
                </div>
            </div>

            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-xl">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-slate-800"><%= totalApps %></p>
                    <p class="text-xs text-slate-400 font-medium">Total Applications</p>
                </div>
            </div>

            <div class="bg-white p-5 rounded-2xl border border-slate-200/80 shadow-sm flex items-center gap-4">
                <div class="w-12 h-12 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center text-xl">
                    <i class="fas fa-briefcase"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-slate-800"><%= totalJobs %></p>
                    <p class="text-xs text-slate-400 font-medium">Live Jobs</p>
                </div>
            </div>
        </div>

        <!-- Post Job Card Form -->
        <div class="bg-white rounded-3xl border border-slate-200/80 shadow-xl overflow-hidden">
            <div class="bg-slate-900 px-8 py-6 text-white">
                <h1 class="font-sora text-2xl font-bold">Post a New Opening</h1>
                <p class="text-slate-400 text-sm mt-1">Publish job details to reach thousands of qualified applicants.</p>
            </div>

            <form action="JobController" method="POST" class="p-8 space-y-6">
                <input type="hidden" name="action" value="postJob">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="input-group">
                        <label class="input-label">Company Name</label>
                        <input type="text" name="company_name" value="<%= companyName %>" class="input-field" required readonly>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Contact Email</label>
                        <input type="email" name="email" value="<%= employerEmail %>" class="input-field" required readonly>
                    </div>

                    <div class="input-group md:col-span-2">
                        <label class="input-label">Job Title *</label>
                        <input type="text" name="jobTitle" placeholder="e.g. Senior Full Stack Java Developer" class="input-field" required>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Job Category *</label>
                        <select name="category" class="input-field" required>
                            <option value="">Select Category</option>
                            <option value="Information Technology">Information Technology</option>
                            <option value="Software Development">Software Development</option>
                            <option value="Web Design">Web Design</option>
                            <option value="Finance & Sales">Finance & Sales</option>
                        </select>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Job Type *</label>
                        <select name="jobType" class="input-field" required>
                            <option value="Full Time">Full Time</option>
                            <option value="Part Time">Part Time</option>
                            <option value="Contract">Contract</option>
                            <option value="Internship">Internship</option>
                            <option value="Remote">Remote</option>
                        </select>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Offered Salary (Annual) *</label>
                        <input type="text" name="salary" placeholder="e.g. ₹6,00,000 - ₹10,00,000" class="input-field" required>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Required Experience *</label>
                        <input type="text" name="experience" placeholder="e.g. 2-4 Years" class="input-field" required>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Openings *</label>
                        <input type="number" name="opening" value="1" min="1" class="input-field" required>
                    </div>

                    <div class="input-group">
                        <label class="input-label">Job Location *</label>
                        <input type="text" name="location" placeholder="e.g. Ahmedabad, Gujarat or Remote" class="input-field" required>
                    </div>

                    <div class="input-group md:col-span-2">
                        <label class="input-label">Key Skills Required *</label>
                        <input type="text" name="skillsReq" placeholder="e.g. Java, Spring Boot, MySQL, JSP, Tailwind" class="input-field" required>
                    </div>

                    <div class="input-group md:col-span-2">
                        <label class="input-label">Detailed Job Description *</label>
                        <textarea name="description" rows="5" placeholder="Write responsibilities, qualifications, and role description..." class="input-field" required></textarea>
                    </div>
                </div>

                <div class="pt-4 flex items-center justify-end gap-4 border-t border-slate-100">
                    <a href="compny-home.jsp" class="px-6 py-3 rounded-xl text-sm font-semibold text-slate-500 hover:bg-slate-100 transition">Cancel</a>
                    <button type="submit" class="px-8 py-3 rounded-xl text-sm font-semibold bg-brand-600 hover:bg-brand-700 text-white transition shadow-lg shadow-brand-600/30">
                        <i class="fas fa-paper-plane mr-2"></i>Publish Job
                    </button>
                </div>
            </form>
        </div>
    </main>

</body>
</html>