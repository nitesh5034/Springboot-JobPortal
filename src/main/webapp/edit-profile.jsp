<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%
    // Session Check & Single Top-Level Variable Declaration
    UserModel m = (UserModel) session.getAttribute("Model");
    if (m == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = request.getParameter("msg");

    String firstName = (m.getFirstname() != null) ? m.getFirstname().trim() : "";
    String lastName  = (m.getLastname() != null) ? m.getLastname().trim() : "";
    String userEmail = (m.getEmail() != null) ? m.getEmail().trim() : "";
    String initial   = !firstName.isEmpty() ? String.valueOf(firstName.charAt(0)).toUpperCase() : "U";
    String fullName  = (firstName + " " + lastName).trim();
    if (fullName.isEmpty()) fullName = "Candidate Profile";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Profile | JobBoard</title>
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
    body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #f8fafc; color: #0f172a; overflow-x: hidden; }
    .font-sora { font-family: 'Sora', sans-serif; }
    .font-mono { font-family: 'JetBrains Mono', monospace; }

    /* ===== HERO MESH BACKGROUND ===== */
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
      z-index: 1;
    }

    #particleCanvas {
      position: absolute; top: 0; left: 0; width: 100%; height: 100%;
      z-index: 2; pointer-events: none;
    }

    .text-glow-gradient {
      background: linear-gradient(135deg, #a855f7 0%, #6366f1 50%, #38bdf8 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    /* ===== FORM INPUT STYLES ===== */
    .field-wrapper {
      position: relative;
    }
    .input-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      color: #94a3b8;
      font-size: 13px;
      transition: color 0.2s ease;
      pointer-events: none;
    }
    .custom-input {
      width: 100%;
      background-color: #ffffff;
      border: 1.5px solid #e2e8f0;
      border-radius: 14px;
      padding: 12px 16px 12px 42px;
      font-size: 13px;
      color: #0f172a;
      font-weight: 500;
      outline: none;
      transition: all 0.2s ease;
    }
    .custom-input:focus {
      border-color: #6366f1;
      box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12);
    }
    .custom-input:focus + .input-icon,
    .field-wrapper:focus-within .input-icon {
      color: #6366f1;
    }

    .custom-input-readonly {
      background-color: #f1f5f9;
      border-color: #e2e8f0;
      color: #64748b;
      cursor: not-allowed;
    }

    /* ===== CARD SHADOWS & ANIMATIONS ===== */
    .glass-card {
      background: #ffffff;
      border-radius: 24px;
      border: 1.5px solid #e2e8f0;
      box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
    }

    /* Dropdown */
    .dropdown-custom {
      display: none; position: absolute; top: calc(100% + 12px); right: 0;
      background: #0f172a; border: 1px solid rgba(255, 255, 255, 0.12);
      border-radius: 20px; padding: 10px; min-width: 230px;
      box-shadow: 0 25px 50px rgba(0,0,0,0.6); z-index: 1000;
    }
    .dropdown-custom.show { display: block; animation: floatUp 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
    @keyframes floatUp { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-up {
      animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
  </style>
</head>
<body class="antialiased">

<!-- ===== HERO NAVBAR (STANDARD USER HEADER) ===== -->
<nav class="fixed top-0 inset-x-0 z-50 bg-[#030712]/80 backdrop-blur-xl border-b border-white/10">
  <div class="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">

    <!-- Brand Logo -->
    <a href="user-home.jsp" class="font-sora font-extrabold text-2xl text-white tracking-tight flex items-center gap-2.5">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-purple-600 via-indigo-600 to-sky-400 p-[1px] flex items-center justify-center shadow-lg shadow-indigo-500/30">
        <div class="w-full h-full bg-[#030712] rounded-[11px] flex items-center justify-center">
          <i class="fas fa-briefcase text-xs text-indigo-400"></i>
        </div>
      </div>
      Job<span class="text-glow-gradient">Board</span>
    </a>

    <!-- Navigation Links -->
    <div class="hidden lg:flex items-center gap-2">
      <a href="user-home.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        <i class="fas fa-compass mr-1.5 text-indigo-400"></i> Explore Jobs
      </a>
      <a href="Application-track.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Applications Tracker
      </a>
      <a href="Saved-jobs.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Saved Jobs
      </a>
      <a href="review.jsp" class="text-slate-300 hover:text-white hover:bg-white/5 px-4 py-2 rounded-xl text-xs font-semibold tracking-wide transition-all">
        Reviews
      </a>
    </div>

    <!-- Right Profile Controls -->
    <div class="flex items-center gap-4">
      <a href="ViewProfile.jsp" class="hidden sm:inline-flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-all backdrop-blur-md">
        <i class="fas fa-user-circle text-[11px] text-indigo-400"></i> View Profile
      </a>

      <!-- User Menu -->
      <div class="relative">
        <button id="avatarBtn" class="flex items-center gap-3 bg-slate-900/80 hover:bg-slate-800 border border-white/10 rounded-full pl-1.5 pr-4 py-1.5 transition-all shadow-lg">
          <div class="w-8 h-8 rounded-full bg-gradient-to-tr from-purple-500 to-indigo-500 text-white font-sora font-extrabold text-xs flex items-center justify-center shadow-md">
            <%= initial %>
          </div>
          <span class="text-white text-xs font-semibold hidden sm:inline-block max-w-[130px] truncate"><%= firstName %></span>
          <i class="fas fa-chevron-down text-slate-400 text-[10px]"></i>
        </button>

        <div id="avatarMenu" class="dropdown-custom">
          <div class="px-4 py-3 border-b border-white/10 mb-1">
            <p class="text-white font-sora font-bold text-xs truncate"><%= fullName %></p>
            <p class="text-slate-400 font-mono text-[10px] truncate"><%= userEmail %></p>
          </div>
          <a href="ViewProfile.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-user-circle w-4 text-indigo-400"></i> View Profile
          </a>
          <a href="edit-profile.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-white bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-sliders w-4 text-indigo-400"></i> Edit Profile & Settings
          </a>
          <a href="Application-track.jsp" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-slate-300 hover:text-white hover:bg-indigo-600/20 text-xs font-medium transition-all">
            <i class="fas fa-paper-plane w-4 text-indigo-400"></i> Track Applications
          </a>
          <div class="border-t border-white/10 mt-1 pt-1">
            <a href="logout" class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl text-rose-400 hover:bg-rose-500/10 text-xs font-medium transition-all">
              <i class="fas fa-power-off w-4"></i> Log Out
            </a>
          </div>
        </div>
      </div>
    </div>

  </div>
</nav>

<!-- ===== HERO HEADER SECTION ===== -->
<section class="hero-glow-mesh pt-36 pb-28 text-center relative">
  <canvas id="particleCanvas"></canvas>

  <div class="max-w-4xl mx-auto px-6 relative z-10 space-y-3">
    <div class="inline-flex items-center gap-2 bg-indigo-500/10 border border-indigo-500/30 rounded-full px-4 py-1.5 text-xs font-semibold text-purple-300 shadow-xl">
      <i class="fas fa-user-gear text-indigo-400"></i>
      <span>Candidate Account Settings</span>
      <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span>
    </div>

    <h1 class="font-sora text-3xl md:text-5xl font-extrabold text-white tracking-tight leading-tight">
      Edit Your <span class="text-glow-gradient">Profile</span>
    </h1>

    <p class="text-slate-300 text-xs md:text-sm font-normal max-w-lg mx-auto leading-relaxed">
      Keep your details updated so top companies and recruiters can match and connect with your profile quickly.
    </p>
  </div>
</section>

<!-- ===== MAIN CONTENT CONTAINER ===== -->
<main class="max-w-4xl mx-auto px-6 -mt-12 pb-20 relative z-20 space-y-8">

  <!-- ALERT NOTIFICATIONS -->
  <% if ("updated".equals(msg) || "success".equals(msg)) { %>
    <div class="bg-emerald-50 border border-emerald-200 text-emerald-800 px-5 py-4 rounded-2xl text-xs sm:text-sm font-bold flex items-center justify-between shadow-sm animate-fade-up">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-emerald-500 text-white flex items-center justify-center font-bold text-xs flex-shrink-0">
          <i class="fas fa-check"></i>
        </div>
        <div>
          <p class="font-semibold text-emerald-900">Profile Updated!</p>
          <p class="text-xs text-emerald-700 font-normal mt-0.5">Your personal information has been saved successfully.</p>
        </div>
      </div>
      <button onclick="this.parentElement.remove()" class="text-emerald-500 hover:text-emerald-700 text-sm p-1">
        <i class="fas fa-times"></i>
      </button>
    </div>
  <% } else if ("failed".equals(msg) || "error".equals(msg)) { %>
    <div class="bg-rose-50 border border-rose-200 text-rose-800 px-5 py-4 rounded-2xl text-xs sm:text-sm font-bold flex items-center justify-between shadow-sm animate-fade-up">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-rose-500 text-white flex items-center justify-center font-bold text-xs flex-shrink-0">
          <i class="fas fa-exclamation"></i>
        </div>
        <div>
          <p class="font-semibold text-rose-900">Update Failed!</p>
          <p class="text-xs text-rose-700 font-normal mt-0.5">An error occurred while saving your details. Please try again.</p>
        </div>
      </div>
      <button onclick="this.parentElement.remove()" class="text-rose-500 hover:text-rose-700 text-sm p-1">
        <i class="fas fa-times"></i>
      </button>
    </div>
  <% } %>

  <!-- PROFILE EDIT FORM CARD -->
  <div class="glass-card overflow-hidden animate-fade-up">

    <!-- CARD HEADER BAR -->
    <div class="bg-slate-900 border-b border-slate-800 px-8 py-6 flex items-center justify-between">
      <div class="flex items-center gap-4">
        <div class="w-12 h-12 rounded-2xl bg-gradient-to-tr from-purple-600 via-indigo-600 to-sky-400 text-white font-sora font-extrabold text-xl flex items-center justify-center shadow-lg shadow-indigo-500/30">
          <%= initial %>
        </div>
        <div>
          <h2 class="font-sora font-bold text-base sm:text-lg text-white"><%= fullName %></h2>
          <p class="text-xs text-slate-400 mt-0.5 font-mono"><i class="fas fa-id-badge mr-1 text-indigo-400"></i> Account ID: #<%= m.getUserid() %></p>
        </div>
      </div>
      <span class="hidden sm:inline-flex items-center gap-1.5 bg-indigo-500/10 border border-indigo-500/20 text-indigo-400 text-xs font-semibold px-3 py-1.5 rounded-full">
        <i class="fas fa-user-check text-[10px]"></i> Active Candidate
      </span>
    </div>

    <!-- UPDATE FORM -->
    <form action="UserController" method="post" id="editProfileForm" class="p-8 space-y-8">
      <input type="hidden" name="action" value="updateProfile">
      <input type="hidden" name="userid" value="<%= m.getUserid() %>">

      <!-- SECTION 1: BASIC INFORMATION -->
      <div class="space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <div class="w-7 h-7 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center text-xs font-bold">
            <i class="fas fa-user"></i>
          </div>
          <h3 class="font-sora text-xs font-bold text-slate-900 uppercase tracking-wider">Basic Details</h3>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">First Name <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="fname" value="<%= firstName %>" class="custom-input" placeholder="John" required>
              <i class="fas fa-user input-icon"></i>
            </div>
          </div>

          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Last Name <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="lname" value="<%= lastName %>" class="custom-input" placeholder="Doe" required>
              <i class="fas fa-user input-icon"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- SECTION 2: CONTACT & EMAIL -->
      <div class="space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <div class="w-7 h-7 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center text-xs font-bold">
            <i class="fas fa-envelope"></i>
          </div>
          <h3 class="font-sora text-xs font-bold text-slate-900 uppercase tracking-wider">Contact & Credentials</h3>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 pt-1">
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-500 mb-1.5">Email Address <span class="text-slate-400 font-normal">(Non-editable)</span></label>
            <div class="field-wrapper">
              <input type="email" name="email" value="<%= userEmail %>" class="custom-input custom-input-readonly" readonly>
              <i class="fas fa-lock input-icon"></i>
            </div>
          </div>

          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Contact / Mobile <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="contact" value="<%= m.getContact() != null ? m.getContact() : "" %>" class="custom-input" placeholder="+91 9876543210" required>
              <i class="fas fa-phone-alt input-icon"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- SECTION 3: ADDRESS DETAILS -->
      <div class="space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <div class="w-7 h-7 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center text-xs font-bold">
            <i class="fas fa-map-marker-alt"></i>
          </div>
          <h3 class="font-sora text-xs font-bold text-slate-900 uppercase tracking-wider">Location & Address</h3>
        </div>

        <div class="space-y-5 pt-1">
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Street Address</label>
            <div class="field-wrapper">
              <input type="text" name="address" value="<%= m.getAddress() != null ? m.getAddress() : "" %>" class="custom-input" placeholder="House no, Street area, Landmark">
              <i class="fas fa-home input-icon"></i>
            </div>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <div>
              <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">City</label>
              <div class="field-wrapper">
                <input type="text" name="city" value="<%= m.getCity() != null ? m.getCity() : "" %>" class="custom-input" placeholder="Ahmedabad">
                <i class="fas fa-building input-icon"></i>
              </div>
            </div>

            <div>
              <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">State</label>
              <div class="field-wrapper">
                <input type="text" name="state" value="<%= m.getState() != null ? m.getState() : "" %>" class="custom-input" placeholder="Gujarat">
                <i class="fas fa-map input-icon"></i>
              </div>
            </div>

            <div>
              <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Pincode</label>
              <div class="field-wrapper">
                <input type="number" name="pincode" value="<%= m.getPincode() != 0 ? m.getPincode() : "" %>" class="custom-input" placeholder="380001">
                <i class="fas fa-mail-bulk input-icon"></i>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ACTION BUTTONS -->
      <div class="pt-6 border-t border-slate-100 flex flex-col-reverse sm:flex-row items-center justify-end gap-3">
        <a href="ViewProfile.jsp" class="w-full sm:w-auto px-6 py-3 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 text-xs font-bold tracking-wide transition-all text-center">
          Cancel
        </a>
        <button type="submit" id="saveBtn" class="w-full sm:w-auto px-8 py-3 rounded-xl bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-700 hover:to-blue-700 text-white font-sora font-bold text-xs uppercase tracking-wider shadow-lg shadow-indigo-500/25 hover:shadow-indigo-500/40 hover:-translate-y-0.5 transition-all flex items-center justify-center gap-2">
          <i class="fas fa-save text-xs"></i> Save Changes
        </button>
      </div>
    </form>
  </div>

  <!-- DANGER ZONE: PERMANENT ACCOUNT DELETION -->
  <div class="glass-card p-6 sm:p-8 border-rose-200 bg-rose-50/30 animate-fade-up">
    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
      <div class="space-y-1">
        <h4 class="font-sora font-bold text-sm text-rose-600 flex items-center gap-2">
          <i class="fas fa-triangle-exclamation"></i> Danger Zone
        </h4>
        <p class="text-xs text-slate-500 leading-relaxed max-w-xl">
          Permanently delete your candidate profile and remove all submitted job applications from JobBoard. This action is irreversible.
        </p>
      </div>

      <form action="UserController" method="post" onsubmit="return confirm('CRITICAL WARNING: Are you sure you want to PERMANENTLY DELETE your account? All your profile data and application history will be lost forever!');" class="flex-shrink-0 w-full sm:w-auto">
        <input type="hidden" name="action" value="deleteAccount">
        <button type="submit" class="w-full sm:w-auto bg-white hover:bg-rose-600 hover:text-white border border-rose-300 text-rose-600 font-sora font-bold text-xs uppercase tracking-wider py-3 px-5 rounded-xl transition-all shadow-sm flex items-center justify-center gap-2">
          <i class="fas fa-trash-alt text-xs"></i> Delete Account
        </button>
      </form>
    </div>
  </div>

</main>

<!-- ===== FOOTER ===== -->
<footer class="bg-slate-900 py-8 border-t border-slate-800 text-center text-xs text-slate-500 font-mono">
  <div class="max-w-6xl mx-auto px-5">
    <p>&copy; 2026 <span class="text-slate-300 font-semibold">JobBoard</span>. All rights reserved.</p>
  </div>
</footer>

<!-- ===== SCRIPTS ===== -->
<script>
  // Avatar Dropdown Toggle
  const avatarBtn = document.getElementById('avatarBtn');
  const avatarMenu = document.getElementById('avatarMenu');
  if (avatarBtn && avatarMenu) {
    avatarBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      avatarMenu.classList.toggle('show');
    });
    document.addEventListener('click', () => {
      avatarMenu.classList.remove('show');
    });
  }

  // Live Input Realtime Highlights & Button Spinner
  const form = document.getElementById('editProfileForm');
  const inputs = form.querySelectorAll('input[required]');
  const saveBtn = document.getElementById('saveBtn');

  inputs.forEach(input => {
    input.addEventListener('input', () => {
      if (input.value.trim() !== "") {
        input.style.borderColor = "#6366f1";
      } else {
        input.style.borderColor = "#f43f5e";
      }
    });
  });

  form.onsubmit = function() {
    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin text-xs"></i> Saving Changes...';
    saveBtn.disabled = true;
    saveBtn.classList.add('opacity-75', 'cursor-not-allowed');
  };

  // Particle Canvas Background Animation
  const canvas = document.getElementById('particleCanvas');
  if (canvas) {
    const ctx = canvas.getContext('2d');
    let particles = [];

    function resizeCanvas() {
      canvas.width = canvas.parentElement.clientWidth;
      canvas.height = canvas.parentElement.clientHeight;
    }
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    class Particle {
      constructor() { this.reset(); }
      reset() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.size = Math.random() * 2 + 0.5;
        this.speedX = (Math.random() - 0.5) * 0.4;
        this.speedY = (Math.random() - 0.5) * 0.4;
        this.alpha = Math.random() * 0.5 + 0.2;
      }
      update() {
        this.x += this.speedX;
        this.y += this.speedY;
        if (this.x < 0 || this.x > canvas.width || this.y < 0 || this.y > canvas.height) {
          this.reset();
        }
      }
      draw() {
        ctx.fillStyle = 'rgba(168, 85, 247, ' + this.alpha + ')';
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    for (let i = 0; i < 40; i++) { particles.push(new Particle()); }

    function animateParticles() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      particles.forEach(p => { p.update(); p.draw(); });
      requestAnimationFrame(animateParticles);
    }
    animateParticles();
  }
</script>

</body>
</html>