<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.model.review" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.Repository.ReviewRepository" %>
<%
    // Session Guard Check
    UserModel u = (UserModel) session.getAttribute("Model");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch Review Repository
    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    ReviewRepository reviewRepo = ctx.getBean(ReviewRepository.class);

    List<review> allReviews = new ArrayList<>();
    List<review> myReviews  = new ArrayList<>();

    String uName = (u.getFirstname() != null ? u.getFirstname() : "") + " " + (u.getLastname() != null ? u.getLastname() : "");
    uName = uName.trim();
    String uEmail = u.getEmail() != null ? u.getEmail().trim() : "";

    double avgRating = 5.0;
    int totalRatingSum = 0;

    try {
        allReviews = reviewRepo.findAll();
        for (review r : allReviews) {
            totalRatingSum += r.getRating();
            if (r.getName() != null && r.getName().equalsIgnoreCase(uName)) {
                myReviews.add(r);
            }
        }
        if (!allReviews.isEmpty()) {
            avgRating = (double) totalRatingSum / allReviews.size();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Reviews | JobBoard</title>
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
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&family=Sora:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #f8fafc; color: #0f172a; }
        .font-sora { font-family: 'Sora', sans-serif; }

        /* HERO MESH GRADIENT */
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

        .review-card-hover { transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1); }
        .review-card-hover:hover { transform: translateY(-4px); box-shadow: 0 16px 35px -5px rgba(99, 102, 241, 0.15); border-color: #6366f1; }

        /* MODAL BACKDROP */
        .modal-backdrop {
          display: none; position: fixed; inset: 0;
          background: rgba(3, 7, 18, 0.85);
          backdrop-filter: blur(12px); z-index: 9999;
          align-items: center; justify-content: center; padding: 20px;
        }
        .modal-backdrop.active { display: flex; }
    </style>
</head>
<body class="antialiased">

    <!-- HERO HEADER WITH NAVIGATION -->
    <header class="hero-glow-mesh pt-12 pb-28 relative">
        <div class="max-w-6xl mx-auto px-6 relative z-10">
            <div class="flex items-center justify-between mb-10">
                <a href="user-home.jsp" class="inline-flex items-center gap-2 bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-semibold px-4 py-2.5 rounded-full transition-all backdrop-blur-md">
                    <i class="fas fa-arrow-left text-[11px] text-indigo-400"></i> Back to Home
                </a>
                <a href="user-home.jsp" class="font-sora font-extrabold text-2xl text-white tracking-tight flex items-center gap-2">
                    <div class="w-8 h-8 rounded-xl bg-blue-600 text-white flex items-center justify-center text-xs">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    Job<span class="text-blue-400">Board</span>
                </a>
            </div>

            <div class="text-center max-w-3xl mx-auto space-y-4">
                <div class="inline-flex items-center gap-2 bg-indigo-500/10 border border-indigo-500/30 rounded-full px-4 py-1.5 text-xs font-semibold text-indigo-300">
                    <i class="fas fa-star text-amber-400"></i> Community Experience & Reviews
                </div>
                <h1 class="text-3xl md:text-5xl font-extrabold text-white font-sora tracking-tight leading-tight">
                    Real Feedback from <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 via-indigo-300 to-purple-300">Verified Candidates</span>
                </h1>
                <p class="text-slate-300 text-xs md:text-sm font-normal max-w-xl mx-auto leading-relaxed">
                    Read feedback from developers and recruiters on JobBoard or click the button below to submit your experience.
                </p>

                <div class="pt-4">
                    <button type="button" onclick="openReviewModal()" class="inline-flex items-center gap-2.5 bg-gradient-to-r from-blue-600 via-indigo-600 to-purple-600 hover:from-blue-500 hover:to-purple-500 text-white font-sora font-bold text-xs uppercase tracking-wider py-4 px-8 rounded-2xl transition-all shadow-xl shadow-indigo-500/30">
                        <i class="fas fa-pen-to-square text-xs"></i> Write A Review
                    </button>
                </div>
            </div>
        </div>
    </header>

    <!-- LIVE STATS BANNER OVERLAY -->
    <section class="max-w-6xl mx-auto px-6 -mt-12 relative z-20">
        <div class="bg-white border border-slate-200/80 rounded-3xl p-6 md:p-8 shadow-xl">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-6 text-center">
                <div class="border-r border-slate-100 last:border-0">
                    <p class="font-sora text-3xl md:text-4xl font-extrabold text-blue-600 mb-1"><%= String.format("%.1f", avgRating) %></p>
                    <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Average Rating</p>
                </div>
                <div class="border-r border-slate-100 last:border-0">
                    <p class="font-sora text-3xl md:text-4xl font-extrabold text-slate-900 mb-1"><%= allReviews.size() %></p>
                    <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Total Reviews</p>
                </div>
                <div class="border-r border-slate-100 last:border-0">
                    <p class="font-sora text-3xl md:text-4xl font-extrabold text-slate-900 mb-1"><%= myReviews.size() %></p>
                    <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Your Reviews</p>
                </div>
                <div>
                    <p class="font-sora text-3xl md:text-4xl font-extrabold text-blue-600 mb-1">100%</p>
                    <p class="text-[11px] font-mono text-slate-500 uppercase tracking-widest">Verified Users</p>
                </div>
            </div>
        </div>
    </section>

    <!-- MAIN CONTENT AREA -->
    <main class="max-w-6xl mx-auto px-6 py-16">

        <!-- ALERT TOASTS -->
        <% if("success".equals(msg)) { %>
            <div class="mb-10 p-4 bg-emerald-50 text-emerald-800 rounded-2xl border border-emerald-200 text-xs font-bold flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-circle-check text-emerald-600 text-sm"></i> Review submitted! An email notification has been sent to Admin, Employer & your inbox.
                </div>
                <button onclick="this.parentElement.remove()" class="text-emerald-500 p-1"><i class="fas fa-times"></i></button>
            </div>
        <% } else if("deleted".equals(msg)) { %>
            <div class="mb-10 p-4 bg-amber-50 text-amber-800 rounded-2xl border border-amber-200 text-xs font-bold flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-trash-alt text-amber-600 text-sm"></i> Your review has been deleted successfully!
                </div>
                <button onclick="this.parentElement.remove()" class="text-amber-500 p-1"><i class="fas fa-times"></i></button>
            </div>
        <% } else if("error".equals(msg)) { %>
            <div class="mb-10 p-4 bg-rose-50 text-rose-800 rounded-2xl border border-rose-200 text-xs font-bold flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-circle-xmark text-rose-600 text-sm"></i> An error occurred while submitting feedback.
                </div>
                <button onclick="this.parentElement.remove()" class="text-rose-500 p-1"><i class="fas fa-times"></i></button>
            </div>
        <% } %>

        <!-- SECTION 1: MY POSTED REVIEWS -->
        <div class="mb-16 glass-card p-8">
            <div class="flex items-center justify-between border-b border-slate-100 pb-4 mb-6">
                <div>
                    <h2 class="text-xl font-extrabold font-sora text-slate-900">My Posted Reviews</h2>
                    <p class="text-xs text-slate-400 mt-0.5">Manage reviews posted under (<%= uName %>)</p>
                </div>
                <button type="button" onclick="openReviewModal()" class="bg-indigo-50 hover:bg-indigo-100 text-indigo-700 text-xs font-bold px-4 py-2 rounded-xl transition-all border border-indigo-100 flex items-center gap-1.5">
                    <i class="fas fa-plus text-[10px]"></i> Add Review
                </button>
            </div>

            <% if (myReviews.isEmpty()) { %>
                <div class="text-center py-10 bg-slate-50 rounded-2xl border border-dashed border-slate-200">
                    <i class="fas fa-comment-dots text-slate-300 text-3xl mb-2"></i>
                    <p class="text-xs font-bold text-slate-600">You haven't posted any reviews yet.</p>
                    <button type="button" onclick="openReviewModal()" class="text-xs font-bold text-blue-600 hover:text-blue-800 mt-2 inline-block">
                        Click here to leave a review
                    </button>
                </div>
            <% } else { %>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <% for (review myRev : myReviews) { %>
                        <div class="bg-slate-50 border border-slate-200 p-5 rounded-2xl flex items-start justify-between gap-4">
                            <div class="space-y-2">
                                <div class="flex items-center gap-1 text-amber-400 text-xs">
                                    <% for(int s = 0; s < myRev.getRating(); s++) { %>
                                        <i class="fas fa-star"></i>
                                    <% } %>
                                </div>
                                <p class="text-xs text-slate-700 leading-relaxed font-medium">"<%= myRev.getText() %>"</p>
                            </div>

                            <!-- DELETE FORM -->
                            <form action="reviewController" method="post" onsubmit="return confirm('Are you sure you want to delete this review?');" class="flex-shrink-0">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="reviewId" value="<%= myRev.getId() %>">
                                <button type="submit" class="w-8 h-8 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-600 border border-rose-200 flex items-center justify-center text-xs transition-all" title="Delete Review">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </form>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- SECTION 2: ALL COMMUNITY REVIEWS GRID -->
        <div>
            <div class="flex items-center justify-between mb-8">
                <div>
                    <p class="text-xs font-mono font-bold uppercase tracking-widest text-indigo-600 mb-1">— Verified Feedback</p>
                    <h2 class="text-2xl font-extrabold font-sora text-slate-900">Community Reviews</h2>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <% if (allReviews == null || allReviews.isEmpty()) { %>
                    <p class="text-xs text-slate-400 col-span-3 text-center py-10">No community reviews posted yet.</p>
                <% } else {
                    for (review rev : allReviews) {
                        String name = rev.getName() != null && !rev.getName().trim().isEmpty() ? rev.getName() : "Candidate";
                        String text = rev.getText() != null && !rev.getText().trim().isEmpty() ? rev.getText() : "";
                        int rating = rev.getRating() > 0 ? rev.getRating() : 5;
                        String initialChar = String.valueOf(name.charAt(0)).toUpperCase();
                %>
                    <div class="review-card-hover bg-white p-7 rounded-2xl border border-slate-200 shadow-sm space-y-4 flex flex-col justify-between">
                        <div class="space-y-3">
                            <div class="flex items-center gap-1 text-amber-400 text-xs">
                                <% for(int s = 0; s < rating; s++) { %>
                                    <i class="fas fa-star"></i>
                                <% } %>
                            </div>
                            <p class="text-xs text-slate-600 leading-relaxed italic">"<%= text %>"</p>
                        </div>

                        <div class="flex items-center gap-3 pt-4 border-t border-slate-100">
                            <div class="w-9 h-9 rounded-full bg-gradient-to-tr from-blue-600 to-indigo-600 text-white font-sora font-bold text-xs flex items-center justify-center shadow-sm">
                                <%= initialChar %>
                            </div>
                            <div>
                                <h4 class="font-bold text-xs text-slate-900"><%= name %></h4>
                                <p class="text-[10px] text-slate-400 font-mono">Verified Candidate</p>
                            </div>
                        </div>
                    </div>
                <%   }
                   } %>
            </div>
        </div>

    </main>

    <!-- ===== LEAVE A REVIEW MODAL POPUP ===== -->
    <div id="reviewModal" class="modal-backdrop">
        <div class="bg-white border border-slate-200 w-full max-w-lg rounded-3xl shadow-2xl overflow-hidden m-4 animate-fade-up">

            <!-- Modal Header -->
            <div class="bg-slate-900 text-white px-6 py-5 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <div class="w-7 h-7 rounded-lg bg-blue-600 text-white flex items-center justify-center text-xs">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3 class="font-sora font-bold text-base">Submit Candidate Review</h3>
                </div>
                <button type="button" onclick="closeReviewModal()" class="text-slate-400 hover:text-white text-base">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Modal Form -->
            <form action="reviewController" method="post" class="p-6 space-y-5">
                <input type="hidden" name="action" value="review">
                <input type="hidden" name="userEmail" value="<%= uEmail %>">

                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Your Full Name</label>
                    <input type="text" name="name" value="<%= uName %>" required readonly
                           class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-slate-100 text-slate-600 text-xs font-semibold outline-none cursor-not-allowed">
                </div>

                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Rating Experience</label>
                    <select name="rating" required
                            class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white text-xs font-semibold focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition cursor-pointer">
                        <option value="" disabled selected>Select rating score</option>
                        <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                        <option value="4">⭐⭐⭐⭐ (4 - Good)</option>
                        <option value="3">⭐⭐⭐ (3 - Average)</option>
                        <option value="2">⭐⭐ (2 - Poor)</option>
                        <option value="1">⭐ (1 - Terrible)</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-slate-600 mb-1.5">Your Feedback / Review Message</label>
                    <textarea name="text" rows="4" required
                              class="w-full px-4 py-3 rounded-xl border border-slate-200 bg-white text-xs font-medium focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition"
                              placeholder="Describe your candidate journey, application experience, or platform feedback..."></textarea>
                </div>

                <div class="pt-2 flex items-center justify-end gap-3 border-t border-slate-100">
                    <button type="button" onclick="closeReviewModal()" class="px-5 py-2.5 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 text-xs font-semibold">
                        Cancel
                    </button>
                    <button type="submit"
                            class="px-6 py-2.5 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider shadow-md shadow-blue-500/20 flex items-center gap-2">
                        <i class="fas fa-paper-plane text-xs"></i> Submit Review
                    </button>
                </div>
            </form>

        </div>
    </div>

    <!-- FOOTER -->
    <footer class="py-8 bg-slate-900 text-center text-slate-500 text-xs border-t border-slate-800 font-mono">
        &copy; 2026 JobBoard Portal. All rights reserved.
    </footer>

    <!-- MODAL TOGGLE SCRIPT -->
    <script>
        function openReviewModal() {
            document.getElementById('reviewModal').classList.add('active');
        }
        function closeReviewModal() {
            document.getElementById('reviewModal').classList.remove('active');
        }
    </script>

</body>
</html>