<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.userdao, com.model.UserModel, java.util.*" %>
<%
  String adminRole = (String) session.getAttribute("adminRole");
  if (!"admin".equals(adminRole)) {
    response.sendRedirect("admin-login.jsp");
    return;
  }
  userdao dao = new userdao();
  List<UserModel> pending = dao.getPendingEmployers();
  int totalEmployers = dao.getTotalEmployers();
  int totalVerified  = dao.getTotalVerifiedEmployers();
  String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin — Pending Verifications</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; background: #060c18; color: #e2e8f0; min-height: 100vh; }
    .font-sora { font-family: 'Sora', sans-serif; }
    .sidebar { width: 240px; background: #0b1120; border-right: 1px solid rgba(255,255,255,0.07); min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; }
    .sidebar-logo { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.07); font-family: 'Sora', sans-serif; font-size: 20px; font-weight: 800; color: white; }
    .sidebar-logo span { color: #f59e0b; }
    .sidebar-nav { padding: 16px 12px; flex: 1; }
    .nav-item { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 10px; color: rgba(255,255,255,0.45); font-size: 13px; font-weight: 500; text-decoration: none; transition: all 0.2s; margin-bottom: 2px; }
    .nav-item:hover { color: white; background: rgba(255,255,255,0.06); }
    .nav-item.active { color: white; background: rgba(26,86,219,0.2); border: 1px solid rgba(26,86,219,0.3); }
    .nav-item i { width: 16px; text-align: center; font-size: 13px; }
    .nav-section { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: rgba(255,255,255,0.2); padding: 16px 12px 6px; }
    .sidebar-bottom { padding: 16px 12px; border-top: 1px solid rgba(255,255,255,0.07); }
    .admin-avatar { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 10px; background: rgba(255,255,255,0.04); }
    .avatar-circle { width: 32px; height: 32px; border-radius: 50%; background: linear-gradient(135deg,#1a56db,#6366f1); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 12px; color: white; flex-shrink: 0; }
    .main { margin-left: 240px; min-height: 100vh; display: flex; flex-direction: column; }
    .topbar { background: #0b1120; border-bottom: 1px solid rgba(255,255,255,0.07); padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; }
    .topbar-title { font-family: 'Sora', sans-serif; font-size: 18px; font-weight: 700; color: white; }
    .topbar-sub { font-size: 12px; color: rgba(255,255,255,0.4); margin-top: 2px; }
    .badge-pending { background: rgba(245,158,11,0.12); border: 1px solid rgba(245,158,11,0.3); color: #fbbf24; font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 999px; display: flex; align-items: center; gap: 6px; }
    .content { padding: 32px; flex: 1; }
    .stats-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 32px; }
    .stat-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 16px; padding: 20px 24px; position: relative; overflow: hidden; transition: all 0.2s; }
    .stat-card:hover { border-color: rgba(255,255,255,0.12); transform: translateY(-2px); }
    .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; }
    .stat-card.yellow::before { background: linear-gradient(90deg,#f59e0b,#fbbf24); }
    .stat-card.blue::before   { background: linear-gradient(90deg,#1a56db,#6366f1); }
    .stat-card.green::before  { background: linear-gradient(90deg,#10b981,#34d399); }
    .stat-icon { width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 16px; margin-bottom: 14px; }
    .stat-icon.yellow { background: rgba(245,158,11,0.12); color: #fbbf24; }
    .stat-icon.blue   { background: rgba(26,86,219,0.12);  color: #60a5fa; }
    .stat-icon.green  { background: rgba(16,185,129,0.12); color: #34d399; }
    .stat-num { font-family: 'Sora', sans-serif; font-size: 28px; font-weight: 800; color: white; line-height: 1; margin-bottom: 4px; }
    .stat-label { font-size: 12px; color: rgba(255,255,255,0.4); }
    .table-section { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; overflow: hidden; }
    .table-header { padding: 20px 24px; border-bottom: 1px solid rgba(255,255,255,0.07); display: flex; align-items: center; justify-content: space-between; }
    .table-header h2 { font-family: 'Sora', sans-serif; font-size: 15px; font-weight: 700; color: white; }
    .table-header p { font-size: 12px; color: rgba(255,255,255,0.4); margin-top: 2px; }
    .search-bar { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.08); border-radius: 8px; padding: 7px 14px; font-size: 13px; color: white; outline: none; width: 200px; transition: all 0.2s; }
    .search-bar::placeholder { color: rgba(255,255,255,0.3); }
    .search-bar:focus { border-color: rgba(26,86,219,0.5); }
    .employer-row { padding: 16px 24px; border-bottom: 1px solid rgba(255,255,255,0.06); display: flex; align-items: center; justify-content: space-between; gap: 16px; transition: background 0.15s; animation: slideIn 0.3s ease both; }
    .employer-row:last-child { border-bottom: none; }
    .employer-row:hover { background: rgba(255,255,255,0.02); }
    @keyframes slideIn { from { opacity: 0; transform: translateX(-10px); } to { opacity: 1; transform: translateX(0); } }
    .emp-avatar { width: 44px; height: 44px; border-radius: 12px; background: rgba(26,86,219,0.2); border: 1px solid rgba(26,86,219,0.3); display: flex; align-items: center; justify-content: center; font-family: 'Sora', sans-serif; font-weight: 800; font-size: 16px; color: #93c5fd; flex-shrink: 0; }
    .emp-name { font-size: 14px; font-weight: 600; color: white; margin-bottom: 3px; }
    .emp-meta { font-size: 12px; color: rgba(255,255,255,0.4); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
    .btn-approve { background: rgba(16,185,129,0.12); border: 1px solid rgba(16,185,129,0.3); color: #34d399; font-size: 12px; font-weight: 600; padding: 7px 16px; border-radius: 8px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 6px; }
    .btn-approve:hover { background: rgba(16,185,129,0.22); transform: translateY(-1px); }
    .btn-reject { background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.25); color: #fca5a5; font-size: 12px; font-weight: 600; padding: 7px 16px; border-radius: 8px; cursor: pointer; transition: all 0.2s; display: flex; align-items: center; gap: 6px; }
    .btn-reject:hover { background: rgba(239,68,68,0.2); transform: translateY(-1px); }
    .empty-state { padding: 80px 24px; text-align: center; }
    .empty-icon { width: 64px; height: 64px; border-radius: 20px; background: rgba(16,185,129,0.1); border: 1px solid rgba(16,185,129,0.2); display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 24px; color: #34d399; }
    .toast { position: fixed; top: 20px; right: 20px; padding: 14px 20px; border-radius: 12px; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 10px; z-index: 9999; animation: toastIn 0.3s ease; }
    .toast.success { background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.3); color: #34d399; }
    .toast.error   { background: rgba(239,68,68,0.15);  border: 1px solid rgba(239,68,68,0.3);  color: #fca5a5; }
    @keyframes toastIn { from { opacity: 0; transform: translateX(20px); } to { opacity: 1; transform: translateX(0); } }
    @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.3} }
  </style>
</head>
<body>

<!-- TOAST -->
<% if ("approved".equals(msg)) { %>
  <div class="toast success" id="toast"><i class="fas fa-check-circle"></i> Company approved & email sent!</div>
<% } else if ("rejected".equals(msg)) { %>
  <div class="toast error" id="toast"><i class="fas fa-times-circle"></i> Company rejected & email sent.</div>
<% } else if ("failed".equals(msg)) { %>
  <div class="toast error" id="toast"><i class="fas fa-exclamation-circle"></i> Action failed. Try again.</div>
<% } %>

<!-- SIDEBAR -->
<div class="sidebar">
  <div class="sidebar-logo">Job<span>Board</span></div>
  <div class="sidebar-nav">
    <div class="nav-section">Main</div>
    <a class="nav-item active"><i class="fas fa-shield-alt"></i> Verifications</a>
    <a href="#" class="nav-item"><i class="fas fa-users"></i> All Employers</a>
    <a href="#" class="nav-item"><i class="fas fa-briefcase"></i> Job Posts</a>
    <div class="nav-section">Settings</div>
    <a href="#" class="nav-item"><i class="fas fa-cog"></i> Settings</a>
    <a href="admin-login.jsp" class="nav-item" style="color:#fca5a5;"><i class="fas fa-sign-out-alt"></i> Logout</a>
  </div>
  <div class="sidebar-bottom">
    <div class="admin-avatar">
      <div class="avatar-circle">A</div>
      <div>
        <div style="font-size:13px;font-weight:600;color:white;">Admin</div>
        <div style="font-size:11px;color:rgba(255,255,255,0.4);">Super Admin</div>
      </div>
    </div>
  </div>
</div>

<!-- MAIN -->
<div class="main">
  <div class="topbar">
    <div>
      <div class="topbar-title">Verification Requests</div>
      <div class="topbar-sub">Review and approve pending company registrations</div>
    </div>
    <div class="badge-pending">
      <span style="width:6px;height:6px;border-radius:50%;background:#fbbf24;animation:blink 1.5s infinite;display:inline-block;"></span>
      <%= pending.size() %> Pending
    </div>
  </div>

  <div class="content">

    <!-- STATS — ✅ Real numbers -->
    <div class="stats-grid">
      <div class="stat-card yellow">
        <div class="stat-icon yellow"><i class="fas fa-clock"></i></div>
        <div class="stat-num"><%= pending.size() %></div>
        <div class="stat-label">Pending Verifications</div>
      </div>
      <div class="stat-card blue">
        <div class="stat-icon blue"><i class="fas fa-building"></i></div>
        <div class="stat-num"><%= totalEmployers %></div>  <!-- ✅ -->
        <div class="stat-label">Total Employers</div>
      </div>
      <div class="stat-card green">
        <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
        <div class="stat-num"><%= totalVerified %></div>  <!-- ✅ -->
        <div class="stat-label">Verified Companies</div>
      </div>
    </div>

    <!-- TABLE -->
    <div class="table-section">
      <div class="table-header">
        <div>
          <h2>Pending Companies</h2>
          <p>Companies awaiting admin verification</p>
        </div>
        <input type="text" class="search-bar" placeholder="Search company..." id="searchInput" onkeyup="filterRows()">
      </div>

      <% if (pending.isEmpty()) { %>
        <div class="empty-state">
          <div class="empty-icon"><i class="fas fa-check-double"></i></div>
          <p class="font-sora" style="font-size:16px;font-weight:700;color:white;margin-bottom:6px;">All Caught Up!</p>
          <p style="font-size:13px;color:rgba(255,255,255,0.4);">No pending verification requests.</p>
        </div>
      <% } else { %>
        <div id="employerList">
          <% for (UserModel u : pending) {
               String initial = u.getFirstname() != null && !u.getFirstname().isEmpty()
                   ? String.valueOf(u.getFirstname().charAt(0)).toUpperCase() : "?";
          %>
          <div class="employer-row" data-name="<%= u.getFirstname().toLowerCase() %>">
            <div style="display:flex;align-items:center;gap:14px;">
              <div class="emp-avatar"><%= initial %></div>
              <div>
                <div class="emp-name"><%= u.getFirstname() %> <%= u.getLastname() != null ? u.getLastname() : "" %></div>
                <div class="emp-meta">
                  <span><i class="fas fa-envelope" style="font-size:10px;"></i> <%= u.getEmail() %></span>
                  <% if (u.getCity() != null && !u.getCity().isEmpty()) { %>
                    <span><i class="fas fa-map-marker-alt" style="font-size:10px;"></i> <%= u.getCity() %></span>
                  <% } %>
                  <% if (u.getContact() != null && !u.getContact().isEmpty()) { %>
                    <span><i class="fas fa-phone" style="font-size:10px;"></i> <%= u.getContact() %></span>
                  <% } %>
                </div>
              </div>
            </div>
            <div style="display:flex;align-items:center;gap:8px;flex-shrink:0;">
              <span style="background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.25);color:#fbbf24;font-size:11px;font-weight:600;padding:4px 10px;border-radius:999px;">Pending</span>
              <form action="${pageContext.request.contextPath}/AdminVerifyController" method="post" style="display:inline;">
                <input type="hidden" name="userid" value="<%= u.getUserid() %>">
                <input type="hidden" name="action" value="approve">
                <button type="submit" class="btn-approve" onclick="return confirm('Approve <%= u.getFirstname() %>?')">
                  <i class="fas fa-check" style="font-size:10px;"></i> Approve
                </button>
              </form>
              <form action="${pageContext.request.contextPath}/AdminVerifyController" method="post" style="display:inline;">
                <input type="hidden" name="userid" value="<%= u.getUserid() %>">
                <input type="hidden" name="action" value="reject">
                <button type="submit" class="btn-reject" onclick="return confirm('Reject <%= u.getFirstname() %>?')">
                  <i class="fas fa-times" style="font-size:10px;"></i> Reject
                </button>
              </form>
            </div>
          </div>
          <% } %>
        </div>
      <% } %>
    </div>
  </div>
</div>

<script>
  const toast = document.getElementById('toast');
  if (toast) setTimeout(() => { toast.style.opacity='0'; toast.style.transition='opacity 0.5s'; }, 3000);

  function filterRows() {
    const q = document.getElementById('searchInput').value.toLowerCase();
    document.querySelectorAll('.employer-row').forEach(row => {
      row.style.display = row.getAttribute('data-name').includes(q) ? '' : 'none';
    });
  }
</script>
</body>
</html>