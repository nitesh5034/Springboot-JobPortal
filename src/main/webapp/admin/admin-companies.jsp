<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Company, com.model.companyverify, com.model.UserModel" %>
<%@ page import="com.Repository.CompanyRepository, com.Repository.CompanyVerifyRepository, com.Repository.UserRepository" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // 1. Session Guard (Redirects safely to login)
    Object sessionModel = session.getAttribute("Model");
    if (sessionModel == null) {
        response.sendRedirect(request.getContextPath() + "/admin/admin-login");
        return;
    }

    String action = request.getParameter("action");
    String msg = "";

    // 2. DELETE ACTION (Sync across tables)
    if ("delete".equals(action)) {
        String targetEmail = request.getParameter("email");
        String idStr = request.getParameter("id");
        try {
            Connection cn = new DBUtil().getConnection();
            if (targetEmail != null && !targetEmail.trim().isEmpty()) {
                String cleanEmail = targetEmail.trim().toLowerCase();

                PreparedStatement ps1 = cn.prepareStatement("DELETE FROM company WHERE LOWER(email)=?");
                ps1.setString(1, cleanEmail);
                ps1.executeUpdate();
                ps1.close();

                PreparedStatement ps2 = cn.prepareStatement("DELETE FROM userregister WHERE LOWER(email)=?");
                ps2.setString(1, cleanEmail);
                ps2.executeUpdate();
                ps2.close();

                try {
                    PreparedStatement ps3 = cn.prepareStatement("DELETE FROM companyverify WHERE LOWER(email)=?");
                    ps3.setString(1, cleanEmail);
                    ps3.executeUpdate();
                    ps3.close();
                } catch(Exception ignore) {}
            } else if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr.trim());
                PreparedStatement ps = cn.prepareStatement("DELETE FROM company WHERE id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
            }
            cn.close();
            msg = "deleted";
        } catch (Exception e) { e.printStackTrace(); }
    }

    // 3. STATUS UPDATE ACTION (Sync across company and userregister)
    if ("status".equals(action)) {
        String st = request.getParameter("status");
        String targetEmail = request.getParameter("email");
        String idStr = request.getParameter("id");

        try {
            Connection cn = new DBUtil().getConnection();
            if (targetEmail != null && !targetEmail.trim().isEmpty()) {
                String cleanEmail = targetEmail.trim().toLowerCase();

                PreparedStatement ps1 = cn.prepareStatement("UPDATE company SET status=? WHERE LOWER(email)=?");
                ps1.setString(1, st);
                ps1.setString(2, cleanEmail);
                ps1.executeUpdate();
                ps1.close();

                int isVerified = "active".equalsIgnoreCase(st) ? 1 : ("inactive".equalsIgnoreCase(st) || "rejected".equalsIgnoreCase(st) ? 2 : 0);
                PreparedStatement ps2 = cn.prepareStatement("UPDATE userregister SET is_verified=? WHERE LOWER(email)=?");
                ps2.setInt(1, isVerified);
                ps2.setString(2, cleanEmail);
                ps2.executeUpdate();
                ps2.close();

                try {
                    PreparedStatement ps3 = cn.prepareStatement("UPDATE companyverify SET status=? WHERE LOWER(email)=?");
                    ps3.setString(1, st);
                    ps3.setString(2, cleanEmail);
                    ps3.executeUpdate();
                    ps3.close();
                } catch(Exception ignore) {}

            } else if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr.trim());
                PreparedStatement ps = cn.prepareStatement("UPDATE company SET status=? WHERE id=?");
                ps.setString(1, st);
                ps.setInt(2, id);
                ps.executeUpdate();
                ps.close();
            }
            cn.close();
            msg = "updated";
        } catch (Exception e) { e.printStackTrace(); }
    }

    String search = request.getParameter("search");
    String filterStatus = request.getParameter("filter");

    // 4. FETCH ALL COMPANIES WITH MULTI-SOURCE SYNC
    Map<String, Map<String, String>> companyMap = new LinkedHashMap<>();

    Connection cn = null;
    try {
        cn = new DBUtil().getConnection();

        // Source A: company table
        try {
            Statement st = cn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM company ORDER BY id DESC");
            while (rs.next()) {
                String email = rs.getString("email") != null ? rs.getString("email").trim().toLowerCase() : "";
                if (email.isEmpty()) continue;

                Map<String, String> m = new HashMap<>();
                m.put("company_id",  rs.getString("id"));
                m.put("companyname", rs.getString("companyname"));
                m.put("email",       rs.getString("email"));
                m.put("website",     rs.getString("website"));
                m.put("location",    rs.getString("location"));
                m.put("about",       rs.getString("about"));
                m.put("status",      rs.getString("status") != null ? rs.getString("status") : "pending");
                companyMap.put(email, m);
            }
            rs.close(); st.close();
        } catch (Exception e) { e.printStackTrace(); }

        // Source B: userregister with EMPLOYER role
        try {
            Statement st = cn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM userregister WHERE UPPER(role)='EMPLOYER' ORDER BY userid DESC");
            while (rs.next()) {
                String email = rs.getString("email") != null ? rs.getString("email").trim().toLowerCase() : "";
                if (email.isEmpty()) continue;

                int isVer = 0;
                try { isVer = rs.getInt("is_verified"); } catch(Exception ignore) {}
                String statusStr = (isVer == 1) ? "active" : ((isVer == 2) ? "inactive" : "pending");

                String fName = rs.getString("firstname") != null ? rs.getString("firstname") : "";
                String lName = rs.getString("lastname") != null ? rs.getString("lastname") : "";
                String compName = (fName + " " + lName).trim();
                if (compName.isEmpty()) compName = "Enterprise Employer";

                String loc = rs.getString("city") != null ? rs.getString("city") : rs.getString("address");

                if (!companyMap.containsKey(email)) {
                    Map<String, String> m = new HashMap<>();
                    m.put("company_id",  String.valueOf(rs.getInt("userid")));
                    m.put("companyname", compName);
                    m.put("email",       rs.getString("email"));
                    m.put("website",     "");
                    m.put("location",    loc != null ? loc : "Ahmedabad, India");
                    m.put("about",       "Registered Employer Account on JobBoard");
                    m.put("status",      statusStr);
                    companyMap.put(email, m);
                }
            }
            rs.close(); st.close();
        } catch (Exception e) { e.printStackTrace(); }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (cn != null) {
            try { cn.close(); } catch(Exception e) {}
        }
    }

    // 5. STATS CALCULATION
    int totalCompanies = companyMap.size();
    int totalActive = 0, totalInactive = 0, totalPending = 0;

    for (Map<String, String> c : companyMap.values()) {
        String st = c.get("status") != null ? c.get("status").toLowerCase() : "pending";
        if ("active".equals(st) || "approved".equals(st)) totalActive++;
        else if ("inactive".equals(st) || "rejected".equals(st)) totalInactive++;
        else totalPending++;
    }

    // 6. FILTER & SEARCH
    List<Map<String, String>> displayList = new ArrayList<>();
    for (Map<String, String> c : companyMap.values()) {
        String st = c.get("status") != null ? c.get("status").toLowerCase() : "pending";

        boolean matchesStatus = true;
        if (filterStatus != null && !filterStatus.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(filterStatus)) {
                matchesStatus = "active".equals(st) || "approved".equals(st);
            } else if ("inactive".equalsIgnoreCase(filterStatus)) {
                matchesStatus = "inactive".equals(st) || "rejected".equals(st);
            } else {
                matchesStatus = filterStatus.equalsIgnoreCase(st);
            }
        }

        boolean matchesSearch = true;
        if (search != null && !search.trim().isEmpty()) {
            String q = search.toLowerCase().trim();
            String name  = c.get("companyname") != null ? c.get("companyname").toLowerCase() : "";
            String email = c.get("email") != null ? c.get("email").toLowerCase() : "";
            String loc   = c.get("location") != null ? c.get("location").toLowerCase() : "";
            matchesSearch = name.contains(q) || email.contains(q) || loc.contains(q);
        }

        if (matchesStatus && matchesSearch) {
            displayList.add(c);
        }
    }

    // Clean MVC URL Routing — MUST match the controller's real mapping: /admin/admin-companies
    String pageUrl = request.getContextPath() + "/admin/admin-companies";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Portal — Companies Directory | JobBoard</title>
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
    .stat-card.green::before  { background: linear-gradient(90deg, #10b981, #34d399); }
    .stat-card.yellow::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
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
    <a href="<%= request.getContextPath() %>/admin/admin-application" class="nav-item">
      <i class="fas fa-file-invoice text-indigo-500"></i> Job Applications
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-companies" class="nav-item active">
      <i class="fas fa-building-circle-check text-indigo-500"></i> Companies Directory
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
        <p class="text-[10px] text-slate-400 font-mono">Operations Control</p>
      </div>
    </div>
  </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div>
      <h1 class="font-sora text-lg font-bold text-slate-900">Corporate Partners & Employers</h1>
      <p class="text-xs text-slate-500">Review company verification requests and manage corporate posting privileges</p>
    </div>
    <div class="flex items-center gap-3">
      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-mono font-bold bg-indigo-50 border border-indigo-200 text-indigo-600">
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <%= totalCompanies %> Total Companies
      </span>
    </div>
  </header>

  <!-- CONTENT WRAPPER -->
  <div class="p-8 flex-1 space-y-6">

    <!-- ALERT TOASTS -->
    <% if ("updated".equals(msg)) { %>
      <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-check-circle text-emerald-500"></i> Company status updated across all database tables!
        </div>
        <button onclick="this.parentElement.remove()" class="text-emerald-500"><i class="fas fa-times"></i></button>
      </div>
    <% } else if ("deleted".equals(msg)) { %>
      <div class="p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-trash-alt text-rose-500"></i> Company record permanently removed.
        </div>
        <button onclick="this.parentElement.remove()" class="text-rose-500"><i class="fas fa-times"></i></button>
      </div>
    <% } %>

    <!-- STATS ROW -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Total Companies</span>
          <i class="fas fa-building text-indigo-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-slate-900"><%= totalCompanies %></p>
      </div>

      <div class="stat-card green">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Active & Verified</span>
          <i class="fas fa-check-circle text-emerald-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-emerald-500"><%= totalActive %></p>
      </div>

      <div class="stat-card yellow">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Pending Approval</span>
          <i class="fas fa-clock text-amber-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-amber-500"><%= totalPending %></p>
      </div>

      <div class="stat-card red">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Inactive / Declined</span>
          <i class="fas fa-ban text-rose-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-rose-500"><%= totalInactive %></p>
      </div>
    </div>

    <!-- FILTER TOOLBAR -->
    <div class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm">
      <form method="GET" action="<%= pageUrl %>" class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <div class="flex flex-1 items-center gap-3 flex-wrap">

          <div class="relative flex-1 min-w-[240px]">
            <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
            <input type="text" name="search" placeholder="Search company name, email, or location..." value="<%= search != null ? search : "" %>"
                   class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2 text-xs font-semibold text-slate-800 outline-none focus:border-indigo-400 transition-all">
          </div>

          <select name="filter" class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-xs font-semibold text-slate-600 outline-none cursor-pointer">
            <option value="">All Statuses</option>
            <option value="active" <%= "active".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>Active / Verified</option>
            <option value="pending" <%= "pending".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>Pending Approval</option>
            <option value="inactive" <%= "inactive".equalsIgnoreCase(filterStatus) ? "selected" : "" %>>Inactive / Declined</option>
          </select>

          <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase px-5 py-2 rounded-xl transition-all">
            Filter
          </button>
          <a href="<%= pageUrl %>" class="bg-slate-100 hover:bg-slate-200 text-slate-600 text-xs font-bold px-4 py-2 rounded-xl transition-all">
            Reset
          </a>
        </div>

        <div class="text-xs font-mono font-bold text-slate-400">
          Showing <%= displayList.size() %> of <%= totalCompanies %> Companies
        </div>
      </form>
    </div>

    <!-- TABLE SECTION -->
    <div class="table-section">
      <% if (displayList.isEmpty()) { %>
        <div class="py-16 text-center space-y-3">
          <div class="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-200 text-slate-400 flex items-center justify-center mx-auto text-2xl">
            <i class="fas fa-building-circle-exclamation"></i>
          </div>
          <p class="font-sora font-bold text-slate-800 text-sm">No Companies Found</p>
          <p class="text-xs text-slate-400">No company records matched your active query filters.</p>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="custom-table text-left">
            <thead>
              <tr>
                <th># ID</th>
                <th>Company Entity</th>
                <th>Corporate Email</th>
                <th>Location</th>
                <th>Website</th>
                <th>Status</th>
                <th class="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (Map<String, String> c : displayList) {
                  String st = c.get("status") != null ? c.get("status").toLowerCase() : "pending";
                  String statusBadge = "bg-amber-50 text-amber-600 border-amber-200";
                  if ("active".equals(st) || "approved".equals(st)) {
                      statusBadge = "bg-emerald-50 text-emerald-600 border-emerald-200";
                  } else if ("inactive".equals(st) || "rejected".equals(st)) {
                      statusBadge = "bg-rose-50 text-rose-600 border-rose-200";
                  }

                  String compName = c.get("companyname") != null && !c.get("companyname").isEmpty() ? c.get("companyname") : "Enterprise Employer";
                  String initial = String.valueOf(compName.charAt(0)).toUpperCase();
                  String website = c.get("website");
                  String location = c.get("location") != null && !c.get("location").isEmpty() ? c.get("location") : "Ahmedabad, India";
                  String email = c.get("email");
                  String about = c.get("about") != null ? c.get("about") : "No description provided.";
              %>
              <tr>
                <td class="font-mono text-slate-400">#<%= c.get("company_id") %></td>
                <td>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-200 text-indigo-600 font-sora font-bold text-xs flex items-center justify-center flex-shrink-0">
                      <%= initial %>
                    </div>
                    <div>
                      <p class="font-bold text-slate-800 text-xs"><%= compName %></p>
                      <p class="text-[10px] text-slate-400 truncate max-w-[200px]"><%= about %></p>
                    </div>
                  </div>
                </td>
                <td class="font-mono text-slate-500 text-xs"><%= email %></td>
                <td class="font-mono text-slate-500 text-xs">
                  <i class="fas fa-location-dot text-indigo-500 mr-1 text-[10px]"></i><%= location %>
                </td>
                <td class="font-mono text-xs">
                  <% if (website != null && !website.trim().isEmpty()) { %>
                    <a href="<%= website.startsWith("http") ? website : "https://" + website %>" target="_blank" class="text-indigo-500 hover:underline inline-flex items-center gap-1">
                      Visit <i class="fas fa-arrow-up-right-from-square text-[9px]"></i>
                    </a>
                  <% } else { %>
                    <span class="text-slate-400">N/A</span>
                  <% } %>
                </td>
                <td>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border <%= statusBadge %>">
                    <%= st %>
                  </span>
                </td>
                <td class="text-right">
                  <div class="inline-flex items-center gap-1.5">
                    <!-- Approve / Activate -->
                    <a href="<%= pageUrl %>?action=status&email=<%= email %>&id=<%= c.get("company_id") %>&status=active"
                       class="action-btn bg-emerald-50 hover:bg-emerald-600 text-emerald-500 hover:text-white border border-emerald-200" title="Approve & Activate"
                       onclick="return confirm('Authorize and activate <%= compName %>?')">
                      <i class="fas fa-check"></i>
                    </a>
                    <!-- Deactivate / Suspend -->
                    <a href="<%= pageUrl %>?action=status&email=<%= email %>&id=<%= c.get("company_id") %>&status=inactive"
                       class="action-btn bg-amber-50 hover:bg-amber-600 text-amber-500 hover:text-white border border-amber-200" title="Deactivate / Suspend"
                       onclick="return confirm('Deactivate <%= compName %>?')">
                      <i class="fas fa-ban"></i>
                    </a>
                    <!-- View Details Modal -->
                    <button type="button"
                            onclick="openDetailsModal('<%= compName.replace("'", "\\'") %>', '<%= email %>', '<%= location.replace("'", "\\'") %>', '<%= (website != null ? website.replace("'", "\\'") : "") %>', '<%= about.replace("'", "\\'").replace("\n", " ") %>')"
                            class="action-btn bg-indigo-50 hover:bg-indigo-600 text-indigo-500 hover:text-white border border-indigo-200" title="View Full Details">
                      <i class="fas fa-eye"></i>
                    </button>
                    <!-- Delete -->
                    <a href="<%= pageUrl %>?action=delete&email=<%= email %>&id=<%= c.get("company_id") %>"
                       class="action-btn bg-slate-50 hover:bg-rose-600 text-slate-400 hover:text-white border border-slate-200" title="Delete"
                       onclick="return confirm('Permanently delete <%= compName %>?')">
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

<!-- DETAILS MODAL POPUP -->
<div id="companyModal" class="hidden fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
  <div class="bg-white border border-slate-200 rounded-3xl max-w-lg w-full p-8 space-y-6 shadow-2xl relative text-left">
    <div class="flex items-center justify-between border-b border-slate-200 pb-4">
      <div>
        <h3 id="modalName" class="font-sora font-extrabold text-lg text-slate-900">Company Overview</h3>
        <p id="modalEmail" class="text-xs text-slate-400 font-mono"></p>
      </div>
      <button onclick="closeDetailsModal()" class="w-8 h-8 rounded-full bg-slate-100 text-slate-500 hover:text-slate-800 flex items-center justify-center text-xs">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <div class="space-y-4 text-xs">
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Location / Headquarters</p>
        <p id="modalLocation" class="text-slate-800 font-semibold"></p>
      </div>
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Official Website</p>
        <p id="modalWebsite" class="font-mono text-indigo-600"></p>
      </div>
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Company Description</p>
        <p id="modalAbout" class="text-slate-600 leading-relaxed"></p>
      </div>
    </div>

    <div class="pt-2">
      <button onclick="closeDetailsModal()" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3 rounded-xl transition-all">
        Close Window
      </button>
    </div>
  </div>
</div>

<!-- SCRIPT -->
<script>
  function openDetailsModal(name, email, loc, web, about) {
    document.getElementById('modalName').textContent = name;
    document.getElementById('modalEmail').textContent = email;
    document.getElementById('modalLocation').textContent = loc || 'Not Provided';
    document.getElementById('modalWebsite').textContent = web || 'No official website linked';
    document.getElementById('modalAbout').textContent = about || 'No corporate description entered.';
    document.getElementById('companyModal').classList.remove('hidden');
  }

  function closeDetailsModal() {
    document.getElementById('companyModal').classList.add('hidden');
  }
</script>

</body>
</html>
