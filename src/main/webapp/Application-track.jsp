<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel, com.model.applymodel, com.model.Postjob" %>
<%@ page import="com.Repository.ApplyRepository, com.Repository.JobRepository" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.List, java.util.ArrayList" %>

<%
    // 1. Session Check
    UserModel m = (UserModel) session.getAttribute("Model");
    if (m == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Extract Candidate Email
    String userEmail = (m.getEmail() != null) ? m.getEmail().trim() : "";
    String userName  = (m.getFirstname() != null && !m.getFirstname().trim().isEmpty()) ? m.getFirstname().trim() : "Candidate";
    String initial   = !userName.isEmpty() ? String.valueOf(userName.charAt(0)).toUpperCase() : "U";

    // 3. Fetch Repositories
    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    ApplyRepository applyRepo = ctx.getBean(ApplyRepository.class);
    JobRepository jobRepo     = ctx.getBean(JobRepository.class);

    // 4. Fetch Applications List via Spring JPA
    List<applymodel> appList = new ArrayList<>();
    if (!userEmail.isEmpty()) {
        appList = applyRepo.findByEmailIgnoreCase(userEmail);

        if (appList == null || appList.isEmpty()) {
            List<applymodel> all = applyRepo.findAll();
            List<applymodel> filtered = new ArrayList<>();
            for (applymodel a : all) {
                if (a.getEmail() != null && a.getEmail().trim().equalsIgnoreCase(userEmail)) {
                    filtered.add(a);
                }
            }
            appList = filtered;
        }
    }

    // 5. Stat Counts Calculation
    int totalApps = appList.size();
    int pendingCount = 0, approvedCount = 0, rejectedCount = 0;

    for (applymodel app : appList) {
        String st = app.getStatus() != null ? app.getStatus().trim().toLowerCase() : "pending";
        if ("shortlisted".equals(st) || "approved".equals(st)) {
            approvedCount++;
        } else if ("rejected".equals(st)) {
            rejectedCount++;
        } else {
            pendingCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Application Tracker | JobBoard</title>
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

    /* ===== DROPDOWN ANIMATION ===== */
    .dropdown-custom {
      display: none; position: absolute; top: calc(100% + 12px); right: 0;
      background: #0f172a; border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 20px; padding: 10px; min-width: 240px;
      box-shadow: 0 25px 50px rgba(0,0,0,0.6); z-index: 1000;
    }
    .dropdown-custom.show { display: block; animation: floatUp 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
    @keyframes floatUp { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

    /* Custom Table Cards */
    .job-card-clean {
      background: #ffffff;
      border: 1.5px solid #e2e8f0;
      border-radius: 20px;
      transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    }
    .job-card-clean:hover {
      border-color: #6366f1;
      box-shadow: 0 12px 30px -5px rgba(99, 102, 241, 0.12);
    }
  </style>
</head>
<body class="antialiased">

<!-- ===== HERO NAVBAR (STANDARD FOR ALL USER PAGES) ===== -->
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
      <a href="user-home.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        <i class="fas fa-compass mr-2 text-indigo-400"></i> Explore Jobs
      </a>
      <a href="Application-track.jsp" class="text-white bg-white/10 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all border border-white/10">
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
          <span class="text-white text-xs font-semibold hidden sm:inline-block"><%= userName %></span>
          <i class="fas fa-chevron-down text-slate-400 text-[10px]"></i>
        </button>

        <div id="avatarMenu" class="dropdown-custom">
          <div class="px-4 py-3 border-b border-white/10 mb-1">
            <p class="text-white font-sora font-bold text-sm"><%= userName %></p>
            <p class="text-slate-400 font-mono text-[11px] truncate"><%= userEmail %></p>
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

<!-- ===== HERO SECTION WITH ANIMATED MESH ===== -->
<section class="hero-glow-mesh pt-36 pb-20">
  <canvas id="particleCanvas"></canvas>

  <div class="max-w-7xl mx-auto px-6 relative z-10">
    <div class="max-w-3xl mx-auto text-center space-y-4 mb-8">
      <div class="inline-flex items-center gap-2.5 badge-glow-gradient rounded-full px-4 py-1.5 text-xs font-semibold text-purple-300 shadow-xl">
        <i class="fas fa-chart-line text-indigo-400"></i>
        <span>Live Career Status</span>
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
      </div>

      <h1 class="font-sora text-3xl md:text-5xl font-extrabold text-white tracking-tight leading-tight">
        My Application <span class="text-glow-gradient">Tracker</span>
      </h1>

      <p class="text-slate-300 text-xs md:text-sm max-w-lg mx-auto font-normal leading-relaxed">
        Monitor real-time updates and recruitment pipeline progress for all your submitted job applications.
      </p>
    </div>
  </div>
</section>

<!-- ===== MAIN STATS & APPLICATION DASHBOARD ===== -->
<main class="max-w-6xl mx-auto px-6 -mt-10 relative z-20 pb-20">

  <!-- STATS OVERLAY BANNER -->
  <div class="bg-white border border-slate-200 rounded-3xl p-6 md:p-8 shadow-xl mb-8">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
      <div class="border-r border-slate-100 last:border-0">
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-indigo-600 mb-1"><%= totalApps %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Total Applied</p>
      </div>
      <div class="border-r border-slate-100 last:border-0">
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-amber-500 mb-1"><%= pendingCount %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Pending Review</p>
      </div>
      <div class="border-r border-slate-100 last:border-0">
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-emerald-500 mb-1"><%= approvedCount %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Shortlisted / Approved</p>
      </div>
      <div>
        <p class="font-sora text-3xl md:text-4xl font-extrabold text-rose-500 mb-1"><%= rejectedCount %></p>
        <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest font-semibold">Rejected</p>
      </div>
    </div>
  </div>

  <!-- APPLICATIONS TABLE CONTAINER -->
  <div class="job-card-clean bg-white p-6 sm:p-8 shadow-sm">

    <!-- Header & Filter Tabs -->
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pb-6 border-b border-slate-100 mb-6">
      <div>
        <h2 class="font-sora font-extrabold text-lg text-slate-900">Application Pipeline</h2>
        <p class="text-xs text-slate-400 mt-0.5">Showing all submitted profiles for <%= userEmail %></p>
      </div>

      <!-- Filter Tabs -->
      <div class="flex items-center gap-1.5 bg-slate-100 p-1 rounded-2xl border border-slate-200/80">
        <button onclick="filterTable('all', this)" class="filter-tab active-tab px-3.5 py-1.5 rounded-xl text-xs font-bold bg-white text-indigo-600 shadow-sm transition-all">All</button>
        <button onclick="filterTable('pending', this)" class="filter-tab px-3.5 py-1.5 rounded-xl text-xs font-semibold text-slate-500 hover:text-slate-900 transition-all">Pending</button>
        <button onclick="filterTable('approved', this)" class="filter-tab px-3.5 py-1.5 rounded-xl text-xs font-semibold text-slate-500 hover:text-slate-900 transition-all">Approved</button>
        <button onclick="filterTable('rejected', this)" class="filter-tab px-3.5 py-1.5 rounded-xl text-xs font-semibold text-slate-500 hover:text-slate-900 transition-all">Rejected</button>
      </div>
    </div>

    <% if(!appList.isEmpty()) { %>
    <div class="overflow-x-auto">
      <table class="w-full text-left" id="appTable">
        <thead>
          <tr class="border-b border-slate-100 text-[11px] font-mono font-bold uppercase tracking-wider text-slate-400">
            <th class="pb-3 px-3">#</th>
            <th class="pb-3 px-3">Job Title & Company</th>
            <th class="pb-3 px-3">Candidate</th>
            <th class="pb-3 px-3">Location</th>
            <th class="pb-3 px-3">Experience</th>
            <th class="pb-3 px-3">Status</th>
            <th class="pb-3 px-3 text-right">Resume</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-100 text-xs font-medium text-slate-700">
        <%
          int srNo = 1;
          for(applymodel app : appList) {
            Postjob job = jobRepo.findByJobId(app.getJobId()).orElse(null);
            String title = (job != null && job.getJob_title() != null) ? job.getJob_title() : "Software Engineer Role #" + app.getJobId();
            String compName = (job != null && job.getCompany_name() != null) ? job.getCompany_name() : "Partner Employer";

            String status = app.getStatus();
            if(status == null || status.trim().isEmpty()) status = "Pending";

            String rowStatus = "pending";
            String pillClass = "bg-amber-50 text-amber-700 border-amber-200/80";
            String dotColor  = "bg-amber-400";

            if("Approved".equalsIgnoreCase(status) || "shortlisted".equalsIgnoreCase(status)) {
                rowStatus = "approved";
                pillClass = "bg-emerald-50 text-emerald-700 border-emerald-200/80";
                dotColor  = "bg-emerald-500";
            } else if("Rejected".equalsIgnoreCase(status)) {
                rowStatus = "rejected";
                pillClass = "bg-rose-50 text-rose-700 border-rose-200/80";
                dotColor  = "bg-rose-500";
            }

            String expDisplay = (app.getExperience() != null) ? app.getExperience() + " Years" : "Freshers";
            String cityDisplay = (app.getCity() != null && !app.getCity().trim().isEmpty()) ? app.getCity() : "Remote";
            String fullNameDisplay = (app.getFullname() != null) ? app.getFullname() : userName;
        %>
        <tr class="app-row hover:bg-slate-50/80 transition-colors" data-status="<%= rowStatus %>">
          <td class="py-4 px-3 font-mono text-slate-400"><%= srNo++ %></td>
          <td class="py-4 px-3">
            <p class="font-sora font-bold text-slate-900 text-xs"><%= title %></p>
            <p class="text-[11px] text-slate-400 font-mono">@ <%= compName %></p>
          </td>
          <td class="py-4 px-3">
            <p class="font-bold text-slate-800"><%= fullNameDisplay %></p>
            <p class="text-[10px] text-slate-400 font-mono"><%= app.getEmail() %></p>
          </td>
          <td class="py-4 px-3 font-mono text-slate-500">
            <i class="fas fa-location-dot text-indigo-400 mr-1"></i><%= cityDisplay %>
          </td>
          <td class="py-4 px-3 font-mono text-slate-500"><%= expDisplay %></td>
          <td class="py-4 px-3">
            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-mono font-bold border <%= pillClass %>">
              <span class="w-1.5 h-1.5 rounded-full <%= dotColor %>"></span>
              <%= status %>
            </span>
          </td>
          <td class="py-4 px-3 text-right">
            <%
                String fileName = app.getResume();
                if (fileName != null && !fileName.trim().isEmpty()) {
            %>
                <a href="<%= request.getContextPath() %>/uploads/<%= fileName %>" target="_blank"
                   class="inline-flex items-center gap-1.5 bg-indigo-50 hover:bg-indigo-600 text-indigo-600 hover:text-white px-3 py-1.5 rounded-xl transition-all text-xs font-bold border border-indigo-100 shadow-sm">
                    <i class="fas fa-file-pdf"></i> View CV
                </a>
            <% } else { %>
                <span class="text-[11px] text-slate-300 font-mono">N/A</span>
            <% } %>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
    <% } else { %>
    <!-- Empty Applications State -->
    <div class="py-12 px-6 text-center space-y-3">
      <div class="w-12 h-12 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto text-xl border border-indigo-100">
        <i class="fas fa-folder-open"></i>
      </div>
      <p class="font-sora font-bold text-slate-900 text-base">No Applications Found</p>
      <p class="text-xs text-slate-400 max-w-sm mx-auto">You haven't submitted any job applications under this account yet.</p>
      <div class="pt-2">
        <a href="user-home.jsp" class="inline-flex items-center gap-2 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold px-5 py-2.5 rounded-xl transition-all shadow-md shadow-indigo-500/20">
          <i class="fas fa-search text-[11px]"></i> Explore Openings
        </a>
      </div>
    </div>
    <% } %>

  </div>
</main>

<!-- FOOTER -->
<footer class="bg-slate-900 text-white pt-16 pb-8 border-t border-slate-800">
  <div class="max-w-6xl mx-auto px-6">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-10 pb-12 border-b border-slate-800">

      <div class="space-y-3">
        <a href="user-home.jsp" class="font-sora font-extrabold text-xl text-white">
          Job<span class="text-indigo-400">Board</span>
        </a>
        <p class="text-xs text-slate-400 leading-relaxed">Enterprise career network connecting software talent with leading companies across India.</p>
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
  // Profile Avatar Dropdown
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

  // Application Table Filtering Function
  function filterTable(status, btn) {
    document.querySelectorAll('.filter-tab').forEach(t => {
      t.classList.remove('bg-white', 'text-indigo-600', 'shadow-sm', 'font-bold');
      t.classList.add('text-slate-500', 'font-semibold');
    });
    btn.classList.add('bg-white', 'text-indigo-600', 'shadow-sm', 'font-bold');
    btn.classList.remove('text-slate-500');

    document.querySelectorAll('#appTable tbody tr').forEach(row => {
      row.style.display = (status === 'all' || row.getAttribute('data-status') === status) ? '' : 'none';
    });
  }

  // Live Canvas Particle Background Animation
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