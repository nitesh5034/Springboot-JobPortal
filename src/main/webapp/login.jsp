<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Single Top-Level Variable Declaration
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>JobBoard | Login</title>
    <meta charset="utf-8">
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
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f8fafc;
            color: #0f172a;
        }

        .font-sora { font-family: 'Sora', sans-serif; }

        .custom-input {
            width: 100%;
            background-color: #ffffff;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            padding: 12px 16px 12px 42px;
            font-size: 14px;
            color: #0f172a;
            font-weight: 500;
            outline: none;
            transition: all 0.2s ease;
        }

        .custom-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .custom-select {
            width: 100%;
            background-color: #ffffff;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            padding: 12px 16px 12px 42px;
            font-size: 14px;
            color: #0f172a;
            font-weight: 500;
            outline: none;
            cursor: pointer;
            appearance: none;
            transition: all 0.2s ease;
        }

        .custom-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }
    </style>
</head>

<body class="antialiased bg-slate-50 min-h-screen flex flex-col justify-between">

    <!-- Top Navigation Bar -->
    <header class="py-6 px-8 max-w-7xl mx-auto w-full flex items-center justify-between">
        <a href="index.jsp" class="font-sora font-extrabold text-2xl text-slate-900 tracking-tight flex items-center gap-2">
            <div class="w-9 h-9 rounded-xl bg-blue-600 text-white flex items-center justify-center shadow-md">
                <i class="fas fa-briefcase text-xs"></i>
            </div>
            Job<span class="text-blue-600">Board</span>
        </a>
        <a href="index.jsp" class="inline-flex items-center gap-2 bg-white hover:bg-slate-100 border border-slate-200 text-slate-700 text-xs font-semibold px-4 py-2 rounded-xl transition-all shadow-sm">
            <i class="fas fa-arrow-left text-[11px]"></i> Back to Home
        </a>
    </header>

    <!-- Main Split Screen Container -->
    <main class="max-w-5xl mx-auto px-4 py-6 w-full my-auto">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">

            <!-- Left Form Card -->
            <div class="lg:col-span-7 bg-white rounded-3xl border border-slate-200 shadow-xl p-8 sm:p-10 relative overflow-hidden">

                <!-- Top Gradient Accent Strip -->
                <div class="h-1.5 w-full bg-gradient-to-r from-blue-600 via-indigo-600 to-amber-400 absolute top-0 left-0"></div>

                <!-- Card Header -->
                <div class="mb-6">
                    <h1 class="font-sora font-extrabold text-2xl sm:text-3xl text-slate-900 tracking-tight mb-1">Welcome Back</h1>
                    <p class="text-xs sm:text-sm text-slate-500">Sign in to your account to manage your applications and career.</p>
                </div>

                <!-- VALIDATION ALERT TOASTS (CLEAN IF-ELSE CHAIN) -->
                <% if ("registered".equals(msg)) { %>
                    <div class="mb-6 p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                        <div class="flex items-center gap-2">
                            <i class="fas fa-circle-check text-emerald-600 text-sm"></i>
                            <span>Account created successfully! Please sign in with your credentials.</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="text-emerald-500 p-1 hover:text-emerald-700"><i class="fas fa-times"></i></button>
                    </div>
                <% } else if ("logout".equals(msg)) { %>
                    <div class="mb-6 p-4 bg-blue-50 border border-blue-200 text-blue-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                        <div class="flex items-center gap-2">
                            <i class="fas fa-circle-info text-blue-600 text-sm"></i>
                            <span>You have been logged out successfully.</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="text-blue-500 p-1 hover:text-blue-700"><i class="fas fa-times"></i></button>
                    </div>
                <% } else if ("accountDeleted".equals(msg)) { %>
                    <div class="mb-6 p-4 bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                        <div class="flex items-center gap-2">
                            <i class="fas fa-trash-alt text-rose-600 text-sm"></i>
                            <span>Your account has been permanently deleted from JobBoard.</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="text-rose-500 p-1 hover:text-rose-700"><i class="fas fa-times"></i></button>
                    </div>
                <% } else if ("error".equals(msg)) { %>
                    <div class="mb-6 p-4 bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                        <div class="flex items-center gap-2">
                            <i class="fas fa-circle-xmark text-rose-600 text-sm"></i>
                            <span>Invalid Email, Password or Role. Please try again.</span>
                        </div>
                        <button onclick="this.parentElement.remove()" class="text-rose-500 p-1 hover:text-rose-700"><i class="fas fa-times"></i></button>
                    </div>
                <% } %>

                <!-- Login Form -->
                <form action="UserController" method="post" class="space-y-5">
                    <input type="hidden" name="action" value="login">

                    <!-- Section Divider -->
                    <div class="flex items-center gap-2 border-b border-slate-100 pb-2">
                        <i class="fas fa-key text-blue-600 text-xs"></i>
                        <span class="font-sora text-xs font-bold text-slate-400 uppercase tracking-wider">Account Credentials</span>
                    </div>

                    <!-- Email Address -->
                    <div>
                        <label for="email" class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Email Address <span class="text-rose-500">*</span></label>
                        <div class="relative flex items-center">
                            <i class="fas fa-envelope absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                            <input type="email" id="email" name="email" class="custom-input" placeholder="john@email.com" required autocomplete="email">
                        </div>
                    </div>

                    <!-- Password -->
                    <div>
                        <div class="flex items-center justify-between mb-1.5">
                            <label for="password" class="block text-xs font-bold uppercase tracking-wider text-slate-600">Password <span class="text-rose-500">*</span></label>
                            <a href="forgotpassword.jsp" class="text-xs font-semibold text-blue-600 hover:text-blue-800 transition-colors">Forgot Password?</a>
                        </div>
                        <div class="relative flex items-center">
                            <i class="fas fa-lock absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                            <input type="password" id="password" name="password" class="custom-input pr-10" placeholder="••••••••" required autocomplete="current-password">
                            <button type="button" onclick="togglePasswordVisibility()" class="absolute right-3.5 text-slate-400 hover:text-slate-600 text-xs focus:outline-none">
                                <i class="fas fa-eye" id="togglePasswordIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Role Selection -->
                    <div>
                        <label for="role" class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Login Role <span class="text-rose-500">*</span></label>
                        <div class="relative flex items-center">
                            <i class="fas fa-user-tag absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                            <select name="role" id="role" class="custom-select">
                                <option value="JOBSEEKER">Job Seeker</option>
                                <option value="EMPLOYER">Employer / Recruiter</option>
                            </select>
                            <i class="fas fa-chevron-down absolute right-4 text-slate-400 text-xs pointer-events-none"></i>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-4 px-6 rounded-xl transition-all duration-200 shadow-md shadow-blue-500/20 flex items-center justify-center gap-2 group">
                        <span>Sign In</span>
                        <i class="fas fa-arrow-right text-xs group-hover:translate-x-1 transition-transform"></i>
                    </button>

                    <!-- Footer Links -->
                    <div class="pt-4 border-t border-slate-100 text-center space-y-1">
                        <p class="text-xs text-slate-500">
                            Don't have an account?
                            <a href="registration.jsp" class="font-bold text-blue-600 hover:text-blue-800 transition-colors ml-1">Create an account</a>
                        </p>
                    </div>
                </form>

            </div>

            <!-- Right Dark Feature Card -->
            <div class="lg:col-span-5 bg-slate-900 rounded-3xl p-8 sm:p-10 text-white flex flex-col justify-between relative overflow-hidden shadow-2xl min-h-[480px]">

                <!-- Background Glow -->
                <div class="absolute -right-20 -top-20 w-60 h-60 bg-indigo-600/20 rounded-full blur-3xl pointer-events-none"></div>
                <div class="absolute -left-20 -bottom-20 w-60 h-60 bg-blue-600/20 rounded-full blur-3xl pointer-events-none"></div>

                <div>
                    <!-- Badge -->
                    <div class="inline-flex items-center gap-2 bg-indigo-500/10 border border-indigo-500/30 rounded-full px-3.5 py-1 text-[11px] font-semibold text-indigo-400 mb-6">
                        <span class="w-1.5 h-1.5 rounded-full bg-indigo-400 inline-block animate-pulse"></span>
                        Member Portal
                    </div>

                    <h2 class="font-sora font-bold text-2xl sm:text-3xl text-white tracking-tight mb-3">
                        Manage Your Career Dashboard
                    </h2>
                    <p class="text-xs sm:text-sm text-slate-300 leading-relaxed mb-8 font-light">
                        Log in to pick up right where you left off and connect directly with top companies.
                    </p>

                    <!-- Unique Features List -->
                    <div class="space-y-5">
                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-indigo-500/20 text-indigo-400 border border-indigo-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-clock-rotate-left"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Live Application Tracker</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">Check real-time status of your submitted resumes</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-purple-500/20 text-purple-400 border border-purple-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-bookmark"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Saved Job Bookmarks</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">Quick access to positions saved for later</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-sky-500/20 text-sky-400 border border-sky-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Direct Recruiter Contact</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">Get interview invites straight to your inbox</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer Note -->
                <div class="pt-6 border-t border-white/10 mt-8 text-[11px] text-slate-400 flex items-center justify-between">
                    <span>© 2026 JobBoard Inc.</span>
                    <span class="text-indigo-400 font-semibold"><i class="fas fa-lock mr-1"></i> SSL Encrypted</span>
                </div>

            </div>

        </div>
    </main>

    <!-- Page Footer -->
    <footer class="py-6 text-center text-xs text-slate-400">
        <p>&copy; 2026 JobBoard. All rights reserved.</p>
    </footer>

    <!-- Toggle Password Script -->
    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('togglePasswordIcon');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>

</body>

</html>