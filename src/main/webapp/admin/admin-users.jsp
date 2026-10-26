<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 1. Session Guard (Redirects safely to login without 404 pathing errors)
    Object sessionModel = session.getAttribute("Model");
    if (sessionModel == null) {
        response.sendRedirect(request.getContextPath() + "/admin/admin-login");
        return;
    }

    String action = request.getParameter("action");
    String msg = "";

    // 2. Delete User Action (Handles both 'userid' and 'id' column variations)
    if ("delete".equals(action)) {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                Connection cn = new DBUtil().getConnection();
                int targetId = Integer.parseInt(idStr.trim());
                PreparedStatement ps = cn.prepareStatement("DELETE FROM userregister WHERE userid=? OR userid=?");
                ps.setInt(1, targetId);
                ps.setInt(2, targetId);
                ps.executeUpdate();
                ps.close();
                cn.close();
                msg = "deleted";
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    String search = request.getParameter("search");
    String filterRole = request.getParameter("filter");

    List<Map<String, String>> users = new ArrayList<>();
    int totalUsers = 0, totalJobseekers = 0, totalEmployers = 0;

    try {
        Connection cn = new DBUtil().getConnection();

        // 3. Stats Aggregation
        Statement st = cn.createStatement();
        ResultSet rsStats = st.executeQuery("SELECT role, COUNT(*) as cnt FROM userregister GROUP BY role");
        while (rsStats.next()) {
            String r = rsStats.getString("role");
            int c    = rsStats.getInt("cnt");
            totalUsers += c;
            if ("jobseeker".equalsIgnoreCase(r)) totalJobseekers += c;
            if ("employer".equalsIgnoreCase(r))  totalEmployers  += c;
        }
        rsStats.close();
        st.close();

        // 4. Safe Fetch with Column Metadata Mapping
        StringBuilder sql = new StringBuilder("SELECT * FROM userregister WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (LOWER(email) LIKE ? OR LOWER(firstname) LIKE ? OR LOWER(lastname) LIKE ?)");
            String term = "%" + search.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (filterRole != null && !filterRole.trim().isEmpty()) {
            sql.append(" AND UPPER(role) = ?");
            params.add(filterRole.trim().toUpperCase());
        }
        sql.append(" ORDER BY 1 DESC");

        PreparedStatement ps = cn.prepareStatement(sql.toString());
        for (int p = 0; p < params.size(); p++) {
            ps.setObject(p + 1, params.get(p));
        }

        ResultSet rs = ps.executeQuery();
        ResultSetMetaData md = rs.getMetaData();

        while (rs.next()) {
            Map<String, String> m = new HashMap<>();

            for (int col = 1; col <= md.getColumnCount(); col++) {
                String colName = md.getColumnName(col).toLowerCase();
                String colVal  = rs.getString(col);
                if (colVal == null) colVal = "";

                if (colName.contains("id")) m.put("userid", colVal);
                if (colName.contains("first")) m.put("firstname", colVal);
                if (colName.contains("last")) m.put("lastname", colVal);
                if (colName.contains("email")) m.put("email", colVal);
                if (colName.contains("contact") || colName.contains("mobile") || colName.contains("phone")) m.put("contact", colVal);
                if (colName.contains("city")) m.put("city", colVal);
                if (colName.contains("state")) m.put("state", colVal);
                if (colName.contains("role")) m.put("role", colVal);
            }

            if (!m.containsKey("firstname") || m.get("firstname").isEmpty()) m.put("firstname", "User");
            if (!m.containsKey("lastname")) m.put("lastname", "");
            if (!m.containsKey("contact") || m.get("contact").isEmpty()) m.put("contact", "—");
            if (!m.containsKey("city") || m.get("city").isEmpty()) m.put("city", "—");
            if (!m.containsKey("state") || m.get("state").isEmpty()) m.put("state", "—");
            if (!m.containsKey("role") || m.get("role").isEmpty()) m.put("role", "JOBSEEKER");

            users.add(m);
        }
        rs.close();
        ps.close();
        cn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    // Clean MVC URL Routing — MUST match the controller's real mapping: /admin/admin-users
    String pageUrl = request.getContextPath() + "/admin/admin-users";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Portal — Registered Users | JobBoard</title>
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
    /* ===== WHITE / LIGHT THEME ===== */
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

    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 28px; }
    .stat-card { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 18px; padding: 20px 24px; position: relative; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
    .stat-card.blue::before   { background: linear-gradient(90deg, #6366f1, #38bdf8); }
    .stat-card.green::before  { background: linear-gradient(90deg, #10b981, #34d399); }
    .stat-card.yellow::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }

    .table-section { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 20px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
    .custom-table th { background: #f8fafc; border-bottom: 1px solid #e5e7eb; color: #94a3b8; font-size: 11px; text-transform: uppercase; font-family: 'JetBrains Mono', monospace; font-weight: 700; letter-spacing: 0.05em; padding: 14px 20px; }
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
    <a href="<%= request.getContextPath() %>/admin/admin-companies" class="nav-item">
      <i class="fas fa-building-circle-check text-indigo-500"></i> Companies Directory
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-jobs" class="nav-item">
      <i class="fas fa-briefcase text-indigo-500"></i> Job Postings
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-users" class="nav-item active">
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
        <p class="text-[10px] text-slate-400 font-mono">User Management</p>
      </div>
    </div>
  </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div>
      <h1 class="font-sora text-lg font-bold text-slate-900">User Accounts & Profiles Directory</h1>
      <p class="text-xs text-slate-500">Inspect, monitor, and manage candidate and employer registrations</p>
    </div>
    <div class="flex items-center gap-3">
      <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-mono font-bold bg-indigo-50 border border-indigo-200 text-indigo-600">
        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
        <%= totalUsers %> Total Accounts
      </span>
    </div>
  </header>

  <!-- CONTENT WRAPPER -->
  <div class="p-8 flex-1 space-y-6">

    <!-- ALERT TOASTS -->
    <% if ("deleted".equals(msg)) { %>
      <div class="p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-trash-alt text-rose-500"></i> User account permanently removed from database.
        </div>
        <button onclick="this.parentElement.remove()" class="text-rose-500"><i class="fas fa-times"></i></button>
      </div>
    <% } %>

    <!-- STATS ROW -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Total Accounts</span>
          <i class="fas fa-users text-indigo-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-slate-900"><%= totalUsers %></p>
      </div>

      <div class="stat-card green">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Job Seekers</span>
          <i class="fas fa-user-graduate text-emerald-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-emerald-500"><%= totalJobseekers %></p>
      </div>

      <div class="stat-card yellow">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Employer Partners</span>
          <i class="fas fa-briefcase text-amber-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-amber-500"><%= totalEmployers %></p>
      </div>
    </div>

    <!-- FILTER TOOLBAR -->
    <div class="bg-white border border-slate-200 rounded-2xl p-4 shadow-sm">
      <form method="GET" action="<%= pageUrl %>" class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <div class="flex flex-1 items-center gap-3 flex-wrap">

          <div class="relative flex-1 min-w-[240px]">
            <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
            <input type="text" name="search" placeholder="Search by name or email address..." value="<%= search != null ? search : "" %>"
                   class="w-full bg-slate-50 border border-slate-200 rounded-xl pl-10 pr-4 py-2 text-xs font-semibold text-slate-800 outline-none focus:border-indigo-400 transition-all">
          </div>

          <select name="filter" class="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-xs font-semibold text-slate-600 outline-none cursor-pointer">
            <option value="">All Roles</option>
            <option value="JOBSEEKER" <%= "JOBSEEKER".equalsIgnoreCase(filterRole) ? "selected" : "" %>>Job Seeker</option>
            <option value="EMPLOYER" <%= "EMPLOYER".equalsIgnoreCase(filterRole) ? "selected" : "" %>>Employer</option>
          </select>

          <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase px-5 py-2 rounded-xl transition-all">
            Filter
          </button>
          <a href="<%= pageUrl %>" class="bg-slate-100 hover:bg-slate-200 text-slate-600 text-xs font-bold px-4 py-2 rounded-xl transition-all">
            Reset
          </a>
        </div>

        <div class="text-xs font-mono font-bold text-slate-400">
          Showing <%= users.size() %> of <%= totalUsers %> Registered Users
        </div>
      </form>
    </div>

    <!-- TABLE SECTION -->
    <div class="table-section">
      <% if (users.isEmpty()) { %>
        <div class="py-16 text-center space-y-3">
          <div class="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-200 text-slate-400 flex items-center justify-center mx-auto text-2xl">
            <i class="fas fa-user-slash"></i>
          </div>
          <p class="font-sora font-bold text-slate-800 text-sm">No Users Found</p>
          <p class="text-xs text-slate-400">No registered user accounts matched your search parameters.</p>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="custom-table text-left">
            <thead>
              <tr>
                <th># ID</th>
                <th>User Profile</th>
                <th>Email Address</th>
                <th>Contact Phone</th>
                <th>Location</th>
                <th>Account Role</th>
                <th class="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (Map<String, String> u : users) {
                  String role = u.get("role") != null ? u.get("role").toUpperCase() : "JOBSEEKER";
                  String fName = u.get("firstname") != null ? u.get("firstname") : "";
                  String lName = u.get("lastname") != null ? u.get("lastname") : "";
                  String fullName = (fName + " " + lName).trim();
                  if (fullName.isEmpty()) fullName = "User Account";

                  String initial = String.valueOf(fullName.charAt(0)).toUpperCase();
                  String email = u.get("email");
                  String contact = u.get("contact");
                  String city = u.get("city");
                  String state = u.get("state");
                  String location = city + (!city.equals("—") && !state.equals("—") ? ", " + state : "");

                  String roleBadge = "bg-emerald-50 text-emerald-600 border-emerald-200";
                  if ("EMPLOYER".equalsIgnoreCase(role)) {
                      roleBadge = "bg-amber-50 text-amber-600 border-amber-200";
                  } else if ("ADMIN".equalsIgnoreCase(role)) {
                      roleBadge = "bg-rose-50 text-rose-600 border-rose-200";
                  }

                  // Safe HTML Entity Encoding for HTML Attributes
                  String cleanName = fullName.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanCity = city.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanState = state.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanEmail = email.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanContact = contact.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
              %>
              <tr>
                <td class="font-mono text-slate-400">#<%= u.get("userid") %></td>
                <td>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-200 text-indigo-600 font-sora font-bold text-xs flex items-center justify-center flex-shrink-0">
                      <%= initial %>
                    </div>
                    <div>
                      <p class="font-bold text-slate-800 text-xs"><%= fullName %></p>
                      <p class="text-[10px] text-slate-400 font-mono">ID: #<%= u.get("userid") %></p>
                    </div>
                  </div>
                </td>
                <td class="font-mono text-slate-500 text-xs"><%= email %></td>
                <td class="font-mono text-slate-500 text-xs">
                  <i class="fas fa-phone text-slate-400 text-[10px] mr-1"></i><%= contact %>
                </td>
                <td class="font-mono text-slate-500 text-xs">
                  <i class="fas fa-location-dot text-indigo-500 mr-1 text-[10px]"></i><%= location %>
                </td>
                <td>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border <%= roleBadge %>">
                    <%= role %>
                  </span>
                </td>
                <td class="text-right">
                  <div class="inline-flex items-center gap-1.5">
                    <!-- View Modal Button using Data Attributes -->
                    <button type="button"
                            data-name="<%= cleanName %>"
                            data-email="<%= cleanEmail %>"
                            data-mobile="<%= cleanContact %>"
                            data-role="<%= role %>"
                            data-city="<%= cleanCity %>"
                            data-state="<%= cleanState %>"
                            onclick="handleUserModalOpen(this)"
                            class="action-btn bg-indigo-50 hover:bg-indigo-600 text-indigo-500 hover:text-white border border-indigo-200"
                            title="View Profile Details">
                      <i class="fas fa-eye"></i>
                    </button>
                    <!-- Delete Button -->
                    <a href="<%= pageUrl %>?action=delete&id=<%= u.get("userid") %>"
                       class="action-btn bg-slate-50 hover:bg-rose-600 text-slate-400 hover:text-white border border-slate-200"
                       title="Permanently Delete User"
                       onclick="return confirm('Permanently delete account for <%= cleanName %>?')">
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

<!-- USER DETAILS MODAL POPUP -->
<div id="userModal" class="hidden fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
  <div class="bg-white border border-slate-200 rounded-3xl max-w-md w-full p-8 space-y-6 shadow-2xl relative text-left">
    <div class="flex items-center justify-between border-b border-slate-200 pb-4">
      <div>
        <h3 id="modalName" class="font-sora font-extrabold text-lg text-slate-900">User Profile</h3>
        <p id="modalRoleBadge" class="text-xs font-mono font-bold text-indigo-600 uppercase mt-0.5"></p>
      </div>
      <button onclick="closeUserModal()" class="w-8 h-8 rounded-full bg-slate-100 text-slate-500 hover:text-slate-800 flex items-center justify-center text-xs">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <div class="space-y-4 text-xs">
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Email Address</p>
        <p id="modalEmail" class="font-mono text-slate-800 font-semibold"></p>
      </div>
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Contact Number</p>
        <p id="modalMobile" class="font-mono text-slate-800 font-semibold"></p>
      </div>
      <div class="grid grid-cols-2 gap-4">
        <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
          <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">City</p>
          <p id="modalCity" class="text-slate-800 font-semibold"></p>
        </div>
        <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
          <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">State</p>
          <p id="modalState" class="text-slate-800 font-semibold"></p>
        </div>
      </div>
    </div>

    <div class="pt-2">
      <button onclick="closeUserModal()" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3 rounded-xl transition-all">
        Close Window
      </button>
    </div>
  </div>
</div>

<!-- MODAL SCRIPT -->
<script>
  function handleUserModalOpen(btn) {
    const name = btn.getAttribute('data-name');
    const email = btn.getAttribute('data-email');
    const mobile = btn.getAttribute('data-mobile');
    const role = btn.getAttribute('data-role');
    const city = btn.getAttribute('data-city');
    const state = btn.getAttribute('data-state');

    openUserModal(name, email, mobile, role, city, state);
  }

  function openUserModal(name, email, mobile, role, city, state) {
    document.getElementById('modalName').textContent = name;
    document.getElementById('modalRoleBadge').textContent = 'Role: ' + role;
    document.getElementById('modalEmail').textContent = email;
    document.getElementById('modalMobile').textContent = mobile || '—';
    document.getElementById('modalCity').textContent = city || '—';
    document.getElementById('modalState').textContent = state || '—';
    document.getElementById('userModal').classList.remove('hidden');
  }

  function closeUserModal() {
    document.getElementById('userModal').classList.add('hidden');
  }
</script>

</body>
</html>
