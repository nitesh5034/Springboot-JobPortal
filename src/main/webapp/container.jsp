<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.model.Postjob" %>
<%@ page import="com.model.review" %>
<%@ page import="java.util.List" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.Repository.JobRepository" %>
<%@ page import="com.Repository.CompanyVerifyRepository" %>
<%@ page import="com.Repository.ApplyRepository" %>
<%@ page import="com.Repository.UserRepository" %>
<%@ page import="com.Repository.ReviewRepository" %>
<%
  UserModel m = (UserModel) session.getAttribute("Model");
  if (m == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // Fetch Repositories from Spring Context
  WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
  JobRepository jobRepo               = ctx.getBean(JobRepository.class);
  CompanyVerifyRepository companyRepo = ctx.getBean(CompanyVerifyRepository.class);
  ApplyRepository applyRepo           = ctx.getBean(ApplyRepository.class);
  UserRepository userRepo             = ctx.getBean(UserRepository.class);
  ReviewRepository reviewRepo         = ctx.getBean(ReviewRepository.class);

  List<Postjob> jobList = jobRepo.findAll();
  List<review> reviewList = null;
  try {
      reviewList = reviewRepo.findAll();
  } catch(Exception e) {
      e.printStackTrace();
  }

  // Dynamic Counts from Database
  int totalJobs       = (int) jobRepo.count();
  int totalCompanies  = (int) companyRepo.count();
  int totalFilled     = (int) applyRepo.count();
  int totalCandidates = (int) userRepo.count();
  String initial      = (m.getFirstname() != null && !m.getFirstname().isEmpty()) ? String.valueOf(m.getFirstname().charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>JobBoard — Find Your Dream Job</title>
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

    /* ===== HERO MESH BACKGROUND ===== */
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

    /* Live Canvas Layer */
    #particleCanvas {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: 2;
      pointer-events: none;
    }

    /* ===== GLOW GRADIENT TEXT ===== */
    .text-glow-gradient {
      background: linear-gradient(135deg, #a855f7 0%, #6366f1 50%, #38bdf8 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .badge-glow-gradient {
      background: linear-gradient(135deg, rgba(168, 85, 247, 0.15) 0%, rgba(99, 102, 241, 0.15) 100%);
      border: 1px solid rgba(168, 85, 247, 0.3);
    }

    /* ===== SEARCH CARD IN HERO ===== */
    .glow-search-card {
      background: rgba(15, 23, 42, 0.6);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid rgba(255, 255, 255, 0.12);
    }

    /* ===== CLEAN WHITE JOB CARDS ===== */
    .job-card-clean {
      background: #ffffff;
      border: 1.5px solid #e2e8f0;
      border-radius: 20px;
      padding: 24px;
      transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.03);
    }
    .job-card-clean:hover {
      border-color: #6366f1;
      box-shadow: 0 12px 30px -5px rgba(99, 102, 241, 0.15);
      transform: translateY(-2px);
    }

    /* ===== DROPDOWN ANIMATION ===== */
    .dropdown-custom {
      display: none; position: absolute; top: calc(100% + 12px); right: 0;
      background: #0f172a; border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 20px; padding: 10px; min-width: 240px;
      box-shadow: 0 25px 50px rgba(0,0,0,0.6); z-index: 1000;
    }
    .dropdown-custom.show { display: block; animation: floatUp 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
    @keyframes floatUp { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

    /* Modal Backdrop */
    .modal-backdrop {
      display: none; position: fixed; inset: 0;
      background: rgba(15, 23, 42, 0.75);
      backdrop-filter: blur(8px); z-index: 9999;
      align-items: center; justify-content: center; padding: 20px;
    }
    .modal-backdrop.active { display: flex; }
  </style>
</head>
<body class="antialiased">

<!-- ===== HERO NAVBAR ===== -->
<nav class="fixed top-0 inset-x-0 z-50 bg-[#030712]/80 backdrop-blur-xl border-b border-white/10">
  <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">

    <!-- Brand Logo -->
    <a href="user-home.jsp" class="font-sora font-extrabold text-2xl text-white tracking-tight flex items-center gap-2.5">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 via-indigo-600 to-sky-400 p-[1px] flex items-center justify-center shadow-lg shadow-indigo-500/30">
        <div class="w-full h-full bg-[#030712] rounded-[11px] flex items-center justify-center">
          <i class="fas fa-briefcase text-xs text-indigo-400"></i>
        </div>
      </div>
      Job<span class="text-glow-gradient">Board</span>
    </a>

    <!-- Navigation Links -->
    <div class="hidden lg:flex items-center gap-2">
      <a href="user-home.jsp" class="text-white bg-white/10 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all border border-white/10">
        <i class="fas fa-compass mr-2 text-indigo-400"></i> Explore Jobs
      </a>
      <a href="Application-track.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Applications Tracker
      </a>
      <a href="Saved-jobs.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Saved Jobs
      </a>
      <a href="review.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Reviews
      </a>
      <a href="contact.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Support
      </a>
    </div>

    <!-- Right Profile Controls -->
    <div class="flex items-center gap-4">

      <!-- User Menu -->
      <div class="relative">
        <button id="avatarBtn" class="flex items-center gap-3 bg-slate-900/80 hover:bg-slate-800 border border-white/10 rounded-full pl-1.5 pr-4 py-1.5 transition-all shadow-lg">
          <div class="w-8 h-8 rounded-full bg-gradient-to-tr from-purple-500 to-indigo-500 text-white font-sora font-extrabold text-xs flex items-center justify-center shadow-md">
            <%= initial %>
          </div>
          <span class="text-white text-xs font-semibold hidden sm:inline-block"><%= m.getFirstname() %></span>
          <i class="fas fa-chevron-down text-slate-400 text-[10px]"></i>
        </button>

        <div id="avatarMenu" class="dropdown-custom">
          <div class="px-4 py-3 border-b border-white/10 mb-1">
            <p class="text-white font-sora font-bold text-sm"><%= m.getFirstname() %> <%= m.getLastname() != null ? m.getLastname() : "" %></p>
            <p class="text-slate-400 font-mono text-[11px] truncate"><%= m.getEmail() %></p>
          </div>
          <a href="ViewProfile.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-user-circle w-4 text-indigo-400"></i> View Profile
          </a>
          <a href="edit-profile.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-sliders w-4 text-indigo-400"></i> Settings & Profile
          </a>
          <a href="Application-track.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-paper-plane w-4 text-indigo-400"></i> Track Applications
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

<!-- ===== HERO HEADER WITH LIVE PARTICLE BACKGROUND ===== -->
<section class="hero-glow-mesh pt-36 pb-28">
  <canvas id="particleCanvas"></canvas>

  <div class="max-w-7xl mx-auto px-6 relative z-10">

    <div class="max-w-3xl mx-auto text-center space-y-6 mb-12">
      <div class="inline-flex items-center gap-2.5 badge-glow-gradient rounded-full px-4 py-1.5 text-xs font-semibold text-purple-300 shadow-xl">
        <i class="fas fa-bolt text-indigo-400"></i>
        <span>Active Opportunities Available</span>
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
      </div>

      <h1 class="font-sora text-4xl md:text-6xl font-extrabold text-white tracking-tight leading-[1.15]">
        Find Your <span class="text-glow-gradient">Dream Job</span> Today
      </h1>

      <p class="text-slate-300 text-sm md:text-base max-w-xl mx-auto font-normal leading-relaxed">
        Discover verified positions from leading technology companies and top employers across India.
      </p>
    </div>

    <!-- ===== FLOATING SEARCH BAR ===== -->
    <div class="max-w-4xl mx-auto">
      <div class="glow-search-card p-3 rounded-2xl shadow-2xl">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-3">

          <div class="flex items-center gap-3 px-4 py-3 bg-slate-900/90 rounded-xl border border-white/10">
            <i class="fas fa-search text-indigo-400 text-sm"></i>
            <input type="text" id="searchInput" onkeyup="filterJobs()" placeholder="Title, skills, company..." class="w-full bg-transparent text-sm font-medium outline-none text-white placeholder:text-slate-500">
          </div>

          <div class="flex items-center gap-3 px-4 py-3 bg-slate-900/90 rounded-xl border border-white/10">
            <i class="fas fa-location-dot text-indigo-400 text-sm"></i>
            <select id="locationSelect" onchange="filterJobs()" class="w-full bg-transparent text-sm font-medium outline-none text-slate-300 cursor-pointer">
              <option value="" class="bg-slate-900">Any Location</option>
              <option value="ahmedabad" class="bg-slate-900">Ahmedabad</option>
              <option value="mumbai" class="bg-slate-900">Mumbai</option>
              <option value="bangalore" class="bg-slate-900">Bangalore</option>
              <option value="delhi" class="bg-slate-900">Delhi / NCR</option>
              <option value="remote" class="bg-slate-900">Remote</option>
            </select>
          </div>

          <button type="button" onclick="filterJobs()" class="w-full bg-gradient-to-r from-purple-600 via-indigo-600 to-blue-600 hover:from-purple-500 hover:to-blue-500 text-white font-sora font-bold text-xs uppercase tracking-wider py-3.5 px-6 rounded-xl transition-all shadow-lg shadow-indigo-500/30 flex items-center justify-center gap-2">
            <i class="fas fa-sliders text-xs"></i> Filter Results
          </button>

        </div>
      </div>
    </div>

  </div>
</section>

<!-- ===== STATS BANNER ===== -->
<section class="bg-white border-y border-slate-200 py-10 shadow-sm">
  <div class="max-w-7xl mx-auto px-6">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
      <div>
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-indigo-600 mb-1"><%= totalCandidates %>+</p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Registered Candidates</p>
      </div>
      <div>
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-slate-900 mb-1"><%= totalJobs %>+</p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Verified Openings</p>
      </div>
      <div>
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-slate-900 mb-1"><%= totalFilled %>+</p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Applications Submitted</p>
      </div>
      <div>
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-indigo-600 mb-1"><%= totalCompanies %>+</p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Hiring Partners</p>
      </div>
    </div>
  </div>
</section>

<!-- ===== MAIN JOB LISTINGS SECTION ===== -->
<section class="py-20 bg-slate-50">
  <div class="max-w-6xl mx-auto px-6">

    <div class="flex flex-col md:flex-row md:items-end justify-between mb-10 gap-4">
      <div>
        <p class="text-xs font-mono font-bold uppercase tracking-widest text-indigo-600 mb-1.5">— Latest Positions</p>
        <h2 class="font-sora text-3xl font-extrabold text-slate-900">Featured Job Opportunities</h2>
      </div>
      <p class="text-xs text-slate-500 max-w-xs">Click quick view to see details or apply directly.</p>
    </div>

    <!-- Job Cards Container -->
    <div id="jobListContainer" class="space-y-4">
      <% if (jobList == null || jobList.isEmpty()) { %>
        <div class="bg-white rounded-2xl border border-slate-200 p-16 text-center">
          <div class="w-16 h-16 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto mb-4 text-2xl border border-indigo-100">
            <i class="fas fa-briefcase"></i>
          </div>
          <p class="font-sora font-bold text-lg text-slate-900 mb-1">No Jobs Posted Yet</p>
          <p class="text-xs text-slate-400">Please check back later for new career opportunities.</p>
        </div>
      <% } else {
          for (Postjob job : jobList) {
            String jt = job.getJob_Type() != null ? job.getJob_Type().toLowerCase() : "";
            String initialChar = job.getCompany_name() != null && !job.getCompany_name().isEmpty()
                ? String.valueOf(job.getCompany_name().charAt(0)).toUpperCase() : "J";
            boolean isFull = jt.contains("full");
            boolean isPart = jt.contains("part");
            String badgeStyle = isFull ? "bg-indigo-50 text-indigo-700 border-indigo-200" : isPart ? "bg-emerald-50 text-emerald-700 border-emerald-200" : "bg-purple-50 text-purple-700 border-purple-200";
      %>
        <div class="job-card-clean job-item flex flex-col md:flex-row md:items-center justify-between gap-6"
             data-title="<%= job.getJob_Title() != null ? job.getJob_Title().toLowerCase() : "" %>"
             data-company="<%= job.getCompany_name() != null ? job.getCompany_name().toLowerCase() : "" %>"
             data-location="<%= job.getLocation() != null ? job.getLocation().toLowerCase() : "" %>">

          <!-- Left Details -->
          <div class="flex items-start sm:items-center gap-5 min-w-0">
            <div class="w-12 h-12 rounded-2xl bg-slate-900 text-indigo-400 font-sora font-extrabold text-xl flex items-center justify-center flex-shrink-0 shadow-md">
              <%= initialChar %>
            </div>
            <div class="min-w-0">
              <div class="flex items-center gap-2">
                <h3 class="font-sora font-bold text-base text-slate-900 truncate">
                  <%= job.getJob_Title() %>
                </h3>
                <span class="text-xs text-slate-400 font-normal">@ <%= job.getCompany_name() %></span>
                <span class="hidden sm:inline-flex items-center gap-1 text-[10px] font-mono font-semibold px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-600 border border-emerald-200">
                  <i class="fas fa-check-circle"></i> Verified
                </span>
              </div>

              <div class="flex items-center gap-3 flex-wrap mt-2">
                <span class="px-2.5 py-0.5 rounded-full border text-[11px] font-mono font-semibold <%= badgeStyle %>">
                  <%= job.getJob_Type() %>
                </span>
                <span class="text-xs text-slate-500 font-mono"><i class="fas fa-location-dot text-indigo-600 mr-1"></i><%= job.getLocation() %></span>
                <span class="text-xs text-slate-500 font-mono"><i class="fas fa-indian-rupee-sign text-indigo-600 mr-1"></i><%= job.getSalary() %></span>
                <span class="text-xs text-slate-500 font-mono"><i class="fas fa-clock text-indigo-600 mr-1"></i><%= job.getExperience() %> yr exp</span>
              </div>
            </div>
          </div>

          <!-- Right Action Buttons -->
          <div class="flex items-center gap-3 self-end md:self-center flex-shrink-0">

            <button type="button"
                    onclick="openJobModal('<%= job.getJobId() %>', '<%= job.getJob_Title() %>', '<%= job.getCompany_name() %>', '<%= job.getLocation() %>', '<%= job.getSalary() %>', '<%= job.getExperience() %>', '<%= job.getJob_Type() %>', '<%= job.getJob_Description() != null ? job.getJob_Description().replace("'", "\\'") : "" %>')"
                    class="px-4 py-2.5 rounded-xl border border-slate-200 hover:bg-slate-100 text-slate-700 text-xs font-semibold transition-all">
              <i class="fas fa-eye mr-1 text-indigo-600"></i> Quick View
            </button>

            <a href="apply.jsp?job_id=<%= job.getJobId() %>" class="px-5 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold transition-all shadow-md shadow-indigo-500/20">
              <i class="fas fa-paper-plane mr-1"></i> Apply Now
            </a>

          </div>

        </div>
      <% } } %>
    </div>

  </div>
</section>

<!-- ===== CANDIDATE REVIEWS SECTION (EXACT GETTER BINDING FIX) ===== -->
<section class="py-20 bg-white border-t border-slate-200">
  <div class="max-w-6xl mx-auto px-6">

    <div class="flex flex-col md:flex-row md:items-end justify-between mb-12 gap-4">
      <div>
        <p class="text-xs font-mono font-bold uppercase tracking-widest text-indigo-600 mb-1.5">— Verified Candidate Feedback</p>
        <h2 class="font-sora text-3xl font-extrabold text-slate-900">What Candidates Say</h2>
      </div>
      <a href="review.jsp" class="inline-flex items-center gap-2 text-xs font-bold text-indigo-600 hover:text-indigo-800 transition-all">
        Post Your Review <i class="fas fa-arrow-right text-[10px]"></i>
      </a>
    </div>

    <!-- Dynamic Review Cards Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">

      <% if (reviewList == null || reviewList.isEmpty()) { %>
        <!-- Default Fallback Cards if DB is Empty -->
        <div class="bg-slate-50 border border-slate-200 p-7 rounded-2xl space-y-5 flex flex-col justify-between shadow-sm">
          <div class="space-y-3">
            <div class="flex items-center gap-1 text-amber-400 text-xs">
              <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
            </div>
            <p class="text-xs text-slate-600 leading-relaxed italic">
              "JobBoard made my application tracking effortless. Applied directly from Saved Jobs and received an interview offer in 48 hours!"
            </p>
          </div>
          <div class="flex items-center gap-3 pt-4 border-t border-slate-200">
            <div class="w-9 h-9 rounded-full bg-indigo-600 text-white font-sora font-bold text-xs flex items-center justify-center">P</div>
            <div>
              <p class="font-sora font-bold text-xs text-slate-900">Pooja Sharma</p>
              <p class="text-[10px] text-slate-500 font-mono">Software Engineer @ TechCorp</p>
            </div>
          </div>
        </div>

        <div class="bg-slate-50 border border-slate-200 p-7 rounded-2xl space-y-5 flex flex-col justify-between shadow-sm">
          <div class="space-y-3">
            <div class="flex items-center gap-1 text-amber-400 text-xs">
              <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
            </div>
            <p class="text-xs text-slate-600 leading-relaxed italic">
              "Direct recruiter response with live status updates on applications. The candidate settings page is super clean."
            </p>
          </div>
          <div class="flex items-center gap-3 pt-4 border-t border-slate-200">
            <div class="w-9 h-9 rounded-full bg-purple-600 text-white font-sora font-bold text-xs flex items-center justify-center">R</div>
            <div>
              <p class="font-sora font-bold text-xs text-slate-900">Rahul Verma</p>
              <p class="text-[10px] text-slate-500 font-mono">Full Stack Developer</p>
            </div>
          </div>
        </div>

        <div class="bg-slate-50 border border-slate-200 p-7 rounded-2xl space-y-5 flex flex-col justify-between shadow-sm">
          <div class="space-y-3">
            <div class="flex items-center gap-1 text-amber-400 text-xs">
              <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
            </div>
            <p class="text-xs text-slate-600 leading-relaxed italic">
              "The direct apply modal and quick view options saved so much time. Highly recommended for active job seekers!"
            </p>
          </div>
          <div class="flex items-center gap-3 pt-4 border-t border-slate-200">
            <div class="w-9 h-9 rounded-full bg-blue-600 text-white font-sora font-bold text-xs flex items-center justify-center">A</div>
            <div>
              <p class="font-sora font-bold text-xs text-slate-900">Ananya Patel</p>
              <p class="text-[10px] text-slate-500 font-mono">UI/UX Designer</p>
            </div>
          </div>
        </div>
      <% } else {
          for (review rev : reviewList) {
            String rName = rev.getName() != null && !rev.getName().trim().isEmpty() ? rev.getName() : "Candidate";
            String rText = rev.getText() != null && !rev.getText().trim().isEmpty() ? rev.getText() : "No review text provided.";
            int rating   = rev.getRating() > 0 ? rev.getRating() : 5;
            String rInit = String.valueOf(rName.charAt(0)).toUpperCase();
      %>
        <!-- Dynamic Review Item Bound to Exact Review Model -->
        <div class="bg-slate-50 border border-slate-200 p-7 rounded-2xl space-y-5 flex flex-col justify-between shadow-sm hover:border-indigo-300 transition-all">
          <div class="space-y-3">
            <div class="flex items-center gap-1 text-amber-400 text-xs">
              <% for (int s = 0; s < rating; s++) { %>
                <i class="fas fa-star"></i>
              <% } %>
            </div>
            <p class="text-xs text-slate-600 leading-relaxed italic">
              "<%= rText %>"
            </p>
          </div>
          <div class="flex items-center gap-3 pt-4 border-t border-slate-200">
            <div class="w-9 h-9 rounded-full bg-indigo-600 text-white font-sora font-bold text-xs flex items-center justify-center shadow-sm">
              <%= rInit %>
            </div>
            <div>
              <p class="font-sora font-bold text-xs text-slate-900"><%= rName %></p>
              <p class="text-[10px] text-slate-500 font-mono">Verified Candidate</p>
            </div>
          </div>
        </div>
      <%   }
         } %>

    </div>
  </div>
</section>

<!-- ===== QUICK VIEW JOB MODAL ===== -->
<div id="jobModal" class="modal-backdrop">
  <div class="bg-white border border-slate-200 w-full max-w-xl rounded-2xl shadow-2xl overflow-hidden m-4 animate-fade-up">

    <!-- Modal Header -->
    <div class="bg-slate-900 text-white px-6 py-5 flex items-center justify-between">
      <div>
        <h3 class="font-sora font-bold text-base text-white" id="modalTitle">Job Title</h3>
        <p class="text-xs text-slate-400 mt-0.5" id="modalCompany">Company Name</p>
      </div>
      <button type="button" onclick="closeJobModal()" class="text-slate-400 hover:text-white text-lg">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <!-- Modal Content -->
    <div class="p-6 space-y-5">
      <div class="grid grid-cols-2 gap-3">
        <div class="bg-slate-50 p-3 rounded-xl border border-slate-200">
          <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Location</p>
          <p class="text-xs font-semibold text-slate-800 mt-0.5" id="modalLocation">-</p>
        </div>
        <div class="bg-slate-50 p-3 rounded-xl border border-slate-200">
          <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Salary</p>
          <p class="text-xs font-semibold text-slate-800 mt-0.5" id="modalSalary">-</p>
        </div>
        <div class="bg-slate-50 p-3 rounded-xl border border-slate-200">
          <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Experience</p>
          <p class="text-xs font-semibold text-slate-800 mt-0.5" id="modalExp">-</p>
        </div>
        <div class="bg-slate-50 p-3 rounded-xl border border-slate-200">
          <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400">Job Type</p>
          <p class="text-xs font-semibold text-slate-800 mt-0.5" id="modalType">-</p>
        </div>
      </div>

      <div>
        <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-1.5">Job Description</p>
        <p class="text-xs text-slate-600 leading-relaxed bg-slate-50 p-4 rounded-xl border border-slate-200" id="modalDesc">
          No description available.
        </p>
      </div>

      <!-- Action Buttons -->
      <div class="pt-4 flex items-center justify-end gap-3 border-t border-slate-100">
        <button type="button" onclick="closeJobModal()" class="px-5 py-2.5 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 text-xs font-semibold">
          Close
        </button>
        <a id="modalApplyBtn" href="#" class="px-6 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold shadow-md shadow-indigo-500/20">
          <i class="fas fa-paper-plane mr-1"></i> Apply Position
        </a>
      </div>
    </div>

  </div>
</div>

<!-- ===== FOOTER ===== -->
<footer class="bg-slate-900 text-white pt-16 pb-8 border-t border-slate-800">
  <div class="max-w-6xl mx-auto px-6">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-10 pb-12 border-b border-slate-800">

      <div class="space-y-3">
        <a href="user-home.jsp" class="font-sora font-extrabold text-xl text-white">
          Job<span class="text-indigo-400">Board</span>
        </a>
        <p class="text-xs text-slate-400 leading-relaxed">Enterprise career network connecting candidates with leading companies in India.</p>
      </div>

      <div>
        <p class="text-xs font-mono font-bold uppercase tracking-wider text-indigo-400 mb-4">Navigation</p>
        <ul class="space-y-2 text-xs text-slate-400">
          <li><a href="user-home.jsp" class="hover:text-white transition-colors">Home Portal</a></li>
          <li><a href="Application-track.jsp" class="hover:text-white transition-colors">Applications Tracker</a></li>
          <li><a href="Saved-jobs.jsp" class="hover:text-white transition-colors">Saved Jobs</a></li>
          <li><a href="review.jsp" class="hover:text-white transition-colors">Candidate Reviews</a></li>
        </ul>
      </div>

      <div>
        <p class="text-xs font-mono font-bold uppercase tracking-wider text-indigo-400 mb-4">Account</p>
        <ul class="space-y-2 text-xs text-slate-400">
          <li><a href="ViewProfile.jsp" class="hover:text-white transition-colors">View Profile</a></li>
          <li><a href="edit-profile.jsp" class="hover:text-white transition-colors">Settings & Profile</a></li>
          <li><a href="contact.jsp" class="hover:text-white transition-colors">Support Desk</a></li>
        </ul>
      </div>

      <div>
        <p class="text-xs font-mono font-bold uppercase tracking-wider text-indigo-400 mb-4">Headquarters</p>
        <p class="text-xs text-slate-400 leading-relaxed">Corporate Road, SG Highway, Ahmedabad, Gujarat 380015</p>
      </div>

    </div>

    <div class="pt-8 text-center text-xs text-slate-500 font-mono">
      &copy; 2026 JobBoard Portal. All rights reserved.
    </div>
  </div>
</footer>

<script>
  // Profile Avatar Toggle
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

  // Client-side Instant Job Filtering
  function filterJobs() {
    const searchVal = document.getElementById('searchInput').value.toLowerCase();
    const locVal = document.getElementById('locationSelect').value.toLowerCase();
    const jobItems = document.querySelectorAll('.job-item');

    jobItems.forEach(item => {
      const title = item.getAttribute('data-title');
      const company = item.getAttribute('data-company');
      const location = item.getAttribute('data-location');

      const matchesSearch = title.includes(searchVal) || company.includes(searchVal);
      const matchesLoc = locVal === "" || location.includes(locVal);

      if (matchesSearch && matchesLoc) {
        item.style.display = 'flex';
      } else {
        item.style.display = 'none';
      }
    });
  }

  // Quick View Modal Controls
  function openJobModal(id, title, company, location, salary, exp, type, desc) {
    document.getElementById('modalTitle').innerText = title;
    document.getElementById('modalCompany').innerText = '@ ' + company;
    document.getElementById('modalLocation').innerText = location || 'Not Specified';
    document.getElementById('modalSalary').innerText = salary ? '₹' + salary : 'Disclosed on Application';
    document.getElementById('modalExp').innerText = exp ? exp + ' Years' : 'Freshers Allowed';
    document.getElementById('modalType').innerText = type || 'Full Time';
    document.getElementById('modalDesc').innerText = desc || 'No detailed description provided.';
    document.getElementById('modalApplyBtn').href = 'apply.jsp?job_id=' + id;

    document.getElementById('jobModal').classList.add('active');
  }

  function closeJobModal() {
    document.getElementById('jobModal').classList.remove('active');
  }

  // ===== LIVE CANVAS PARTICLES SCRIPT =====
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
      constructor() {
        this.reset();
      }
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

    for (let i = 0; i < 45; i++) {
      particles.push(new Particle());
    }

    function animateParticles() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => {
        p.update();
        p.draw();
      });
      requestAnimationFrame(animateParticles);
    }
    animateParticles();
  }
</script>

</body>
</html>