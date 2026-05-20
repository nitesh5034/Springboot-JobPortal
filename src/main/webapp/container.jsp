<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.dao.postjobdao" %>
<%@ page import="com.dao.CompanyDao" %>
<%@ page import="com.model.Postjob" %>
<%@ page import="java.util.List" %>
<%
  UserModel m = (UserModel) session.getAttribute("Model");
  if (m == null) {
    response.sendRedirect("login.jsp");
    return;
  }
  postjobdao jobDAO = new postjobdao();
  CompanyDao companyDao = new CompanyDao();

  List<Postjob> jobList = jobDAO.getAllJobs();

  int totalCandidates = companyDao.getTotalCandidates();
  int totalJobs       = jobDAO.getTotalJobs();
  int totalCompanies  = companyDao.getTotalCompanies();
  int totalFilled     = companyDao.getTotalApplications();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>JobBoard — Find Your Dream Job</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    body { font-family: 'DM Sans', sans-serif; }
    h1,h2,h3,.font-sora { font-family: 'Sora', sans-serif; }
    html { scroll-behavior: smooth; }

    /* ── Navbar ── */
    .navbar { position: sticky; top: 0; z-index: 999; background: rgba(6,11,20,0.97); backdrop-filter: blur(12px); border-bottom: 1px solid rgba(255,255,255,0.08); }
    .nav-link { color: rgba(255,255,255,0.65); font-size: 14px; font-weight: 500; text-decoration: none; padding: 6px 12px; border-radius: 8px; transition: all 0.2s; cursor: pointer; }
    .nav-link:hover { color: #fff; background: rgba(255,255,255,0.08); }

    /* ── JS-driven dropdowns (no CSS :hover) ── */
    .nav-dropdown { position: relative; }
    .nav-dropdown-menu {
      display: none;
      position: absolute;
      top: calc(100% + 8px);
      left: 0;
      background: #0f172a;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 12px;
      padding: 6px;
      min-width: 190px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
      z-index: 1000;
    }
    .nav-dropdown-menu.show { display: block; }
    .nav-dropdown-menu a {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 9px 14px;
      color: rgba(255,255,255,0.65);
      font-size: 13px;
      border-radius: 8px;
      text-decoration: none;
      transition: all 0.15s;
      white-space: nowrap;
    }
    .nav-dropdown-menu a:hover { background: rgba(255,255,255,0.08); color: #fff; }

    /* ── Avatar dropdown ── */
    .avatar-dropdown { position: relative; }
    .avatar-dropdown-menu {
      display: none;
      position: absolute;
      top: calc(100% + 10px);
      right: 0;
      background: #0f172a;
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 14px;
      padding: 8px;
      min-width: 210px;
      box-shadow: 0 8px 24px rgba(0,0,0,0.4);
      z-index: 1000;
    }
    .avatar-dropdown-menu.show { display: block; }
    .avatar-menu-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 9px 12px;
      border-radius: 9px;
      color: rgba(255,255,255,0.7);
      font-size: 13px;
      text-decoration: none;
      transition: all 0.15s;
    }
    .avatar-menu-item:hover { background: rgba(255,255,255,0.08); color: #fff; }
    .avatar-menu-item.danger { color: #f87171; }
    .avatar-menu-item.danger:hover { background: rgba(248,113,113,0.1); }

    /* ── Mobile menu ── */
    .mobile-menu { display: none; background: #0a0f1a; border-top: 1px solid rgba(255,255,255,0.06); padding: 12px 16px 16px; }
    .mobile-menu.open { display: block; }
    .mobile-menu a { display: block; padding: 10px 12px; color: rgba(255,255,255,0.7); font-size: 14px; border-radius: 8px; text-decoration: none; transition: all 0.15s; }
    .mobile-menu a:hover { background: rgba(255,255,255,0.08); color: #fff; }

    /* ── Hero ── */
    .hero-mesh { background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%); position: relative; overflow: hidden; }
    .hero-mesh::before { content: ''; position: absolute; inset: 0; background-image: radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.25) 0%, transparent 70%), radial-gradient(ellipse 40% 40% at 20% 70%, rgba(245,158,11,0.10) 0%, transparent 60%); }
    .hero-mesh::after { content: ''; position: absolute; inset: 0; background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px); background-size: 28px 28px; }

    .search-input { border: none; outline: none; background: transparent; font-size: 14px; color: #0f172a; font-family: 'DM Sans', sans-serif; width: 100%; }
    .search-input::placeholder { color: #94a3b8; }
    .search-field-wrap { flex: 1; min-width: 150px; display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-radius: 10px; border: 1.5px solid transparent; transition: all 0.2s; }
    .search-field-wrap:focus-within { border-color: #1a56db; background: #f0f6ff; }

    /* ── Stats ── */
    .stats-bg { background: linear-gradient(135deg, #1a56db 0%, #0f172a 100%); position: relative; overflow: hidden; }
    .stats-bg::before { content: ''; position: absolute; inset: 0; background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px); background-size: 24px 24px; }

    /* ── Job cards ── */
    .job-card-item { background: #fff; border: 1.5px solid #e2e8f0; border-radius: 12px; padding: 20px 24px; margin-bottom: 12px; display: flex; align-items: center; justify-content: space-between; transition: all 0.2s; cursor: pointer; }
    .job-card-item:hover { border-color: #1a56db; box-shadow: 0 4px 16px rgba(0,0,0,0.10); transform: translateY(-2px); }

    /* ── Modal ── */
    .job-modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.55); z-index: 9999; align-items: center; justify-content: center; padding: 16px; }
    .job-modal-overlay.active { display: flex; }
    .job-modal-box { background: #fff; border-radius: 20px; padding: 32px; max-width: 580px; width: 100%; position: relative; max-height: 88vh; overflow-y: auto; animation: slideUp 0.25s ease; }
    @keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

    .apply-form { display: none; border-top: 1px solid #e2e8f0; padding-top: 20px; margin-top: 4px; }
    .apply-form.active { display: block; }
    .apply-input { width: 100%; border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 10px 14px; font-size: 14px; margin-bottom: 14px; font-family: 'DM Sans', sans-serif; color: #0f172a; outline: none; transition: border-color 0.2s; }
    .apply-input:focus { border-color: #1a56db; }

    .company-logo { filter: grayscale(100%); opacity: 0.4; transition: all 0.3s; }
    .company-logo:hover { filter: none; opacity: 1; }

    @media(max-width: 640px) {
      .job-card-item { flex-direction: column; align-items: flex-start; gap: 12px; }
    }
  </style>
</head>
<body class="bg-white antialiased">

<!-- ══════════════════════════════════════════
     NAVBAR
══════════════════════════════════════════ -->
<nav class="navbar">
  <div class="max-w-7xl mx-auto px-5">
    <div class="flex items-center justify-between h-16">

      <!-- Logo -->
      <a href="user-home.jsp" class="font-sora font-bold text-xl text-white tracking-tight">
        Job<span class="text-yellow-400">Board</span>
      </a>

      <!-- Desktop links -->
      <div class="hidden md:flex items-center gap-1">
        <a href="user-home.jsp" class="nav-link"><i class="fas fa-home mr-1 text-xs"></i> Home</a>

        <!-- My Account dropdown -->
        <div class="nav-dropdown">
          <span class="nav-link" id="accountDropBtn">
            My Account <i class="fas fa-chevron-down ml-1 text-xs"></i>
          </span>
          <div class="nav-dropdown-menu" id="accountDropMenu">
            <a href="ViewProfile.jsp"><i class="fas fa-user text-xs opacity-60"></i> View Profile</a>
            <a href="edit-profile.jsp"><i class="fas fa-edit text-xs opacity-60"></i> Edit Profile</a>
            <a href="Application-track.jsp"><i class="fas fa-file-alt text-xs opacity-60"></i> My Applications</a>
            <a href="Saved-jobs.jsp"><i class="fas fa-bookmark text-xs opacity-60"></i> Saved Jobs</a>
          </div>
        </div>

        <a href="contact.jsp" class="nav-link"><i class="fas fa-envelope mr-1 text-xs"></i> Contact</a>
      </div>

      <!-- Right side: bell + avatar -->
      <div class="flex items-center gap-3">
        <button class="relative w-9 h-9 rounded-full bg-white/10 hover:bg-white/20 flex items-center justify-center text-white/70 hover:text-white transition-all">
          <i class="fas fa-bell text-sm"></i>
          <span class="absolute top-1 right-1 w-2 h-2 bg-yellow-400 rounded-full"></span>
        </button>

        <!-- Avatar dropdown -->
        <div class="avatar-dropdown">
          <button class="flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 rounded-full pl-1 pr-3 py-1 transition-all" id="avatarDropBtn">
            <div class="w-7 h-7 rounded-full bg-blue-500 flex items-center justify-center font-sora font-bold text-white text-xs">
              <%= m.getFirstname().substring(0,1).toUpperCase() %>
            </div>
            <span class="text-white text-sm font-medium hidden sm:block"><%= m.getFirstname() %></span>
            <i class="fas fa-chevron-down text-white/50 text-xs" id="avatarChevron"></i>
          </button>
          <div class="avatar-dropdown-menu" id="avatarDropMenu">
            <div class="px-3 py-2 mb-1 border-b border-white/10">
              <p class="text-white text-sm font-semibold"><%= m.getFirstname() %> <%= m.getLastname() %></p>
              <p class="text-white/40 text-xs"><%= m.getEmail() %></p>
            </div>
            <a href="ViewProfile.jsp" class="avatar-menu-item"><i class="fas fa-user text-xs opacity-60"></i> View Profile</a>
            <a href="edit-profile.jsp" class="avatar-menu-item"><i class="fas fa-edit text-xs opacity-60"></i> Edit Profile</a>
            <a href="Application-track.jsp" class="avatar-menu-item"><i class="fas fa-file-alt text-xs opacity-60"></i> My Applications</a>
            <a href="Saved-jobs.jsp" class="avatar-menu-item"><i class="fas fa-bookmark text-xs opacity-60"></i> Saved Jobs</a>
            <div class="border-t border-white/10 mt-1 pt-1">
              <a href="LogoutServlet" class="avatar-menu-item danger"><i class="fas fa-sign-out-alt text-xs"></i> Logout</a>
            </div>
          </div>
        </div>

        <!-- Mobile hamburger -->
        <button class="md:hidden w-9 h-9 rounded-full bg-white/10 flex items-center justify-center text-white" id="mobileToggle">
          <i class="fas fa-bars text-sm" id="menuIcon"></i>
        </button>
      </div>

    </div>
  </div>

  <!-- Mobile menu -->
  <div class="mobile-menu" id="mobileMenu">
    <a href="user-home.jsp"><i class="fas fa-home mr-2 text-xs opacity-60"></i> Home</a>
    <a href="ViewProfile.jsp"><i class="fas fa-user mr-2 text-xs opacity-60"></i> View Profile</a>
    <a href="edit-profile.jsp"><i class="fas fa-edit mr-2 text-xs opacity-60"></i> Edit Profile</a>
    <a href="Application-track.jsp"><i class="fas fa-file-alt mr-2 text-xs opacity-60"></i> My Applications</a>
    <a href="Saved-jobs.jsp"><i class="fas fa-bookmark mr-2 text-xs opacity-60"></i> Saved Jobs</a>
    <a href="contact.jsp"><i class="fas fa-envelope mr-2 text-xs opacity-60"></i> Contact</a>
    <div class="border-t border-white/10 mt-2 pt-2">
      <a href="LogoutServlet" style="color:#f87171;"><i class="fas fa-sign-out-alt mr-2 text-xs"></i> Logout</a>
    </div>
  </div>
</nav>

<!-- ══════════════════════════════════════════
     HERO
══════════════════════════════════════════ -->
<section class="hero-mesh min-h-[520px] flex items-center py-20 relative">
  <div class="max-w-7xl mx-auto px-5 relative z-10 w-full">
    <div class="max-w-3xl mx-auto text-center">
      <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-5">
        <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
        Welcome back, <%= m.getFirstname() %>! 👋
      </div>
      <h1 class="font-sora text-4xl md:text-5xl font-bold text-white leading-tight tracking-tight mb-3">
        Find Your <span class="text-yellow-400">Dream Job</span><br>The Smarter Way
      </h1>
      <p class="text-white/60 text-base mb-10">Browse thousands of jobs from top companies. Your next opportunity is just one search away.</p>
      <form method="GET" action="user-home.jsp">
        <div class="bg-white rounded-2xl p-2.5 flex flex-wrap gap-2 shadow-2xl">
          <div class="search-field-wrap">
            <i class="fas fa-search text-gray-400 text-sm flex-shrink-0"></i>
            <input type="text" name="keyword" class="search-input" placeholder="Job title, skills or company...">
          </div>
          <div class="w-px bg-gray-200 hidden sm:block self-stretch my-1"></div>
          <div class="search-field-wrap">
            <i class="fas fa-map-marker-alt text-gray-400 text-sm flex-shrink-0"></i>
            <select name="location" class="search-input cursor-pointer">
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
          <div class="search-field-wrap">
            <i class="fas fa-briefcase text-gray-400 text-sm flex-shrink-0"></i>
            <select name="jobType" class="search-input cursor-pointer">
              <option value="">All Types</option>
              <option value="fulltime">Full Time</option>
              <option value="parttime">Part Time</option>
              <option value="contract">Contract</option>
              <option value="internship">Internship</option>
            </select>
          </div>
          <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-6 py-2.5 rounded-xl transition-all flex-shrink-0 flex items-center gap-2">
            <i class="fas fa-search text-xs"></i> Search Jobs
          </button>
        </div>
      </form>
      <div class="mt-5 flex items-center justify-center gap-2 flex-wrap">
        <span class="text-white/50 text-xs">Trending:</span>
        <a href="#" class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">Java</a>
        <a href="#" class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">Python</a>
        <a href="#" class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">React</a>
        <a href="#" class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">UI/UX</a>
        <a href="#" class="text-xs bg-white/10 border border-white/20 text-white/80 hover:text-white hover:bg-white/20 rounded-full px-3 py-1 transition-all">DevOps</a>
      </div>
    </div>
  </div>
</section>

<!-- ══════════════════════════════════════════
     STATS
══════════════════════════════════════════ -->
<section class="stats-bg py-14 relative">
  <div class="max-w-7xl mx-auto px-5 relative z-10">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
      <div class="hover:-translate-y-1 transition-all">
        <div class="font-sora text-4xl font-bold text-white mb-1"><span class="number" data-number="<%= totalCandidates %>">0</span>+</div>
        <div class="text-xs text-white/50 uppercase tracking-widest">Candidates</div>
      </div>
      <div class="hover:-translate-y-1 transition-all">
        <div class="font-sora text-4xl font-bold text-white mb-1"><span class="number" data-number="<%= totalJobs %>">0</span>+</div>
        <div class="text-xs text-white/50 uppercase tracking-widest">Jobs Posted</div>
      </div>
      <div class="hover:-translate-y-1 transition-all">
        <div class="font-sora text-4xl font-bold text-white mb-1"><span class="number" data-number="<%= totalFilled %>">0</span>+</div>
        <div class="text-xs text-white/50 uppercase tracking-widest">Applications</div>
      </div>
      <div class="hover:-translate-y-1 transition-all">
        <div class="font-sora text-4xl font-bold text-white mb-1"><span class="number" data-number="<%= totalCompanies %>">0</span>+</div>
        <div class="text-xs text-white/50 uppercase tracking-widest">Companies</div>
      </div>
    </div>
  </div>
</section>

<!-- ══════════════════════════════════════════
     JOB LISTINGS
══════════════════════════════════════════ -->
<section class="py-16 bg-gray-50">
  <div class="max-w-7xl mx-auto px-5">
    <div class="text-center mb-10">
      <p class="text-xs font-semibold text-blue-600 uppercase tracking-widest mb-1">Opportunities</p>
      <h2 class="font-sora text-2xl md:text-3xl font-bold text-gray-900 mb-2">Latest Job Listings</h2>
      <p class="text-sm text-gray-500">Click any job to see full details, apply or save for later.</p>
    </div>
    <div id="jobsContainer">
      <% if (jobList == null || jobList.isEmpty()) { %>
        <div class="text-center py-16">
          <div class="w-16 h-16 rounded-2xl bg-blue-50 flex items-center justify-center mx-auto mb-4">
            <i class="fas fa-briefcase text-2xl text-blue-300"></i>
          </div>
          <p class="font-sora font-semibold text-gray-700 text-lg mb-1">No Jobs Available</p>
          <p class="text-sm text-gray-400">Check back soon for new opportunities!</p>
        </div>
      <% } else { %>
        <% for (Postjob job : jobList) {
          String jt = job.getJob_Type() != null ? job.getJob_Type().toLowerCase() : "";
          String initial = job.getCompany_name() != null && !job.getCompany_name().isEmpty()
              ? String.valueOf(job.getCompany_name().charAt(0)).toUpperCase() : "J";
          boolean isFull = jt.contains("full");
          boolean isPart = jt.contains("part");
          String badgeClass = isFull ? "bg-blue-50 text-blue-600" : isPart ? "bg-green-50 text-green-600" : "bg-amber-50 text-amber-600";
        %>
        <div class="job-card-item"
          data-id="<%= job.getJob_id() %>"
          data-title="<%= job.getJob_Title() != null ? job.getJob_Title().replace("\"","") : "" %>"
          data-company="<%= job.getCompany_name() != null ? job.getCompany_name().replace("\"","") : "" %>"
          data-location="<%= job.getLocation() != null ? job.getLocation() : "" %>"
          data-type="<%= job.getJob_Type() != null ? job.getJob_Type() : "" %>"
          data-salary="<%= job.getSalary() != null ? job.getSalary() : "" %>"
          data-experience="<%= job.getExperience() != null ? job.getExperience() : "" %>"
          data-opening="<%= job.getOpening() %>"
          data-region="<%= job.getJob_Region() != null ? job.getJob_Region() : "" %>"
          data-desc="<%= job.getJob_Description() != null ? job.getJob_Description().replace("\"","").replace("\n"," ") : "" %>"
          data-skills="<%= job.getSkills_req() != null ? job.getSkills_req() : "" %>"
          data-initial="<%= initial %>">
          <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center font-sora font-bold text-blue-600 text-lg flex-shrink-0">
              <%= initial %>
            </div>
            <div>
              <h3 class="text-sm font-semibold text-gray-900 mb-0.5">
                <%= job.getJob_Title() %>
                <span class="text-blue-600 font-normal">@ <%= job.getCompany_name() %></span>
              </h3>
              <div class="flex items-center gap-2 flex-wrap mt-1">
                <span class="inline-block px-2.5 py-0.5 rounded-full text-xs font-medium <%= badgeClass %>"><%= job.getJob_Type() %></span>
                <span class="text-xs text-gray-400"><i class="fas fa-map-marker-alt mr-1"></i><%= job.getLocation() %></span>
                <span class="text-xs text-gray-400"><i class="fas fa-rupee-sign mr-1"></i><%= job.getSalary() %></span>
                <span class="text-xs text-gray-400"><i class="fas fa-clock mr-1"></i><%= job.getExperience() %> yr exp</span>
              </div>
            </div>
          </div>
          <button class="btn-view-details bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold px-4 py-2 rounded-lg transition-all flex-shrink-0 mt-2 sm:mt-0">
            View Details
          </button>
        </div>
        <% } %>
      <% } %>
    </div>
  </div>
</section>

<!-- ══════════════════════════════════════════
     COMPANIES
══════════════════════════════════════════ -->
<section class="py-14 bg-white border-t border-gray-100">
  <div class="max-w-7xl mx-auto px-5">
    <div class="text-center mb-10">
      <p class="text-xs font-semibold text-blue-600 uppercase tracking-widest mb-1">Trusted by</p>
      <h2 class="font-sora text-2xl md:text-3xl font-bold text-gray-900">Companies We've Helped</h2>
    </div>
    <div class="grid grid-cols-3 md:grid-cols-6 gap-6 items-center justify-items-center">
      <img src="images/logo_mailchimp.svg" alt="Mailchimp" class="company-logo h-7 object-contain">
      <img src="images/logo_paypal.svg"    alt="PayPal"    class="company-logo h-7 object-contain">
      <img src="images/logo_stripe.svg"    alt="Stripe"    class="company-logo h-7 object-contain">
      <img src="images/logo_visa.svg"      alt="Visa"      class="company-logo h-7 object-contain">
      <img src="images/logo_apple.svg"     alt="Apple"     class="company-logo h-7 object-contain">
      <img src="images/logo_airbnb.svg"    alt="Airbnb"    class="company-logo h-7 object-contain">
    </div>
  </div>
</section>

<!-- ══════════════════════════════════════════
     CTA
══════════════════════════════════════════ -->
<section class="py-16 relative overflow-hidden" style="background: linear-gradient(135deg, #1a56db 0%, #0f172a 100%);">
  <div class="absolute inset-0 opacity-5" style="background-image:radial-gradient(circle,#fff 1px,transparent 1px);background-size:24px 24px;"></div>
  <div class="max-w-2xl mx-auto px-5 text-center relative z-10">
    <h2 class="font-sora text-3xl font-bold text-white mb-3">Ready to Take the Next Step?</h2>
    <p class="text-white/60 text-base mb-8">Update your profile and let employers find you faster.</p>
    <a href="EditProfile.jsp" class="inline-block bg-white text-blue-600 hover:bg-gray-50 font-sora font-semibold text-sm px-8 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-lg">
      Update My Profile
    </a>
  </div>
</section>

<!-- ══════════════════════════════════════════
     JOB MODAL
══════════════════════════════════════════ -->
<div id="jobModal" class="job-modal-overlay" aria-hidden="true">
  <div class="job-modal-box" role="dialog" aria-modal="true">
    <button class="absolute top-4 right-4 w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 flex items-center justify-center text-gray-500 text-lg" id="modalClose">&times;</button>
    <div class="w-12 h-12 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center font-sora font-bold text-blue-600 text-xl mb-4" id="modalLogo">J</div>
    <div class="font-sora text-xl font-bold text-gray-900 mb-1" id="modalTitle"></div>
    <div class="text-sm text-blue-600 mb-4" id="modalCompany"></div>
    <div class="flex gap-2 flex-wrap mb-4" id="modalTags"></div>
    <div class="grid grid-cols-2 gap-3 mb-5">
      <div class="bg-gray-50 rounded-xl p-3">
        <p class="text-xs text-gray-400 uppercase tracking-wider mb-1">Location</p>
        <p class="text-sm font-semibold text-gray-900" id="modalLocation"></p>
      </div>
      <div class="bg-gray-50 rounded-xl p-3">
        <p class="text-xs text-gray-400 uppercase tracking-wider mb-1">Salary</p>
        <p class="text-sm font-semibold text-gray-900" id="modalSalary"></p>
      </div>
      <div class="bg-gray-50 rounded-xl p-3">
        <p class="text-xs text-gray-400 uppercase tracking-wider mb-1">Experience</p>
        <p class="text-sm font-semibold text-gray-900" id="modalExp"></p>
      </div>
      <div class="bg-gray-50 rounded-xl p-3">
        <p class="text-xs text-gray-400 uppercase tracking-wider mb-1">Openings</p>
        <p class="text-sm font-semibold text-gray-900" id="modalOpening"></p>
      </div>
    </div>
    <p class="text-xs font-semibold text-gray-700 uppercase tracking-wider mb-2">Job Description</p>
    <div class="text-sm text-gray-600 leading-relaxed bg-gray-50 rounded-xl p-4 mb-4" id="modalDesc"></div>
    <p class="text-xs font-semibold text-gray-700 uppercase tracking-wider mb-2">Skills Required</p>
    <div class="flex gap-2 flex-wrap mb-5" id="modalSkills"></div>

    <input type="hidden" id="applyJobId" value="">
    <input type="hidden" id="applyJobTitle" value="">

    <div class="flex gap-2 flex-wrap mb-4">
      <button class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-2"
              onclick="window.location.href='apply.jsp?job_id=' + document.getElementById('applyJobId').value">
        <i class="fas fa-paper-plane text-xs"></i> Apply Now
      </button>
      <form action="SaveJobServlet" method="post" style="display:inline;">
        <input type="hidden" name="jobId" id="saveJobId" value="">
        <input type="hidden" name="action" value="save">
        <button type="submit" class="bg-green-50 hover:bg-green-100 text-green-700 border border-green-200 text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-2">
          <i class="fas fa-bookmark text-xs"></i> Save Job
        </button>
      </form>
      <a href="review.jsp" class="bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-2">
        <i class="fas fa-upload text-xs"></i> Upload Review
      </a>
      <button class="bg-gray-100 hover:bg-gray-200 text-gray-600 text-sm px-5 py-2.5 rounded-xl transition-all" id="closeModalBtn" type="button">Close</button>
    </div>
  </div>
</div>

<!-- ══════════════════════════════════════════
     SCRIPTS
══════════════════════════════════════════ -->
<script>
  // ── Helpers ──
  function safeGet(id) { return document.getElementById(id); }

  // ── Mobile hamburger ──
  safeGet('mobileToggle').addEventListener('click', function () {
    const menu = safeGet('mobileMenu');
    const icon = safeGet('menuIcon');
    menu.classList.toggle('open');
    icon.className = menu.classList.contains('open') ? 'fas fa-times text-sm' : 'fas fa-bars text-sm';
  });

  // ── Dropdown helper (click-based, closes on outside click) ──
  function setupDropdown(btnId, menuId, chevronId) {
    const btn    = safeGet(btnId);
    const menu   = safeGet(menuId);
    const chev   = chevronId ? safeGet(chevronId) : null;
    if (!btn || !menu) return;

    btn.addEventListener('click', function (e) {
      e.stopPropagation();
      const isOpen = menu.classList.contains('show');
      // close all dropdowns first
      document.querySelectorAll('.nav-dropdown-menu, .avatar-dropdown-menu').forEach(m => m.classList.remove('show'));
      if (chev) chev.style.transform = '';
      // then open this one if it was closed
      if (!isOpen) {
        menu.classList.add('show');
        if (chev) chev.style.transform = 'rotate(180deg)';
      }
    });

    // Keep menu open when clicking inside it (so links work)
    menu.addEventListener('click', function (e) {
      e.stopPropagation();
    });
  }

  setupDropdown('accountDropBtn', 'accountDropMenu', null);
  setupDropdown('avatarDropBtn',  'avatarDropMenu',  'avatarChevron');

  // Close all dropdowns when clicking anywhere outside
  document.addEventListener('click', function () {
    document.querySelectorAll('.nav-dropdown-menu, .avatar-dropdown-menu').forEach(m => m.classList.remove('show'));
    const chev = safeGet('avatarChevron');
    if (chev) chev.style.transform = '';
  });

  // ── Animated counters ──
  function animateCounter(el) {
    const target = parseInt(el.getAttribute('data-number'));
    if (!target) { el.textContent = '0'; return; }
    let current = 0;
    const inc = target / 60;
    const timer = setInterval(() => {
      current += inc;
      if (current >= target) { current = target; clearInterval(timer); }
      el.textContent = Math.floor(current);
    }, 20);
  }
  const obs = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) { animateCounter(e.target); obs.unobserve(e.target); }
    });
  }, { threshold: 0.5 });
  document.querySelectorAll('.number[data-number]').forEach(c => obs.observe(c));

  // ── Job modal ──
  (function () {
    const modal        = safeGet('jobModal');
    const closeModalBtn = safeGet('closeModalBtn');
    const modalClose   = safeGet('modalClose');

    function openModal(card) {
      const d = card.dataset;
      safeGet('modalLogo').textContent     = d.initial || 'J';
      safeGet('modalTitle').textContent    = d.title || '';
      safeGet('modalCompany').textContent  = '@ ' + (d.company || '');
      safeGet('modalLocation').textContent = d.location || '';
      safeGet('modalSalary').textContent   = d.salary ? '₹' + d.salary : '';
      safeGet('modalExp').textContent      = d.experience ? d.experience + ' years' : '';
      safeGet('modalOpening').textContent  = d.opening ? d.opening + ' seats' : '';
      safeGet('modalDesc').textContent     = d.desc || 'No description available.';
      if (safeGet('applyJobId'))    safeGet('applyJobId').value    = d.id || '';
      if (safeGet('applyJobTitle')) safeGet('applyJobTitle').value = d.title || '';
      if (safeGet('saveJobId'))     safeGet('saveJobId').value     = d.id || '';

      // type badge
      const tagsEl = safeGet('modalTags');
      if (tagsEl) {
        const jt = d.type || '';
        const isFull = jt.toLowerCase().includes('full');
        const isPart = jt.toLowerCase().includes('part');
        const bc = isFull ? 'bg-blue-50 text-blue-600' : isPart ? 'bg-green-50 text-green-600' : 'bg-amber-50 text-amber-600';
        tagsEl.innerHTML = jt ? '<span class="inline-block px-2.5 py-1 rounded-full text-xs font-medium ' + bc + '">' + jt + '</span>' : '';
      }

      // skills
      const skillsEl = safeGet('modalSkills');
      if (skillsEl) {
        skillsEl.innerHTML = '';
        (d.skills ? d.skills.split(',') : []).forEach(s => {
          if (s.trim()) {
            const tag = document.createElement('span');
            tag.className = 'bg-blue-50 text-blue-600 border border-blue-100 rounded-full px-3 py-1 text-xs font-medium';
            tag.textContent = s.trim();
            skillsEl.appendChild(tag);
          }
        });
      }

      modal.classList.add('active');
      document.body.style.overflow = 'hidden';
    }

    function closeModal() {
      modal.classList.remove('active');
      document.body.style.overflow = '';
    }

    // Delegate clicks on job list
    const jobsContainer = safeGet('jobsContainer');
    if (jobsContainer) {
      jobsContainer.addEventListener('click', function (e) {
        const viewBtn = e.target.closest('.btn-view-details');
        const card    = e.target.closest('.job-card-item');
        if (viewBtn && card) { e.stopPropagation(); openModal(card); return; }
        if (card) { window.location.href = 'apply.jsp?job_id=' + card.dataset.id; }
      });
    }

    if (closeModalBtn) closeModalBtn.addEventListener('click', closeModal);
    if (modalClose)    modalClose.addEventListener('click', closeModal);
    window.addEventListener('click', function (e) { if (e.target === modal) closeModal(); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });
  })();
</script>
</body>
</html>