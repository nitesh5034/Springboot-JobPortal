<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.dao.CompanyDao" %>
<%@ page import="com.dao.postjobdao" %>
<%@ page import="com.model.Postjob" %>
<%@ page import="java.util.List" %>

<%

// UserModel u = (UserModel) session.getAttribute("Model");  <-- આ લાઈન ખોટી છે

com.model.companyverify u = (com.model.companyverify) session.getAttribute("Model");
String role = (String) session.getAttribute("role");

if (u == null || !"EMPLOYER".equalsIgnoreCase(role)) {
    response.sendRedirect("login.jsp");
    return;
}


  CompanyDao companyDAO = new CompanyDao();
  postjobdao jobDAO     = new postjobdao();

  int totalCandidates   = companyDAO.getTotalCandidates();
  int totalJobs         = jobDAO.getTotalJobs();
  int totalApplications = companyDAO.getTotalApplications();
  int totalCompanies = companyDAO.getAllRegisteredCompaniesCount(); 

  List<Postjob> postedJobs = jobDAO.getJobsByCompany(u.getEmail());

  String initial = u.getCompanyname() != null && !u.getCompanyname().isEmpty()
      ? String.valueOf(u.getCompanyname().charAt(0)).toUpperCase() : "C";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>JobBoard — Company Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm:   ['DM Sans', 'sans-serif'],
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    body { font-family: 'DM Sans', sans-serif; }
    h1,h2,h3,.font-sora { font-family: 'Sora', sans-serif; }
    html { scroll-behavior: smooth; }

    .navbar-blur { background: rgba(15,23,42,0.92); backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px); }

    .hero-mesh { background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%); position: relative; overflow: hidden; }
    .hero-mesh::before { content: ''; position: absolute; inset: 0; background-image: radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.25) 0%, transparent 70%), radial-gradient(ellipse 40% 40% at 20% 70%, rgba(245,158,11,0.10) 0%, transparent 60%); }
    .hero-mesh::after { content: ''; position: absolute; inset: 0; background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px); background-size: 28px 28px; }

    .stats-overlay { background: linear-gradient(135deg, #1a56db 0%, #0f172a 100%); position: relative; overflow: hidden; }
    .stats-overlay::before { content: ''; position: absolute; inset: 0; background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px); background-size: 24px 24px; }

    .job-row { transition: background 0.18s, transform 0.18s; }
    .job-row:hover { background: #f0f6ff; transform: translateX(3px); }

    .dropdown-menu { display: none; position: absolute; top: 110%; right: 0; min-width: 200px; background: #fff; border: 1px solid #e2e8f0; border-radius: 12px; box-shadow: 0 12px 40px rgba(0,0,0,0.14); padding: 8px 0; z-index: 100; }
    .dropdown-parent:hover .dropdown-menu { display: block; }
    .dropdown-menu a { display: flex; align-items: center; gap: 8px; padding: 10px 18px; font-size: 13px; color: #475569; text-decoration: none; transition: background 0.15s, color 0.15s; }
    .dropdown-menu a:hover { background: #f8fafc; color: #1a56db; }
    .logout-link { color: #ef4444 !important; }
    .logout-link:hover { background: #fef2f2 !important; }
    .dropdown-divider { border-top: 1px solid #e2e8f0; margin: 6px 0; }

    .company-logo { filter: grayscale(100%); opacity: 0.4; transition: all 0.3s; }
    .company-logo:hover { filter: none; opacity: 1; }

    #mobileMenu { display: none; }
    #mobileMenu.open { display: block; }
  </style>
</head>
<body class="bg-gray-50 text-gray-900 antialiased">

<!-- NAVBAR -->
<header class="navbar-blur sticky top-0 z-50 border-b border-white/10">
  <div class="max-w-7xl mx-auto px-5 py-3 flex items-center justify-between gap-6">
    <a href="companyhome.jsp" class="font-sora font-bold text-xl text-white tracking-tight flex-shrink-0">
      Job<span class="text-yellow-400">Board</span>
      <span class="ml-2 text-xs bg-yellow-400/20 text-yellow-400 px-2 py-0.5 rounded-full align-middle">Employer</span>
    </a>
    <nav class="hidden xl:flex items-center gap-1">
      <a href="companyhome.jsp" class="text-white/90 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-home mr-1.5 text-xs"></i>Home
      </a>
      <a href="postjob.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-plus-circle mr-1.5 text-xs"></i>Post a Job
      </a>
      <a href="companyappview.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-file-alt mr-1.5 text-xs"></i>Applications
      </a>
      <a href="companyprofile.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-building mr-1.5 text-xs"></i>Profile
      </a>
      <div class="dropdown-parent relative ml-2">
        <button class="flex items-center gap-2 bg-white/10 border border-white/20 rounded-full pl-1.5 pr-3 py-1.5 text-sm text-white font-medium hover:bg-white/20 transition-all">
          <span class="w-7 h-7 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center"><%= initial %></span>
          <%= u.getCompanyname() %>
          <i class="fas fa-chevron-down text-[10px] text-white/60"></i>
        </button>
        <div class="dropdown-menu">
          <a href="companyprofile.jsp"><i class="fas fa-building fa-xs text-blue-600"></i> Company Profile</a>
          <a href="postjob.jsp"><i class="fas fa-plus fa-xs text-blue-600"></i> Post New Job</a>
          <a href="applicationview.jsp"><i class="fas fa-file-alt fa-xs text-blue-600"></i> Applications</a>
          <a href="Setting.jsp"><i class="fas fa-cog fa-xs text-gray-400"></i> Settings</a>
          <div class="dropdown-divider"></div>
          <a href="login.jsp" class="logout-link"><i class="fas fa-sign-out-alt fa-xs"></i> Logout</a>
        </div>
      </div>
    </nav>
    <div class="hidden xl:flex items-center gap-2 flex-shrink-0">
      <a href="postjob.jsp" class="border border-white/30 text-white text-sm font-medium px-4 py-2 rounded-lg hover:bg-white/10 transition-all">
        <i class="fas fa-plus mr-1.5 text-xs"></i>Post Job
      </a>
      <a href="logout" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium px-4 py-2 rounded-lg transition-all">
        <i class="fas fa-sign-out-alt mr-1.5 text-xs"></i>Logout
      </a>
    </div>
    <button id="hamburger" class="xl:hidden text-white text-xl p-1"><i class="fas fa-bars"></i></button>
  </div>
  <div id="mobileMenu" class="xl:hidden border-t border-white/10 px-5 pb-4 pt-2 flex flex-col gap-1">
    <a href="companyhome.jsp"     class="text-white/90 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-home w-4"></i> Home</a>
    <a href="postjob.jsp"         class="text-white/70 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-plus-circle w-4"></i> Post a Job</a>
    <a href="applicationview.jsp" class="text-white/70 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-file-alt w-4"></i> Applications</a>
    <a href="companyprofile.jsp"  class="text-white/70 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-building w-4"></i> Profile</a>
    <hr class="border-white/10 my-1">
    <a href="logout" class="text-red-400 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-sign-out-alt w-4"></i> Logout</a>
  </div>
</header>

<!-- HERO -->
<section class="hero-mesh min-h-[520px] flex items-center py-20 relative">
  <div class="max-w-7xl mx-auto px-5 relative z-10 w-full">
    <div class="max-w-3xl mx-auto text-center">
      <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-5">
        <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
        Company Dashboard
      </div>
      <h1 class="font-sora text-4xl md:text-5xl font-bold text-white leading-tight tracking-tight mb-3">
        Welcome Back, <span class="text-yellow-400"><%= u.getCompanyname() %></span>! 👋
      </h1>
      <p class="text-white/60 text-base mb-10">Manage your job postings and track applications from one powerful place.</p>
      <form method="GET" action="joblistings.jsp">
        <div class="bg-white rounded-2xl p-2.5 flex flex-wrap gap-2 shadow-2xl max-w-3xl mx-auto">
          <div class="flex-1 min-w-[150px] flex items-center gap-2 px-3 py-2.5 rounded-xl border-[1.5px] border-transparent focus-within:border-blue-600 focus-within:bg-blue-50 transition-all">
            <i class="fas fa-search text-gray-400 text-sm flex-shrink-0"></i>
            <input type="text" name="keyword" placeholder="Job title or skill..." class="border-none outline-none bg-transparent text-sm text-gray-800 w-full placeholder:text-gray-400">
          </div>
          <div class="w-px bg-gray-200 hidden sm:block self-stretch my-1"></div>
          <div class="flex-1 min-w-[130px] flex items-center gap-2 px-3 py-2.5 rounded-xl border-[1.5px] border-transparent focus-within:border-blue-600 transition-all">
            <i class="fas fa-map-marker-alt text-gray-400 text-sm flex-shrink-0"></i>
            <select name="location" class="border-none outline-none bg-transparent text-sm text-gray-700 w-full cursor-pointer">
              <option value="">Anywhere</option>
              <option value="ahmedabad">Ahmedabad</option>
              <option value="surat">Surat</option>
              <option value="mumbai">Mumbai</option>
              <option value="bangalore">Bangalore</option>
              <option value="delhi">Delhi</option>
              <option value="remote">Remote</option>
            </select>
          </div>
          <div class="w-px bg-gray-200 hidden sm:block self-stretch my-1"></div>
          <div class="flex-1 min-w-[130px] flex items-center gap-2 px-3 py-2.5 rounded-xl border-[1.5px] border-transparent focus-within:border-blue-600 transition-all">
            <i class="fas fa-briefcase text-gray-400 text-sm flex-shrink-0"></i>
            <select name="jobType" class="border-none outline-none bg-transparent text-sm text-gray-700 w-full cursor-pointer">
              <option value="">All Types</option>
              <option value="fulltime">Full Time</option>
              <option value="parttime">Part Time</option>
              <option value="contract">Contract</option>
              <option value="internship">Internship</option>
            </select>
          </div>
          <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-6 py-2.5 rounded-xl transition-all flex-shrink-0">
            <i class="fas fa-search mr-2"></i>Search
          </button>
        </div>
      </form>
      <div class="mt-5 flex items-center justify-center gap-2 flex-wrap">
        <span class="text-white/50 text-xs">Quick Links:</span>
        <a href="postjob.jsp"         class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">Post a Job</a>
        <a href="applicationview.jsp" class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">Applications</a>
        <a href="companyprofile.jsp"  class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">Edit Profile</a>
      </div>
    </div>
  </div>
  <a href="#stats" class="absolute bottom-6 left-1/2 -translate-x-1/2 text-white/40 hover:text-white/70 transition-all animate-bounce z-10">
    <i class="fas fa-chevron-down text-lg"></i>
  </a>
</section>

<!-- STATS -->
<section id="stats" class="stats-overlay py-14 relative">
  <div class="max-w-7xl mx-auto px-5 relative z-10">
    <div class="text-center mb-10">
      <p class="text-xs font-semibold text-blue-300 uppercase tracking-widest mb-1">Platform Overview</p>
      <h2 class="font-sora text-2xl md:text-3xl font-bold text-white">JobBoard Live Stats</h2>
    </div>
    <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
      <div class="bg-white/10 border border-white/10 rounded-2xl p-6 text-center hover:bg-white/15 transition-all hover:-translate-y-1">
        <div class="w-11 h-11 rounded-xl bg-blue-600/30 flex items-center justify-center mx-auto mb-3"><i class="fas fa-users text-blue-300 text-lg"></i></div>
        <div class="font-sora text-3xl font-bold text-white number" data-number="<%= totalCandidates %>">0</div>
        <div class="text-xs text-white/50 uppercase tracking-wider mt-1.5">Candidates</div>
      </div>
      <div class="bg-white/10 border border-white/10 rounded-2xl p-6 text-center hover:bg-white/15 transition-all hover:-translate-y-1">
        <div class="w-11 h-11 rounded-xl bg-yellow-400/20 flex items-center justify-center mx-auto mb-3"><i class="fas fa-briefcase text-yellow-400 text-lg"></i></div>
        <div class="font-sora text-3xl font-bold text-white number" data-number="<%= totalJobs %>">0</div>
        <div class="text-xs text-white/50 uppercase tracking-wider mt-1.5">Jobs Posted</div>
      </div>
      <div class="bg-white/10 border border-white/10 rounded-2xl p-6 text-center hover:bg-white/15 transition-all hover:-translate-y-1">
        <div class="w-11 h-11 rounded-xl bg-green-500/20 flex items-center justify-center mx-auto mb-3"><i class="fas fa-file-alt text-green-400 text-lg"></i></div>
        <div class="font-sora text-3xl font-bold text-white number" data-number="<%= totalApplications %>">0</div>
        <div class="text-xs text-white/50 uppercase tracking-wider mt-1.5">Applications</div>
      </div>
     <div class="bg-white/10 border border-white/10 rounded-2xl p-6 text-center hover:bg-white/15 transition-all hover:-translate-y-1">
    <div class="w-11 h-11 rounded-xl bg-purple-500/20 flex items-center justify-center mx-auto mb-3">
        <i class="fas fa-building text-purple-400 text-lg"></i>
    </div>
    
    <div class="font-sora text-3xl font-bold text-white number" data-number="<%= totalCompanies %>">
        <%= totalCompanies %>
    </div>
    
    <div class="text-xs text-white/50 uppercase tracking-wider mt-1.5">Total Companies</div>
</div>
    </div>
  </div>
</section>

<!-- POSTED JOBS -->
<section class="py-16 bg-gray-50">
  <div class="max-w-7xl mx-auto px-5">
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8">
      <div>
        <p class="text-xs font-semibold text-blue-600 uppercase tracking-widest mb-1">Your Postings</p>
        <h2 class="font-sora text-2xl md:text-3xl font-bold text-gray-900">Posted Jobs</h2>
        <p class="text-sm text-gray-500 mt-1">Manage and track all your active job listings.</p>
      </div>
      <a href="postjob.jsp" class="flex-shrink-0 bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md">
        <i class="fas fa-plus mr-2"></i>Post New Job
      </a>
    </div>

    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
      <% if (postedJobs == null || postedJobs.isEmpty()) { %>
        <div class="py-16 px-8 text-center">
          <div class="w-16 h-16 rounded-2xl bg-blue-50 flex items-center justify-center mx-auto mb-4">
            <i class="fas fa-briefcase text-2xl text-blue-300"></i>
          </div>
          <p class="font-sora font-semibold text-gray-700 text-lg mb-1">No Jobs Posted Yet</p>
          <p class="text-sm text-gray-400 mb-5">Post your first job and start finding the right candidates.</p>
          <a href="postjob.jsp" class="inline-block bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-6 py-2.5 rounded-xl transition-all">
            <i class="fas fa-plus mr-2"></i>Post First Job
          </a>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-gray-100">
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">#</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Job Title</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Type</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Location</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Salary</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Openings</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Applied</th>
                <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-50">
              <% int sr = 1; for (Postjob job : postedJobs) {
                String jt = job.getJob_Type() != null ? job.getJob_Type().toLowerCase() : "";
                boolean isFull = jt.contains("full");
                boolean isPart = jt.contains("part");
              %>
              <tr class="job-row">
                <td class="px-5 py-4 text-sm text-gray-400 font-medium"><%= sr++ %></td>
                <td class="px-5 py-4">
                  <p class="text-sm font-semibold text-gray-900"><%= job.getJob_Title() %></p>
                  <p class="text-xs text-gray-400 mt-0.5">
                    <%= job.getExperience() %> yr exp
                    <% if (job.getSkills_req() != null && !job.getSkills_req().isEmpty()) { %>
                      &bull; <%= job.getSkills_req().length() > 30 ? job.getSkills_req().substring(0,30) + "…" : job.getSkills_req() %>
                    <% } %>
                  </p>
                </td>
                <td class="px-5 py-4">
                  <span class="inline-block px-2.5 py-1 rounded-full text-xs font-medium
                    <%= isFull ? "bg-blue-50 text-blue-600" : isPart ? "bg-green-50 text-green-600" : "bg-amber-50 text-amber-600" %>">
                    <%= job.getJob_Type() %>
                  </span>
                </td>
                <td class="px-5 py-4 text-sm text-gray-600">
                  <i class="fas fa-map-marker-alt text-gray-300 mr-1"></i><%= job.getLocation() %>
                </td>
                <td class="px-5 py-4 text-sm font-medium text-gray-700">&#8377;<%= job.getSalary() %></td>
                <td class="px-5 py-4 text-sm text-gray-600 text-center">
                  <span class="inline-flex w-8 h-8 rounded-lg bg-gray-100 text-gray-700 font-semibold text-xs items-center justify-center">
                    <%= job.getOpening() %>
                  </span>
                </td>
                <td class="px-5 py-4 text-center">
                  <span class="inline-block min-w-[28px] px-2 py-1 rounded-full bg-blue-50 text-blue-600 font-bold text-xs">
                    <%= job.getAppliedCount() %>
                  </span>
                </td>
                <!-- ✅ Actions — View Applications ઉમેર્યો -->
                <td class="px-5 py-4">
                  <div class="flex items-center gap-2">
                    <!-- ✅ View Applications -->
                    <a href="applicationview.jsp?job_id=<%= job.getJob_id() %>"
                       class="inline-flex items-center gap-1 bg-green-50 hover:bg-green-500 text-green-600 hover:text-white border border-green-200 hover:border-green-500 rounded-lg px-3 py-1.5 text-xs font-medium transition-all">
                      <i class="fas fa-eye text-[10px]"></i>
                      <% if (job.getAppliedCount() > 0) { %><%= job.getAppliedCount() %> Apps<% } else { %>Apps<% } %>
                    </a>
                    <!-- Edit -->
                    <a href="editjob.jsp?id=<%= job.getJob_id() %>"
                       class="inline-flex items-center gap-1 bg-blue-50 hover:bg-blue-600 text-blue-600 hover:text-white border border-blue-200 hover:border-blue-600 rounded-lg px-3 py-1.5 text-xs font-medium transition-all">
                      <i class="fas fa-pen text-[10px]"></i> Edit
                    </a>
                    <!-- Delete -->
                    <a href="deletejob.jsp?id=<%= job.getJob_id() %>"
                       onclick="return confirm('Job delete karvu chhe?')"
                       class="inline-flex items-center gap-1 bg-red-50 hover:bg-red-500 text-red-500 hover:text-white border border-red-200 hover:border-red-500 rounded-lg px-3 py-1.5 text-xs font-medium transition-all">
                      <i class="fas fa-trash text-[10px]"></i> Delete
                    </a>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>

    <div class="text-center mt-6">
      <a href="postjob.jsp" class="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 text-sm font-semibold group">
        <i class="fas fa-plus-circle"></i>
        <span>Post Another Job</span>
        <i class="fas fa-arrow-right text-xs transition-transform group-hover:translate-x-1"></i>
      </a>
    </div>
  </div>
</section>

<!-- COMPANIES -->
<section class="py-14 bg-white border-t border-gray-100">
  <div class="max-w-7xl mx-auto px-5">
    <div class="text-center mb-10">
      <p class="text-xs font-semibold text-blue-600 uppercase tracking-widest mb-1">Trusted By</p>
      <h2 class="font-sora text-2xl md:text-3xl font-bold text-gray-900">Companies We've Helped</h2>
    </div>
    <div class="grid grid-cols-4 md:grid-cols-8 gap-6 items-center justify-items-center">
      <img src="images/logo_mailchimp.svg" alt="Mailchimp" class="company-logo h-7 object-contain">
      <img src="images/logo_paypal.svg"    alt="PayPal"    class="company-logo h-7 object-contain">
      <img src="images/logo_stripe.svg"    alt="Stripe"    class="company-logo h-7 object-contain">
      <img src="images/logo_visa.svg"      alt="Visa"      class="company-logo h-7 object-contain">
      <img src="images/logo_apple.svg"     alt="Apple"     class="company-logo h-7 object-contain">
      <img src="images/logo_tinder.svg"    alt="Tinder"    class="company-logo h-7 object-contain">
      <img src="images/logo_sony.svg"      alt="Sony"      class="company-logo h-7 object-contain">
      <img src="images/logo_airbnb.svg"    alt="Airbnb"    class="company-logo h-7 object-contain">
    </div>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="py-16 bg-gray-50">
  <div class="max-w-7xl mx-auto px-5">
    <div class="text-center mb-10">
      <p class="text-xs font-semibold text-blue-600 uppercase tracking-widest mb-1">Success Stories</p>
      <h2 class="font-sora text-2xl md:text-3xl font-bold text-gray-900">What Employers Say</h2>
    </div>
    <div class="grid md:grid-cols-2 gap-6">
      <div class="bg-white rounded-2xl p-8 border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
        <div class="flex gap-1 mb-4">
          <i class="fas fa-star text-yellow-400 text-xs"></i><i class="fas fa-star text-yellow-400 text-xs"></i>
          <i class="fas fa-star text-yellow-400 text-xs"></i><i class="fas fa-star text-yellow-400 text-xs"></i>
          <i class="fas fa-star text-yellow-400 text-xs"></i>
        </div>
        <blockquote class="text-gray-700 text-sm leading-relaxed italic mb-6">
          "JobBoard helped us find 3 senior developers within a week. The platform is incredibly easy to use!"
        </blockquote>
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-full bg-blue-600 text-white font-bold text-sm flex items-center justify-center">CW</div>
          <div>
            <p class="text-sm font-semibold text-gray-900">Corey Woods</p>
            <p class="text-xs text-gray-400">CTO at Dribbble</p>
          </div>
        </div>
      </div>
      <div class="bg-white rounded-2xl p-8 border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
        <div class="flex gap-1 mb-4">
          <i class="fas fa-star text-yellow-400 text-xs"></i><i class="fas fa-star text-yellow-400 text-xs"></i>
          <i class="fas fa-star text-yellow-400 text-xs"></i><i class="fas fa-star text-yellow-400 text-xs"></i>
          <i class="fas fa-star text-yellow-400 text-xs"></i>
        </div>
        <blockquote class="text-gray-700 text-sm leading-relaxed italic mb-6">
          "We scaled our team from 10 to 50 people using JobBoard. The tracking system saves us hours every week!"
        </blockquote>
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-full bg-emerald-500 text-white font-bold text-sm flex items-center justify-center">CP</div>
          <div>
            <p class="text-sm font-semibold text-gray-900">Chris Peters</p>
            <p class="text-xs text-gray-400">Engineering Lead at Google</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section class="py-16 relative overflow-hidden" style="background: linear-gradient(135deg, #1a56db 0%, #0f172a 100%);">
  <div class="absolute inset-0 opacity-5" style="background-image:radial-gradient(circle,#fff 1px,transparent 1px);background-size:24px 24px;"></div>
  <div class="max-w-3xl mx-auto px-5 text-center relative z-10">
    <h2 class="font-sora text-3xl md:text-4xl font-bold text-white mb-3">Ready to Hire?</h2>
    <p class="text-white/60 text-base mb-8">Post your next job and connect with thousands of qualified candidates.</p>
    <div class="flex flex-wrap justify-center gap-3">
      <a href="postjob.jsp"        class="bg-white text-blue-600 hover:bg-gray-50 font-semibold text-sm px-6 py-3 rounded-xl transition-all hover:-translate-y-0.5 shadow-lg">
        <i class="fas fa-plus mr-2"></i>Post a Job
      </a>
      <a href="companyprofile.jsp" class="border border-white/30 text-white hover:bg-white/10 font-semibold text-sm px-6 py-3 rounded-xl transition-all">
        <i class="fas fa-building mr-2"></i>Update Profile
      </a>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer style="background:#0f172a;" class="pt-14 pb-6">
  <div class="max-w-7xl mx-auto px-5">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-10">
      <div class="col-span-2 md:col-span-1">
        <p class="font-sora font-bold text-xl text-white mb-2">Job<span class="text-yellow-400">Board</span></p>
        <p class="text-xs text-white/40 leading-relaxed max-w-[200px]">The easiest way to connect companies with top talent across India.</p>
        <div class="flex gap-2 mt-4">
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 hover:border-blue-600 transition-all text-xs"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 hover:border-blue-600 transition-all text-xs"><i class="fab fa-twitter"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 hover:border-blue-600 transition-all text-xs"><i class="fab fa-instagram"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 hover:border-blue-600 transition-all text-xs"><i class="fab fa-linkedin-in"></i></a>
        </div>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">For Employers</p>
        <ul class="space-y-2.5">
          <li><a href="postjob.jsp"         class="text-xs text-white/40 hover:text-white transition-colors">Post a Job</a></li>
          <li><a href="applicationview.jsp"  class="text-xs text-white/40 hover:text-white transition-colors">Applications</a></li>
          <li><a href="company-profile.jsp"   class="text-xs text-white/40 hover:text-white transition-colors">Company Profile</a></li>
        </ul>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">Company</p>
        <ul class="space-y-2.5">
          <li><a href="about.jsp"   class="text-xs text-white/40 hover:text-white transition-colors">About Us</a></li>
          <li><a href="contact.jsp" class="text-xs text-white/40 hover:text-white transition-colors">Contact</a></li>
          <li><a href="#"           class="text-xs text-white/40 hover:text-white transition-colors">Blog</a></li>
        </ul>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">Support</p>
        <ul class="space-y-2.5">
          <li><a href="#" class="text-xs text-white/40 hover:text-white transition-colors">FAQ</a></li>
          <li><a href="#" class="text-xs text-white/40 hover:text-white transition-colors">Privacy Policy</a></li>
          <li><a href="#" class="text-xs text-white/40 hover:text-white transition-colors">Terms of Service</a></li>
        </ul>
      </div>
    </div>
    <hr class="border-white/10 mb-6">
    <p class="text-center text-xs text-white/30">&copy; <span id="yr"></span> JobBoard. All rights reserved.</p>
  </div>
</footer>

<script>
  document.getElementById('yr').textContent = new Date().getFullYear();
  document.getElementById('hamburger').addEventListener('click', function(){
    document.getElementById('mobileMenu').classList.toggle('open');
  });
  function animateCounter(el) {
    const target = parseInt(el.getAttribute('data-number')) || 0;
    if (target === 0) return;
    let current = 0;
    const inc = target / 60;
    const timer = setInterval(() => {
      current += inc;
      if (current >= target) { current = target; clearInterval(timer); }
      el.textContent = Math.floor(current).toLocaleString();
    }, 20);
  }
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) { animateCounter(e.target); observer.unobserve(e.target); }
    });
  }, { threshold: 0.5 });
  document.querySelectorAll('.number[data-number]').forEach(el => observer.observe(el));
</script>
</body>
</html>