<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="com.Repository.UserRepository" %>
<%@ page import="com.Repository.JobRepository" %>
<%@ page import="com.Repository.ApplyRepository" %>
<%@ page import="com.model.UserModel" %>
<%@ page import="java.util.List, java.util.ArrayList" %>

<%
    // 1. Session Guard (Redirects safely to admin-login.jsp)
    Object sessionModel = session.getAttribute("Model");
    if (sessionModel == null) {
        response.sendRedirect(request.getContextPath() + "/admin/admin-login");
        return;
    }

    String msg = request.getParameter("msg");

    // 2. Fetch Repositories from Spring Context
    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    UserRepository userRepository = ctx.getBean(UserRepository.class);
    JobRepository jobRepository     = ctx.getBean(JobRepository.class);
    ApplyRepository applyRepository = ctx.getBean(ApplyRepository.class);

    // 3. Fail-safe fetch for pending employers and stats
    List<UserModel> pending = new ArrayList<>();
    long totalUsers = 0;
    long totalEmployers = 0;
    long totalVerified = 0;
    long totalJobs = 0;
    long totalApplications = 0;

    try {
        List<UserModel> allUsers = userRepository.findAll();
        totalUsers = allUsers.size();
        for (UserModel u : allUsers) {
            String uRole = u.getRole() != null ? u.getRole().trim().toUpperCase() : "";
            if ("EMPLOYER".equals(uRole)) {
                totalEmployers++;
                int isVer = 0;
                try { isVer = u.getIsVerified(); } catch(Throwable t) {}

                if (isVer == 1) {
                    totalVerified++;
                } else if (isVer == 0) {
                    pending.add(u);
                }
            }
        }
        totalJobs = jobRepository.count();
        totalApplications = applyRepository.count();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // MUST match the controller's real mapping: /admin/admin-dashboard (no .jsp suffix)
    String pageUrl = request.getContextPath() + "/admin/admin-dashboard";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Portal — Overview & Verifications | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Tailwind CSS & Fonts -->
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
    /* ===== LIGHT THEME ===== */
    body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f3f4f8; color: #1e293b; min-height: 100vh; }
    .font-sora { font-family: 'Sora', sans-serif; }
    .font-mono { font-family: 'JetBrains Mono', monospace; }

    .sidebar { width: 260px; background: #ffffff; border-right: 1px solid #e5e7eb; min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; box-shadow: 1px 0 3px rgba(0,0,0,0.03); }
    .sidebar-logo { padding: 24px 20px; border-bottom: 1px solid #e5e7eb; font-family: 'Sora', sans-serif; font-size: 20px; font-weight: 800; color: #0f172a; }
    .sidebar-logo span { color: #4f46e5; }
    .sidebar-nav { padding: 16px 12px; flex: 1; overflow-y: auto; }
    .nav-item { display: flex; align-items: center; gap: 12px; padding: 10px 14px; border-radius: 12px; color: #64748b; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.2s; margin-bottom: 4px; }
    .nav-item:hover { color: #0f172a; background: #f1f5f9; }
    .nav-item.active { color: #4338ca; background: #eef2ff; border: 1px solid #c7d2fe; }
    .nav-item i { width: 18px; text-align: center; font-size: 14px; }
    .nav-section { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #94a3b8; padding: 16px 14px 6px; }

    .main { margin-left: 260px; min-height: 100vh; display: flex; flex-direction: column; }
    .topbar { background: #ffffff; border-bottom: 1px solid #e5e7eb; padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; }

    .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 28px; }
    .stat-card { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 18px; padding: 20px 24px; position: relative; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
    .stat-card.yellow::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
    .stat-card.blue::before   { background: linear-gradient(90deg, #6366f1, #38bdf8); }
    .stat-card.green::before  { background: linear-gradient(90deg, #10b981, #34d399); }
    .stat-card.purple::before { background: linear-gradient(90deg, #a855f7, #c084fc); }

    .table-section { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 20px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
    .custom-table th { background: #f8fafc; border-bottom: 1px solid #e5e7eb; color: #94a3b8; font-size: 11px; text-transform: uppercase; font-family: 'JetBrains Mono', monospace; font-weight: 700; letter-spacing: 0.05em; padding: 14px 20px; }
    .custom-table td { border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-size: 13px; vertical-align: middle; color: #334155; }
    .custom-table tr:last-child td { border-bottom: none; }
    .custom-table tr:hover td { background: #f8fafc; }

    .action-btn { padding: 6px 14px; border-radius: 10px; font-size: 12px; font-weight: 700; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sidebar-logo flex items-center justify-between">
    <div>Job<span>Board</span></div>
    <span class="text-[9px] font-mono uppercase bg-rose-50 text-rose-500 border border-rose-200 px-2 py-0.5 rounded-md">Admin</span>
  </div>

  <div class="sidebar-nav">

    <div class="nav-section">Main Management</div>

    <!-- Dashboard -->
    <a href="${pageContext.request.contextPath}/admin/admin-dashboard"
       class="nav-item active">

        <i class="fas fa-chart-pie text-indigo-500"></i>
        Dashboard

    </a>


    <!-- Job Applications -->
    <a href="${pageContext.request.contextPath}/admin/admin-application"
       class="nav-item">

        <i class="fas fa-file-invoice text-indigo-500"></i>
        Job Applications

    </a>


    <!-- Companies -->
    <a href="${pageContext.request.contextPath}/admin/admin-companies"
       class="nav-item">

        <i class="fas fa-building-circle-check text-indigo-500"></i>
        Companies Directory

    </a>


    <!-- Jobs -->
    <a href="${pageContext.request.contextPath}/admin/admin-jobs"
       class="nav-item">

        <i class="fas fa-briefcase text-indigo-500"></i>
        Job Postings

    </a>


    <!-- Users -->
    <a href="${pageContext.request.contextPath}/admin/admin-users"
       class="nav-item">

        <i class="fas fa-users text-indigo-500"></i>
        User Directory

    </a>


    <!-- Proposals -->
    <a href="${pageContext.request.contextPath}/admin/admin-praposal"
       class="nav-item">

        <i class="fas fa-handshake text-indigo-500"></i>
        Proposals

    </a>


    <div class="nav-section">Session</div>


    <!-- Logout -->
    <a href="${pageContext.request.contextPath}/admin/admin-login"
       class="nav-item text-rose-500 hover:bg-rose-50">

        <i class="fas fa-sign-out-alt"></i>
        Logout

    </a>

</div>

  <div class="p-4 border-t border-slate-100">
    <div class="flex items-center gap-3">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center font-bold text-xs text-white">
        A
      </div>
      <div>
        <p class="text-xs font-bold text-slate-800">Administrator</p>
        <p class="text-[10px] text-slate-400 font-mono">Platform Overseer</p>
      </div>
    </div>
  </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div>
      <h1 class="font-sora text-lg font-bold text-slate-900">Administrative Overview & Verifications</h1>
      <p class="text-xs text-slate-500">Real-time metrics and employer identity verification pipeline</p>
    </div>
    <div class="flex items-center gap-3">
      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-mono font-bold bg-amber-50 border border-amber-200 text-amber-600">
        <span class="w-1.5 h-1.5 rounded-full bg-amber-500 animate-pulse"></span>
        <%= pending.size() %> Pending Requests
      </span>
    </div>
  </header>

  <!-- CONTENT WRAPPER -->
  <div class="p-8 flex-1 space-y-6">

    <!-- ALERT TOASTS -->
    <% if ("approved".equals(msg)) { %>
      <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-check-circle text-emerald-500"></i> Employer authorized successfully! Email notification dispatched.
        </div>
        <button onclick="this.parentElement.remove()" class="text-emerald-500"><i class="fas fa-times"></i></button>
      </div>
    <% } else if ("rejected".equals(msg)) { %>
      <div class="p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-circle-xmark text-rose-500"></i> Employer verification request declined.
        </div>
        <button onclick="this.parentElement.remove()" class="text-rose-500"><i class="fas fa-times"></i></button>
      </div>
    <% } %>

    <!-- OVERVIEW STATS -->
    <div class="stats-grid">
      <div class="stat-card yellow">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Pending Approvals</span>
          <i class="fas fa-clock text-amber-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-amber-500"><%= pending.size() %></p>
      </div>

      <div class="stat-card blue">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Total Users</span>
          <i class="fas fa-users text-indigo-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-slate-900"><%= totalUsers %></p>
      </div>

      <div class="stat-card green">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Verified Employers</span>
          <i class="fas fa-building-circle-check text-emerald-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-emerald-500"><%= totalVerified %></p>
      </div>

      <div class="stat-card purple">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Total Applications</span>
          <i class="fas fa-file-invoice text-purple-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-purple-500"><%= totalApplications %></p>
      </div>
    </div>

    <!-- FILTER TOOLBAR -->
    <div class="bg-white border border-slate-200 rounded-2xl p-4 flex flex-col sm:flex-row items-center justify-between gap-4 shadow-sm">
      <div class="relative w-full sm:max-w-md">
        <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
        <input type="text" id="searchInput" onkeyup="filterRows()" placeholder="Search pending employer by name or email..."
               class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2 text-xs font-semibold text-slate-800 outline-none focus:border-indigo-400 transition-all">
      </div>

      <span class="text-xs font-mono font-bold text-slate-400">
        Queue: <%= pending.size() %> Actionable Requests
      </span>
    </div>

    <!-- VERIFICATION TABLE -->
    <div class="table-section">
      <div class="p-5 border-b border-slate-100 flex items-center justify-between">
        <div>
          <h2 class="font-sora text-sm font-bold text-slate-900">Pending Employer Authorizations</h2>
          <p class="text-[11px] text-slate-400">New company signups requiring identity and credentials review</p>
        </div>
      </div>

      <% if (pending.isEmpty()) { %>
        <div class="py-16 text-center space-y-3">
          <div class="w-14 h-14 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-500 flex items-center justify-center mx-auto text-2xl">
            <i class="fas fa-check-double"></i>
          </div>
          <p class="font-sora font-bold text-slate-800 text-sm">All Caught Up!</p>
          <p class="text-xs text-slate-400">There are currently no pending employer verification requests in queue.</p>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="custom-table text-left">
            <thead>
              <tr>
                <th># ID</th>
                <th>Company / Employer Profile</th>
                <th>Corporate Email</th>
                <th>Phone Contact</th>
                <th>Location</th>
                <th>Authorization Status</th>
                <th class="text-right">Action Decision</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (UserModel u : pending) {
                  String fName = u.getFirstname() != null ? u.getFirstname().trim() : "";
                  String lName = u.getLastname() != null ? u.getLastname().trim() : "";
                  String compName = (fName + " " + lName).trim();
                  if (compName.isEmpty()) compName = "Enterprise Employer";

                  String initial = String.valueOf(compName.charAt(0)).toUpperCase();
                  String email = u.getEmail() != null ? u.getEmail() : "—";
                  String contact = u.getContact() != null ? u.getContact() : "—";
                  String city = u.getCity() != null ? u.getCity() : (u.getAddress() != null ? u.getAddress() : "Ahmedabad");
                  int uId = u.getUserid();
              %>
              <tr class="employer-row" data-name="<%= compName.toLowerCase() %>" data-email="<%= email.toLowerCase() %>">
                <td class="font-mono text-slate-400">#<%= uId %></td>
                <td>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-amber-50 border border-amber-200 text-amber-600 font-sora font-bold text-xs flex items-center justify-center flex-shrink-0">
                      <%= initial %>
                    </div>
                    <div>
                      <p class="font-bold text-slate-800 text-xs"><%= compName %></p>
                      <p class="text-[10px] text-slate-400 font-mono">Role: EMPLOYER</p>
                    </div>
                  </div>
                </td>
                <td class="font-mono text-slate-500 text-xs"><%= email %></td>
                <td class="font-mono text-slate-500 text-xs"><%= contact %></td>
                <td class="font-mono text-slate-500 text-xs">
                  <i class="fas fa-location-dot text-indigo-500 mr-1 text-[10px]"></i><%= city %>
                </td>
                <td>
                  <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider bg-amber-50 text-amber-600 border border-amber-200">
                    <span class="w-1.5 h-1.5 rounded-full bg-amber-500 animate-pulse"></span> Pending
                  </span>
                </td>
                <td class="text-right">
                  <div class="inline-flex items-center gap-2">
                    <!-- Approve Button -->
                    <form action="${pageContext.request.contextPath}/AdminVerifyController" method="post" style="display:inline;">
                      <input type="hidden" name="userid" value="<%= uId %>">
                      <input type="hidden" name="action" value="approve">
                      <button type="submit" class="action-btn bg-emerald-50 hover:bg-emerald-600 text-emerald-600 hover:text-white border border-emerald-200"
                              onclick="return confirm('Authorize and activate <%= compName %>?')">
                        <i class="fas fa-check text-[10px]"></i> Approve
                      </button>
                    </form>

                    <!-- Reject Button -->
                    <form action="${pageContext.request.contextPath}/AdminVerifyController" method="post" style="display:inline;">
                      <input type="hidden" name="userid" value="<%= uId %>">
                      <input type="hidden" name="action" value="reject">
                      <button type="submit" class="action-btn bg-rose-50 hover:bg-rose-600 text-rose-600 hover:text-white border border-rose-200"
                              onclick="return confirm('Decline verification request for <%= compName %>?')">
                        <i class="fas fa-times text-[10px]"></i> Reject
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>

  </div>

  <!-- FOOTER -->
  <footer class="p-6 border-t border-slate-200 text-center text-xs text-slate-400 font-mono mt-auto">
    &copy; 2026 JobBoard Master Admin Control Center. All rights reserved.
  </footer>
</div>

<!-- REAL-TIME FILTER SCRIPT -->
<script>
  function filterRows() {
    const q = document.getElementById('searchInput').value.toLowerCase().trim();
    document.querySelectorAll('.employer-row').forEach(row => {
      const name = row.getAttribute('data-name') || '';
      const email = row.getAttribute('data-email') || '';
      row.style.display = (name.includes(q) || email.includes(q)) ? '' : 'none';
    });
  }
</script>

</body>
</html>
