<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Simple admin login check
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if ("admin".equals(username) && "admin123".equals(password)) {
      session.setAttribute("adminRole", "admin");
      session.setAttribute("adminName", username);
      response.sendRedirect("admin-dashboard.jsp");
      return;
    } else {
      request.setAttribute("error", "invalid");
    }
  }

  // Logout check
  String logout = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm:   ['DM Sans', 'sans-serif'],
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; }
    .font-sora { font-family: 'Sora', sans-serif; }

    .auth-left {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 50%, #1a56db 100%);
      position: relative; overflow: hidden;
    }
    .auth-left::before {
      content: ''; position: absolute; inset: 0;
      background-image:
        radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.3) 0%, transparent 70%),
        radial-gradient(ellipse 40% 40% at 20% 70%, rgba(245,158,11,0.12) 0%, transparent 60%);
    }
    .auth-left::after {
      content: ''; position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
    }

    .form-input {
      width: 100%;
      border: 1.5px solid #e2e8f0;
      border-radius: 10px;
      padding: 11px 14px;
      font-size: 14px;
      font-family: 'DM Sans', sans-serif;
      color: #0f172a;
      background: #fff;
      transition: border-color 0.2s, box-shadow 0.2s;
      outline: none;
    }
    .form-input:focus {
      border-color: #1a56db;
      box-shadow: 0 0 0 3px rgba(26,86,219,0.08);
    }
    .form-input::placeholder { color: #94a3b8; }

    .pass-toggle {
      position: absolute; right: 12px; top: 50%;
      transform: translateY(-50%);
      cursor: pointer; color: #94a3b8;
      background: none; border: none;
    }
    .pass-toggle:hover { color: #1a56db; }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-up { animation: fadeUp 0.5s ease both; }
  </style>
</head>
<body class="bg-gray-50 antialiased min-h-screen">

<div class="min-h-screen flex flex-col lg:flex-row">

  <!-- ===== LEFT PANEL ===== -->
  <div class="auth-left lg:w-5/12 xl:w-4/12 flex flex-col justify-between p-8 md:p-12 min-h-[260px] lg:min-h-screen">

    <div class="relative z-10">
      <a href="index.jsp" class="font-sora font-bold text-2xl text-white tracking-tight">
        Job<span class="text-yellow-400">Board</span>
      </a>
    </div>

    <div class="relative z-10 py-10">
      <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-6">
        <span class="w-1.5 h-1.5 rounded-full bg-red-400 inline-block"></span>
        Admin Access Only
      </div>

      <h2 class="font-sora text-2xl md:text-3xl font-bold text-white leading-tight mb-4">
        Admin <span class="text-yellow-400">Control</span><br>Panel
      </h2>
      <p class="text-white/60 text-sm leading-relaxed mb-8">
        Manage company verifications, job listings and platform settings from one place.
      </p>

      <div class="space-y-3">
        <div class="flex items-center gap-3 bg-white/8 border border-white/10 rounded-xl p-3">
          <div class="w-8 h-8 rounded-lg bg-blue-600/40 flex items-center justify-center flex-shrink-0">
            <i class="fas fa-building text-yellow-400 text-xs"></i>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">Company Verification</p>
            <p class="text-white/50 text-xs">Approve or reject company requests</p>
          </div>
        </div>
        <div class="flex items-center gap-3 bg-white/8 border border-white/10 rounded-xl p-3">
          <div class="w-8 h-8 rounded-lg bg-blue-600/40 flex items-center justify-center flex-shrink-0">
            <i class="fas fa-users text-yellow-400 text-xs"></i>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">User Management</p>
            <p class="text-white/50 text-xs">Manage all job seekers and employers</p>
          </div>
        </div>
        <div class="flex items-center gap-3 bg-white/8 border border-white/10 rounded-xl p-3">
          <div class="w-8 h-8 rounded-lg bg-blue-600/40 flex items-center justify-center flex-shrink-0">
            <i class="fas fa-chart-bar text-yellow-400 text-xs"></i>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">Platform Analytics</p>
            <p class="text-white/50 text-xs">View stats and platform performance</p>
          </div>
        </div>
      </div>
    </div>

    <div class="relative z-10">
      <p class="text-white/30 text-xs">
        Not an admin?
        <a href="login.jsp" class="text-yellow-400 hover:text-yellow-300 font-semibold ml-1">Go to User Login</a>
      </p>
    </div>
  </div>

  <!-- ===== RIGHT PANEL ===== -->
  <div class="flex-1 flex items-center justify-center p-6 md:p-10 bg-gray-50">
    <div class="w-full max-w-md fade-up">

      <!-- Header -->
      <div class="mb-8">
        <div class="flex items-center gap-2 mb-3">
          <div class="w-8 h-8 rounded-lg bg-red-500 flex items-center justify-center">
            <i class="fas fa-shield-alt text-white text-sm"></i>
          </div>
          <span class="text-xs font-semibold text-red-500 uppercase tracking-widest">Restricted Access</span>
        </div>
        <h1 class="font-sora text-2xl md:text-3xl font-bold text-gray-900 mb-1">Admin Login</h1>
        <p class="text-sm text-gray-500">Enter your admin credentials to access the dashboard.</p>
      </div>

      <!-- Error Message -->
      <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3 mb-6">
          <i class="fas fa-exclamation-circle text-red-500 flex-shrink-0"></i>
          <p class="text-sm text-red-700 font-medium">Invalid username or password. Try again.</p>
        </div>
      <% } %>

      <!-- Logout Message -->
      <% if ("logout".equals(logout)) { %>
        <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center gap-3 mb-6">
          <i class="fas fa-check-circle text-green-500 flex-shrink-0"></i>
          <p class="text-sm text-green-700 font-medium">Logged out successfully.</p>
        </div>
      <% } %>

      <!-- FORM — same page pe post kare che -->
      <form action="admin-login.jsp" method="post" class="space-y-5">

        <!-- Username -->
        <div>
          <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
            Admin Username <span class="text-red-400">*</span>
          </label>
          <div class="relative">
            <i class="fas fa-user absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
            <input type="text" name="username" required
              class="form-input pl-10"
              placeholder="Enter admin username">
          </div>
        </div>

        <!-- Password -->
        <div>
          <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
            Password <span class="text-red-400">*</span>
          </label>
          <div class="relative">
            <i class="fas fa-lock absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
            <input type="password" name="password" id="passField" required
              class="form-input pl-10 pr-10"
              placeholder="Enter admin password">
            <button type="button" class="pass-toggle" onclick="togglePass()">
              <i class="fas fa-eye text-sm" id="eyeIcon"></i>
            </button>
          </div>
        </div>

        <!-- Hint -->
        <div class="bg-blue-50 border border-blue-100 rounded-xl p-3 flex items-center gap-2">
          <i class="fas fa-info-circle text-blue-400 text-sm flex-shrink-0"></i>
          <p class="text-xs text-blue-600">
            Username: <strong>admin</strong> &nbsp;|&nbsp; Password: <strong>admin123</strong>
          </p>
        </div>

        <!-- Submit -->
        <button type="submit"
          class="w-full bg-gray-900 hover:bg-gray-800 text-white font-sora font-semibold text-sm px-6 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md flex items-center justify-center gap-2">
          <i class="fas fa-shield-alt text-sm"></i>
          Login to Admin Panel
        </button>
      </form>

      <!-- Security Note -->
      <div class="mt-6 bg-amber-50 border border-amber-200 rounded-xl p-4 flex items-start gap-3">
        <i class="fas fa-exclamation-triangle text-amber-500 mt-0.5 flex-shrink-0 text-sm"></i>
        <p class="text-xs text-amber-700 leading-relaxed">
          This is a restricted area. Unauthorized access attempts are logged and monitored.
        </p>
      </div>

    </div>
  </div>

</div>

<script>
  function togglePass() {
    const f = document.getElementById('passField');
    const i = document.getElementById('eyeIcon');
    if (f.type === 'password') {
      f.type = 'text';
      i.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
      f.type = 'password';
      i.classList.replace('fa-eye-slash', 'fa-eye');
    }
  }
</script>
</body>
</html>
