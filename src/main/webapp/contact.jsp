<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%
    // 1. Session Fetch
    UserModel u = (UserModel) session.getAttribute("Model");

    // Candidate details pre-filling
    String userEmail = (u != null && u.getEmail() != null) ? u.getEmail().trim() : "";
    String firstName = (u != null && u.getFirstname() != null) ? u.getFirstname() : "";
    String lastName  = (u != null && u.getLastname() != null) ? u.getLastname() : "";
    String userPhone = (u != null && u.getContact() != null) ? u.getContact() : "";
    String initial   = !firstName.isEmpty() ? String.valueOf(firstName.charAt(0)).toUpperCase() : "U";

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Contact Us | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- Tailwind CSS & Google Fonts -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            sora: ['Sora', 'sans-serif'],
            dm: ['DM Sans', 'sans-serif'],
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    body { font-family: 'DM Sans', sans-serif; background-color: #f8fafc; }
    .font-sora { font-family: 'Sora', sans-serif; }

    /* Hero Mesh Background */
    .hero-mesh {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 40%, #1e3a5f 70%, #1a56db 100%);
      position: relative; overflow: hidden;
    }
    .hero-mesh::before {
      content: ''; position: absolute; inset: 0;
      background-image:
        radial-gradient(ellipse 60% 50% at 80% 40%, rgba(26,86,219,0.25) 0%, transparent 70%),
        radial-gradient(ellipse 40% 40% at 20% 70%, rgba(245,158,11,0.10) 0%, transparent 60%);
    }
    .hero-mesh::after {
      content: ''; position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
    }

    .navbar-blur {
      background: rgba(15, 23, 42, 0.92);
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
    }

    /* Custom Form Control Styling */
    .field-wrapper { position: relative; }
    .input-icon {
      position: absolute; left: 14px; top: 50%;
      transform: translateY(-50%); color: #94a3b8;
      font-size: 14px; transition: color 0.2s ease;
    }
    .textarea-icon {
      position: absolute; left: 14px; top: 16px;
      color: #94a3b8; font-size: 14px; transition: color 0.2s ease;
    }
    .custom-input {
      width: 100%; background-color: #ffffff;
      border: 1.5px solid #e2e8f0; border-radius: 12px;
      padding: 11px 16px 11px 42px; font-size: 14px;
      color: #0f172a; font-weight: 500; outline: none;
      transition: all 0.2s ease;
    }
    .custom-textarea {
      width: 100%; background-color: #ffffff;
      border: 1.5px solid #e2e8f0; border-radius: 12px;
      padding: 11px 16px 11px 42px; font-size: 14px;
      color: #0f172a; font-weight: 500; outline: none;
      transition: all 0.2s ease;
    }
    .custom-input:focus, .custom-textarea:focus {
      border-color: #1a56db;
      box-shadow: 0 0 0 4px rgba(26, 86, 219, 0.12);
    }
    .custom-input:focus + .input-icon,
    .field-wrapper:focus-within .input-icon,
    .field-wrapper:focus-within .textarea-icon { color: #1a56db; }

    /* Static Locked Email Style */
    .custom-input-readonly {
      background-color: #f1f5f9 !important;
      border-color: #cbd5e1 !important;
      color: #475569 !important;
      cursor: not-allowed;
      user-select: none;
    }

    .glass-card {
      background: #ffffff; border-radius: 24px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05), 0 20px 25px -5px rgba(0, 0, 0, 0.02);
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-up { animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
  </style>
</head>
<body class="antialiased text-slate-800">

<!-- ===== HEADER NAVBAR ===== -->
<header class="navbar-blur sticky top-0 z-50 border-b border-white/10">
  <div class="max-w-7xl mx-auto px-5 py-3.5 flex items-center justify-between">
    <a href="user-home.jsp" class="font-sora font-bold text-xl text-white tracking-tight">
      Job<span class="text-yellow-400">Board</span>
    </a>

    <!-- Nav Links -->
    <nav class="hidden md:flex items-center gap-1">
      <a href="user-home.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-xs font-semibold px-3.5 py-2 rounded-xl transition-all">Home</a>
      <a href="about.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-xs font-semibold px-3.5 py-2 rounded-xl transition-all">About</a>
      <a href="Application-track.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-xs font-semibold px-3.5 py-2 rounded-xl transition-all">Applications</a>
      <a href="Saved-jobs.jsp" class="text-white/70 hover:text-white hover:bg-white/10 text-xs font-semibold px-3.5 py-2 rounded-xl transition-all">Saved Jobs</a>
      <a href="contact.jsp" class="text-white bg-white/15 text-xs font-semibold px-3.5 py-2 rounded-xl">Contact</a>
    </nav>

    <!-- User Action Links -->
    <div class="flex items-center gap-3">
      <% if (u != null) { %>
        <a href="ViewProfile.jsp" class="inline-flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-semibold px-3.5 py-2 rounded-xl transition-all">
          <span class="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[10px] font-bold"><%= initial %></span>
          <%= firstName %>
        </a>
        <a href="logout" class="bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-all shadow-md">
          <i class="fas fa-sign-out-alt mr-1"></i> Log Out
        </a>
      <% } else { %>
        <a href="login.jsp" class="bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold px-4 py-2 rounded-xl transition-all shadow-md">
          <i class="fas fa-lock mr-1"></i> Log In
        </a>
      <% } %>
    </div>
  </div>
</header>

<!-- ===== HERO HEADER ===== -->
<section class="hero-mesh pt-12 pb-24 relative">
  <div class="max-w-4xl mx-auto px-5 relative z-10 text-center">
    <div class="inline-flex items-center gap-2 bg-white/10 border border-white/20 rounded-full px-4 py-1.5 text-xs text-white/80 mb-4">
      <span class="w-2 h-2 rounded-full bg-yellow-400 inline-block animate-pulse"></span>
      24/7 Support Desk
    </div>
    <h1 class="font-sora text-3xl md:text-5xl font-bold text-white tracking-tight mb-3">
      Get in <span class="text-yellow-400">Touch</span>
    </h1>
    <p class="text-white/60 text-sm max-w-lg mx-auto">Have questions or need help with your application? Send us a message and our support team will respond shortly.</p>
  </div>
</section>

<!-- ===== MAIN CONTENT CONTAINER ===== -->
<main class="max-w-6xl mx-auto px-5 -mt-14 pb-20 relative z-20">

  <!-- ALERT NOTIFICATIONS -->
  <% if ("success".equals(msg)) { %>
    <div class="bg-emerald-50 border border-emerald-200 text-emerald-800 px-5 py-4 rounded-2xl text-sm mb-8 flex items-center justify-between shadow-sm animate-fade-up">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-emerald-500 text-white flex items-center justify-center font-bold text-xs">
          <i class="fas fa-check"></i>
        </div>
        <div>
          <p class="font-semibold text-emerald-900">Message Sent Successfully!</p>
          <p class="text-xs text-emerald-700 mt-0.5">Thank you for reaching out. We have sent a confirmation copy to your email.</p>
        </div>
      </div>
      <button onclick="this.parentElement.remove()" class="text-emerald-500 hover:text-emerald-700 text-sm p-1">
        <i class="fas fa-times"></i>
      </button>
    </div>
  <% } else if ("error".equals(msg)) { %>
    <div class="bg-rose-50 border border-rose-200 text-rose-800 px-5 py-4 rounded-2xl text-sm mb-8 flex items-center justify-between shadow-sm animate-fade-up">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-xl bg-rose-500 text-white flex items-center justify-center font-bold text-xs">
          <i class="fas fa-exclamation-triangle"></i>
        </div>
        <div>
          <p class="font-semibold text-rose-900">Delivery Failed!</p>
          <p class="text-xs text-rose-700 mt-0.5">An error occurred while sending your message. Please try again later.</p>
        </div>
      </div>
      <button onclick="this.parentElement.remove()" class="text-rose-500 hover:text-rose-700 text-sm p-1">
        <i class="fas fa-times"></i>
      </button>
    </div>
  <% } %>

  <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">

    <!-- LEFT: CONTACT FORM CARD -->
    <div class="lg:col-span-7 glass-card p-8 animate-fade-up">
      <div class="mb-6 border-b border-slate-100 pb-4">
        <h2 class="font-sora font-bold text-xl text-slate-900">Send Us a Message</h2>
        <p class="text-xs text-slate-400 mt-1">Fill in the form below and our support team will get back to you.</p>
      </div>

      <form action="ContactServlet" method="post" class="space-y-5">

        <!-- First Name & Last Name -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">First Name <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="firstname" value="<%= firstName %>" class="custom-input" placeholder="John" required>
              <i class="fas fa-user input-icon"></i>
            </div>
          </div>
          <div>
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Last Name <span class="text-rose-500">*</span></label>
            <div class="field-wrapper">
              <input type="text" name="lastname" value="<%= lastName %>" class="custom-input" placeholder="Doe" required>
              <i class="fas fa-user input-icon"></i>
            </div>
          </div>
        </div>

        <!-- STATIC LOCKED EMAIL FIELD -->
        <div>
          <div class="flex items-center justify-between mb-1.5">
            <label class="block text-xs font-bold uppercase tracking-wider text-slate-600">Registered Email Address</label>
            <span class="text-[10px] font-bold text-slate-400 bg-slate-100 px-2 py-0.5 rounded-md flex items-center gap-1">
              <i class="fas fa-lock text-[9px]"></i> Non-editable
            </span>
          </div>
          <div class="field-wrapper">
            <input type="email" name="email" value="<%= userEmail %>" class="custom-input custom-input-readonly" readonly required>
            <i class="fas fa-lock input-icon text-slate-400"></i>
          </div>
        </div>

        <!-- Subject -->
        <div>
          <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Subject / Inquiry Topic <span class="text-rose-500">*</span></label>
          <div class="field-wrapper">
            <input type="text" name="subject" class="custom-input" placeholder="e.g. Account verification or application inquiry" required>
            <i class="fas fa-heading input-icon"></i>
          </div>
        </div>

        <!-- Message -->
        <div>
          <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Your Message <span class="text-rose-500">*</span></label>
          <div class="field-wrapper">
            <textarea name="message" rows="5" class="custom-textarea" placeholder="Write your questions or detailed query here..." required></textarea>
            <i class="fas fa-comment-alt textarea-icon"></i>
          </div>
        </div>

        <!-- Submit Button -->
        <div class="pt-2">
          <button type="submit" class="w-full sm:w-auto px-8 py-3.5 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white text-xs font-bold tracking-wide shadow-lg shadow-blue-500/25 hover:shadow-blue-500/40 hover:-translate-y-0.5 transition-all flex items-center justify-center gap-2">
            <i class="fas fa-paper-plane text-xs"></i> Send Message
          </button>
        </div>

      </form>
    </div>

    <!-- RIGHT: CONTACT INFO & MAP CARDS -->
    <div class="lg:col-span-5 space-y-6 animate-fade-up" style="animation-delay: 0.1s;">

      <!-- Info Details Card -->
      <div class="glass-card p-7 space-y-6">
        <h3 class="font-sora font-bold text-lg text-slate-900 border-b border-slate-100 pb-3">Corporate Headquarters</h3>

        <div class="space-y-5">
          <!-- Address -->
          <div class="flex items-start gap-4">
            <div class="w-10 h-10 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-sm font-bold flex-shrink-0">
              <i class="fas fa-map-marker-alt"></i>
            </div>
            <div>
              <p class="text-xs font-bold uppercase tracking-wider text-slate-400">Head Office</p>
              <p class="text-sm font-semibold text-slate-800 mt-0.5">SG Highway, Corporate Road, Ahmedabad, Gujarat, India</p>
            </div>
          </div>

          <!-- Phone -->
          <div class="flex items-start gap-4">
            <div class="w-10 h-10 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-sm font-bold flex-shrink-0">
              <i class="fas fa-phone-alt"></i>
            </div>
            <div>
              <p class="text-xs font-bold uppercase tracking-wider text-slate-400">Phone Support</p>
              <a href="tel:+919876543210" class="text-sm font-semibold text-blue-600 hover:underline mt-0.5 block">+91 98765 43210</a>
            </div>
          </div>

          <!-- Email -->
          <div class="flex items-start gap-4">
            <div class="w-10 h-10 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-sm font-bold flex-shrink-0">
              <i class="fas fa-envelope"></i>
            </div>
            <div>
              <p class="text-xs font-bold uppercase tracking-wider text-slate-400">Support Email</p>
              <a href="mailto:support@jobboard.com" class="text-sm font-semibold text-blue-600 hover:underline mt-0.5 block">support@jobboard.com</a>
            </div>
          </div>
        </div>
      </div>

      <!-- Working Hours Card -->
      <div class="bg-gradient-to-br from-slate-900 to-slate-800 rounded-3xl p-7 text-white shadow-xl relative overflow-hidden">
        <div class="relative z-10 space-y-3">
          <div class="w-8 h-8 rounded-xl bg-white/10 flex items-center justify-center text-yellow-400 text-sm">
            <i class="fas fa-clock"></i>
          </div>
          <h4 class="font-sora font-bold text-base text-white">Helpdesk Hours</h4>
          <p class="text-xs text-slate-300 leading-relaxed">Our support team is available Monday to Saturday, 9:00 AM – 6:00 PM IST to assist you.</p>
        </div>
      </div>

    </div>

  </div>
</main>

<!-- ===== FOOTER ===== -->
<footer class="bg-slate-900 py-10 border-t border-slate-800 text-center text-xs text-slate-500">
  <div class="max-w-6xl mx-auto px-5 space-y-4">
    <div class="flex items-center justify-center gap-6 text-slate-400">
      <a href="user-home.jsp" class="hover:text-white transition-colors">Home</a>
      <a href="about.jsp" class="hover:text-white transition-colors">About Us</a>
      <a href="Application-track.jsp" class="hover:text-white transition-colors">Applications</a>
      <a href="contact.jsp" class="hover:text-white transition-colors">Contact</a>
    </div>
    <p>&copy; 2026 <span class="text-slate-300 font-semibold">JobBoard</span>. All rights reserved.</p>
  </div>
</footer>

</body>
</html>