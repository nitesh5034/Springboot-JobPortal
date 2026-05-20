<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.companyverify" %>
<%@ page import="com.dao.CompanyDao" %>
<%@ page import="com.dao.postjobdao" %>
<%
    com.model.companyverify u = (com.model.companyverify) session.getAttribute("Model");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    CompanyDao companyDAO = new CompanyDao();
    postjobdao jobDAO = new postjobdao();
    
    int totalApps = 0, totalJobs = 0, liveCandidates = 0;
    try {
        totalApps = companyDAO.getTotalApplications(); 
        totalJobs = jobDAO.getTotalJobs();
        liveCandidates = companyDAO.getTotalCandidates();
    } catch(Exception e) { 
        e.printStackTrace();
    }

    String initial = (u.getCompanyname() != null && !u.getCompanyname().isEmpty())
        ? String.valueOf(u.getCompanyname().charAt(0)).toUpperCase() : "E";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post New Job | JobBoard</title>
    
    <script src="[cdn.tailwindcss.com](https://cdn.tailwindcss.com)"></script>
    <link href="[fonts.googleapis.com](https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap)" rel="stylesheet">
    <link rel="stylesheet" href="[cdnjs.cloudflare.com](https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css)">

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
                    },
                    colors: {
                        brand: {
                            50: '#eef2ff',
                            100: '#e0e7ff',
                            500: '#6366f1',
                            600: '#4f46e5',
                            700: '#4338ca',
                            900: '#1e1b4b'
                        }
                    }
                }
            }
        }
    </script>

    <style>
        * { font-family: 'Inter', sans-serif; }
        body { background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%); min-height: 100vh; }
        
        /* Smooth Loading */
        .page-loader {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
        }
        
        /* Card Styles */
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.8);
        }
        
        /* Input Styles */
        .input-group {
            position: relative;
            transition: all 0.3s ease;
        }
        .input-group:focus-within {
            transform: translateY(-2px);
        }
        .input-group:focus-within .input-label {
            color: #4f46e5;
        }
        .input-group:focus-within .input-field {
            border-color: #4f46e5;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }
        
        .input-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            margin-bottom: 8px;
            display: block;
            transition: color 0.3s ease;
        }
        
        .input-field {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 500;
            color: #1e293b;
            background: #fff;
            transition: all 0.3s ease;
            outline: none;
        }
        .input-field::placeholder {
            color: #94a3b8;
            font-weight: 400;
        }
        
        /* Step Animation */
        .step-panel {
            display: none;
            animation: slideIn 0.5s ease forwards;
        }
        .step-panel.active {
            display: block;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        /* Progress Bar */
        .progress-step {
            height: 4px;
            background: #e2e8f0;
            border-radius: 2px;
            overflow: hidden;
            position: relative;
        }
        .progress-step::after {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, #4f46e5, #7c3aed);
            transition: width 0.5s ease;
        }
        .progress-step.done::after { width: 100%; }
        
        /* Stat Cards */
        .stat-card {
            background: linear-gradient(135deg, #fff 0%, #fafafa 100%);
            border: 1px solid #f1f5f9;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px -12px rgba(0,0,0,0.1);
        }
        
        /* Button Hover */
        .btn-primary {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px -5px rgba(79, 70, 229, 0.4);
        }
        
        /* Scrollbar */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #f1f5f9; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }
    </style>
</head>
<body class="antialiased">

<!-- Loader -->
<div id="pageLoader" class="page-loader fixed inset-0 z-[200] flex items-center justify-center transition-opacity duration-500">
    <div class="text-center">
        <div class="w-12 h-12 border-3 border-white/20 border-t-white rounded-full animate-spin mx-auto mb-4"></div>
        <p class="text-white/60 text-xs font-semibold tracking-wider uppercase">Loading...</p>
    </div>
</div>

<!-- Navbar -->
<nav class="sticky top-0 z-50 bg-white/80 backdrop-blur-xl border-b border-slate-100">
    <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
        <div class="flex items-center gap-8">
            <a href="companyhome.jsp" class="flex items-center gap-2.5">
                <div class="w-9 h-9 bg-brand-600 rounded-xl flex items-center justify-center">
                    <i class="fas fa-briefcase text-white text-sm"></i>
                </div>
                <span class="font-bold text-xl text-slate-800">JobBoard</span>
            </a>
            
            <div class="hidden md:flex items-center gap-1 ml-8">
                <a href="companyhome.jsp" class="px-4 py-2 text-sm font-medium text-slate-500 hover:text-slate-900 rounded-lg hover:bg-slate-50 transition-all">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
                <a href="postjob.jsp" class="px-4 py-2 text-sm font-medium text-brand-600 bg-brand-50 rounded-lg">
                    <i class="fas fa-plus mr-2"></i>Post Job
                </a>
                <a href="viewapplications.jsp" class="px-4 py-2 text-sm font-medium text-slate-500 hover:text-slate-900 rounded-lg hover:bg-slate-50 transition-all">
                    <i class="fas fa-users mr-2"></i>Applications
                </a>
            </div>
        </div>

        <div class="flex items-center gap-4">
            <div class="hidden sm:block text-right mr-3">
                <p class="text-sm font-semibold text-slate-800"><%= u.getCompanyname() %></p>
                <p class="text-xs text-slate-400">Employer Account</p>
            </div>
            <div class="w-10 h-10 rounded-full bg-gradient-to-br from-brand-500 to-purple-500 text-white flex items-center justify-center font-bold text-sm shadow-lg">
                <%= initial %>
            </div>
        </div>
    </div>
</nav>

<main class="max-w-7xl mx-auto px-6 py-10">
    
    <!-- Header -->
    <div class="mb-10">
        <h1 class="text-3xl font-bold text-slate-900 mb-2">Post a New Job</h1>
        <p class="text-slate-500">Fill in the details below to create your job listing</p>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Sidebar Stats -->
        <div class="lg:col-span-1 space-y-6">
            
            <!-- Quick Stats -->
            <div class="glass-card rounded-2xl p-6 shadow-lg">
                <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-6">Platform Stats</h3>
                
                <div class="space-y-4">
                    <div class="stat-card rounded-xl p-4 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-blue-50 text-blue-500 flex items-center justify-center">
                            <i class="fas fa-users"></i>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-slate-800"><%= liveCandidates %>K+</p>
                            <p class="text-xs text-slate-400 font-medium">Active Candidates</p>
                        </div>
                    </div>
                    
                    <div class="stat-card rounded-xl p-4 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-green-50 text-green-500 flex items-center justify-center">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-slate-800"><%= totalApps %></p>
                            <p class="text-xs text-slate-400 font-medium">Total Applications</p>
                        </div>
                    </div>
                    
                    <div class="stat-card rounded-xl p-4 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-purple-50 text-purple-500 flex items-center justify-center">
                            <i class="fas fa-briefcase"></i>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-slate-800"><%= totalJobs %></p>
                            <p class="text-xs text-slate-400 font-medium">Live Jobs</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Tips Card -->
            <div class="glass-card rounded-2xl p-6 shadow-lg">
                <h3 class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-4">
                    <i class="fas fa-lightbulb text-yellow-500 mr-2"></i>Tips
                </h3>
                <ul class="space-y-3 text-sm text-slate-600">
                    <li class="flex items-start gap-2">
                        <i class="fas fa-check-circle text-green-500 mt-0.5"></i>
                        <span>Use clear, specific job titles</span>
                    </li>
                    <li class="flex items-start gap-2">
                        <i class="fas fa-check-circle text-green-500 mt-0.5"></i>
                        <span>List 5-7 key skills required</span>
                    </li>
                    <li class="flex items-start gap-2">
                        <i class="fas fa-check-circle text-green-500 mt-0.5"></i>
                        <span>Include salary range for more applications</span>
                    </li>
                </ul>
            </div>
        </div>
        
        <!-- Form Section -->
        <div class="lg:col-span-2">
            <div class="glass-card rounded-3xl shadow-xl overflow-hidden">
                
                <!-- Progress Bar -->
                <div class="px-8 pt-8">
                    <div class="flex items-center gap-3 mb-2">
                        <span class="text-xs font-semibold text-brand-600">Step <span id="currentStep">1</span> of 3</span>
                    </div>
                    <div class="flex gap-2">
                        <div class="progress-step flex-1 done" id="prog1"></div>
                        <div class="progress-step flex-1" id="prog2"></div>
                        <div class="progress-step flex-1" id="prog3"></div>
                    </div>
                </div>
                
                <form action="JobController" method="post" id="jobForm" class="p-8">
                    <input type="hidden" name="action" value="postJob">

                    <!-- Step 1: Basic Info -->
                    <div class="step-panel active" id="step1">
                        <div class="flex items-center gap-4 mb-8">
                            <div class="w-12 h-12 rounded-2xl bg-brand-100 text-brand-600 flex items-center justify-center">
                                <i class="fas fa-building"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-800">Basic Information</h2>
                                <p class="text-sm text-slate-400">Company and job basics</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="input-group">
                                <label class="input-label">Company Name</label>
                                <input type="text" name="company_name" value="<%= u.getCompanyname() %>" class="input-field" required>
                            </div>
                            <div class="input-group">
                                <label class="input-label">Contact Email</label>
                                <input type="email" name="email" value="<%= u.getEmail() %>" class="input-field" required>
                            </div>
                            <div class="input-group md:col-span-2">
                                <label class="input-label">Job Title</label>
                                <input type="text" name="Job_Title" placeholder="e.g. Senior Software Engineer" class="input-field" required>
                            </div>
                            <div class="input-group">
                                <label class="input-label">Number of Openings</label>
                                <input type="number" name="opening" placeholder="e.g. 5" class="input-field" required>
                            </div>
                            <div class="input-group">
                                <label class="input-label">Annual Salary (₹)</label>
                                <input type="text" name="salary" placeholder="e.g. 12,00,000" class="input-field" required>
                            </div>
                        </div>
                        
                        <div class="mt-8 flex justify-end">
                            <button type="button" onclick="goToStep(2)" class="btn-primary text-white px-8 py-3 rounded-xl font-semibold text-sm flex items-center gap-2">
                                Continue <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Step 2: Location -->
                    <div class="step-panel" id="step2">
                        <div class="flex items-center gap-4 mb-8">
                            <div class="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-600 flex items-center justify-center">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-800">Location & Type</h2>
                                <p class="text-sm text-slate-400">Where and how they'll work</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="input-group">
                                <label class="input-label">City</label>
                                <input type="text" name="Location" placeholder="e.g. Mumbai, Bangalore" class="input-field" required>
                            </div>
                            <div class="input-group">
                                <label class="input-label">State/Region</label>
                                <input type="text" name="job_Region" placeholder="e.g. Maharashtra" class="input-field" required>
                            </div>
                            <div class="input-group md:col-span-2">
                                <label class="input-label">Employment Type</label>
                                <select name="job_Type" class="input-field cursor-pointer">
                                    <option value="Full Time">Full-Time</option>
                                    <option value="Part Time">Part-Time</option>
                                    <option value="Contract">Contract</option>
                                    <option value="Internship">Internship</option>
                                    <option value="Remote">Remote</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-8 flex justify-between">
                            <button type="button" onclick="goToStep(1)" class="text-slate-400 hover:text-slate-600 font-semibold text-sm flex items-center gap-2">
                                <i class="fas fa-arrow-left"></i> Back
                            </button>
                            <button type="button" onclick="goToStep(3)" class="btn-primary text-white px-8 py-3 rounded-xl font-semibold text-sm flex items-center gap-2">
                                Continue <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Step 3: Requirements -->
                    <div class="step-panel" id="step3">
                        <div class="flex items-center gap-4 mb-8">
                            <div class="w-12 h-12 rounded-2xl bg-amber-100 text-amber-600 flex items-center justify-center">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-800">Requirements</h2>
                                <p class="text-sm text-slate-400">Skills and description</p>
                            </div>
                        </div>

                        <div class="space-y-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div class="input-group">
                                    <label class="input-label">Experience Required</label>
                                    <input type="text" name="experience" placeholder="e.g. 3-5 years" class="input-field" required>
                                </div>
                                <div class="input-group">
                                    <label class="input-label">Required Skills</label>
                                    <input type="text" name="skills_req" placeholder="e.g. Java, React, SQL" class="input-field" required>
                                </div>
                            </div>
                            
                            <div class="input-group">
                                <label class="input-label">Job Description</label>
                                <textarea name="job_Description" id="descBox" rows="8" placeholder="Describe the role, responsibilities, and what you're looking for..." class="input-field resize-none" required></textarea>
                                <div class="flex justify-end mt-2">
                                    <span class="text-xs text-slate-400"><span id="charCount" class="text-brand-600 font-semibold">0</span> / 5000</span>
                                </div>
                            </div>
                        </div>

                        <div class="mt-8 flex justify-between items-center">
                            <button type="button" onclick="goToStep(2)" class="text-slate-400 hover:text-slate-600 font-semibold text-sm flex items-center gap-2">
                                <i class="fas fa-arrow-left"></i> Back
                            </button>
                            <button type="submit" id="submitBtn" class="bg-gradient-to-r from-brand-600 to-purple-600 text-white px-10 py-4 rounded-xl font-bold text-sm flex items-center gap-3 shadow-lg hover:shadow-xl transition-all">
                                <i class="fas fa-paper-plane"></i> Post Job
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-slate-900 mt-20 py-12 text-center">
    <p class="text-slate-400 text-sm font-medium mb-2">JobBoard</p>
    <p class="text-slate-500 text-xs">&copy; 2025 All rights reserved</p>
</footer>

<script>
    // Page Load
    window.addEventListener('load', () => {
        setTimeout(() => {
            document.getElementById('pageLoader').style.opacity = '0';
            setTimeout(() => {
                document.getElementById('pageLoader').style.display = 'none';
            }, 500);
        }, 800);
    });

    // Step Navigation
    function goToStep(step) {
        document.querySelectorAll('.step-panel').forEach(p => p.classList.remove('active'));
        document.getElementById('step' + step).classList.add('active');
        document.getElementById('currentStep').textContent = step;
        
        // Update progress
        for(let i = 1; i <= 3; i++) {
            const prog = document.getElementById('prog' + i);
            if(i <= step) prog.classList.add('done');
            else prog.classList.remove('done');
        }
        
        window.scrollTo({ top: 150, behavior: 'smooth' });
    }

    // Character Counter
    const descBox = document.getElementById('descBox');
    const charCount = document.getElementById('charCount');
    descBox.addEventListener('input', () => {
        charCount.textContent = descBox.value.length;
    });

    // Form Submit
    document.getElementById('jobForm').addEventListener('submit', function() {
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner animate-spin"></i> Posting...';
    });
</script>
</body>
</html>
