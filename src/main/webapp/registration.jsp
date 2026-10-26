<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Top-Level single declaration for 'msg' to prevent duplicate variable errors
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>JobBoard | Register</title>
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

    <!-- Main Split Screen Container -->
    <main class="max-w-6xl mx-auto px-4 py-12 w-full my-auto">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-stretch">

            <!-- Left Registration Form Card -->
            <div class="lg:col-span-7 bg-white rounded-3xl border border-slate-200 shadow-xl p-8 sm:p-10 relative overflow-hidden flex flex-col justify-between">

                <!-- Top Accent Strip -->
                <div class="h-1.5 w-full bg-gradient-to-r from-blue-600 via-indigo-600 to-amber-400 absolute top-0 left-0"></div>

                <div>
                    <!-- Form Header -->
                    <div class="mb-6">
                        <div class="inline-flex items-center gap-2 font-sora font-extrabold text-2xl text-slate-900 mb-2">
                            <div class="w-8 h-8 rounded-xl bg-blue-600 text-white flex items-center justify-center text-xs">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            Job<span class="text-blue-600">Board</span>
                        </div>
                        <h1 class="font-sora font-extrabold text-2xl sm:text-3xl text-slate-900 tracking-tight mb-1">Create Your Account</h1>
                        <p class="text-xs sm:text-sm text-slate-500">Fill in the details below to get started on JobBoard.</p>
                    </div>

                    <!-- VALIDATION ALERT NOTIFICATIONS -->
                    <div id="jsErrorAlert" class="hidden mb-6 p-4 bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                        <div class="flex items-center gap-2">
                            <i class="fas fa-circle-xmark text-rose-600 text-sm"></i>
                            <span id="jsErrorMsg">Passwords do not match!</span>
                        </div>
                        <button type="button" onclick="this.parentElement.classList.add('hidden')" class="text-rose-500 p-1 hover:text-rose-700"><i class="fas fa-times"></i></button>
                    </div>

                    <% if ("failed".equals(msg)) { %>
                        <div class="mb-6 p-4 bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                            <div class="flex items-center gap-2">
                                <i class="fas fa-circle-xmark text-rose-600 text-sm"></i>
                                <span>Registration failed. This email may already be registered or details were invalid.</span>
                            </div>
                            <button type="button" onclick="this.parentElement.remove()" class="text-rose-500 p-1 hover:text-rose-700"><i class="fas fa-times"></i></button>
                        </div>
                    <% } else if ("passmismatch".equals(msg)) { %>
                        <div class="mb-6 p-4 bg-amber-50 border border-amber-200 text-amber-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                            <div class="flex items-center gap-2">
                                <i class="fas fa-triangle-exclamation text-amber-600 text-sm"></i>
                                <span>Passwords did not match. Please enter identical passwords.</span>
                            </div>
                            <button type="button" onclick="this.parentElement.remove()" class="text-amber-500 p-1 hover:text-amber-700"><i class="fas fa-times"></i></button>
                        </div>
                    <% } %>

                    <!-- Registration Form -->
                    <form action="UserController" method="post" onsubmit="return validateRegisterForm()" class="space-y-6">
                        <input type="hidden" name="action" value="register">

                        <!-- SECTION 1: PERSONAL INFO -->
                        <div class="space-y-4">
                            <div class="flex items-center gap-2 border-b border-slate-100 pb-2">
                                <i class="fas fa-user text-blue-600 text-xs"></i>
                                <span class="font-sora text-xs font-bold text-slate-400 uppercase tracking-wider">Personal Info</span>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">First Name <span class="text-rose-500">*</span></label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-user absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="text" name="fname" class="custom-input" placeholder="John" required>
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Last Name <span class="text-rose-500">*</span></label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-user absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="text" name="lname" class="custom-input" placeholder="Doe" required>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Email <span class="text-rose-500">*</span></label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-envelope absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="email" name="email" class="custom-input" placeholder="john@email.com" required>
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Contact <span class="text-rose-500">*</span></label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-phone absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="tel" name="contact" pattern="[0-9]{10}" title="Please enter a valid 10-digit mobile number" class="custom-input" placeholder="9876543210" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- SECTION 2: ADDRESS DETAILS -->
                        <div class="space-y-4">
                            <div class="flex items-center gap-2 border-b border-slate-100 pb-2">
                                <i class="fas fa-map-marker-alt text-blue-600 text-xs"></i>
                                <span class="font-sora text-xs font-bold text-slate-400 uppercase tracking-wider">Address</span>
                            </div>

                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Address</label>
                                <div class="relative flex items-center">
                                    <i class="fas fa-home absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                    <input type="text" name="address" class="custom-input" placeholder="Street address">
                                </div>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">City</label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-city absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="text" name="city" class="custom-input" placeholder="Ahmedabad">
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">State</label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-map absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="text" name="state" class="custom-input" placeholder="Gujarat">
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Pincode</label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-hashtag absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="text" name="pincode" pattern="[0-9]{6}" title="Please enter 6-digit Pincode" class="custom-input" placeholder="380001">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- SECTION 3: ACCOUNT SETUP -->
                        <div class="space-y-4">
                            <div class="flex items-center gap-2 border-b border-slate-100 pb-2">
                                <i class="fas fa-shield-alt text-blue-600 text-xs"></i>
                                <span class="font-sora text-xs font-bold text-slate-400 uppercase tracking-wider">Account Setup</span>
                            </div>

                            <div>
                                <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Register As <span class="text-rose-500">*</span></label>
                                <div class="relative flex items-center">
                                    <i class="fas fa-briefcase absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                    <select name="role" class="custom-select" required>
                                        <option value="">-- Select Role --</option>
                                        <option value="JOBSEEKER">Job Seeker</option>
                                        <option value="EMPLOYER">Employer</option>
                                    </select>
                                    <i class="fas fa-chevron-down absolute right-4 text-slate-400 text-xs pointer-events-none"></i>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Password <span class="text-rose-500">*</span></label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-lock absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="password" name="password" id="pass1" minlength="6" class="custom-input pr-10" placeholder="Min 6 characters" required>
                                        <button type="button" onclick="togglePass('pass1','eye1')" class="absolute right-3.5 text-slate-400 hover:text-slate-600 text-xs focus:outline-none">
                                            <i class="fas fa-eye" id="eye1"></i>
                                        </button>
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Retype Password <span class="text-rose-500">*</span></label>
                                    <div class="relative flex items-center">
                                        <i class="fas fa-lock absolute left-4 text-slate-400 text-xs pointer-events-none"></i>
                                        <input type="password" name="repassword" id="pass2" minlength="6" class="custom-input pr-10" placeholder="Repeat password" required>
                                        <button type="button" onclick="togglePass('pass2','eye2')" class="absolute right-3.5 text-slate-400 hover:text-slate-600 text-xs focus:outline-none">
                                            <i class="fas fa-eye" id="eye2"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-4 px-6 rounded-xl transition-all duration-200 shadow-md shadow-blue-500/20 flex items-center justify-center gap-2 group">
                            <i class="fas fa-user-plus text-xs"></i>
                            <span>Create Account</span>
                        </button>

                        <!-- Login Footer Link -->
                        <div class="pt-4 border-t border-slate-100 text-center">
                            <p class="text-xs text-slate-500">
                                Already have an account?
                                <a href="login.jsp" class="font-bold text-blue-600 hover:text-blue-800 transition-colors ml-1">Sign In</a>
                            </p>
                        </div>
                    </form>
                </div>

            </div>

            <!-- Right Dark Feature Panel -->
            <div class="lg:col-span-5 bg-slate-900 rounded-3xl p-8 sm:p-10 text-white flex flex-col justify-between relative overflow-hidden shadow-2xl min-h-[500px]">

                <!-- Background Glow -->
                <div class="absolute -right-20 -top-20 w-60 h-60 bg-blue-600/20 rounded-full blur-3xl pointer-events-none"></div>
                <div class="absolute -left-20 -bottom-20 w-60 h-60 bg-indigo-600/20 rounded-full blur-3xl pointer-events-none"></div>

                <div>
                    <!-- Badge -->
                    <div class="inline-flex items-center gap-2 bg-amber-500/10 border border-amber-500/30 rounded-full px-3.5 py-1 text-[11px] font-semibold text-amber-400 mb-6">
                        <span class="w-1.5 h-1.5 rounded-full bg-amber-400 inline-block animate-pulse"></span>
                        Why Join JobBoard?
                    </div>

                    <h2 class="font-sora font-bold text-2xl sm:text-3xl text-white tracking-tight mb-3">
                        Find Your Dream Job Today
                    </h2>
                    <p class="text-xs sm:text-sm text-slate-300 leading-relaxed mb-8 font-light">
                        Join thousands of professionals and employers on India's fastest growing job platform.
                    </p>

                    <!-- Feature List -->
                    <div class="space-y-6">

                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-blue-500/20 text-blue-400 border border-blue-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-search"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Smart Job Search</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">Find jobs matching your skills instantly</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-bell"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Instant Alerts</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">Get notified for new matching jobs</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-amber-500/20 text-amber-400 border border-amber-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Easy Apply</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">One-click apply to top companies</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-4">
                            <div class="w-10 h-10 rounded-2xl bg-purple-500/20 text-purple-400 border border-purple-500/30 flex items-center justify-center text-sm font-bold flex-shrink-0">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div>
                                <h3 class="font-sora font-bold text-xs text-white">Career Growth</h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">Track applications and grow faster</p>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- Footer Note -->
                <div class="pt-6 border-t border-white/10 mt-8 text-[11px] text-slate-400 flex items-center justify-between">
                    <span>© 2026 JobBoard Inc.</span>
                    <span class="text-emerald-400 font-semibold"><i class="fas fa-shield-alt mr-1"></i> 100% Secure</span>
                </div>

            </div>

        </div>
    </main>

    <!-- Detailed Footer Section -->
    <footer class="bg-slate-900 text-slate-400 pt-12 pb-8 border-t border-slate-800 mt-12">
        <div class="max-w-6xl mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8 pb-10 border-b border-slate-800">

                <!-- About JobBoard -->
                <div class="space-y-3">
                    <div class="font-sora font-extrabold text-xl text-white tracking-tight flex items-center gap-2">
                        <div class="w-7 h-7 rounded-lg bg-blue-600 text-white flex items-center justify-center text-xs">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        Job<span class="text-blue-500">Board</span>
                    </div>
                    <p class="text-xs text-slate-400 leading-relaxed">
                        India's premier career network connecting top talent with industry-leading companies and recruiters.
                    </p>
                </div>

                <!-- Quick Navigation -->
                <div>
                    <h4 class="font-sora text-xs font-bold uppercase tracking-wider text-slate-200 mb-3">Portal</h4>
                    <ul class="space-y-2 text-xs">
                        <li><a href="login.jsp" class="hover:text-white transition-colors">Sign In</a></li>
                        <li><a href="registration.jsp" class="hover:text-white transition-colors">Candidate Sign Up</a></li>
                        <li><a href="registration.jsp" class="hover:text-white transition-colors">Employer Portal</a></li>
                    </ul>
                </div>

                <!-- Platform Features -->
                <div>
                    <h4 class="font-sora text-xs font-bold uppercase tracking-wider text-slate-200 mb-3">Features</h4>
                    <ul class="space-y-2 text-xs">
                        <li><span class="hover:text-white transition-colors">Real-time Application Status</span></li>
                        <li><span class="hover:text-white transition-colors">Verified Enterprise Companies</span></li>
                        <li><span class="hover:text-white transition-colors">Resume Processing Engine</span></li>
                    </ul>
                </div>

                <!-- Contact & Support Info -->
                <div>
                    <h4 class="font-sora text-xs font-bold uppercase tracking-wider text-slate-200 mb-3">Support</h4>
                    <p class="text-xs text-slate-400 mb-2"><i class="fas fa-envelope text-blue-500 mr-2"></i> support@jobboard.com</p>
                    <p class="text-xs text-slate-400"><i class="fas fa-location-dot text-blue-500 mr-2"></i> SG Highway, Ahmedabad, Gujarat</p>
                </div>

            </div>

            <div class="pt-6 text-center text-xs text-slate-500 font-mono">
                &copy; 2026 JobBoard Portal. All rights reserved.
            </div>
        </div>
    </footer>

    <!-- Toggle Password Script & Validation Script -->
    <script>
        function togglePass(fieldId, iconId) {
            const f = document.getElementById(fieldId);
            const i = document.getElementById(iconId);
            if (f.type === 'password') {
                f.type = 'text';
                i.classList.remove('fa-eye');
                i.classList.add('fa-eye-slash');
            } else {
                f.type = 'password';
                i.classList.remove('fa-eye-slash');
                i.classList.add('fa-eye');
            }
        }

        function validateRegisterForm() {
            const p1 = document.getElementById('pass1').value;
            const p2 = document.getElementById('pass2').value;
            const errDiv = document.getElementById('jsErrorAlert');
            const errTxt = document.getElementById('jsErrorMsg');

            if (p1 !== p2) {
                errTxt.innerText = "Password and Retype Password do not match!";
                errDiv.classList.remove('hidden');
                return false;
            }
            errDiv.classList.add('hidden');
            return true;
        }
    </script>

</body>

</html>