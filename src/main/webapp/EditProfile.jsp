<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%
    UserModel u = (UserModel) session.getAttribute("Model");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String initial = (u.getFirstname() != null && !u.getFirstname().trim().isEmpty())
                     ? String.valueOf(u.getFirstname().trim().charAt(0)).toUpperCase() : "U";

    // Top-level Single Declaration for 'msg'
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile | JobBoard</title>

    <!-- Frameworks -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary: #1a56db;
            --secondary: #0f172a;
        }
        body {
            font-family: 'DM Sans', sans-serif;
            background-color: #f3f4f6;
        }
        .font-sora { font-family: 'Sora', sans-serif; }

        /* Glassmorphism Effect */
        .glass-nav {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* Sidebar Styling */
        .sidebar-link {
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            border-radius: 12px;
            color: #64748b;
        }
        .sidebar-link:hover, .sidebar-link.active {
            background-color: #eff6ff;
            color: #1a56db;
        }

        /* Form Styling */
        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            outline: none;
            transition: all 0.3s;
        }
        .form-input:focus {
            border-color: #1a56db;
            box-shadow: 0 0 0 4px rgba(26, 86, 219, 0.1);
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade { animation: fadeIn 0.5s ease-out; }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="glass-nav sticky top-0 z-50 py-4">
    <div class="max-w-7xl mx-auto px-6 flex justify-between items-center">
        <a href="user-home.jsp" class="font-sora text-2xl font-bold text-white tracking-tight">
            Job<span class="text-yellow-400">Board</span>
        </a>
        <div class="flex items-center gap-6">
            <a href="user-home.jsp" class="text-white/70 hover:text-white transition-colors text-sm font-medium">Dashboard</a>
            <div class="flex items-center gap-3 border-l border-white/20 pl-6">
                <div class="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center font-bold text-white">
                    <%= initial %>
                </div>
                <span class="text-white text-sm font-medium hidden md:block"><%= u.getFirstname() != null ? u.getFirstname() : "" %></span>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-6 py-10">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">

        <!-- SIDEBAR -->
        <aside class="lg:col-span-1 space-y-2">
            <div class="bg-white p-6 rounded-3xl shadow-sm mb-6 text-center">
                <div class="w-20 h-20 mx-auto rounded-3xl bg-slate-900 text-white flex items-center justify-center text-3xl font-bold mb-4 shadow-xl">
                    <%= initial %>
                </div>
                <h4 class="font-bold text-slate-900"><%= u.getFirstname() != null ? u.getFirstname() : "" %> <%= u.getLastname() != null ? u.getLastname() : "" %></h4>
                <p class="text-xs text-slate-400"><%= u.getEmail() != null ? u.getEmail() : "" %></p>
            </div>

            <nav class="space-y-1">
                <a href="ViewProfile.jsp" class="sidebar-link">
                    <i class="fas fa-user-circle"></i> View Profile
                </a>
                <a href="edit-profile.jsp" class="sidebar-link active">
                    <i class="fas fa-user-edit"></i> Edit Profile
                </a>
                <a href="Application-track.jsp" class="sidebar-link">
                    <i class="fas fa-briefcase"></i> My Applications
                </a>

                <hr class="my-4 border-slate-100">
                <a href="logout" class="sidebar-link text-red-500 hover:bg-red-50 hover:text-red-600">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </nav>
        </aside>

        <!-- MAIN FORM SECTION -->
        <main class="lg:col-span-3">
            <div class="bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden animate-fade">

                <!-- Form Header -->
                <div class="bg-slate-50 border-b border-slate-100 p-8">
                    <h3 class="text-2xl font-bold text-slate-900 font-sora">Profile Settings</h3>
                    <p class="text-slate-500 text-sm mt-1">Update your personal information and contact details.</p>
                </div>

                <!-- ALERT MESSAGES -->
                <div class="px-8 pt-6">
                    <% if ("updated".equals(msg) || "success".equals(msg)) { %>
                        <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                            <div class="flex items-center gap-2">
                                <i class="fas fa-circle-check text-emerald-600 text-sm"></i>
                                <span>Profile details updated successfully!</span>
                            </div>
                            <button onclick="this.parentElement.remove()" class="text-emerald-500 p-1 hover:text-emerald-700"><i class="fas fa-times"></i></button>
                        </div>
                    <% } else if ("failed".equals(msg) || "error".equals(msg)) { %>
                        <div class="p-4 bg-rose-50 border border-rose-200 text-rose-800 text-xs font-bold rounded-2xl flex items-center justify-between shadow-sm">
                            <div class="flex items-center gap-2">
                                <i class="fas fa-circle-xmark text-rose-600 text-sm"></i>
                                <span>Failed to update profile details. Please try again.</span>
                            </div>
                            <button onclick="this.parentElement.remove()" class="text-rose-500 p-1 hover:text-rose-700"><i class="fas fa-times"></i></button>
                        </div>
                    <% } %>
                </div>

                <!-- Form Body -->
                <form action="UserController" method="post" id="editProfileForm" class="p-8 space-y-8 pt-4">
                    <input type="hidden" name="action" value="updateProfile">
                    <input type="hidden" name="userid" value="<%= u.getUserid() %>">

                    <!-- Personal Info Section -->
                    <div class="space-y-6">
                        <div class="flex items-center gap-3 text-blue-600 mb-2">
                            <i class="fas fa-id-card"></i>
                            <h5 class="font-bold text-sm uppercase tracking-wider">Personal Information</h5>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">First Name <span class="text-rose-500">*</span></label>
                                <input type="text" name="fname" class="form-input"
                                       value="<%= (u.getFirstname() != null) ? u.getFirstname() : "" %>" required>
                            </div>
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">Last Name <span class="text-rose-500">*</span></label>
                                <input type="text" name="lname" class="form-input"
                                       value="<%= (u.getLastname() != null) ? u.getLastname() : "" %>" required>
                            </div>
                        </div>
                    </div>

                    <hr class="border-slate-100">

                    <!-- Contact & Location Section -->
                    <div class="space-y-6">
                        <div class="flex items-center gap-3 text-blue-600 mb-2">
                            <i class="fas fa-envelope-open-text"></i>
                            <h5 class="font-bold text-sm uppercase tracking-wider">Contact & Location</h5>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">Email Address</label>
                                <input type="email" name="email" class="form-input bg-slate-50 cursor-not-allowed"
                                       value="<%= (u.getEmail() != null) ? u.getEmail() : "" %>" readonly>
                                <p class="text-[10px] text-slate-400 italic">* Email cannot be changed</p>
                            </div>
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">Contact Number <span class="text-rose-500">*</span></label>
                                <input type="text" name="contact" class="form-input"
                                       value="<%= (u.getContact() != null) ? u.getContact() : "" %>" required>
                            </div>
                        </div>

                        <!-- Address Row -->
                        <div class="space-y-2">
                            <label class="text-sm font-semibold text-slate-700">Street Address</label>
                            <input type="text" name="address" class="form-input"
                                   value="<%= (u.getAddress() != null) ? u.getAddress() : "" %>" placeholder="House no., Street, Area">
                        </div>

                        <!-- City, State & Pincode Grid -->
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">City</label>
                                <input type="text" name="city" class="form-input"
                                       value="<%= (u.getCity() != null) ? u.getCity() : "" %>" placeholder="Ahmedabad">
                            </div>
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">State</label>
                                <input type="text" name="state" class="form-input"
                                       value="<%= (u.getState() != null) ? u.getState() : "" %>" placeholder="Gujarat">
                            </div>
                            <div class="space-y-2">
                                <label class="text-sm font-semibold text-slate-700">Pincode</label>
                                <input type="number" name="pincode" class="form-input"
                                       value="<%= (u.getPincode() != 0) ? u.getPincode() : "" %>" placeholder="380001">
                            </div>
                        </div>
                    </div>

                    <hr class="border-slate-100">

                    <!-- Action Buttons -->
                    <div class="flex flex-wrap items-center justify-between gap-4 pt-2">
                        <div class="flex items-center gap-4">
                            <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-10 rounded-xl shadow-lg shadow-blue-200 transition-all active:scale-95">
                                Save All Changes
                            </button>
                            <a href="ViewProfile.jsp" class="text-slate-500 hover:text-slate-800 font-semibold text-sm transition-colors">
                                Cancel
                            </a>
                        </div>

                        <p id="statusMsg" class="hidden text-green-600 text-sm font-medium">
                            <i class="fas fa-check-circle mr-1"></i> Data validated!
                        </p>
                    </div>
                </form>
            </div>

            <!-- Security Reminder Box -->
            <div class="mt-8 p-6 bg-amber-50 rounded-3xl border border-amber-100 flex gap-4 items-start">
                <div class="w-10 h-10 rounded-xl bg-amber-100 flex items-center justify-center text-amber-600 flex-shrink-0">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div>
                    <h6 class="font-bold text-amber-800 text-sm">Security Tip</h6>
                    <p class="text-xs text-amber-700 mt-1 leading-relaxed">
                        Make sure your contact information is up to date so that potential employers can reach you easily.
                        Your email address is used for authentication and cannot be updated directly.
                    </p>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- FOOTER -->
<footer class="py-10 text-center text-slate-400 text-sm bg-white border-t border-slate-100 mt-20">
    <div class="max-w-7xl mx-auto px-6">
        <p>&copy; 2026 JobBoard Recruitment Portal. All rights reserved.</p>
        <div class="flex justify-center gap-6 mt-4">
            <a href="#" class="hover:text-blue-600 transition-colors">Privacy Policy</a>
            <a href="#" class="hover:text-blue-600 transition-colors">Terms of Service</a>
            <a href="#" class="hover:text-blue-600 transition-colors">Support</a>
        </div>
    </div>
</footer>

<!-- SCRIPTS -->
<script>
    // Real-time Form Validation
    const form = document.getElementById('editProfileForm');
    const inputs = form.querySelectorAll('input');
    const statusMsg = document.getElementById('statusMsg');

    inputs.forEach(input => {
        input.addEventListener('input', () => {
            if (input.value.trim() !== "") {
                input.style.borderColor = "#1a56db";
            } else {
                input.style.borderColor = "#f87171";
            }

            let allValid = true;
            inputs.forEach(i => { if(i.hasAttribute('required') && i.value.trim() === "") allValid = false; });
            if(allValid) statusMsg.classList.remove('hidden');
            else statusMsg.classList.add('hidden');
        });
    });

    // Handle Form Submit Animation
    form.onsubmit = function() {
        const btn = form.querySelector('button[type="submit"]');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Updating...';
        btn.disabled = true;
        btn.classList.add('opacity-70', 'cursor-not-allowed');
    };
</script>

</body>
</html>