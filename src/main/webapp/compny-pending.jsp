<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Verification Pending | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@700;800&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; }
    .font-sora { font-family: 'Sora', sans-serif; }
    @keyframes fadeUp { from{opacity:0;transform:translateY(20px)} to{opacity:1;transform:translateY(0)} }
    .fade-up { animation: fadeUp 0.6s ease both; }
    @keyframes pulse-ring {
      0%   { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245,158,11,0.5); }
      70%  { transform: scale(1);    box-shadow: 0 0 0 16px rgba(245,158,11,0); }
      100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245,158,11,0); }
    }
    .pulse-ring { animation: pulse-ring 2s infinite; }
  </style>
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center p-5">

<div class="max-w-md w-full text-center fade-up">

  <%
    String msg = request.getParameter("msg");
    boolean isSuccess = "success".equals(msg);
    boolean isWaiting = "waiting".equals(msg);
  %>

  <!-- Icon -->
  <div class="w-20 h-20 rounded-full <%= isSuccess ? "bg-amber-400" : "bg-blue-100" %> flex items-center justify-center mx-auto mb-6 pulse-ring">
    <i class="fas <%= isSuccess ? "fa-hourglass-half text-white" : "fa-clock text-blue-500" %> text-3xl"></i>
  </div>

  <% if (isSuccess) { %>
    <h1 class="font-sora text-2xl font-bold text-gray-900 mb-2">Request Submitted! 🎉</h1>
    <p class="text-gray-500 text-sm leading-relaxed mb-6">
      Your company verification request has been sent to our admin team.<br>
      You'll receive an email once it's approved — usually within <strong>24 hours</strong>.
    </p>
  <% } else { %>
    <h1 class="font-sora text-2xl font-bold text-gray-900 mb-2">Verification Pending ⏳</h1>
    <p class="text-gray-500 text-sm leading-relaxed mb-6">
      Your account is currently under review. Our team is verifying your company details.
      Please check back soon or wait for our email.
    </p>
  <% } %>

  <!-- Steps -->
  <div class="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 text-left mb-6">
    <div class="flex items-center gap-3 mb-4">
      <div class="w-7 h-7 rounded-full bg-green-500 text-white text-xs font-bold flex items-center justify-center">✓</div>
      <div>
        <p class="text-sm font-semibold text-gray-800">Request Submitted</p>
        <p class="text-xs text-gray-400">Your details are with our team</p>
      </div>
    </div>
    <div class="flex items-center gap-3 mb-4">
      <div class="w-7 h-7 rounded-full bg-amber-400 text-white text-xs font-bold flex items-center justify-center animate-spin" style="animation-duration:3s">
        <i class="fas fa-circle-notch text-xs"></i>
      </div>
      <div>
        <p class="text-sm font-semibold text-gray-800">Admin Review</p>
        <p class="text-xs text-gray-400">In progress — usually 24 hours</p>
      </div>
    </div>
    <div class="flex items-center gap-3">
      <div class="w-7 h-7 rounded-full bg-gray-200 text-gray-400 text-xs font-bold flex items-center justify-center">3</div>
      <div>
        <p class="text-sm font-semibold text-gray-400">Email Notification</p>
        <p class="text-xs text-gray-300">You'll be notified on approval</p>
      </div>
    </div>
  </div>

  <div class="flex gap-3 justify-center">
    <a href="login.jsp" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-5 py-2.5 rounded-xl transition-all">
      <i class="fas fa-sign-in-alt mr-2"></i>Try Login
    </a>
    <a href="compny-home.jsp" class="border border-gray-200 text-gray-600 text-sm font-medium px-5 py-2.5 rounded-xl hover:bg-gray-50 transition-all">
      Go Home
    </a>
  </div>
</div>
</body>
</html>