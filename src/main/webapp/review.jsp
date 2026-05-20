<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Reviews | JobBoard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { font-family: 'DM Sans', sans-serif; background-color: #f8fafc; }
        .font-sora { font-family: 'Sora', sans-serif; }
        .review-card { transition: all 0.3s ease; }
        .review-card:hover { transform: translateY(-5px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body>

    <section class="py-16 bg-slate-900 text-center">
        <div class="max-w-7xl mx-auto px-5">
            <h1 class="text-4xl md:text-5xl font-bold text-white font-sora mb-4">What Our <span class="text-yellow-400">Users</span> Say</h1>
            <p class="text-slate-400 max-w-2xl mx-auto">Read how JobBoard has helped thousands of candidates find their dream jobs and companies find top talent.</p>
        </div>
    </section>

    <div class="max-w-7xl mx-auto px-5 -mt-10">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 text-center">
                <h3 class="text-3xl font-bold text-blue-600">4.9/5</h3>
                <p class="text-sm text-slate-500 font-medium uppercase tracking-wider">Average Rating</p>
            </div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 text-center">
                <h3 class="text-3xl font-bold text-blue-600">10k+</h3>
                <p class="text-sm text-slate-500 font-medium uppercase tracking-wider">Happy Candidates</p>
            </div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border border-slate-100 text-center">
                <h3 class="text-3xl font-bold text-blue-600">500+</h3>
                <p class="text-sm text-slate-500 font-medium uppercase tracking-wider">Verified Companies</p>
            </div>
        </div>
    </div>

    <main class="max-w-7xl mx-auto px-5 py-20">
        
        <% 
            String msg = request.getParameter("msg");
            if("success".equals(msg)) { 
        %>
            <div class="mb-10 p-4 bg-green-50 text-green-700 rounded-2xl border border-green-200 text-sm font-semibold max-w-3xl mx-auto">
                <i class="fa-solid fa-circle-check mr-2"></i> Review submitted successfully! It has been printed to your console trace.
            </div>
        <% } else if("invalidrating".equals(msg)) { %>
            <div class="mb-10 p-4 bg-amber-50 text-amber-700 rounded-2xl border border-amber-200 text-sm font-semibold max-w-3xl mx-auto">
                <i class="fa-solid fa-triangle-exclamation mr-2"></i> Invalid rating received. Please select between 1 and 5 stars.
            </div>
        <% } else if("error".equals(msg)) { %>
            <div class="mb-10 p-4 bg-red-50 text-red-700 rounded-2xl border border-red-200 text-sm font-semibold max-w-3xl mx-auto">
                <i class="fa-solid fa-circle-xmark mr-2"></i> System Error. Controller execution bypassed or failed.
            </div>
        <% } %>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            
            <div class="review-card bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
                <div class="flex gap-1 text-yellow-400 mb-4">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                </div>
                <p class="text-slate-600 italic mb-6">"JobBoard made my job search so easy. I applied for 3 positions and got shortlisted in two of them within a week!"</p>
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center font-bold text-blue-600">AJ</div>
                    <div>
                        <h4 class="font-bold text-slate-900">Amit Joshi</h4>
                        <p class="text-xs text-slate-400">Software Developer</p>
                    </div>
                </div>
            </div>

            <div class="review-card bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
                <div class="flex gap-1 text-yellow-400 mb-4">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                </div>
                <p class="text-slate-600 italic mb-6">"As an employer, the dashboard is very intuitive. Managing candidate resumes and tracking status is a breeze."</p>
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center font-bold text-green-600">NC</div>
                    <div>
                        <h4 class="font-bold text-slate-900">Nitesh Chaudhary</h4>
                        <p class="text-xs text-slate-400">HR Manager, Tech Corp</p>
                    </div>
                </div>
            </div>

            <div class="review-card bg-white p-8 rounded-3xl border border-slate-100 shadow-sm">
                <div class="flex gap-1 text-yellow-400 mb-4">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i>
                </div>
                <p class="text-slate-600 italic mb-6">"The email notification system is great. I get instant updates when my application is shortlisted or rejected."</p>
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center font-bold text-purple-600">DP</div>
                    <div>
                        <h4 class="font-bold text-slate-900">Darshan Patel</h4>
                        <p class="text-xs text-slate-400">UI/UX Designer</p>
                    </div>
                </div>
            </div>

        </div>

        <div class="mt-20 max-w-2xl mx-auto bg-white border border-slate-100 rounded-3xl p-8 shadow-sm">
            <h2 class="text-2xl font-bold font-sora text-slate-900 mb-2 text-center">Leave a Review</h2>
            <p class="text-slate-500 text-sm text-center mb-8">Share your experience working with the JobBoard professional application platform.</p>
            
            <form action="reviewController" method="post" class="space-y-5">
                <input type="hidden" name="action" value="review">

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Your Full Name</label>
                    <input type="text" name="name" required 
                           class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition" 
                           placeholder="e.g. Darshan Patel">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Rating</label>
                    <select name="rating" required 
                            class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition">
                        <option value="" disabled selected>Select stars</option>
                        <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                        <option value="4">⭐⭐⭐⭐ (4 - Good)</option>
                        <option value="3">⭐⭐⭐ (3 - Average)</option>
                        <option value="2">⭐⭐ (2 - Poor)</option>
                        <option value="1">⭐ (1 - Terrible)</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Your Message</label>
                    <textarea name="text" rows="4" required 
                              class="w-full px-4 py-3 rounded-xl border border-slate-200 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition" 
                              placeholder="Describe your user experience..."></textarea>
                </div>

                <button type="submit" 
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-xl transition duration-200 shadow-md">
                    Submit Feedback
                </button>
            </form>
        </div>

        <div class="mt-20 bg-blue-600 rounded-3xl p-10 text-center text-white shadow-xl shadow-blue-200">
            <h2 class="text-3xl font-bold font-sora mb-4">Ready to start your journey?</h2>
            <p class="mb-8 opacity-80">Join thousands of others who found success through JobBoard.</p>
            <div class="flex flex-wrap justify-center gap-4">
                <a href="register.jsp" class="bg-white text-blue-600 px-8 py-3 rounded-xl font-bold hover:bg-slate-50 transition-colors">Create Account</a>
                <a href="job-listings.jsp" class="bg-blue-700 text-white px-8 py-3 rounded-xl font-bold hover:bg-blue-800 transition-colors">Browse Jobs</a>
            </div>
        </div>
    </main>

    <footer class="py-10 text-center text-slate-400 text-sm border-t border-slate-100">
        &copy; 2026 JobBoard. All rights reserved.
    </footer>

</body>
</html>