<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel, java.sql.*, java.util.*" %>
<%
    UserModel m = (UserModel) session.getAttribute("Model");
    if(m == null) {
        response.sendRedirect("login.jsp");
        return;
    }
  
    String userEmail = m.getEmail();
    int totalApps = 0, pendingCount = 0, approvedCount = 0, rejectedCount = 0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "");
        PreparedStatement ps2 = con.prepareStatement("SELECT status FROM apply WHERE email = ?");
        ps2.setString(1, userEmail);
        ResultSet rs2 = ps2.executeQuery();
        while(rs2.next()) {
            totalApps++;
            String s = rs2.getString("status");
            if("Approved".equalsIgnoreCase(s))      approvedCount++;
            else if("Rejected".equalsIgnoreCase(s)) rejectedCount++;
            else                                     pendingCount++;
        }
        rs2.close(); ps2.close(); con.close();
    } catch(Exception e) {}

    String initial = m.getFirstname() != null && !m.getFirstname().isEmpty()
        ? String.valueOf(m.getFirstname().charAt(0)).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Applications | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm:   ['DM Sans', 'sans-serif'],
          },
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; }
    .font-sora, h1, h2, h3 { font-family: 'Sora', sans-serif; }
    html { scroll-behavior: smooth; }
    .navbar-blur {
      background: rgba(15,23,42,0.92);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
    }
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
    .dropdown-menu {
      display: none; position: absolute; top: 110%; right: 0;
      min-width: 200px; background: #fff; border: 1px solid #e2e8f0;
      border-radius: 12px; box-shadow: 0 12px 40px rgba(0,0,0,0.14);
      padding: 8px 0; z-index: 100;
    }
    .dropdown-parent:hover .dropdown-menu { display: block; }
    .dropdown-menu a {
      display: flex; align-items: center; gap: 8px;
      padding: 10px 18px; font-size: 13px; color: #475569;
      text-decoration: none; transition: background 0.15s, color 0.15s;
    }
    .dropdown-menu a:hover { background: #f8fafc; color: #1a56db; }
    .logout-link { color: #ef4444 !important; }
    .logout-link:hover { background: #fef2f2 !important; }
    .dropdown-divider { border-top: 1px solid #e2e8f0; margin: 6px 0; }
    #mobileMenu { display: none; }
    #mobileMenu.open { display: flex; }

    /* Table row hover */
    .app-row { transition: background 0.15s, transform 0.15s; }
    .app-row:hover { background: #f0f6ff; transform: translateX(2px); }

    /* Status pill animation */
    .pill-approved { animation: pulse-green 2s infinite; }
    @keyframes pulse-green {
      0%, 100% { box-shadow: 0 0 0 0 rgba(34,197,94,0.3); }
      50%       { box-shadow: 0 0 0 4px rgba(34,197,94,0); }
    }

    /* Stat card counter animation */
    @keyframes countUp {
      from { opacity: 0; transform: translateY(8px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .stat-num { animation: countUp 0.5s ease both; }

    /* Mobile table */
    @media(max-width: 640px) {
      .table-head { display: none; }
      .app-row { display: block; border: 1px solid #e2e8f0; border-radius: 12px; margin-bottom: 12px; padding: 14px; }
      .app-row td { display: flex; justify-content: space-between; align-items: center; border: none; padding: 6px 0; font-size: 13px; }
      .app-row td::before { content: attr(data-label); font-weight: 700; color: #94a3b8; font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px; flex-shrink: 0; margin-right: 10px; }
    }
  </style>
</head>
<body class="bg-gray-50 antialiased">

<!-- NAVBAR -->
<header class="navbar-blur sticky top-0 z-50 border-b border-white/10">
  <div class="max-w-7xl mx-auto px-5 py-3 flex items-center justify-between gap-6">
    <a href="userhome.jsp" class="font-sora font-bold text-xl text-white tracking-tight flex-shrink-0">
      Job<span class="text-yellow-400">Board</span>
    </a>
    <nav class="hidden xl:flex items-center gap-1">
      <a href="userhome.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-home mr-1.5 text-xs"></i>Home
      </a>
      <a href="userhome.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-briefcase mr-1.5 text-xs"></i>Browse Jobs
      </a>
      <a href="Application-track.jsp" class="text-white bg-white/15 text-sm font-medium px-3 py-2 rounded-lg">
        <i class="fas fa-file-alt mr-1.5 text-xs"></i>Applications
      </a>
      <a href="resumeupload.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-sm font-medium px-3 py-2 rounded-lg transition-all">
        <i class="fas fa-file-upload mr-1.5 text-xs"></i>Resume
      </a>
      <div class="dropdown-parent relative ml-2">
        <button class="flex items-center gap-2 bg-white/10 border border-white/20 rounded-full pl-1.5 pr-3 py-1.5 text-sm text-white font-medium hover:bg-white/20 transition-all">
          <span class="w-7 h-7 rounded-full bg-blue-600 text-white font-bold text-xs flex items-center justify-center"><%= initial %></span>
          <%= m.getFirstname() %>
          <i class="fas fa-chevron-down text-[10px] text-white/60"></i>
        </button>
        <div class="dropdown-menu">
          <a href="newProfile.jsp"><i class="fas fa-user fa-xs text-blue-600"></i> My Profile</a>
          <a href="Application-track.jsp"><i class="fas fa-file-alt fa-xs text-blue-600"></i> Applications</a>
          <a href="resumeupload.jsp"><i class="fas fa-file-upload fa-xs text-blue-600"></i> Resume</a>
          <a href="Setting.jsp"><i class="fas fa-cog fa-xs text-gray-400"></i> Settings</a>
          <div class="dropdown-divider"></div>
          <a href="logout" class="logout-link"><i class="fas fa-sign-out-alt fa-xs"></i> Logout</a>
        </div>
      </div>
    </nav>
    <div class="hidden xl:flex items-center gap-2">
      <a href="logout" class="border border-white/30 text-white text-sm font-medium px-4 py-2 rounded-lg hover:bg-white/10 transition-all">
        <i class="fas fa-sign-out-alt mr-1.5 text-xs"></i>Logout
      </a>
    </div>
    <button id="hamburger" class="xl:hidden text-white text-xl p-1"><i class="fas fa-bars"></i></button>
  </div>
  <div id="mobileMenu" class="xl:hidden border-t border-white/10 px-5 pb-4 pt-2 flex-col gap-1">
    <a href="userhome.jsp"          class="text-white/90 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-home w-4"></i> Home</a>
    <a href="userhome.jsp"          class="text-white/70 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-briefcase w-4"></i> Browse Jobs</a>
    <a href="Application-track.jsp" class="text-white text-sm py-2.5 px-3 rounded-lg bg-white/15 flex items-center gap-2"><i class="fas fa-file-alt w-4"></i> Applications</a>
    <a href="resumeupload.jsp"      class="text-white/70 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-file-upload w-4"></i> Resume</a>
    <hr class="border-white/10 my-1">
    <a href="logout" class="text-red-400 text-sm py-2.5 px-3 rounded-lg hover:bg-white/10 flex items-center gap-2"><i class="fas fa-sign-out-alt w-4"></i> Logout</a>
  </div>
</header>

<!-- HERO -->
<section class="hero-mesh py-12 relative">
  <div class="max-w-7xl mx-auto px-5 relative z-10">
    <div class="flex items-center gap-2 text-white/50 text-xs mb-4">
      <a href="userhome.jsp" class="hover:text-white transition-colors">Home</a>
      <i class="fas fa-chevron-right text-[10px]"></i>
      <span class="text-white/80">My Applications</span>
    </div>
    <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-4">
      <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
      Application Tracker
    </div>
    <h1 class="font-sora text-3xl md:text-4xl font-bold text-white tracking-tight mb-2">
      My <span class="text-yellow-400">Applications</span>
    </h1>
    <p class="text-white/60 text-sm">Track all your job applications and their current status in real time.</p>
  </div>
</section>

<!-- MAIN -->
<section class="py-10 bg-gray-50">
  <div class="max-w-7xl mx-auto px-5">

    <!-- Welcome Bar -->
    <div class="bg-gradient-to-r from-dark-900 to-blue-900 rounded-2xl p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8"
         style="background: linear-gradient(135deg, #0f172a 0%, #1e3a5f 100%);">
      <div class="flex items-center gap-4">
        <div class="w-12 h-12 rounded-xl bg-blue-600 text-white font-bold text-lg flex items-center justify-center font-sora flex-shrink-0">
          <%= initial %>
        </div>
        <div>
          <p class="font-sora font-bold text-white text-base">👋 Welcome back, <%= m.getFirstname() %>!</p>
          <p class="text-white/50 text-xs mt-0.5"><%= userEmail %></p>
        </div>
      </div>
      <a href="userhome.jsp"
         class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-4 py-2.5 rounded-xl transition-all flex-shrink-0">
        <i class="fas fa-search text-xs"></i> Browse More Jobs
      </a>
    </div>

    <!-- STAT CARDS -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
      <!-- Total -->
      <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex items-center gap-4 hover:-translate-y-1 transition-all border-l-4 border-l-blue-600">
        <div class="w-11 h-11 rounded-xl bg-blue-50 flex items-center justify-center flex-shrink-0">
          <i class="fas fa-layer-group text-blue-600"></i>
        </div>
        <div>
          <p class="font-sora font-bold text-2xl text-gray-900 stat-num"><%= totalApps %></p>
          <p class="text-xs text-gray-400 uppercase tracking-wider font-semibold mt-0.5">Total Applied</p>
        </div>
      </div>
      <!-- Pending -->
      <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex items-center gap-4 hover:-translate-y-1 transition-all border-l-4 border-l-amber-400">
        <div class="w-11 h-11 rounded-xl bg-amber-50 flex items-center justify-center flex-shrink-0">
          <i class="fas fa-clock text-amber-500"></i>
        </div>
        <div>
          <p class="font-sora font-bold text-2xl text-gray-900 stat-num"><%= pendingCount %></p>
          <p class="text-xs text-gray-400 uppercase tracking-wider font-semibold mt-0.5">Pending</p>
        </div>
      </div>
      <!-- Approved -->
      <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex items-center gap-4 hover:-translate-y-1 transition-all border-l-4 border-l-green-500">
        <div class="w-11 h-11 rounded-xl bg-green-50 flex items-center justify-center flex-shrink-0">
          <i class="fas fa-check-circle text-green-500"></i>
        </div>
        <div>
          <p class="font-sora font-bold text-2xl text-gray-900 stat-num"><%= approvedCount %></p>
          <p class="text-xs text-gray-400 uppercase tracking-wider font-semibold mt-0.5">Approved</p>
        </div>
      </div>
      <!-- Rejected -->
      <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 flex items-center gap-4 hover:-translate-y-1 transition-all border-l-4 border-l-red-500">
        <div class="w-11 h-11 rounded-xl bg-red-50 flex items-center justify-center flex-shrink-0">
          <i class="fas fa-times-circle text-red-500"></i>
        </div>
        <div>
          <p class="font-sora font-bold text-2xl text-gray-900 stat-num"><%= rejectedCount %></p>
          <p class="text-xs text-gray-400 uppercase tracking-wider font-semibold mt-0.5">Rejected</p>
        </div>
      </div>
    </div>

    <!-- Progress Bar Summary -->
    <% if(totalApps > 0) { %>
    <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-8">
      <div class="flex items-center justify-between mb-3">
        <p class="text-sm font-semibold text-gray-700">Application Progress Overview</p>
        <p class="text-xs text-gray-400"><%= totalApps %> total</p>
      </div>
      <div class="flex h-3 rounded-full overflow-hidden gap-0.5">
        <% if(approvedCount > 0) { %>
        <div class="bg-green-500 rounded-full transition-all" style="width:<%= (approvedCount * 100 / totalApps) %>%"></div>
        <% } %>
        <% if(pendingCount > 0) { %>
        <div class="bg-amber-400 rounded-full transition-all" style="width:<%= (pendingCount * 100 / totalApps) %>%"></div>
        <% } %>
        <% if(rejectedCount > 0) { %>
        <div class="bg-red-400 rounded-full transition-all" style="width:<%= (rejectedCount * 100 / totalApps) %>%"></div>
        <% } %>
      </div>
      <div class="flex items-center gap-4 mt-2.5 flex-wrap">
        <span class="flex items-center gap-1.5 text-xs text-gray-500"><span class="w-2.5 h-2.5 rounded-full bg-green-500 inline-block"></span>Approved (<%= approvedCount %>)</span>
        <span class="flex items-center gap-1.5 text-xs text-gray-500"><span class="w-2.5 h-2.5 rounded-full bg-amber-400 inline-block"></span>Pending (<%= pendingCount %>)</span>
        <span class="flex items-center gap-1.5 text-xs text-gray-500"><span class="w-2.5 h-2.5 rounded-full bg-red-400 inline-block"></span>Rejected (<%= rejectedCount %>)</span>
      </div>
    </div>
    <% } %>

    <!-- APPLICATIONS TABLE -->
    <div class="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
      <!-- Header -->
      <div class="px-6 py-4 border-b border-gray-100 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
        <div class="flex items-center gap-2">
          <div class="w-8 h-8 rounded-lg bg-blue-50 flex items-center justify-center">
            <i class="fas fa-list-alt text-blue-600 text-sm"></i>
          </div>
          <h2 class="font-sora font-bold text-gray-900 text-base">Submitted Applications</h2>
        </div>
        <!-- Filter Tabs -->
        <div class="flex items-center gap-2 flex-wrap">
          <button onclick="filterTable('all', this)"      class="filter-tab active-tab px-3 py-1.5 rounded-full text-xs font-semibold border border-blue-600 bg-blue-600 text-white transition-all">All</button>
          <button onclick="filterTable('pending', this)"  class="filter-tab px-3 py-1.5 rounded-full text-xs font-semibold border border-gray-200 text-gray-500 hover:border-amber-400 hover:text-amber-600 transition-all">Pending</button>
          <button onclick="filterTable('approved', this)" class="filter-tab px-3 py-1.5 rounded-full text-xs font-semibold border border-gray-200 text-gray-500 hover:border-green-500 hover:text-green-600 transition-all">Approved</button>
          <button onclick="filterTable('rejected', this)" class="filter-tab px-3 py-1.5 rounded-full text-xs font-semibold border border-gray-200 text-gray-500 hover:border-red-500 hover:text-red-600 transition-all">Rejected</button>
        </div>
      </div>

      <%
        boolean hasApps = false;
        try {
          Class.forName("com.mysql.jdbc.Driver");
          Connection con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "");
          PreparedStatement ps = con2.prepareStatement("SELECT * FROM apply WHERE email = ? ORDER BY app_id DESC");
          ps.setString(1, userEmail);
          ResultSet rs = ps.executeQuery();
          if(rs.isBeforeFirst()) { hasApps = true;
      %>
      <div class="overflow-x-auto">
        <table class="w-full" id="appTable">
          <thead class="table-head">
            <tr class="border-b border-gray-100">
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">#</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">Job</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">Full Name</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">Email</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">City</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">Experience</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">Status</th>
              <th class="bg-gray-50 px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-wider">Resume</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-50">
          <%
            int srNo = 1;
            while(rs.next()) {
              String status = rs.getString("status");
              if(status == null) status = "Pending";
              String rowStatus = "pending";
              String pillClass = "bg-amber-50 text-amber-700 border border-amber-200";
              String dotColor  = "bg-amber-400";
              if("Approved".equalsIgnoreCase(status)) { rowStatus="approved"; pillClass="bg-green-50 text-green-700 border border-green-200"; dotColor="bg-green-500"; }
              if("Rejected".equalsIgnoreCase(status)) { rowStatus="rejected"; pillClass="bg-red-50 text-red-700 border border-red-200";   dotColor="bg-red-500"; }
              if("Reviewed".equalsIgnoreCase(status)) { rowStatus="reviewed"; pillClass="bg-blue-50 text-blue-700 border border-blue-200"; dotColor="bg-blue-500"; }
          %>
          <tr class="app-row" data-status="<%= rowStatus %>">
            <td data-label="Sr" class="px-5 py-4 text-sm text-gray-400 font-medium"><%= srNo++ %></td>
            <td data-label="Job" class="px-5 py-4">
              <p class="text-sm font-semibold text-gray-900">Job Position</p>
              <p class="text-xs text-gray-400 mt-0.5">ID: #<%= rs.getInt("job_id") %></p>
            </td>
            <td data-label="Name" class="px-5 py-4 text-sm font-semibold text-gray-800"><%= rs.getString("fullname") %></td>
            <td data-label="Email" class="px-5 py-4 text-sm text-gray-500"><%= rs.getString("email") %></td>
            <td data-label="City" class="px-5 py-4 text-sm text-gray-600">
              <i class="fas fa-map-marker-alt text-gray-300 mr-1 text-xs"></i>
              <%= rs.getString("city") != null ? rs.getString("city") : "—" %>
            </td>
            <td data-label="Exp" class="px-5 py-4 text-sm text-gray-600"><%= rs.getString("experience") %> yr</td>
            <td data-label="Status" class="px-5 py-4">
              <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold <%= pillClass %>">
                <span class="w-1.5 h-1.5 rounded-full <%= dotColor %> inline-block"></span>
                <%= status %>
              </span>
            </td>
			           <td data-label="Resume" class="px-5 py-4">
			    <% 
			        String fileName = rs.getString("resume"); 
			        if (fileName != null && !fileName.isEmpty()) { 
			    %>
			        <a href="<%= request.getContextPath() %>/uploads/<%= fileName %>" target="_blank"
			           class="inline-flex items-center gap-1.5 bg-blue-50 hover:bg-blue-600 text-blue-600 hover:text-white px-3 py-1 rounded-lg transition-all text-xs font-bold">
			            <i class="fas fa-file-pdf"></i> View
			        </a>
			    <% } else { %>
			        <span class="text-xs text-gray-300">N/A</span>
			    <% } %>
			</td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
      <%
          }
          rs.close(); ps.close(); con2.close();
        } catch(Exception e) {
          out.print("<p class='text-red-500 p-5 text-sm'>DB Error: " + e.getMessage() + "</p>");
        }
        if(!hasApps) {
      %>
      <!-- Empty State -->
      <div class="py-16 px-8 text-center">
        <div class="w-16 h-16 rounded-2xl bg-blue-50 flex items-center justify-center mx-auto mb-4">
          <i class="fas fa-search text-2xl text-blue-300"></i>
        </div>
        <p class="font-sora font-semibold text-gray-700 text-lg mb-1">No Applications Yet</p>
        <p class="text-sm text-gray-400 mb-5">You haven't applied to any jobs yet.<br>Start exploring and apply today!</p>
        <a href="userhome.jsp"
           class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-6 py-2.5 rounded-xl transition-all">
          <i class="fas fa-briefcase"></i> Browse Jobs
        </a>
      </div>
      <% } %>
    </div>

  </div>
</section>

<!-- FOOTER -->
<footer style="background:#0f172a;" class="pt-14 pb-6 mt-10">
  <div class="max-w-7xl mx-auto px-5">
    <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mb-10">
      <div class="col-span-2 md:col-span-1">
        <p class="font-sora font-bold text-xl text-white mb-2">Job<span class="text-yellow-400">Board</span></p>
        <p class="text-xs text-white/40 leading-relaxed max-w-[200px]">The easiest way to connect talent with top companies across India.</p>
        <div class="flex gap-2 mt-4">
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-twitter"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-instagram"></i></a>
          <a href="#" class="w-8 h-8 rounded-full border border-white/15 flex items-center justify-center text-white/40 hover:text-white hover:bg-blue-600 transition-all text-xs"><i class="fab fa-linkedin-in"></i></a>
        </div>
      </div>
      <div>
        <p class="text-xs font-semibold text-white uppercase tracking-widest mb-4">For Job Seekers</p>
        <ul class="space-y-2.5">
          <li><a href="userhome.jsp"          class="text-xs text-white/40 hover:text-white transition-colors">Browse Jobs</a></li>
          <li><a href="newProfile.jsp"         class="text-xs text-white/40 hover:text-white transition-colors">My Profile</a></li>
          <li><a href="Application-track.jsp"  class="text-xs text-white/40 hover:text-white transition-colors">Applications</a></li>
          <li><a href="resumeupload.jsp"       class="text-xs text-white/40 hover:text-white transition-colors">Upload Resume</a></li>
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

  function filterTable(status, btn) {
    // Update tab styles
    document.querySelectorAll('.filter-tab').forEach(t => {
      t.classList.remove('bg-blue-600','text-white','border-blue-600');
      t.classList.add('border-gray-200','text-gray-500');
    });
    btn.classList.add('bg-blue-600','text-white','border-blue-600');
    btn.classList.remove('border-gray-200','text-gray-500');

    // Filter rows
    document.querySelectorAll('#appTable tbody tr').forEach(row => {
      row.style.display = (status === 'all' || row.getAttribute('data-status') === status) ? '' : 'none';
    });
  }
</script>
</body>
</html>