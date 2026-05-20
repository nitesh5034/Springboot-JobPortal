<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.userdao" %>
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
  <title>User Profile | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; background: #f8fafc; }
    .font-sora { font-family: 'Sora', sans-serif; }

    /* ===== HERO HEADER ===== */
    .profile-hero {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 50%, #1a56db 100%);
      position: relative; overflow: hidden;
      padding: 48px 0 80px;
    }
    .profile-hero::before {
      content: ''; position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
    }
    .profile-hero::after {
      content: ''; position: absolute; inset: 0;
      background-image: radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.3) 0%, transparent 70%);
    }

    /* ===== AVATAR ===== */
    .avatar-ring {
      width: 88px; height: 88px;
      border-radius: 50%;
      background: linear-gradient(135deg, #1a56db, #6366f1);
      display: flex; align-items: center; justify-content: center;
      font-family: 'Sora', sans-serif; font-weight: 800;
      font-size: 32px; color: white;
      border: 4px solid rgba(255,255,255,0.2);
      box-shadow: 0 8px 32px rgba(26,86,219,0.4);
      margin: 0 auto 16px;
      position: relative; z-index: 1;
    }

    /* ===== CARDS ===== */
    .profile-card {
      background: white;
      border-radius: 20px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 2px 16px rgba(0,0,0,0.06);
      overflow: hidden;
      transition: box-shadow 0.2s;
    }
    .profile-card:hover { box-shadow: 0 4px 24px rgba(0,0,0,0.10); }
    .card-header-strip {
      height: 4px;
      background: linear-gradient(90deg, #1a56db, #6366f1);
    }

    /* ===== STAT ITEMS ===== */
    .stat-item {
      display: flex; align-items: center; justify-content: space-between;
      padding: 12px 14px;
      border-radius: 14px;
      margin-bottom: 10px;
      border: 1px solid;
      transition: transform 0.15s;
    }
    .stat-item:hover { transform: translateX(4px); }
    .stat-item.blue   { background: #eff6ff; border-color: #bfdbfe; }
    .stat-item.green  { background: #f0fdf4; border-color: #bbf7d0; }
    .stat-item.red    { background: #fef2f2; border-color: #fecaca; }
    .stat-item.amber  { background: #fffbeb; border-color: #fde68a; }

    .stat-icon {
      width: 36px; height: 36px; border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      font-size: 13px; flex-shrink: 0;
    }
    .stat-icon.blue  { background: #dbeafe; color: #2563eb; }
    .stat-icon.green { background: #dcfce7; color: #16a34a; }
    .stat-icon.red   { background: #fee2e2; color: #dc2626; }
    .stat-icon.amber { background: #fef3c7; color: #d97706; }

    /* ===== INFO FIELDS ===== */
    .info-field {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 14px 16px;
      transition: border-color 0.2s;
    }
    .info-field:hover { border-color: #bfdbfe; }
    .info-label {
      font-size: 10px; font-weight: 700;
      text-transform: uppercase; letter-spacing: 0.8px;
      color: #94a3b8; margin-bottom: 4px;
    }
    .info-value { font-size: 14px; font-weight: 600; color: #0f172a; }

    /* ===== BUTTONS ===== */
    .btn-primary {
      background: linear-gradient(135deg, #1a56db, #2563eb);
      color: white; border: none;
      padding: 10px 20px; border-radius: 12px;
      font-size: 13px; font-weight: 600;
      cursor: pointer; text-decoration: none;
      display: flex; align-items: center; gap: 8px;
      transition: all 0.2s; width: 100%; justify-content: center;
      box-shadow: 0 4px 12px rgba(26,86,219,0.25);
    }
    .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(26,86,219,0.35); }

    .btn-secondary {
      background: white; color: #374151;
      border: 1.5px solid #e2e8f0;
      padding: 10px 20px; border-radius: 12px;
      font-size: 13px; font-weight: 600;
      cursor: pointer; text-decoration: none;
      display: flex; align-items: center; gap: 8px;
      transition: all 0.2s; width: 100%; justify-content: center;
    }
    .btn-secondary:hover { border-color: #1a56db; color: #1a56db; background: #eff6ff; }

    /* ===== SECTION TITLE ===== */
    .section-title {
      font-family: 'Sora', sans-serif; font-size: 13px; font-weight: 700;
      color: #1e293b; margin-bottom: 16px;
      display: flex; align-items: center; gap-8px;
      padding-bottom: 12px;
      border-bottom: 1px solid #f1f5f9;
    }
    .section-title i { color: #1a56db; font-size: 12px; margin-right: 8px; }

    /* ===== PROGRESS BAR ===== */
    .progress-track {
      height: 8px; background: #f1f5f9;
      border-radius: 999px; overflow: hidden;
      display: flex; margin-top: 12px;
    }
    .progress-fill { height: 100%; transition: width 0.8s ease; }

    /* ===== BADGE ===== */
    .role-badge {
      display: inline-block;
      background: rgba(255,255,255,0.15);
      border: 1px solid rgba(255,255,255,0.25);
      color: white; font-size: 11px; font-weight: 600;
      padding: 4px 12px; border-radius: 999px;
      margin-top: 8px; letter-spacing: 0.5px;
    }

    /* ===== ANIMATE ===== */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-up { animation: fadeUp 0.4s ease both; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }
    .delay-3 { animation-delay: 0.3s; }
  </style>
</head>
<body>

<%
    com.model.UserModel u = (com.model.UserModel) session.getAttribute("Model");
    if (u == null) { response.sendRedirect("login.jsp"); return; }

    userdao dao = new userdao();
    int[] stats   = dao.getUserApplicationStats(u.getUserid());
    int totalApplied = stats[0];
    int selected     = stats[1];
    int rejected     = stats[2];
    int pending      = totalApplied - selected - rejected;
    if (pending < 0) pending = 0;

    int selPct = totalApplied > 0 ? (selected * 100) / totalApplied : 0;
    int rejPct = totalApplied > 0 ? (rejected * 100) / totalApplied : 0;
    int penPct = totalApplied > 0 ? (pending  * 100) / totalApplied : 0;
%>

<!-- ===== HERO HEADER ===== -->
<div class="profile-hero">
  <div class="max-w-5xl mx-auto px-5 relative z-10 text-center">
    <a href="user-home.jsp" class="inline-flex items-center gap-2 text-white/50 hover:text-white text-xs mb-6 transition-all absolute left-5 top-0">
      <i class="fas fa-arrow-left"></i> Back
    </a>
    <div class="avatar-ring">
      <%= u.getFirstname() != null ? u.getFirstname().substring(0,1).toUpperCase() : "U" %>
    </div>
    <h1 class="font-sora text-2xl font-bold text-white">
      <%= u.getFirstname() != null ? u.getFirstname() : "" %>
      <%= u.getLastname()  != null ? u.getLastname()  : "" %>
    </h1>
    <div class="role-badge"><%= u.getRole() != null ? u.getRole() : "User" %></div>
    <p class="text-white/50 text-sm mt-2"><%= u.getEmail() != null ? u.getEmail() : "" %></p>
  </div>
</div>

<!-- ===== CONTENT ===== -->
<div class="max-w-5xl mx-auto px-5 -mt-10 pb-16">
  <div class="grid md:grid-cols-3 gap-5">

    <!-- ===== LEFT ===== -->
    <div class="space-y-5">

      <!-- Quick Actions -->
      <div class="profile-card fade-up">
        <div class="card-header-strip"></div>
        <div class="p-5 space-y-3">
          <a href="edit-profile.jsp" class="btn-primary">
            <i class="fas fa-edit text-xs"></i> Edit Profile
          </a>
          <a href="Application-track.jsp" class="btn-secondary">
            <i class="fas fa-chart-line text-xs"></i> Track Applications
          </a>
        </div>
      </div>

      <!-- Application Stats -->
      <div class="profile-card fade-up delay-1">
        <div class="card-header-strip"></div>
        <div class="p-5">
          <div class="section-title">
            <i class="fas fa-chart-bar"></i> Application Summary
          </div>

          <div class="stat-item blue">
            <div class="flex items-center gap-3">
              <div class="stat-icon blue"><i class="fas fa-paper-plane"></i></div>
              <span style="font-size:13px;font-weight:500;color:#374151;">Total Applied</span>
            </div>
            <span class="font-sora" style="font-size:20px;font-weight:800;color:#2563eb;"><%= totalApps %></span>
          </div>

          <div class="stat-item green">
            <div class="flex items-center gap-3">
              <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
              <span style="font-size:13px;font-weight:500;color:#374151;">Selected</span>
            </div>
            <span class="font-sora" style="font-size:20px;font-weight:800;color:#16a34a;"><%= approvedCount %></span>
          </div>

          <div class="stat-item red">
            <div class="flex items-center gap-3">
              <div class="stat-icon red"><i class="fas fa-times-circle"></i></div>
              <span style="font-size:13px;font-weight:500;color:#374151;">Rejected</span>
            </div>
            <span class="font-sora" style="font-size:20px;font-weight:800;color:#dc2626;"><%= rejectedCount %></span>
          </div>

          <div class="stat-item amber" style="margin-bottom:0;">
            <div class="flex items-center gap-3">
              <div class="stat-icon amber"><i class="fas fa-clock"></i></div>
              <span style="font-size:13px;font-weight:500;color:#374151;">Pending</span>
            </div>
            <span class="font-sora" style="font-size:20px;font-weight:800;color:#d97706;"><%= pendingCount %></span>
          </div>

          <% if (totalApplied > 0) { %>
          <div style="margin-top:16px;">
            <div style="display:flex;justify-content:space-between;margin-bottom:6px;">
              <span style="font-size:11px;color:#94a3b8;font-weight:600;">Success Rate</span>
              <span style="font-size:11px;color:#16a34a;font-weight:700;"><%= selPct %>%</span>
            </div>
            <div class="progress-track">
              <div class="progress-fill" style="width:<%= selPct %>%;background:#22c55e;"></div>
              <div class="progress-fill" style="width:<%= rejPct %>%;background:#f87171;"></div>
              <div class="progress-fill" style="width:<%= penPct %>%;background:#fbbf24;"></div>
            </div>
            <div style="display:flex;gap:12px;margin-top:8px;">
              <span style="font-size:11px;color:#16a34a;display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#22c55e;display:inline-block;"></span> Selected</span>
              <span style="font-size:11px;color:#dc2626;display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#f87171;display:inline-block;"></span> Rejected</span>
              <span style="font-size:11px;color:#d97706;display:flex;align-items:center;gap:4px;"><span style="width:8px;height:8px;border-radius:50%;background:#fbbf24;display:inline-block;"></span> Pending</span>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- ===== RIGHT — Details ===== -->
    <div class="md:col-span-2 space-y-5">

      <!-- Personal Info -->
      <div class="profile-card fade-up delay-2">
        <div class="card-header-strip"></div>
        <div class="p-6">
          <div class="section-title">
            <i class="fas fa-user"></i> Personal Information
          </div>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div class="info-field">
              <div class="info-label">First Name</div>
              <div class="info-value"><%= u.getFirstname() != null ? u.getFirstname() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">Last Name</div>
              <div class="info-value"><%= u.getLastname() != null ? u.getLastname() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">Email</div>
              <div class="info-value" style="font-size:13px;"><%= u.getEmail() != null ? u.getEmail() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">Contact</div>
              <div class="info-value"><%= u.getContact() != null ? u.getContact() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">Role</div>
              <div class="info-value">
                <span style="background:#eff6ff;color:#1d4ed8;padding:3px 10px;border-radius:999px;font-size:12px;">
                  <%= u.getRole() != null ? u.getRole() : "—" %>
                </span>
              </div>
            </div>
            <div class="info-field">
              <div class="info-label">User ID</div>
              <div class="info-value" style="color:#6366f1;">#<%= u.getUserid() %></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Address Info -->
      <div class="profile-card fade-up delay-3">
        <div class="card-header-strip"></div>
        <div class="p-6">
          <div class="section-title">
            <i class="fas fa-map-marker-alt"></i> Address Information
          </div>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div class="info-field" style="grid-column:1/-1;">
              <div class="info-label">Address</div>
              <div class="info-value"><%= u.getAddress() != null ? u.getAddress() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">City</div>
              <div class="info-value"><%= u.getCity() != null ? u.getCity() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">State</div>
              <div class="info-value"><%= u.getState() != null ? u.getState() : "—" %></div>
            </div>
            <div class="info-field">
              <div class="info-label">Pincode</div>
              <div class="info-value"><%= u.getPincode() != 0 ? u.getPincode() : "—" %></div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

</body>
</html>