<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String status = request.getParameter("status");
    String msg = request.getParameter("msg");

    boolean isRejected = "rejected".equalsIgnoreCase(status) || "rejected".equalsIgnoreCase(msg);
    boolean isSuccess  = "success".equalsIgnoreCase(msg) || "registered".equalsIgnoreCase(msg);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title><%= isRejected ? "Verification Rejected" : "Verification Pending" %> | JobBoard</title>
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
    body {
      font-family: 'Plus Jakarta Sans', sans-serif;
      background-color: #030712;
      color: #0f172a;
      overflow-x: hidden;
    }
    .font-sora { font-family: 'Sora', sans-serif; }
    .font-mono { font-family: 'JetBrains Mono', monospace; }

    /* ===== HERO MESH GRADIENT ===== */
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
    }

    .glass-card {
      background: #ffffff;
      border-radius: 28px;
      border: 1px solid rgba(255, 255, 255, 0.8);
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35);
    }

    .text-glow-gradient {
      background: linear-gradient(135deg, #a855f7 0%, #6366f1 50%, #38bdf8 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    @keyframes pulseRing {
      0%   { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.4); }
      70%  { transform: scale(1);    box-shadow: 0 0 0 16px rgba(99, 102, 241, 0); }
      100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(99, 102, 241, 0); }
    }
    .pulse-ring { animation: pulseRing 2.5s infinite; }
  </style>
