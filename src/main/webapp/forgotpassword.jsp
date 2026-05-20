<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String step  = request.getParameter("step");
  String error = request.getParameter("error");
  if (step  == null) step  = "1";
  if (error == null) error = "";

  String resetEmail = (String) session.getAttribute("reset_email");
  String savedOtp   = (String) session.getAttribute("reset_otp");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Forgot Password | JobBoard</title>
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

    .otp-box {
      width: 52px; height: 56px;
      border: 1.5px solid #e2e8f0;
      border-radius: 10px;
      text-align: center;
      font-size: 22px;
      font-weight: 700;
      font-family: 'Sora', sans-serif;
      color: #0f172a;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .otp-box:focus {
      border-color: #1a56db;
      box-shadow: 0 0 0 3px rgba(26,86,219,0.08);
    }

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

    @keyframes pulse-ring {
      0%   { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(34,197,94,0.4); }
      70%  { transform: scale(1);    box-shadow: 0 0 0 16px rgba(34,197,94,0); }
      100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(34,197,94,0); }
    }
    .pulse-green { animation: pulse-ring 2s infinite; }
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
        <span class="w-1.5 h-1.5 rounded-full bg-yellow-400 inline-block"></span>
        Password Recovery
      </div>

      <h2 class="font-sora text-2xl md:text-3xl font-bold text-white leading-tight mb-4">
        Reset Your <span class="text-yellow-400">Password</span><br>Securely
      </h2>
      <p class="text-white/60 text-sm leading-relaxed mb-8">
        Follow the simple steps to recover your account and set a new password.
      </p>

      <div class="space-y-4">
        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-bold text-xs text-white
            <% if ("1".equals(step)) { %>bg-yellow-400<% } else { %>bg-green-500<% } %>">
            <% if ("1".equals(step)) { %>1<% } else { %>✓<% } %>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">Enter Email</p>
            <p class="text-white/40 text-xs">Verify your registered email</p>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-bold text-xs text-white
            <% if ("2".equals(step)) { %>bg-yellow-400
            <% } else if ("3".equals(step) || "4".equals(step)) { %>bg-green-500
            <% } else { %>bg-white/20<% } %>">
            <% if ("3".equals(step) || "4".equals(step)) { %>✓<% } else { %>2<% } %>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">Verify OTP</p>
            <p class="text-white/40 text-xs">Enter the OTP</p>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <div class="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 font-bold text-xs text-white
            <% if ("3".equals(step)) { %>bg-yellow-400
            <% } else if ("4".equals(step)) { %>bg-green-500
            <% } else { %>bg-white/20<% } %>">
            <% if ("4".equals(step)) { %>✓<% } else { %>3<% } %>
          </div>
          <div>
            <p class="text-white text-sm font-semibold">New Password</p>
            <p class="text-white/40 text-xs">Set your new secure password</p>
          </div>
        </div>
      </div>
    </div>

    <div class="relative z-10">
      <p class="text-white/30 text-xs">
        Remember your password?
        <a href="login.jsp" class="text-yellow-400 hover:text-yellow-300 font-semibold ml-1">Sign In</a>
      </p>
    </div>
  </div>

  <!-- ===== RIGHT PANEL ===== -->
  <div class="flex-1 flex items-center justify-center p-6 md:p-10 bg-gray-50">
    <div class="w-full max-w-md fade-up">

      <!-- ============ STEP 1 — EMAIL ============ -->
      <% if ("1".equals(step)) { %>
        <div class="mb-8">
          <div class="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center mb-4">
            <i class="fas fa-envelope text-blue-600 text-xl"></i>
          </div>
          <h1 class="font-sora text-2xl font-bold text-gray-900 mb-1">Forgot Password?</h1>
          <p class="text-sm text-gray-500">Enter your registered email address. We'll verify your account.</p>
        </div>

        <% if ("notfound".equals(error)) { %>
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3 mb-5">
            <i class="fas fa-exclamation-circle text-red-500 flex-shrink-0"></i>
            <p class="text-sm text-red-700">No account found with this email.</p>
          </div>
        <% } %>

        <!-- ✅ ForgotController -->
        <form action="ForgotController" method="post" class="space-y-5">
          <input type="hidden" name="step" value="1">
          <div>
            <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
              Email Address <span class="text-red-400">*</span>
            </label>
            <div class="relative">
              <i class="fas fa-envelope absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
              <input type="email" name="email" required
                class="form-input pl-10"
                placeholder="your@email.com">
            </div>
          </div>
          <button type="submit"
            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-sora font-semibold text-sm px-6 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md flex items-center justify-center gap-2">
            <i class="fas fa-arrow-right text-sm"></i>
            Continue
          </button>
          <p class="text-center text-sm text-gray-500">
            Back to <a href="login.jsp" class="text-blue-600 font-semibold ml-1">Login</a>
          </p>
        </form>

      <!-- ============ STEP 2 — OTP ============ -->
      <% } else if ("2".equals(step)) { %>
        <div class="mb-8">
          <div class="w-12 h-12 rounded-xl bg-yellow-50 flex items-center justify-center mb-4">
            <i class="fas fa-key text-yellow-500 text-xl"></i>
          </div>
          <h1 class="font-sora text-2xl font-bold text-gray-900 mb-1">Enter OTP</h1>
          <p class="text-sm text-gray-500">
            OTP generated for <strong><%= resetEmail %></strong>
          </p>
        </div>


        <% if ("invalidotp".equals(error)) { %>
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3 mb-5">
            <i class="fas fa-exclamation-circle text-red-500 flex-shrink-0"></i>
            <p class="text-sm text-red-700">Invalid OTP. Please try again.</p>
          </div>
        <% } %>

        <!-- ✅ ForgotController -->
        <form action="ForgotController" method="post" class="space-y-5">
          <input type="hidden" name="step" value="2">
          <div>
            <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-3">
              Enter 4-Digit OTP
            </label>
            <div class="flex gap-3 justify-center">
              <input type="text" maxlength="1" class="otp-box" id="otp1">
              <input type="text" maxlength="1" class="otp-box" id="otp2">
              <input type="text" maxlength="1" class="otp-box" id="otp3">
              <input type="text" maxlength="1" class="otp-box" id="otp4">
            </div>
            <input type="hidden" name="otp" id="fullOtp">
          </div>
          <p class="text-center text-xs text-gray-400">
            OTP expires in <span id="timer" class="text-blue-600 font-semibold">05:00</span>
          </p>
          <button type="submit" onclick="combineOtp()"
            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-sora font-semibold text-sm px-6 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md flex items-center justify-center gap-2">
            <i class="fas fa-check text-sm"></i>
            Verify OTP
          </button>
          <p class="text-center text-sm text-gray-500">
            Wrong email? <a href="forgotpassword.jsp" class="text-blue-600 font-semibold ml-1">Go Back</a>
          </p>
        </form>

      <!-- ============ STEP 3 — NEW PASSWORD ============ -->
      <% } else if ("3".equals(step)) { %>
        <div class="mb-8">
          <div class="w-12 h-12 rounded-xl bg-green-50 flex items-center justify-center mb-4">
            <i class="fas fa-lock text-green-600 text-xl"></i>
          </div>
          <h1 class="font-sora text-2xl font-bold text-gray-900 mb-1">Set New Password</h1>
          <p class="text-sm text-gray-500">Create a strong new password for your account.</p>
        </div>

        <% if ("mismatch".equals(error)) { %>
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3 mb-5">
            <i class="fas fa-exclamation-circle text-red-500 flex-shrink-0"></i>
            <p class="text-sm text-red-700">Passwords do not match.</p>
          </div>
        <% } else if ("failed".equals(error)) { %>
          <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3 mb-5">
            <i class="fas fa-exclamation-circle text-red-500 flex-shrink-0"></i>
            <p class="text-sm text-red-700">Could not update password. Try again.</p>
          </div>
        <% } %>

        <!-- ✅ ForgotController -->
        <form action="ForgotController" method="post" class="space-y-5">
          <input type="hidden" name="step" value="3">
          <div>
            <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
              New Password <span class="text-red-400">*</span>
            </label>
            <div class="relative">
              <i class="fas fa-lock absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
              <input type="password" name="newpass" id="newPass" required
                class="form-input pl-10 pr-10"
                placeholder="Min 6 characters"
                oninput="checkStrength(this.value)">
              <button type="button" class="pass-toggle" onclick="togglePass('newPass','eye1')">
                <i class="fas fa-eye text-sm" id="eye1"></i>
              </button>
            </div>
            <div class="mt-2">
              <div class="h-1.5 bg-gray-200 rounded-full overflow-hidden">
                <div id="strengthBar" class="h-full rounded-full transition-all duration-300" style="width:0%"></div>
              </div>
              <p id="strengthText" class="text-xs mt-1 text-gray-400"></p>
            </div>
          </div>
          <div>
            <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">
              Confirm Password <span class="text-red-400">*</span>
            </label>
            <div class="relative">
              <i class="fas fa-lock absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-300 text-sm"></i>
              <input type="password" name="confirmpass" id="confPass" required
                class="form-input pl-10 pr-10"
                placeholder="Re-enter password">
              <button type="button" class="pass-toggle" onclick="togglePass('confPass','eye2')">
                <i class="fas fa-eye text-sm" id="eye2"></i>
              </button>
            </div>
          </div>
          <div class="bg-gray-50 rounded-xl p-4 space-y-2">
            <p class="text-xs font-semibold text-gray-500 mb-1">Password Requirements:</p>
            <div class="flex items-center gap-2" id="rule1">
              <i class="fas fa-circle text-gray-300 text-[8px]"></i>
              <span class="text-xs text-gray-400">At least 6 characters</span>
            </div>
            <div class="flex items-center gap-2" id="rule2">
              <i class="fas fa-circle text-gray-300 text-[8px]"></i>
              <span class="text-xs text-gray-400">Contains a number</span>
            </div>
            <div class="flex items-center gap-2" id="rule3">
              <i class="fas fa-circle text-gray-300 text-[8px]"></i>
              <span class="text-xs text-gray-400">Contains uppercase letter</span>
            </div>
          </div>
          <button type="submit"
            class="w-full bg-green-600 hover:bg-green-700 text-white font-sora font-semibold text-sm px-6 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md flex items-center justify-center gap-2">
            <i class="fas fa-save text-sm"></i>
            Save New Password
          </button>
        </form>

      <!-- ============ STEP 4 — SUCCESS ============ -->
      <% } else if ("4".equals(step)) { %>
        <div class="text-center">
          <div class="w-20 h-20 rounded-full bg-green-500 flex items-center justify-center mx-auto mb-6 pulse-green">
            <i class="fas fa-check text-white text-3xl"></i>
          </div>
          <h1 class="font-sora text-2xl font-bold text-gray-900 mb-2">Password Reset!</h1>
          <p class="text-sm text-gray-500 mb-8">
            Your password has been updated successfully.<br>
            You can now login with your new password.
          </p>
          <a href="login.jsp"
            class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-sora font-semibold text-sm px-8 py-3.5 rounded-xl transition-all hover:-translate-y-0.5 shadow-md">
            <i class="fas fa-sign-in-alt text-sm"></i>
            Go to Login
          </a>
        </div>
      <% } %>

    </div>
  </div>
