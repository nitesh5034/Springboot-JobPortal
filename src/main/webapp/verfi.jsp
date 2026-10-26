<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.companyverify" %>
<%@ page import="com.model.UserModel" %>
<%
    Object sessionModel = session.getAttribute("Model");
    companyverify compModel = null;
    UserModel userModel = null;

    if (sessionModel instanceof companyverify) {
        compModel = (companyverify) sessionModel;
    } else if (sessionModel instanceof UserModel) {
        userModel = (UserModel) sessionModel;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>JobBoard — Company Verification</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm:   ['DM Sans', 'sans-serif'],
          },
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; }
    .font-sora, h1, h2, h3 { font-family: 'Sora', sans-serif; }
    html { scroll-behavior: smooth; }

    .auth-left {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%);
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

    .pass-wrap { position: relative; }
    .pass-toggle {
      position: absolute; right: 12px; top: 50%;
      transform: translateY(-50%);
      cursor: pointer; color: #94a3b8;
      background: none; border: none; padding: 0;
    }
    .pass-toggle:hover { color: #1a56db; }

    .step-dot { width: 8px; height: 8px; border-radius: 50%; background: rgba(255,255,255,0.25); transition: all 0.3s; }
    .step-dot.active { background: #f59e0b; width: 24px; border-radius: 4px; }

    .feature-card {
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(255,255,255,0.1);
      border-radius: 12px; padding: 16px;
      transition: background 0.2s;
    }
    .feature-card:hover { background: rgba(255,255,255,0.10); }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(16px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-up { animation: fadeUp 0.5s ease both; }
    .delay-1 { animation-delay: 0.1s; }
    .delay-2 { animation-delay: 0.2s; }
    .delay-3 { animation-delay: 0.3s; }
  </style>
</head>
<body class="bg-gray-50 antialiased min-h-screen">

<div class="min-h-screen flex flex-col lg:flex-row">

  <!-- ===== LEFT PANEL ===== -->
  <div class="auth-left lg:w-5/12 xl:w-4/12 flex flex-col justify-between p-8 md:p-12 min-h-[280px] lg:min-h-screen">
    <div class="relative z-10">
      <a href="index.jsp" class="font-sora font-bold text-2xl text-white tracking-tight">
        Job<span class="text-yellow-400">Board</span>
      </a>
    </div>

    <div class="relative z-10 py-10">
      <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-6">
        <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
        Employer Registration
      </div>
      <h2 class="font-sora text-2xl md:text-3xl font-bold text-white leading-tight mb-4">
        Hire the <span class="text-yellow-400">Best Talent</span><br>for Your Team
      </h2>
      <p class="text-white/60 text-sm leading-relaxed mb-8">
        Register your company on JobBoard and get access to thousands of qualified candidates across India.
      </p>

      <div class="space-y-3">
        <div class="feature-card flex items-center gap-3">
          <div class="w-9 h-9 rounded-xl bg-blue-600/40 flex items-center justify-center flex-shrink-0">
            <i class="fas fa-bolt text-yellow-400 text-sm"></i>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">Post Jobs Instantly</p>
            <p class="text-white/50 text-xs">Go live in under 5 minutes</p>
          </div>
        </div>
        <div class="feature-card flex items-center gap-3">
          <div class="w-9 h-9 rounded-xl bg-blue-600/40 flex items-center justify-center flex-shrink-0">
            <i class="fas fa-users text-yellow-400 text-sm"></i>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">1,930+ Active Candidates</p>
            <p class="text-white/50 text-xs">Reach qualified job seekers</p>
          </div>
        </div>
        <div class="feature-card flex items-center gap-3">
          <div class="w-9 h-9 rounded-xl bg-blue-600/40 flex items-center justify-center flex-shrink-0">
            <i class="fas fa-shield-alt text-yellow-400 text-sm"></i>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">Verified Badge</p>
            <p class="text-white/50 text-xs">Build trust with candidates</p>
          </div>
        </div>
      </div>
    </div>

    <div class="relative z-10">
      <p class="text-white/30 text-xs">
        Already have an account?
        <a href="login.jsp" class="text-yellow-400 hover:text-yellow-300 font-semibold ml-1">Sign In</a>
      </p>
    </div>
  </div>

  <!-- ===== RIGHT PANEL ===== -->
  <div class="flex-1 flex items-start lg:items-center justify-center p-6 md:p-10 bg-gray-50 overflow-y-auto">
    <div class="w-full max-w-lg fade-up">

      <!-- ✅ Session msg show -->
      <% if (request.getParameter("msg") != null) { %>
        <% String msg = request.getParameter("msg"); %>
        <% if ("registered".equals(msg)) { %>
          <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center gap-3 mb-5">
            <i class="fas fa-check-circle text-green-500 flex-shrink-0"></i>
            <p class="text-sm text-green-700 font-semibold">Registration successful! Please wait for admin verification.</p>
          </div>
        <% } else if ("failed".equals(msg)) { %>
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3 mb-5">
            <i class="fas fa-exclamation-circle text-red-500 flex-shrink-0"></i>
            <p class="text-sm text-red-700 font-semibold">Registration failed. Please try again.</p>
          </div>
        <% } %>
      <% } %>

      <div class="mb-8">
        <div class="flex items-center gap-2 mb-3">
          <div class="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center">
            <i class="fas fa-building text-white text-sm"></i>
          </div>
          <span class="text-xs font-semibold text-blue-600 uppercase tracking-widest">Company Registration</span>
        </div>
        <h1 class="font-sora text-2xl md:text-3xl font-bold text-gray-900 mb-1">Register Your Company</h1>
        <p class="text-sm text-gray-500">Fill in your official details. Our team will verify within 24 hours.</p>
      </div>

      <div class="bg-amber-50 border border-amber-200 rounded-xl p-4 flex items-start gap-3 mb-6 delay-1 fade-up">
        <i class="fas fa-info-circle text-amber-500 mt-0.5 flex-shrink-0"></i>
        <div>
          <p class="text-sm font-semibold text-amber-800">Verification Required</p>
          <p class="text-xs text-amber-600 mt-0.5 leading-relaxed">
            After submitting, our team will review your details. You'll receive login access via email once verified.
          </p>
        </div>
      </div>

      <!-- FORM -->
      <form action="CompanyController" method="post" class="space-y-5 delay-2 fade-up">
        <input type="hidden" name="action" value="register">
        <input type="hidden" name="role" value="EMPLOYER">

        <!-- Company Name -->
        <div>
          <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
            Company Name <span class="text-red-400">*</span>
          </label>
          <div class="relative">
            <i class="fas fa-building absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
            <input type="text" name="companyname" required
              class="form-input pl-10"
              placeholder="company Pvt Ltd">
          </div>
        </div>

        <!-- Email + Password -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
              Official Email <span class="text-red-400">*</span>
            </label>
            <div class="relative">
              <i class="fas fa-envelope absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
              <input type="email" name="email" required
                class="form-input pl-10"
                placeholder="hr@company.com">
            </div>
          </div>
          <div>
            <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
              Password <span class="text-red-400">*</span>
            </label>
            <div class="pass-wrap">
              <i class="fas fa-lock absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm" style="position:absolute;"></i>
              <input type="password" name="password" id="passField" required
                class="form-input pl-10 pr-10"
                placeholder="Min 8 characters">
              <button type="button" class="pass-toggle" onclick="togglePass()">
                <i class="fas fa-eye text-sm" id="eyeIcon"></i>
              </button>
            </div>
          </div>
        </div>

        <!-- Contact -->
        <div>
          <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
            Contact Number <span class="text-red-400">*</span>
          </label>
          <div class="relative">
            <i class="fas fa-phone absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
            <input type="text" name="contact" required
              class="form-input pl-10"
              placeholder="9876543210">
          </div>
        </div>

        <!-- Website + Location -->

      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
  <div>
    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
      Company Website
    </label>
    <div class="relative">
      <i class="fas fa-globe absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
      <input type="text" name="address"
        class="form-input pl-10"
        placeholder="https://www.company.com">
    </div>
  </div>
  <div>
    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
      City <span class="text-red-400">*</span>
    </label>
    <div class="relative">
      <i class="fas fa-map-marker-alt absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
      <input type="text" name="city" required
        class="form-input pl-10"
        placeholder="e.g. Ahmedabad">
    </div>
  </div>
</div>

<div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
  <div>
    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
      Industry <span class="text-red-400">*</span>
    </label>
    <div class="relative">
      <i class="fas fa-briefcase absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
      <select name="industry" required class="form-input pl-10">
        <option value="">Select Industry</option>
        <option value="Information Technology">Information Technology</option>
        <option value="Manufacturing">Manufacturing</option>
        <option value="Finance">Finance</option>
        <option value="Healthcare">Healthcare</option>
        <option value="Education">Education</option>
      </select>
    </div>
  </div>
  <div>
    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
      Company Size <span class="text-red-400">*</span>
    </label>
    <div class="relative">
      <i class="fas fa-users-cog absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
      <select name="companysize" required class="form-input pl-10">
        <option value="">Select Size</option>
        <option value="1-50 employees">1-50 employees</option>
        <option value="51-200 employees">51-200 employees</option>
        <option value="201-500 employees">201-500 employees</option>
        <option value="500+ employees">500+ employees</option>
      </select>
    </div>
  </div>
</div>

<div>
  <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
    About Company <span class="text-red-400">*</span>
  </label>
  <div class="relative">
    <textarea name="about" required rows="3"
      class="form-input"
      placeholder="Briefly describe your company..."></textarea>
  </div>
</div>

<div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
  </div>

        <!-- Last Name (hidden - required by UserModel) -->
        <input type="hidden" name="lname" value="Company">

        <!-- Terms -->
        <div class="flex items-start gap-3">
          <input type="checkbox" id="terms" required
            class="mt-0.5 w-4 h-4 rounded border-gray-300 text-blue-600 cursor-pointer flex-shrink-0">
          <label for="terms" class="text-xs text-gray-500 leading-relaxed cursor-pointer">
            I confirm that all information provided is accurate and I agree to JobBoard's
            <a href="#" class="text-blue-600 hover:underline font-semibold">Terms of Service</a> and
            <a href="#" class="text-blue-600 hover:underline font-semibold">Privacy Policy</a>.
          </label>
        </div>

        <!-- Submit -->
        <button type="submit"
          class="w-full bg-blue-600 hover:bg-blue-700 text-white font-sora font-semibold text-sm px-6 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md shadow-blue-600/20 flex items-center justify-center gap-2">
          <i class="fas fa-paper-plane text-sm"></i>
          Submit for Verification
        </button>

        <div class="flex items-center gap-3">
          <div class="flex-1 h-px bg-gray-200"></div>
          <span class="text-xs text-gray-400">or</span>
          <div class="flex-1 h-px bg-gray-200"></div>
        </div>

        <p class="text-center text-sm text-gray-500">
          Already registered?
          <a href="login.jsp" class="text-blue-600 hover:text-blue-700 font-semibold ml-1">Sign In to Dashboard</a>
        </p>
      </form>

      <!-- What happens next -->
      <div class="mt-8 bg-white rounded-2xl border border-gray-100 shadow-sm p-5 delay-3 fade-up">
        <p class="font-sora font-bold text-sm text-gray-800 mb-4">What happens after submission?</p>
        <div class="space-y-3">
          <div class="flex items-start gap-3">
            <div class="w-6 h-6 rounded-full bg-blue-600 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">1</div>
            <div>
              <p class="text-sm font-semibold text-gray-700">Details Reviewed</p>
              <p class="text-xs text-gray-400 mt-0.5">Our team verifies your company details within 24 hours.</p>
            </div>
          </div>
          <div class="flex items-start gap-3">
            <div class="w-6 h-6 rounded-full bg-blue-600 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">2</div>
            <div>
              <p class="text-sm font-semibold text-gray-700">Email Confirmation</p>
              <p class="text-xs text-gray-400 mt-0.5">You receive a confirmation email once verified.</p>
            </div>
          </div>
          <div class="flex items-start gap-3">
            <div class="w-6 h-6 rounded-full bg-yellow-400 text-white text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">3</div>
            <div>
              <p class="text-sm font-semibold text-gray-700">Start Hiring!</p>
              <p class="text-xs text-gray-400 mt-0.5">Post jobs and connect with thousands of candidates immediately.</p>
            </div>
          </div>
        </div>
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