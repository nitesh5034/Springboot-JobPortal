<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.applymodel, com.model.Postjob" %>
<%@ page import="com.Repository.ApplyRepository, com.Repository.JobRepository" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.*" %>
<%
    // 1. Session Guard (Redirects safely to login)
    Object sessionModel = session.getAttribute("Model");
    if (sessionModel == null) {
        response.sendRedirect(request.getContextPath() + "/admin/admin-login");
        return;
    }

    // 2. Fetch Spring Data JPA Repositories safely
    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    ApplyRepository applyRepo = null;
    JobRepository jobRepo     = null;

    try {
        if (ctx != null) {
            applyRepo = ctx.getBean(ApplyRepository.class);
            jobRepo   = ctx.getBean(JobRepository.class);
        }
    } catch(Exception e) {
        e.printStackTrace();
    }

    String action = request.getParameter("action");
    String msg = "";

    // 3. Status Action Handler
    if ("status".equals(action) && applyRepo != null) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String st = request.getParameter("status");
            Optional<applymodel> appOpt = applyRepo.findById(id);
            if (appOpt.isPresent()) {
                applymodel appToUpdate = appOpt.get();
                appToUpdate.setStatus(st);
                applyRepo.save(appToUpdate);
                msg = "updated";
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 4. Delete Action Handler
    if ("delete".equals(action) && applyRepo != null) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            applyRepo.deleteById(id);
            msg = "deleted";
        } catch (Exception e) { e.printStackTrace(); }
    }

    String filterStatus = request.getParameter("filter");
    String search       = request.getParameter("search");

    // 5. Fetch Applications
    List<applymodel> allApps = new ArrayList<>();
    if (applyRepo != null) {
        try {
            allApps = applyRepo.findAll();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    int totalPending = 0, totalAccepted = 0, totalRejected = 0;
    for (applymodel app : allApps) {
        String st = app.getStatus() != null ? app.getStatus().toLowerCase() : "pending";
        if ("accepted".equals(st) || "approved".equals(st) || "shortlisted".equals(st)) {
            totalAccepted++;
        } else if ("rejected".equals(st)) {
            totalRejected++;
        } else {
            totalPending++;
        }
    }
    int totalApps = allApps.size();

    // 6. Search & Status Filter
    List<applymodel> filteredApps = new ArrayList<>();
    for (applymodel app : allApps) {
        String st = app.getStatus() != null ? app.getStatus().toLowerCase() : "pending";

        boolean matchesStatus = true;
        if (filterStatus != null && !filterStatus.trim().isEmpty()) {
            if ("accepted".equalsIgnoreCase(filterStatus) || "approved".equalsIgnoreCase(filterStatus)) {
                matchesStatus = "accepted".equals(st) || "approved".equals(st) || "shortlisted".equals(st);
            } else {
                matchesStatus = filterStatus.equalsIgnoreCase(st);
            }
        }

        boolean matchesSearch = true;
        if (search != null && !search.trim().isEmpty()) {
            String q = search.toLowerCase().trim();
            String name  = app.getFullname() != null ? app.getFullname().toLowerCase() : "";
            String email = app.getEmail() != null ? app.getEmail().toLowerCase() : "";
            String city  = app.getCity() != null ? app.getCity().toLowerCase() : "";
            matchesSearch = name.contains(q) || email.contains(q) || city.contains(q);
        }

        if (matchesStatus && matchesSearch) {
            filteredApps.add(app);
        }
    }

    try {
        filteredApps.sort((a, b) -> Integer.compare(b.getApp_id(), a.getApp_id()));
    } catch(Throwable t) {}

    // Universal URL resolution — MUST match the controller's real mapping: /admin/admin-application
    String pageUrl = request.getContextPath() + "/admin/admin-application";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Portal — Job Applications | JobBoard</title>
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
    .stat-card.blue::before   { background: linear-gradient(90deg, #6366f1, #38bdf8); }
    .stat-card.yellow::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
    .stat-card.green::before  { background: linear-gradient(90deg, #10b981, #34d399); }
    .stat-card.red::before    { background: linear-gradient(90deg, #f43f5e, #fb7185); }

    .table-section { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 20px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
    .custom-table th { background: #f8fafc; border-bottom: 1px solid #e5e7eb; color: #94a3b8; font-size: 11px; text-transform: uppercase; font-family: 'JetBrains Mono', monospace; font-weight: 700; letter-spacing: 0.05em; padding: 14px 20px; }
    .custom-table td { border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-size: 13px; vertical-align: middle; color: #334155; }
    .custom-table tr:last-child td { border-bottom: none; }
    .custom-table tr:hover td { background: #f8fafc; }

    .action-btn { width: 32px; height: 32px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; font-size: 12px; transition: all 0.2s; }
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
    <a href="<%= request.getContextPath() %>/admin/admin-dashboard" class="nav-item">
      <i class="fas fa-chart-pie text-indigo-500"></i> Dashboard
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-application" class="nav-item active">
      <i class="fas fa-file-invoice text-indigo-500"></i> Job Applications
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-companies" class="nav-item">
      <i class="fas fa-building-circle-check text-indigo-500"></i> Companies
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-jobs" class="nav-item">
      <i class="fas fa-briefcase text-indigo-500"></i> Job Postings
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-users" class="nav-item">
      <i class="fas fa-users text-indigo-500"></i> User Directory
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-praposal" class="nav-item">
      <i class="fas fa-handshake text-indigo-500"></i> Proposals
    </a>

    <div class="nav-section">Session</div>
    <a href="<%= request.getContextPath() %>/admin/admin-login" class="nav-item text-rose-500 hover:bg-rose-50">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>

  <div class="p-4 border-t border-slate-100">
    <div class="flex items-center gap-3">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center font-bold text-xs text-white">
        A
      </div>
      <div>
        <p class="text-xs font-bold text-slate-800">Administrator</p>
        <p class="text-[10px] text-slate-400 font-mono">Control Desk</p>
      </div>
    </div>
  </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div>
      <h1 class="font-sora text-lg font-bold text-slate-900">Candidate Applications Manager</h1>
      <p class="text-xs text-slate-500">Monitor and update all candidate submissions submitted across employers</p>
    </div>
    <div class="flex items-center gap-3">
      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-mono font-bold bg-indigo-50 border border-indigo-200 text-indigo-600">
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <%= totalApps %> Total Submissions
      </span>
    </div>
  </header>

  <!-- CONTENT WRAPPER -->
  <div class="p-8 flex-1 space-y-6">

    <!-- ALERT TOASTS -->
    <% if ("updated".equals(msg)) { %>
      <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-check-circle text-emerald-500"></i> Application status updated successfully!
        </div>
        <button onclick="this.parentElement.remove()" class="text-emerald-500"><i class="fas fa-times"></i></button>
      </div>
    <% } else if ("deleted".equals(msg)) { %>
      <div class="p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-trash-alt text-rose-500"></i> Application deleted permanently.
        </div>
        <button onclick="this.parentElement.remove()" class="text-rose-500"><i class="fas fa-times"></i></button>
      </div>
    <% } %>

    <!-- STATS ROW -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Total Applications</span>
          <i class="fas fa-file-invoice text-indigo-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-slate-900"><%= totalApps %></p>
      </div>

      <div class="stat-card yellow">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Pending Review</span>
          <i class="fas fa-clock text-amber-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-amber-500"><%= totalPending %></p>
      </div>

      <div class="stat-card green">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Accepted / Shortlist</span>
          <i class="fas fa-check-circle text-emerald-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-emerald-500"><%= totalAccepted %></p>
      </div>

      <div class="stat-card red">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Rejected</span>
          <i class="fas fa-times-circle text-rose-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-rose-500"><%= totalRejected %></p>
      </div>
    </div>

    <!-- FILTER TOOLBAR -->
    <div class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm">
      <form method="GET" action="<%= pageUrl %>" class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <div class="flex flex-1 items-center gap-3 flex-wrap">

          <div class="relative flex-1 min-w-[240px]">
            <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
            <input type="text" name="search" placeholder="Search applicant, email, or city..." value="<%= search != null ? search : "" %>"
                   class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2 text-xs font-semibold text-slate-800 outline-none focus:border-indigo-400 transition-all">
          </div>

          <select name="filter" class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-xs font-semibold text-slate-600 outline-none cursor-pointer">
            <option value="">All Statuses</option>
            <option value="pending" <%= "pending".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>Pending</option>
            <option value="accepted" <%= "accepted".equalsIgnoreCase(filterStatus) || "approved".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>Accepted</option>
            <option value="rejected" <%= "rejected".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>Rejected</option>
          </select>

          <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase px-5 py-2 rounded-xl transition-all">
            Filter
          </button>
          <a href="<%= pageUrl %>" class="bg-slate-100 hover:bg-slate-200 text-slate-600 text-xs font-bold px-4 py-2 rounded-xl transition-all">
            Reset
          </a>
        </div>

        <div class="text-xs font-mono font-bold text-slate-400">
          Showing <%= filteredApps.size() %> of <%= totalApps %> Records
        </div>
      </form>
    </div>

    <!-- TABLE SECTION -->
    <div class="table-section">
      <% if (filteredApps.isEmpty()) { %>
        <div class="py-16 text-center space-y-3">
          <div class="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-200 text-slate-400 flex items-center justify-center mx-auto text-2xl">
            <i class="fas fa-folder-open"></i>
          </div>
          <p class="font-sora font-bold text-slate-800 text-sm">No Applications Found</p>
          <p class="text-xs text-slate-400">No applications matched your filter or search query.</p>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="custom-table text-left">
            <thead>
              <tr>
                <th># ID</th>
                <th>Applicant Profile</th>
                <th>Applied Job</th>
                <th>Contact</th>
                <th>Location</th>
                <th>Experience</th>
                <th>Resume</th>
                <th>Status</th>
                <th class="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (applymodel app : filteredApps) {
                  Postjob job = null;
                  try {
                      if (jobRepo != null) {
                          job = jobRepo.findById(app.getJobId()).orElse(null);
                      }
                  } catch(Exception ex) {}

                  String jobTitle = (job != null && job.getJob_title() != null) ? job.getJob_title() : "Job Ref #" + app.getJobId();
                  String st = app.getStatus() != null ? app.getStatus().toLowerCase() : "pending";

                  String statusBadge = "bg-amber-50 text-amber-600 border-amber-200";
                  if ("accepted".equals(st) || "approved".equals(st) || "shortlisted".equals(st)) {
                      statusBadge = "bg-emerald-50 text-emerald-600 border-emerald-200";
                  } else if ("rejected".equals(st)) {
                      statusBadge = "bg-rose-50 text-rose-600 border-rose-200";
                  }

                  String initial = (app.getFullname() != null && !app.getFullname().trim().isEmpty())
                                   ? String.valueOf(app.getFullname().trim().charAt(0)).toUpperCase() : "?";
              %>
              <tr>
                <td class="font-mono text-slate-400">#<%= app.getApp_id() %></td>
                <td>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-200 text-indigo-600 font-sora font-bold text-xs flex items-center justify-center flex-shrink-0">
                      <%= initial %>
                    </div>
                    <div>
                      <p class="font-bold text-slate-800 text-xs"><%= app.getFullname() %></p>
                      <p class="text-[10px] text-slate-400 font-mono"><%= app.getEmail() %></p>
                    </div>
                  </div>
                </td>
                <td>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-lg text-xs font-semibold bg-slate-50 border border-slate-200 text-indigo-600">
                    <%= jobTitle %>
                  </span>
                </td>
                <td class="font-mono text-slate-500 text-xs">
                  <i class="fas fa-phone text-slate-400 text-[10px] mr-1"></i><%= app.getMobileno() != null ? app.getMobileno() : "—" %>
                </td>
                <td class="font-mono text-slate-500 text-xs">
                  <i class="fas fa-location-dot text-slate-400 text-[10px] mr-1"></i><%= app.getCity() != null ? app.getCity() : "Remote" %>
                </td>
                <td class="font-mono text-slate-500 text-xs"><%= app.getExperience() %> yrs</td>
                <td>
                  <% if (app.getResume() != null && !app.getResume().trim().isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/uploads/<%= app.getResume() %>" target="_blank"
                       class="inline-flex items-center gap-1.5 bg-indigo-50 hover:bg-indigo-600 text-indigo-600 hover:text-white border border-indigo-200 px-3 py-1 rounded-lg text-xs font-bold transition-all">
                      <i class="fas fa-file-pdf text-rose-500"></i> View CV
                    </a>
                  <% } else { %>
                    <span class="text-slate-400 text-xs font-mono">N/A</span>
                  <% } %>
                </td>
                <td>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border <%= statusBadge %>">
                    <%= st %>
                  </span>
                </td>
                <td class="text-right">
                  <div class="inline-flex items-center gap-1.5">
                    <!-- Accept Button -->
                    <a href="<%= pageUrl %>?action=status&id=<%= app.getApp_id() %>&status=accepted"
                       class="action-btn bg-emerald-50 hover:bg-emerald-600 text-emerald-500 hover:text-white border border-emerald-200" title="Accept"
                       onclick="return confirm('Accept this candidate application?')">
                      <i class="fas fa-check"></i>
                    </a>
                    <!-- Reject Button -->
                    <a href="<%= pageUrl %>?action=status&id=<%= app.getApp_id() %>&status=rejected"
                       class="action-btn bg-rose-50 hover:bg-rose-600 text-rose-500 hover:text-white border border-rose-200" title="Reject"
                       onclick="return confirm('Reject this application?')">
                      <i class="fas fa-times"></i>
                    </a>
                    <!-- Pending Button -->
                    <a href="<%= pageUrl %>?action=status&id=<%= app.getApp_id() %>&status=pending"
                       class="action-btn bg-amber-50 hover:bg-amber-600 text-amber-500 hover:text-white border border-amber-200" title="Set Pending">
                      <i class="fas fa-clock"></i>
                    </a>
                    <!-- Delete Button -->
                    <a href="<%= pageUrl %>?action=delete&id=<%= app.getApp_id() %>"
                       class="action-btn bg-slate-50 hover:bg-rose-600 text-slate-400 hover:text-white border border-slate-200" title="Delete"
                       onclick="return confirm('Permanently delete this application entry?')">
                      <i class="fas fa-trash-alt"></i>
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

  </div>

  <!-- FOOTER -->
  <footer class="p-6 border-t border-slate-200 text-center text-xs text-slate-400 font-mono mt-auto">
    &copy; 2026 JobBoard Master Admin Control Center. All rights reserved.
  </footer>
</div>

</body>
</html>