</div>

<script>
  const boxes = ['otp1','otp2','otp3','otp4'];
  boxes.forEach((id, idx) => {
    const el = document.getElementById(id);
    if (!el) return;
    el.addEventListener('input', function() {
      if (this.value && idx < boxes.length - 1)
        document.getElementById(boxes[idx + 1]).focus();
    });
    el.addEventListener('keydown', function(e) {
      if (e.key === 'Backspace' && !this.value && idx > 0)
        document.getElementById(boxes[idx - 1]).focus();
    });
  });

  function combineOtp() {
    const val = boxes.map(id => {
      const el = document.getElementById(id);
      return el ? el.value : '';
    }).join('');
    const f = document.getElementById('fullOtp');
    if (f) f.value = val;
  }

  const timerEl = document.getElementById('timer');
  if (timerEl) {
    let seconds = 300;
    const interval = setInterval(() => {
      seconds--;
      const m = Math.floor(seconds / 60).toString().padStart(2, '0');
      const s = (seconds % 60).toString().padStart(2, '0');
      timerEl.textContent = m + ':' + s;
      if (seconds <= 0) {
        clearInterval(interval);
        timerEl.textContent = 'Expired';
        timerEl.className = 'text-red-500 font-semibold';
      }
    }, 1000);
  }

  function togglePass(fieldId, iconId) {
    const f = document.getElementById(fieldId);
    const i = document.getElementById(iconId);
    if (!f || !i) return;
    if (f.type === 'password') {
      f.type = 'text';
      i.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
      f.type = 'password';
      i.classList.replace('fa-eye-slash', 'fa-eye');
    }
  }

  function checkStrength(val) {
    const bar  = document.getElementById('strengthBar');
    const text = document.getElementById('strengthText');
    if (!bar) return;
    const has6   = val.length >= 6;
    const hasNum = /\d/.test(val);
    const hasCap = /[A-Z]/.test(val);
    let score = (has6 ? 1 : 0) + (hasNum ? 1 : 0) + (hasCap ? 1 : 0);
    const updateRule = (id, pass) => {
      const el = document.getElementById(id);
      if (!el) return;
      el.querySelector('i').className = pass ? 'fas fa-check-circle text-green-500 text-[10px]' : 'fas fa-circle text-gray-300 text-[8px]';
      el.querySelector('span').className = pass ? 'text-xs text-green-600' : 'text-xs text-gray-400';
    };
    updateRule('rule1', has6);
    updateRule('rule2', hasNum);
    updateRule('rule3', hasCap);
    const colors = ['bg-red-400','bg-yellow-400','bg-green-500'];
    const labels = ['Weak','Medium','Strong'];
    const widths = ['33%','66%','100%'];
    const tColors = ['text-red-500','text-yellow-600','text-green-600'];
    bar.className = 'h-full rounded-full transition-all duration-300 ' + (colors[score-1] || '');
    bar.style.width = score > 0 ? widths[score-1] : '0%';
    text.textContent = score > 0 ? labels[score-1] : '';
    text.className = 'text-xs mt-1 ' + (tColors[score-1] || 'text-gray-400');
  }
</script>
</body>
</html>