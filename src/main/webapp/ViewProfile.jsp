<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.model.applymodel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="com.Repository.ApplyRepository" %>

<%
    // 1. Session Check
    UserModel u = (UserModel) session.getAttribute("Model");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Spring Context Initialization
    ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application);
    ApplyRepository applyRepo = context.getBean(ApplyRepository.class);

    int totalApps = 0;
    int approvedCount = 0;
    int rejectedCount = 0;
    int pendingCount = 0;

    int selPct = 0;
    int rejPct = 0;
    int penPct = 0;

    try {
        List<applymodel> myApps = new ArrayList<>();
        if (u.getEmail() != null && !u.getEmail().trim().isEmpty()) {
            myApps = applyRepo.findByEmailIgnoreCase(u.getEmail().trim());
        }

        totalApps = myApps.size();

        for (applymodel app : myApps) {
            String status = app.getStatus();
            if ("Approved".equalsIgnoreCase(status) || "Selected".equalsIgnoreCase(status) || "Shortlisted".equalsIgnoreCase(status)) {
                approvedCount++;
            } else if ("Rejected".equalsIgnoreCase(status)) {
                rejectedCount++;
            } else {
                pendingCount++;
            }
        }

        if (totalApps > 0) {
            selPct = (approvedCount * 100) / totalApps;
            rejPct = (rejectedCount * 100) / totalApps;
            penPct = (pendingCount * 100) / totalApps;
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    // Safe extraction of profilePic using Reflection
    String profilePic = null;
    try {
        java.lang.reflect.Method picMethod = u.getClass().getMethod("getProfilePic");
        Object picVal = picMethod.invoke(u);
        if (picVal != null && !picVal.toString().trim().isEmpty()) {
            profilePic = picVal.toString().trim();
        }
    } catch(Exception ex) {
        // getProfilePic method not defined in UserModel yet
    }

    String initial = (u.getFirstname() != null && !u.getFirstname().trim().isEmpty())
                      ? String.valueOf(u.getFirstname().trim().charAt(0)).toUpperCase() : "U";
    String fullName = ((u.getFirstname() != null ? u.getFirstname() : "") + " " + (u.getLastname() != null ? u.getLastname() : "")).trim();
    if(fullName.isEmpty()) fullName = "User Profile";

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Profile | JobBoard</title>
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
      border-radius: 24px;
      border: 1.5px solid #e2e8f0;
      box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
    }
  </style>
</head>
<body class="antialiased">

<!-- ===== HERO HEADER WITH AVATAR ===== -->
<div class="hero-glow-mesh pt-12 pb-28 relative">
  <div class="max-w-5xl mx-auto px-6 relative z-10 text-center">

    <!-- Top Back Navigation -->
    <div class="flex items-center justify-between mb-8">
      <a href="user-home.jsp" class="inline-flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-all backdrop-blur-md">
        <i class="fas fa-arrow-left text-[11px] text-indigo-400"></i> Back to Home
      </a>
      <a href="user-home.jsp" class="font-sora font-extrabold text-xl text-white">
        Job<span class="text-indigo-400">Board</span>
      </a>
    </div>

    <!-- PROFILE PHOTO / AVATAR WITH LIVE UPLOAD TRIGGER -->
    <div class="relative w-28 h-28 mx-auto mb-4 group">
      <% if (profilePic != null) { %>
        <img id="avatarImage" src="<%= request.getContextPath() %>/uploads/<%= profilePic %>" alt="Profile Picture" class="w-28 h-28 rounded-full object-cover border-4 border-indigo-500/30 shadow-2xl">
      <% } else { %>
        <div id="avatarFallback" class="w-28 h-28 rounded-full bg-gradient-to-tr from-purple-600 via-indigo-600 to-sky-400 text-white font-sora font-extrabold text-4xl flex items-center justify-center border-4 border-white/20 shadow-2xl">
          <%= initial %>
        </div>
        <img id="avatarImage" src="" alt="Profile Picture" class="hidden w-28 h-28 rounded-full object-cover border-4 border-indigo-500/30 shadow-2xl">
      <% } %>

      <!-- Camera Icon Upload Trigger -->
      <form id="photoForm" action="UserController" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="updateProfilePic">
        <input type="file" id="profilePicInput" name="profilePic" accept="image/*" class="hidden" onchange="previewAndSubmitPhoto()">
        <label for="profilePicInput" class="absolute bottom-0 right-0 w-9 h-9 bg-indigo-600 hover:bg-indigo-700 text-white rounded-full flex items-center justify-center text-xs shadow-lg cursor-pointer border-2 border-slate-900 transition-all">
          <i class="fas fa-camera"></i>
        </label>
      </form>
    </div>

    <h1 class="font-sora font-extrabold text-2xl md:text-3xl text-white tracking-tight">
      <%= fullName %>
    </h1>

    <div class="inline-flex items-center gap-2 bg-indigo-500/10 border border-indigo-500/30 rounded-full px-4 py-1 text-xs font-semibold text-indigo-300 mt-2">
      <i class="fas fa-user-check text-indigo-400"></i> <%= u.getRole() != null ? u.getRole() : "Candidate" %>
    </div>

    <p class="text-slate-400 text-xs mt-1 font-mono"><%= u.getEmail() != null ? u.getEmail() : "" %></p>
  </div>
</div>

<!-- ===== MAIN PROFILE CONTENT AREA ===== -->
<main class="max-w-5xl mx-auto px-6 -mt-14 relative z-20 pb-20">

  <!-- VALIDATION MESSAGES -->
  <% if ("updated".equals(msg)) { %>
      <div class="mb-6 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
          <div class="flex items-center gap-2">
              <i class="fas fa-circle-check text-emerald-600 text-sm"></i>
              <span>Profile details updated successfully!</span>
          </div>
          <button onclick="this.parentElement.remove()" class="text-emerald-500 p-1 hover:text-emerald-700"><i class="fas fa-times"></i></button>
      </div>
  <% } else if ("photoUpdated".equals(msg)) { %>
      <div class="mb-6 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
          <div class="flex items-center gap-2">
              <i class="fas fa-circle-check text-emerald-600 text-sm"></i>
              <span>Profile picture updated successfully!</span>
          </div>
          <button onclick="this.parentElement.remove()" class="text-emerald-500 p-1 hover:text-emerald-700"><i class="fas fa-times"></i></button>
      </div>
  <% } else if ("photoError".equals(msg)) { %>
      <div class="mb-6 p-4 bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
          <div class="flex items-center gap-2">
              <i class="fas fa-circle-xmark text-rose-600 text-sm"></i>
              <span>Failed to upload profile picture. Please try again.</span>
          </div>
          <button onclick="this.parentElement.remove()" class="text-rose-500 p-1 hover:text-rose-700"><i class="fas fa-times"></i></button>
      </div>
  <% } %>

  <div class="grid grid-cols-1 md:grid-cols-12 gap-8 items-start">

    <!-- ===== LEFT SIDEBAR: ACTIONS & SUMMARY STATS ===== -->
    <div class="md:col-span-4 space-y-6">

      <!-- Action Buttons & Delete Account Box -->
      <div class="glass-card p-6 space-y-3">
        <a href="edit-profile.jsp" class="w-full bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-700 hover:to-blue-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3.5 px-4 rounded-xl transition-all shadow-md shadow-indigo-500/20 flex items-center justify-center gap-2">
          <i class="fas fa-pen-to-square text-xs"></i> Edit Settings
        </a>
        <a href="Application-track.jsp" class="w-full bg-slate-50 hover:bg-slate-100 border border-slate-200 text-slate-700 font-sora font-bold text-xs uppercase tracking-wider py-3.5 px-4 rounded-xl transition-all flex items-center justify-center gap-2">
          <i class="fas fa-chart-line text-indigo-600 text-xs"></i> Track Applications
        </a>

        <!-- PROPERLY ALIGNED DELETE ACCOUNT BUTTON -->
        <div class="pt-3 border-t border-slate-100 mt-2">
          <form action="UserController" method="post" onsubmit="return confirm('WARNING: Are you sure you want to PERMANENTLY DELETE your profile? All your data and job applications will be permanently lost!');">
            <input type="hidden" name="action" value="deleteAccount">
            <button type="submit" class="w-full bg-rose-50 hover:bg-rose-100 text-rose-600 border border-rose-200 font-sora font-bold text-xs uppercase tracking-wider py-3 px-4 rounded-xl transition-all flex items-center justify-center gap-2">
              <i class="fas fa-user-slash text-xs"></i> Delete Account
            </button>
          </form>
        </div>
      </div>

      <!-- Application Summary Stats -->
      <div class="glass-card p-6 space-y-4">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <i class="fas fa-chart-pie text-indigo-600 text-xs"></i>
          <h2 class="font-sora font-bold text-xs uppercase tracking-wider text-slate-900">Application Stats</h2>
        </div>

        <div class="space-y-3">
          <div class="flex items-center justify-between p-3 rounded-2xl bg-slate-50 border border-slate-100">
            <div class="flex items-center gap-2.5">
              <div class="w-8 h-8 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-xs">
                <i class="fas fa-paper-plane"></i>
              </div>
              <span class="text-xs font-semibold text-slate-600">Total Applied</span>
            </div>
            <span class="font-sora font-extrabold text-sm text-slate-900"><%= totalApps %></span>
          </div>

          <div class="flex items-center justify-between p-3 rounded-2xl bg-emerald-50/60 border border-emerald-100">
            <div class="flex items-center gap-2.5">
              <div class="w-8 h-8 rounded-xl bg-emerald-100 text-emerald-600 flex items-center justify-center text-xs">
                <i class="fas fa-check-circle"></i>
              </div>
              <span class="text-xs font-semibold text-emerald-800">Shortlisted</span>
            </div>
            <span class="font-sora font-extrabold text-sm text-emerald-600"><%= approvedCount %></span>
          </div>

          <div class="flex items-center justify-between p-3 rounded-2xl bg-amber-50/60 border border-amber-100">
            <div class="flex items-center gap-2.5">
              <div class="w-8 h-8 rounded-xl bg-amber-100 text-amber-600 flex items-center justify-center text-xs">
                <i class="fas fa-clock"></i>
              </div>
              <span class="text-xs font-semibold text-amber-800">Pending Review</span>
            </div>
            <span class="font-sora font-extrabold text-sm text-amber-600"><%= pendingCount %></span>
          </div>

          <div class="flex items-center justify-between p-3 rounded-2xl bg-rose-50/60 border border-rose-100">
            <div class="flex items-center gap-2.5">
              <div class="w-8 h-8 rounded-xl bg-rose-100 text-rose-600 flex items-center justify-center text-xs">
                <i class="fas fa-times-circle"></i>
              </div>
              <span class="text-xs font-semibold text-rose-800">Rejected</span>
            </div>
            <span class="font-sora font-extrabold text-sm text-rose-600"><%= rejectedCount %></span>
          </div>
        </div>

        <% if (totalApps > 0) { %>
        <div class="pt-2 border-t border-slate-100">
          <div class="flex justify-between items-center mb-1.5 text-[11px] font-semibold">
            <span class="text-slate-400 font-mono uppercase">Selection Success</span>
            <span class="text-emerald-600 font-bold"><%= selPct %>%</span>
          </div>
          <div class="h-2 w-full bg-slate-100 rounded-full overflow-hidden flex gap-0.5">
            <div class="bg-emerald-500 h-full" style="width: <%= selPct %>%"></div>
            <div class="bg-amber-400 h-full" style="width: <%= penPct %>%"></div>
            <div class="bg-rose-500 h-full" style="width: <%= rejPct %>%"></div>
          </div>
        </div>
        <% } %>
      </div>

    </div>

    <!-- ===== RIGHT DETAILS SECTION ===== -->
    <div class="md:col-span-8 space-y-6">

      <!-- Personal Info Card -->
      <div class="glass-card p-6 sm:p-8 space-y-6">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <i class="fas fa-user-circle text-indigo-600 text-xs"></i>
          <h2 class="font-sora font-bold text-xs uppercase tracking-wider text-slate-900">Personal Information</h2>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">First Name</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getFirstname() != null ? u.getFirstname() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Last Name</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getLastname() != null ? u.getLastname() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Email Address</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getEmail() != null ? u.getEmail() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Contact Phone</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getContact() != null ? u.getContact() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Account Role</p>
            <p class="text-xs font-bold text-indigo-600"><%= u.getRole() != null ? u.getRole() : "Candidate" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Candidate ID</p>
            <p class="text-xs font-bold font-mono text-slate-800">#<%= u.getUserid() %></p>
          </div>
        </div>
      </div>

      <!-- Address Info Card -->
      <div class="glass-card p-6 sm:p-8 space-y-6">
        <div class="flex items-center gap-2 border-b border-slate-100 pb-3">
          <i class="fas fa-map-location-dot text-indigo-600 text-xs"></i>
          <h2 class="font-sora font-bold text-xs uppercase tracking-wider text-slate-900">Address Details</h2>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div class="sm:col-span-2 p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Street Address</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getAddress() != null && !u.getAddress().trim().isEmpty() ? u.getAddress() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">City</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getCity() != null && !u.getCity().trim().isEmpty() ? u.getCity() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">State</p>
            <p class="text-xs font-bold text-slate-800"><%= u.getState() != null && !u.getState().trim().isEmpty() ? u.getState() : "—" %></p>
          </div>

          <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-100 sm:col-span-2">
            <p class="text-[10px] font-bold uppercase tracking-wider text-slate-400 mb-0.5">Pincode</p>
            <p class="text-xs font-bold font-mono text-slate-800"><%= u.getPincode() != 0 ? u.getPincode() : "—" %></p>
          </div>
        </div>
      </div>

    </div>

  </div>
</main>

<!-- FOOTER -->
<footer class="py-8 bg-slate-900 text-center text-slate-500 text-xs border-t border-slate-800 font-mono">
  &copy; 2026 JobBoard Portal. All rights reserved.
</footer>

<!-- PHOTO PREVIEW & SUBMIT JS -->
<script>
  function previewAndSubmitPhoto() {
    const fileInput = document.getElementById('profilePicInput');
    const avatarImg = document.getElementById('avatarImage');
    const avatarFallback = document.getElementById('avatarFallback');

    if (fileInput.files && fileInput.files[0]) {
      const reader = new FileReader();
      reader.onload = function(e) {
        avatarImg.src = e.target.result;
        avatarImg.classList.remove('hidden');
        if(avatarFallback) avatarFallback.classList.add('hidden');
      };
      reader.readAsDataURL(fileInput.files[0]);

      // Submit Form to Controller
      document.getElementById('photoForm').submit();
    }
  }
</script>

</body>
</html>