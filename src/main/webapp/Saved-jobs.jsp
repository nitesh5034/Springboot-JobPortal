<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel, com.model.Postjob" %>
<%@ page import="com.Repository.JobRepository" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="java.util.List, java.util.ArrayList" %>

<%
    // 1. Session Guard Check
    UserModel u = (UserModel) session.getAttribute("Model");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Fetch Repositories
    WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
    JobRepository jobRepo     = ctx.getBean(JobRepository.class);

    // 3. Fetch Saved Jobs
    List<Postjob> savedJobs = new ArrayList<>();
    try {
        savedJobs = jobRepo.findSavedJobsByUserId(u.getUserid());
    } catch (Exception e) {
        e.printStackTrace();
    }

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Saved Jobs | JobBoard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'DM Sans', sans-serif; background: #f8fafc; }
    .font-sora { font-family: 'Sora', sans-serif; }

    .page-hero {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 50%, #1a56db 100%);
      position: relative; overflow: hidden; padding: 40px 0 70px;
    }
    .page-hero::after {
      content: ''; position: absolute; inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
    }

    .job-card {
      background: white; border: 1.5px solid #e2e8f0;
      border-radius: 16px; padding: 20px 24px;
      transition: all 0.2s; position: relative;
      animation: fadeUp 0.4s ease both;
    }
    .job-card:hover {
      border-color: #1a56db;
      box-shadow: 0 4px 20px rgba(26,86,219,0.1);
      transform: translateY(-2px);
    }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(12px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    .company-initial {
      width: 48px; height: 48px; border-radius: 12px;
      background: linear-gradient(135deg, #eff6ff, #dbeafe);
      border: 1px solid #bfdbfe;
      display: flex; align-items: center; justify-content: center;
      font-family: 'Sora', sans-serif; font-weight: 800;
      font-size: 18px; color: #2563eb; flex-shrink: 0;
    }

    .btn-remove {
      background: #fef2f2; border: 1px solid #fecaca;
      color: #dc2626; font-size: 12px; font-weight: 600;
      padding: 8px 16px; border-radius: 10px;
      cursor: pointer; transition: all 0.2s;
      display: flex; align-items: center; gap: 6px;
    }
    .btn-remove:hover { background: #fee2e2; transform: translateY(-1px); }

    .btn-apply {
      background: #1a56db; color: white;
      font-size: 12px; font-weight: 600;
      padding: 8px 16px; border-radius: 10px;
      cursor: pointer; transition: all 0.2s;
      display: flex; align-items: center; gap: 6px;
      border: none;
    }
    .btn-apply:hover { background: #1347c0; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(26,86,219,0.3); }

    .toast {
      position: fixed; top: 20px; right: 20px;
      padding: 12px 18px; border-radius: 12px;
      font-size: 13px; font-weight: 600;
      display: flex; align-items: center; gap: 8px;
      z-index: 9999; animation: toastIn 0.3s ease;
    }
    .toast.success { background: #f0fdf4; border: 1px solid #bbf7d0; color: #16a34a; }
    .toast.info    { background: #fefce8; border: 1px solid #fde68a; color: #d97706; }
    @keyframes toastIn { from { opacity: 0; transform: translateX(20px); } to { opacity: 1; transform: translateX(0); } }

    .empty-state {
      text-align: center; padding: 80px 20px;
      background: white; border-radius: 20px;
      border: 1.5px dashed #e2e8f0;
    }

    /* Modal Backdrop */
    .modal-backdrop {
      display: none; position: fixed; inset: 0;
      background: rgba(15, 23, 42, 0.75);
      backdrop-filter: blur(4px);
      z-index: 999; align-items: center; justify-content: center;
    }
    .modal-backdrop.open { display: flex; }
  </style>
</head>
<body>

<!-- TOAST NOTIFICATIONS -->
<% if ("saved".equals(msg)) { %>
  <div class="toast success" id="toast"><i class="fas fa-bookmark"></i> Job saved successfully!</div>
<% } else if ("removed".equals(msg)) { %>
  <div class="toast info" id="toast"><i class="fas fa-trash"></i> Job removed from saved list.</div>
<% } else if ("applied".equals(msg)) { %>
  <div class="toast success" id="toast"><i class="fas fa-check-circle"></i> Application submitted successfully!</div>
<% } %>

<!-- HERO -->
<div class="page-hero">
  <div class="max-w-5xl mx-auto px-5 relative z-10">
    <a href="user-home.jsp" class="inline-flex items-center gap-2 text-white/50 hover:text-white text-xs mb-4 transition-all">
      <i class="fas fa-arrow-left"></i> Back to Home
    </a>
    <h1 class="font-sora text-2xl font-bold text-white mb-1">
      <i class="fas fa-bookmark text-yellow-400 mr-2"></i> Saved Jobs
    </h1>
    <p class="text-white/50 text-sm">
      <%= savedJobs.size() %> job<%= savedJobs.size() != 1 ? "s" : "" %> saved
    </p>
  </div>
</div>

<!-- CONTENT CONTAINER -->
<div class="max-w-5xl mx-auto px-5 -mt-8 pb-16">

  <% if (savedJobs.isEmpty()) { %>
    <div class="empty-state">
      <div class="w-16 h-16 rounded-2xl bg-blue-50 flex items-center justify-center mx-auto mb-4">
        <i class="fas fa-bookmark text-2xl text-blue-300"></i>
      </div>
      <h3 class="font-sora font-bold text-gray-700 text-lg mb-2">No Saved Jobs Yet</h3>
      <p class="text-sm text-gray-400 mb-6">Browse jobs and click Save to keep them here for later.</p>
      <a href="user-home.jsp" class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-semibold text-sm px-6 py-2.5 rounded-xl transition-all">
        <i class="fas fa-search text-xs"></i> Browse Jobs
      </a>
    </div>

  <% } else { %>
    <div class="space-y-4">
      <% for (Postjob job : savedJobs) {
           String jt = job.getJob_Type() != null ? job.getJob_Type().toLowerCase() : "";
           String initial = job.getCompany_name() != null && !job.getCompany_name().isEmpty()
               ? String.valueOf(job.getCompany_name().charAt(0)).toUpperCase() : "J";
           boolean isFull = jt.contains("full");
           boolean isPart = jt.contains("part");
           String badgeClass = isFull ? "bg-blue-50 text-blue-600 border-blue-100"
               : isPart ? "bg-green-50 text-green-600 border-green-100"
               : "bg-amber-50 text-amber-600 border-amber-100";
      %>
      <div class="job-card">
        <div style="display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap;">

          <!-- Job Details -->
          <div style="display:flex;align-items:center;gap:14px;flex:1;min-width:200px;">
            <div class="company-initial"><%= initial %></div>
            <div>
              <h3 style="font-size:15px;font-weight:700;color:#0f172a;margin-bottom:3px;">
                <%= job.getJob_Title() %>
                <span style="color:#2563eb;font-weight:400;font-size:13px;">@ <%= job.getCompany_name() %></span>
              </h3>
              <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-top:4px;">
                <span style="font-size:11px;font-weight:600;padding:3px 10px;border-radius:999px;border:1px solid;" class="<%= badgeClass %>">
                  <%= job.getJob_Type() %>
                </span>
                <span style="font-size:12px;color:#94a3b8;">
                  <i class="fas fa-map-marker-alt mr-1"></i><%= job.getLocation() %>
                </span>
                <span style="font-size:12px;color:#94a3b8;">
                  <i class="fas fa-rupee-sign mr-1"></i><%= job.getSalary() %>
                </span>
                <span style="font-size:12px;color:#94a3b8;">
                  <i class="fas fa-clock mr-1"></i><%= job.getExperience() %> yr exp
                </span>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div style="display:flex;align-items:center;gap:8px;flex-shrink:0;">

            <!-- Remove Form -->
            <form action="SaveJobServlet" method="post" style="display:inline;">
              <input type="hidden" name="jobId" value="<%= job.getJobId() %>">
              <input type="hidden" name="action" value="remove">
              <input type="hidden" name="userId" value="<%= u.getUserid() %>">
              <button type="submit" class="btn-remove">
                <i class="fas fa-trash-alt text-xs"></i> Remove
              </button>
            </form>

            <!-- DIRECT APPLY POPUP BUTTON -->
            <button type="button" class="btn-apply" onclick="openApplyModal('<%= job.getJobId() %>', '<%= job.getJob_Title() %>', '<%= job.getCompany_name() %>')">
              <i class="fas fa-paper-plane text-xs"></i> Apply Directly
            </button>

          </div>
        </div>

        <!-- Description Preview -->
        <% if (job.getJob_Description() != null && !job.getJob_Description().isEmpty()) { %>
        <div style="margin-top:12px;padding-top:12px;border-top:1px solid #f1f5f9;">
          <p style="font-size:12px;color:#64748b;line-height:1.6;">
            <%= job.getJob_Description().length() > 150
                ? job.getJob_Description().substring(0, 150) + "..."
                : job.getJob_Description() %>
          </p>
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
  <% } %>
</div>

<!-- ================= DIRECT APPLY MODAL ================= -->
<div id="applyModal" class="modal-backdrop">
  <div class="bg-white w-full max-w-lg rounded-2xl shadow-2xl overflow-hidden m-4 animate-fade-up">

    <!-- Modal Header -->
    <div class="bg-slate-900 text-white px-6 py-4 flex items-center justify-between">
      <div>
        <h3 class="font-sora font-bold text-base" id="modalJobTitle">Apply Position</h3>
        <p class="text-xs text-white/60" id="modalCompanyName">Company Name</p>
      </div>
      <button type="button" onclick="closeApplyModal()" class="text-white/60 hover:text-white text-lg">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <!-- Application Form -->
    <form action="ApplyServlet" method="post" enctype="multipart/form-data" class="p-6 space-y-4">
      <input type="hidden" name="jobId" id="modalJobId" value="">
      <input type="hidden" name="job_id" id="modalJobIdAlt" value="">

      <div>
        <label class="block text-xs font-bold uppercase text-gray-600 mb-1">Full Name</label>
        <input type="text" name="fullname" value="<%= u.getFirstname() != null ? u.getFirstname() + " " + (u.getLastname() != null ? u.getLastname() : "") : "" %>" class="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm outline-none focus:border-blue-600" required>
      </div>

      <div>
        <label class="block text-xs font-bold uppercase text-gray-600 mb-1">Email Address</label>
        <input type="email" name="email" value="<%= u.getEmail() != null ? u.getEmail() : "" %>" class="w-full border border-gray-200 bg-gray-50 text-gray-500 rounded-xl px-3.5 py-2.5 text-sm outline-none" readonly>
      </div>

      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-bold uppercase text-gray-600 mb-1">Contact Mobile</label>
          <input type="text" name="mobileno" value="<%= u.getContact() != null ? u.getContact() : "" %>" class="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm outline-none focus:border-blue-600" required>
        </div>
        <div>
          <label class="block text-xs font-bold uppercase text-gray-600 mb-1">City</label>
          <input type="text" name="city" value="<%= u.getCity() != null ? u.getCity() : "" %>" class="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm outline-none focus:border-blue-600" required>
        </div>
      </div>

      <div>
        <label class="block text-xs font-bold uppercase text-gray-600 mb-1">Total Experience (Years)</label>
        <input type="text" name="experience" placeholder="e.g. 2" class="w-full border border-gray-200 rounded-xl px-3.5 py-2.5 text-sm outline-none focus:border-blue-600" required>
      </div>

      <div>
        <label class="block text-xs font-bold uppercase text-gray-600 mb-1">Upload Resume (PDF / DOC)</label>
        <input type="file" name="resume" accept=".pdf,.doc,.docx" class="w-full border border-gray-200 rounded-xl px-3.5 py-2 text-xs text-gray-600 outline-none" required>
      </div>

      <!-- Action Buttons -->
      <div class="pt-3 flex items-center justify-end gap-3 border-t border-gray-100">
        <button type="button" onclick="closeApplyModal()" class="px-5 py-2.5 rounded-xl border border-gray-200 text-gray-600 hover:bg-gray-50 text-xs font-semibold">
          Cancel
        </button>
        <button type="submit" class="px-6 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-md">
          <i class="fas fa-paper-plane mr-1"></i> Submit Application
        </button>
      </div>

    </form>
  </div>
</div>

<script>
  function openApplyModal(jobId, jobTitle, companyName) {
    document.getElementById('modalJobId').value = jobId;
    document.getElementById('modalJobIdAlt').value = jobId;
    document.getElementById('modalJobTitle').innerText = 'Applying for: ' + jobTitle;
    document.getElementById('modalCompanyName').innerText = '@ ' + companyName;
    document.getElementById('applyModal').classList.add('open');
  }

  function closeApplyModal() {
    document.getElementById('applyModal').classList.remove('open');
  }

  const toast = document.getElementById('toast');
  if (toast) setTimeout(() => { toast.style.opacity = '0'; toast.style.transition = 'opacity 0.5s'; }, 3000);
</script>
</body>
</html>