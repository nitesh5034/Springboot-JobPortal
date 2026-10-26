<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 1. Session Guard (Redirects safely to login)
    Object sessionModel = session.getAttribute("Model");
    if (sessionModel == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String action = request.getParameter("action");
    String msg = "";

    // 2. Delete Job Action
    if ("delete".equals(action)) {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                Connection cn = new DBUtil().getConnection();
                PreparedStatement ps = cn.prepareStatement("DELETE FROM `company job-update` WHERE job_id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
                cn.close();
                msg = "deleted";
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 3. Search & Filter Parameters
    String search     = request.getParameter("search");
    String filterType = request.getParameter("filter");

    List<Map<String, String>> jobs = new ArrayList<>();
    int totalJobs = 0, totalFullTime = 0, totalPartTime = 0;

    try {
        Connection cn = new DBUtil().getConnection();

        // 4. Aggregate Job Stats
        ResultSet rs2 = cn.createStatement().executeQuery(
            "SELECT Job_Type, COUNT(*) as cnt FROM `company job-update` GROUP BY Job_Type");
        while (rs2.next()) {
            String t = rs2.getString("Job_Type");
            int c    = rs2.getInt("cnt");
            totalJobs += c;
            if (t != null && t.toLowerCase().contains("full")) totalFullTime += c;
            if (t != null && t.toLowerCase().contains("part")) totalPartTime += c;
        }
        rs2.close();

        // 5. Query Builder with Parameters
        StringBuilder sql = new StringBuilder("SELECT * FROM `company job-update` WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (LOWER(Job_Title) LIKE ? OR LOWER(company_name) LIKE ? OR LOWER(Location) LIKE ?)");
            String term = "%" + search.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (filterType != null && !filterType.trim().isEmpty()) {
            sql.append(" AND LOWER(Job_Type) LIKE ?");
            params.add("%" + filterType.trim().toLowerCase() + "%");
        }
        sql.append(" ORDER BY job_id DESC");

        PreparedStatement ps = cn.prepareStatement(sql.toString());
        for (int p = 0; p < params.size(); p++) {
            ps.setObject(p + 1, params.get(p));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("job_id",      rs.getString("job_id"));
            m.put("job_title",   rs.getString("Job_Title") != null ? rs.getString("Job_Title") : "Untitled Role");
            m.put("company",     rs.getString("company_name") != null ? rs.getString("company_name") : "Enterprise Employer");
            m.put("email",       rs.getString("Email") != null ? rs.getString("Email") : "—");
            m.put("location",    rs.getString("Location") != null ? rs.getString("Location") : "Remote");
            m.put("job_type",    rs.getString("Job_Type") != null ? rs.getString("Job_Type") : "Full Time");
            m.put("salary",      rs.getString("salary") != null ? rs.getString("salary") : "Negotiable");
            m.put("opening",     rs.getString("opening") != null ? rs.getString("opening") : "1");
            m.put("experience",  rs.getString("experience") != null ? rs.getString("experience") : "0");
            m.put("skills",      rs.getString("skills_req") != null ? rs.getString("skills_req") : "");
            m.put("region",      rs.getString("Job_Region") != null ? rs.getString("Job_Region") : "");
            m.put("applied",     rs.getString("applied_count") != null ? rs.getString("applied_count") : "0");
            m.put("description", rs.getString("Job_Description") != null ? rs.getString("Job_Description") : "");
            jobs.add(m);
        }
        rs.close();
        ps.close();
        cn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Auto-detect page URL based on controller or direct file extension
    String pageUrl = request.getContextPath() + "/admin-jobs.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Portal — Job Postings | JobBoard</title>
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
    body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f8fafc; color: #0f172a; min-height: 100vh; }
    .font-sora { font-family: 'Sora', sans-serif; }
    .font-mono { font-family: 'JetBrains Mono', monospace; }

    .sidebar { width: 260px; background: #ffffff; border-right: 1px solid #e2e8f0; min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; }
    .sidebar-logo { padding: 24px 20px; border-bottom: 1px solid #f1f5f9; font-family: 'Sora', sans-serif; font-size: 20px; font-weight: 800; color: #0f172a; }
    .sidebar-logo span { color: #4f46e5; }
    .sidebar-nav { padding: 16px 12px; flex: 1; overflow-y: auto; }
    .nav-item { display: flex; align-items: center; gap: 12px; padding: 10px 14px; border-radius: 12px; color: #64748b; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.2s; margin-bottom: 4px; }
    .nav-item:hover { color: #4f46e5; background: #f1f5f9; }
    .nav-item.active { color: #4f46e5; background: #eef2ff; border: 1px solid #c7d2fe; }
    .nav-item i { width: 18px; text-align: center; font-size: 14px; }
    .nav-section { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #94a3b8; padding: 16px 14px 6px; }

    .main { margin-left: 260px; min-height: 100vh; display: flex; flex-direction: column; }
    .topbar { background: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; }

    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 28px; }
    .stat-card { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 18px; padding: 20px 24px; position: relative; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
    .stat-card.blue::before   { background: linear-gradient(90deg, #6366f1, #38bdf8); }
    .stat-card.green::before  { background: linear-gradient(90deg, #10b981, #34d399); }
    .stat-card.yellow::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }

    .table-section { background: #ffffff; border: 1px solid #e2e8f0; border-radius: 20px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
    .custom-table th { background: #f8fafc; border-bottom: 1px solid #e2e8f0; color: #64748b; font-size: 11px; text-transform: uppercase; font-family: 'JetBrains Mono', monospace; font-weight: 700; letter-spacing: 0.05em; padding: 14px 20px; }
    .custom-table td { border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-size: 13px; vertical-align: middle; color: #334155; }
    .custom-table tr:last-child td { border-bottom: none; }
    .custom-table tr:hover td { background: #f8fafc; }

    .action-btn { width: 32px; height: 32px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; font-size: 12px; transition: all 0.2s; cursor: pointer; }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sidebar-logo flex items-center justify-between">
    <div>Job<span>Board</span></div>
    <span class="text-[9px] font-mono uppercase bg-rose-100 text-rose-600 border border-rose-200 px-2 py-0.5 rounded-md">Admin</span>
  </div>

  <div class="sidebar-nav">
    <div class="nav-section">Main Management</div>
    <a href="${pageContext.request.contextPath}/admin-dashboard.jsp" class="nav-item">
      <i class="fas fa-chart-pie text-indigo-500"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin-application.jsp" class="nav-item">
      <i class="fas fa-file-invoice text-indigo-500"></i> Job Applications
    </a>
    <a href="${pageContext.request.contextPath}/admin-companies.jsp" class="nav-item">
      <i class="fas fa-building-circle-check text-indigo-500"></i> Companies Directory
    </a>
    <a href="${pageContext.request.contextPath}/admin-jobs.jsp" class="nav-item active">
      <i class="fas fa-briefcase text-indigo-500"></i> Job Postings
    </a>
    <a href="${pageContext.request.contextPath}/admin-users.jsp" class="nav-item">
      <i class="fas fa-users text-indigo-500"></i> User Directory
    </a>
    <a href="${pageContext.request.contextPath}/admin-praposal.jsp" class="nav-item">
      <i class="fas fa-handshake text-indigo-500"></i> Proposals
    </a>

    <div class="nav-section">Session</div>
    <a href="${pageContext.request.contextPath}/admin-login.jsp" class="nav-item text-rose-500 hover:bg-rose-50">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>

  <div class="p-4 border-t border-slate-100 bg-slate-50">
    <div class="flex items-center gap-3">
      <div class="w-9 h-9 rounded-xl bg-indigo-600 flex items-center justify-center font-bold text-xs text-white">
        A
      </div>
      <div>
        <p class="text-xs font-bold text-slate-800">Administrator</p>
        <p class="text-[10px] text-slate-500 font-mono">Job Operations</p>
      </div>
    </div>
  </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div>
      <h1 class="font-sora text-lg font-bold text-slate-800">Active Job Postings Directory</h1>
      <p class="text-xs text-slate-500">Inspect, monitor, and remove job listings across all verified companies</p>
    </div>
    <div class="flex items-center gap-3">
      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-mono font-bold bg-indigo-50 border border-indigo-200 text-indigo-600">
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <%= totalJobs %> Total Live Positions
      </span>
    </div>
  </header>

  <!-- CONTENT WRAPPER -->
  <div class="p-8 flex-1 space-y-6">

    <!-- ALERT TOASTS -->
    <% if ("deleted".equals(msg)) { %>
      <div class="p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-trash-alt text-rose-500"></i> Job posting entry permanently deleted!
        </div>
        <button onclick="this.parentElement.remove()" class="text-rose-500"><i class="fas fa-times"></i></button>
      </div>
    <% } %>

    <!-- STATS ROW -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-500 font-bold">Total Posted Jobs</span>
          <i class="fas fa-briefcase text-indigo-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-slate-800"><%= totalJobs %></p>
      </div>

      <div class="stat-card green">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-500 font-bold">Full Time Openings</span>
          <i class="fas fa-clock text-emerald-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-emerald-600"><%= totalFullTime %></p>
      </div>

      <div class="stat-card yellow">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-500 font-bold">Part Time / Other</span>
          <i class="fas fa-sun text-amber-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-amber-600"><%= totalPartTime %></p>
      </div>
    </div>

    <!-- FILTER TOOLBAR -->
    <div class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm">
      <form method="GET" action="<%= pageUrl %>" class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <div class="flex flex-1 items-center gap-3 flex-wrap">

          <div class="relative flex-1 min-w-[240px]">
            <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
            <input type="text" name="search" placeholder="Search job title, company, or location..." value="<%= search != null ? search : "" %>"
                   class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2 text-xs font-semibold text-slate-800 outline-none focus:border-indigo-500 transition-all">
          </div>

          <select name="filter" class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-xs font-semibold text-slate-700 outline-none cursor-pointer">
            <option value="">All Job Types</option>
            <option value="Full" <%= "Full".equalsIgnoreCase(filterType) ? "selected" : "" %>>Full Time</option>
            <option value="Part" <%= "Part".equalsIgnoreCase(filterType) ? "selected" : "" %>>Part Time</option>
            <option value="Contract" <%= "Contract".equalsIgnoreCase(filterType) ? "selected" : "" %>>Contract</option>
            <option value="Internship" <%= "Internship".equalsIgnoreCase(filterType) ? "selected" : "" %>>Internship</option>
          </select>

          <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase px-5 py-2 rounded-xl transition-all shadow-sm">
            Filter
          </button>
          <a href="<%= pageUrl %>" class="bg-slate-100 hover:bg-slate-200 text-slate-600 text-xs font-bold px-4 py-2 rounded-xl transition-all">
            Reset
          </a>
        </div>

        <div class="text-xs font-mono font-bold text-slate-500">
          Showing <%= jobs.size() %> of <%= totalJobs %> Postings
        </div>
      </form>
    </div>

    <!-- TABLE SECTION -->
    <div class="table-section">
      <% if (jobs.isEmpty()) { %>
        <div class="py-16 text-center space-y-3">
          <div class="w-14 h-14 rounded-2xl bg-slate-100 border border-slate-200 text-slate-400 flex items-center justify-center mx-auto text-2xl">
            <i class="fas fa-briefcase"></i>
          </div>
          <p class="font-sora font-bold text-slate-800 text-sm">No Jobs Found</p>
          <p class="text-xs text-slate-500">No job postings matched your filter or search query.</p>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="custom-table text-left">
            <thead>
              <tr>
                <th># ID</th>
                <th>Role & Experience</th>
                <th>Employer Company</th>
                <th>Location</th>
                <th>Type</th>
                <th>Offered Salary</th>
                <th>Seats</th>
                <th>Applicants</th>
                <th class="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (Map<String, String> job : jobs) {
                  String jt = job.get("job_type") != null ? job.get("job_type").toLowerCase() : "";
                  String typeBadge = "bg-amber-50 text-amber-700 border-amber-200";
                  if (jt.contains("full")) {
                      typeBadge = "bg-indigo-50 text-indigo-700 border-indigo-200";
                  } else if (jt.contains("part")) {
                      typeBadge = "bg-emerald-50 text-emerald-700 border-emerald-200";
                  }

                  String initial = String.valueOf(job.get("company").charAt(0)).toUpperCase();

                  // HTML Attribute-Safe Cleaning
                  String cleanTitle = job.get("job_title").replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanCompany = job.get("company").replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanLoc = job.get("location").replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanSkills = job.get("skills").replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;").replace("\r", "").replace("\n", " ");
                  String cleanDesc = job.get("description").replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;").replace("\r", "").replace("\n", " ");
              %>
              <tr>
                <td class="font-mono text-slate-400">#<%= job.get("job_id") %></td>
                <td>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-100 text-indigo-600 font-sora font-bold text-xs flex items-center justify-center flex-shrink-0">
                      <%= initial %>
                    </div>
                    <div>
                      <p class="font-bold text-slate-800 text-xs"><%= job.get("job_title") %></p>
                      <p class="text-[10px] text-slate-500 font-mono">Exp: <%= job.get("experience") %> yrs</p>
                    </div>
                  </div>
                </td>
                <td>
                  <p class="font-semibold text-slate-700 text-xs"><%= job.get("company") %></p>
                  <p class="text-[10px] text-slate-500 font-mono"><%= job.get("email") %></p>
                </td>
                <td class="font-mono text-slate-600 text-xs">
                  <i class="fas fa-location-dot text-indigo-500 mr-1 text-[10px]"></i><%= job.get("location") %>
                </td>
                <td>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border <%= typeBadge %>">
                    <%= job.get("job_type") %>
                  </span>
                </td>
                <td class="font-mono font-bold text-slate-800 text-xs">&#8377;<%= job.get("salary") %></td>
                <td class="font-mono text-slate-600 text-xs"><%= job.get("opening") %></td>
                <td>
                  <span class="inline-flex items-center px-2 py-0.5 rounded-md bg-indigo-50 text-indigo-700 font-mono font-bold text-xs">
                    <%= job.get("applied") %>
                  </span>
                </td>
                <td class="text-right">
                  <div class="inline-flex items-center gap-1.5">
                    <!-- View Details Modal Trigger -->
                    <button type="button"
                            data-title="<%= cleanTitle %>"
                            data-company="<%= cleanCompany %>"
                            data-location="<%= cleanLoc %>"
                            data-type="<%= job.get("job_type") %>"
                            data-salary="<%= job.get("salary") %>"
                            data-opening="<%= job.get("opening") %>"
                            data-exp="<%= job.get("experience") %>"
                            data-skills="<%= cleanSkills %>"
                            data-desc="<%= cleanDesc %>"
                            onclick="handleModalOpen(this)"
                            class="action-btn bg-indigo-50 hover:bg-indigo-600 text-indigo-600 hover:text-white border border-indigo-200" title="View Full Details">
                      <i class="fas fa-eye"></i>
                    </button>
                    <!-- Delete Button -->
                    <a href="<%= pageUrl %>?action=delete&id=<%= job.get("job_id") %>"
                       class="action-btn bg-slate-50 hover:bg-rose-600 text-slate-500 hover:text-white border border-slate-200" title="Delete Job"
                       onclick="return confirm('Permanently delete this job posting?')">
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
  <footer class="p-6 border-t border-slate-200 text-center text-xs text-slate-500 font-mono mt-auto bg-white">
    &copy; 2026 JobBoard Master Admin Control Center. All rights reserved.
  </footer>
</div>

<!-- JOB DETAILS MODAL POPUP -->
<div id="jobModal" class="hidden fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
  <div class="bg-white border border-slate-200 rounded-3xl max-w-xl w-full p-8 space-y-6 shadow-2xl relative text-left">
    <div class="flex items-center justify-between border-b border-slate-100 pb-4">
      <div>
        <h3 id="modalJobTitle" class="font-sora font-extrabold text-lg text-slate-800">Job Position</h3>
        <p id="modalCompany" class="text-xs text-indigo-600 font-mono font-bold"></p>
      </div>
      <button onclick="closeJobModal()" class="w-8 h-8 rounded-full bg-slate-100 text-slate-500 hover:text-slate-800 flex items-center justify-center text-xs">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <div class="grid grid-cols-2 sm:grid-cols-3 gap-3 text-xs">
      <div class="p-3 rounded-2xl bg-slate-50 border border-slate-100">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Location</p>
        <p id="modalLocation" class="text-slate-800 font-semibold"></p>
      </div>
      <div class="p-3 rounded-2xl bg-slate-50 border border-slate-100">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Job Type</p>
        <p id="modalType" class="text-slate-800 font-semibold"></p>
      </div>
      <div class="p-3 rounded-2xl bg-slate-50 border border-slate-100">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Offered Salary</p>
        <p id="modalSalary" class="text-emerald-600 font-bold"></p>
      </div>
      <div class="p-3 rounded-2xl bg-slate-50 border border-slate-100">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Total Openings</p>
        <p id="modalOpening" class="text-slate-800 font-semibold"></p>
      </div>
      <div class="p-3 rounded-2xl bg-slate-50 border border-slate-100 col-span-2">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Required Experience</p>
        <p id="modalExp" class="text-slate-800 font-semibold"></p>
      </div>
    </div>

    <div class="space-y-3 text-xs">
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Skills Required</p>
        <p id="modalSkills" class="text-slate-600 leading-relaxed"></p>
      </div>
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Job Description</p>
        <p id="modalDesc" class="text-slate-600 leading-relaxed max-h-36 overflow-y-auto"></p>
      </div>
    </div>

    <div class="pt-2">
      <button onclick="closeJobModal()" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3 rounded-xl transition-all shadow-md shadow-indigo-200">
        Close Window
      </button>
    </div>
  </div>
</div>

<!-- SCRIPT -->
<script>
  function handleModalOpen(btn) {
    const title = btn.getAttribute('data-title');
    const company = btn.getAttribute('data-company');
    const loc = btn.getAttribute('data-location');
    const type = btn.getAttribute('data-type');
    const sal = btn.getAttribute('data-salary');
    const opening = btn.getAttribute('data-opening');
    const exp = btn.getAttribute('data-exp');
    const skills = btn.getAttribute('data-skills');
    const desc = btn.getAttribute('data-desc');

    openJobModal(title, company, loc, type, sal, opening, exp, skills, desc);
  }

  function openJobModal(title, company, loc, type, sal, opening, exp, skills, desc) {
    document.getElementById('modalJobTitle').textContent = title;
    document.getElementById('modalCompany').textContent  = company;
    document.getElementById('modalLocation').textContent = loc || 'Remote';
    document.getElementById('modalType').textContent     = type || 'Full Time';
    document.getElementById('modalSalary').textContent   = '₹' + sal;
    document.getElementById('modalOpening').textContent  = opening + ' positions';
    document.getElementById('modalExp').textContent      = exp + ' years minimum';
    document.getElementById('modalSkills').textContent   = skills || 'No specific skills listed.';
    document.getElementById('modalDesc').textContent     = desc || 'No description provided.';
    document.getElementById('jobModal').classList.remove('hidden');
  }

  function closeJobModal() {
    document.getElementById('jobModal').classList.add('hidden');
  }
</script>

</body>
</html>