</head>
<body class="hero-glow-mesh min-h-screen flex flex-col justify-between p-6">

  <!-- Top Logo Header -->
  <header class="max-w-6xl mx-auto w-full flex items-center justify-between py-4 relative z-10">
    <a href="index.jsp" class="font-sora font-extrabold text-2xl text-white tracking-tight flex items-center gap-2.5">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 via-indigo-600 to-sky-400 p-[1px] flex items-center justify-center shadow-lg shadow-indigo-500/30">
        <div class="w-full h-full bg-[#030712] rounded-[11px] flex items-center justify-center">
          <i class="fas fa-building text-xs text-indigo-400"></i>
        </div>
      </div>
      Job<span class="text-glow-gradient">Board</span>
    </a>
    <a href="login.jsp" class="inline-flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-all backdrop-blur-md">
      <i class="fas fa-arrow-left text-[11px] text-indigo-400"></i> Back to Sign In
    </a>
  </header>

  <!-- Main Card Container -->
  <main class="max-w-md w-full mx-auto my-auto relative z-10 py-6">
    <div class="glass-card p-8 sm:p-10 text-center relative overflow-hidden">
      <div class="h-1.5 w-full bg-gradient-to-r <%= isRejected ? "from-rose-500 to-amber-500" : "from-amber-400 via-indigo-600 to-emerald-400" %> absolute top-0 left-0"></div>

      <% if (isRejected) { %>
        <!-- REJECTED STATE -->
        <div class="w-20 h-20 rounded-3xl bg-rose-50 border border-rose-100 text-rose-600 flex items-center justify-center mx-auto mb-6 text-3xl shadow-lg">
          <i class="fas fa-circle-xmark"></i>
        </div>

        <div class="inline-flex items-center gap-2 bg-rose-50 border border-rose-200 rounded-full px-3.5 py-1 text-[11px] font-bold text-rose-700 uppercase tracking-wider mb-3">
          <span class="w-2 h-2 rounded-full bg-rose-500 inline-block"></span>
          Verification Declined
        </div>

        <h1 class="font-sora text-2xl font-extrabold text-slate-900 mb-2">Request Rejected</h1>
        <p class="text-slate-500 text-xs sm:text-sm leading-relaxed mb-6">
          Your company profile could not be verified due to incomplete or unverifiable business details. Please reach out to support for re-evaluation.
        </p>

        <div class="flex flex-col gap-3">
          <a href="contact.jsp" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3.5 px-6 rounded-xl transition-all shadow-md shadow-indigo-500/20 flex items-center justify-center gap-2">
            <i class="fas fa-headset text-xs"></i> Contact Support Desk
          </a>
          <a href="login.jsp" class="w-full bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-700 font-sora font-bold text-xs uppercase tracking-wider py-3 px-6 rounded-xl transition-all flex items-center justify-center gap-2">
            Back to Sign In
          </a>
        </div>

      <% } else if (isSuccess) { %>
        <!-- SUCCESS SUBMISSION STATE -->
        <div class="w-20 h-20 rounded-3xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-6 text-3xl shadow-lg pulse-ring">
          <i class="fas fa-paper-plane"></i>
        </div>

        <div class="inline-flex items-center gap-2 bg-indigo-50 border border-indigo-200 rounded-full px-3.5 py-1 text-[11px] font-bold text-indigo-700 uppercase tracking-wider mb-3">
          <span class="w-2 h-2 rounded-full bg-indigo-500 inline-block animate-ping"></span>
          Request Submitted
        </div>

        <h1 class="font-sora text-2xl font-extrabold text-slate-900 mb-2">Review In Progress</h1>
        <p class="text-slate-500 text-xs sm:text-sm leading-relaxed mb-6">
          Your employer registration details have been submitted to our administration team. Approvals are typically processed within <strong>24 business hours</strong>.
        </p>

        <!-- Progress Steps -->
        <div class="bg-slate-50 rounded-2xl border border-slate-100 p-4 text-left space-y-3.5 mb-6">
          <div class="flex items-center gap-3">
            <div class="w-6 h-6 rounded-lg bg-emerald-500 text-white text-xs font-bold flex items-center justify-center flex-shrink-0">✓</div>
            <div>
              <p class="text-xs font-bold text-slate-800">Registration Received</p>
              <p class="text-[10px] text-slate-400 font-mono">Company info captured</p>
            </div>
          </div>

          <div class="flex items-center gap-3">
            <div class="w-6 h-6 rounded-lg bg-amber-500 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 animate-spin" style="animation-duration: 4s;">
              <i class="fas fa-circle-notch text-[10px]"></i>
            </div>
            <div>
              <p class="text-xs font-bold text-slate-800">Admin Audit</p>
              <p class="text-[10px] text-slate-400 font-mono">Verification underway</p>
            </div>
          </div>

          <div class="flex items-center gap-3 opacity-50">
            <div class="w-6 h-6 rounded-lg bg-slate-300 text-slate-600 text-xs font-bold flex items-center justify-center flex-shrink-0">3</div>
            <div>
              <p class="text-xs font-bold text-slate-700">Account Activated</p>
              <p class="text-[10px] text-slate-400 font-mono">Full employer access</p>
            </div>
          </div>
        </div>

        <div class="flex gap-3">
          <a href="login.jsp" class="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3 px-4 rounded-xl transition-all shadow-md shadow-indigo-500/20 flex items-center justify-center gap-2">
            <i class="fas fa-arrow-right-to-bracket text-xs"></i> Try Sign In
          </a>
          <a href="index.jsp" class="flex-1 bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-700 font-sora font-bold text-xs uppercase tracking-wider py-3 px-4 rounded-xl transition-all flex items-center justify-center gap-2">
            Home Page
          </a>
        </div>

      <% } else { %>
        <!-- DEFAULT PENDING REVIEW STATE -->
        <div class="w-20 h-20 rounded-3xl bg-amber-50 border border-amber-100 text-amber-500 flex items-center justify-center mx-auto mb-6 text-3xl shadow-lg pulse-ring">
          <i class="fas fa-clock"></i>
        </div>

        <div class="inline-flex items-center gap-2 bg-amber-50 border border-amber-200 rounded-full px-3.5 py-1 text-[11px] font-bold text-amber-700 uppercase tracking-wider mb-3">
          <span class="w-2 h-2 rounded-full bg-amber-400 inline-block animate-pulse"></span>
          Pending Authorization
        </div>

        <h1 class="font-sora text-2xl font-extrabold text-slate-900 mb-2">Verification Pending</h1>
        <p class="text-slate-500 text-xs sm:text-sm leading-relaxed mb-6">
          Your employer account is currently under verification by our security team. You will be able to post jobs once the review is complete.
        </p>

        <!-- Timeline Steps -->
        <div class="bg-slate-50 rounded-2xl border border-slate-100 p-4 text-left space-y-3.5 mb-6">
          <div class="flex items-center gap-3">
            <div class="w-6 h-6 rounded-lg bg-emerald-500 text-white text-xs font-bold flex items-center justify-center flex-shrink-0">✓</div>
            <div>
              <p class="text-xs font-bold text-slate-800">Profile Data Logged</p>
              <p class="text-[10px] text-slate-400 font-mono">Employer entity registered</p>
            </div>
          </div>

          <div class="flex items-center gap-3">
            <div class="w-6 h-6 rounded-lg bg-amber-500 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 animate-spin" style="animation-duration: 4s;">
              <i class="fas fa-circle-notch text-[10px]"></i>
            </div>
            <div>
              <p class="text-xs font-bold text-slate-800">Identity & Domain Check</p>
              <p class="text-[10px] text-slate-400 font-mono">Usually takes under 24 hrs</p>
            </div>
          </div>

          <div class="flex items-center gap-3 opacity-50">
            <div class="w-6 h-6 rounded-lg bg-slate-300 text-slate-600 text-xs font-bold flex items-center justify-center flex-shrink-0">3</div>
            <div>
              <p class="text-xs font-bold text-slate-700">Approval Notification</p>
              <p class="text-[10px] text-slate-400 font-mono">Email confirmation dispatched</p>
            </div>
          </div>
        </div>

        <div class="flex gap-3">
          <a href="login.jsp" class="flex-1 bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3 px-4 rounded-xl transition-all shadow-md shadow-indigo-500/20 flex items-center justify-center gap-2">
            <i class="fas fa-arrow-right-to-bracket text-xs"></i> Sign In
          </a>
          <a href="index.jsp" class="flex-1 bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-700 font-sora font-bold text-xs uppercase tracking-wider py-3 px-4 rounded-xl transition-all flex items-center justify-center gap-2">
            Home
          </a>
        </div>
      <% } %>

    </div>
  </main>

  <!-- Footer -->
  <footer class="text-center py-4 text-xs font-mono text-slate-500 relative z-10">
    &copy; 2026 JobBoard Enterprise Verification Network. All rights reserved.
  </footer>

</body>
</html>