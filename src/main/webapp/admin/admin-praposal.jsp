<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.model.Proposal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // =====================================================
    // 1. SESSION GUARD
    // =====================================================

    Object sessionModel = session.getAttribute("Model");

    if (sessionModel == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/admin-login"
        );
        return;
    }


    // =====================================================
    // 2. GET PROPOSALS FROM CONTROLLER
    // =====================================================

    List<Proposal> proposals =
        (List<Proposal>) request.getAttribute("proposals");

    if (proposals == null) {
        proposals = new ArrayList<>();
    }


    // =====================================================
    // 3. MESSAGE FROM CONTROLLER
    // =====================================================

    String msg = request.getParameter("msg");


    // =====================================================
    // 4. STATS CALCULATION
    // =====================================================

    int totalProposals = proposals.size();

    int totalAccepted = 0;
    int totalPending = 0;
    int totalRejected = 0;


    if (proposals != null) {

        for (Proposal p : proposals) {

            String st =
                p.getStatus() != null
                    ? p.getStatus().toLowerCase()
                    : "pending";


            if ("accepted".equals(st)
                    || "approved".equals(st)) {

                totalAccepted++;

            } else if ("rejected".equals(st)) {

                totalRejected++;

            } else {

                totalPending++;
            }
        }
    }


    // =====================================================
    // 5. PAGE URL
    // =====================================================

    String pageUrl =
        request.getContextPath()
        + "/admin/admin-praposal";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Portal — Corporate Proposals | JobBoard</title>
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
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    /* ===== LIGHT THEME ===== */
    body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f3f4f8; color: #1e293b; min-height: 100vh; }
    .font-sora { font-family: 'Sora', sans-serif; }
    .font-mono { font-family: 'JetBrains Mono', monospace; }

    .sidebar { width: 260px; background: #ffffff; border-right: 1px solid #e5e7eb; min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; box-shadow: 1px 0 3px rgba(0,0,0,0.03); }
    .sidebar-logo { padding: 24px 20px; border-bottom: 1px solid #e5e7eb; font-family: 'Sora', sans-serif; font-size: 20px; font-weight: 800; color: #0f172a; }
    .sidebar-logo span { color: #4f46e5; }
    .sidebar-nav { padding: 16px 12px; flex: 1; overflow-y: auto; }
    .nav-item { display: flex; align-items: center; gap: 12px; padding: 10px 14px; border-radius: 12px; color: #64748b; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.2s; margin-bottom: 4px; }
    .nav-item:hover { color: #0f172a; background: #f1f5f9; }
    .nav-item.active { color: #4338ca; background: #eef2ff; border: 1px solid #c7d2fe; }
    .nav-item i { width: 18px; text-align: center; font-size: 14px; }
    .nav-section { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: #94a3b8; padding: 16px 14px 6px; }

    .main { margin-left: 260px; min-height: 100vh; display: flex; flex-direction: column; }
    .topbar { background: #ffffff; border-bottom: 1px solid #e5e7eb; padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 50; }

    .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 28px; }
    .stat-card { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 18px; padding: 20px 24px; position: relative; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px; }
    .stat-card.blue::before   { background: linear-gradient(90deg, #6366f1, #38bdf8); }
    .stat-card.green::before  { background: linear-gradient(90deg, #10b981, #34d399); }
    .stat-card.yellow::before { background: linear-gradient(90deg, #f59e0b, #fbbf24); }
    .stat-card.red::before    { background: linear-gradient(90deg, #f43f5e, #fb7185); }

    .table-section { background: #ffffff; border: 1px solid #e5e7eb; border-radius: 20px; overflow: hidden; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
    .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
    .custom-table th { background: #f8fafc; border-bottom: 1px solid #e5e7eb; color: #94a3b8; font-size: 11px; text-transform: uppercase; font-family: 'JetBrains Mono', monospace; font-weight: 700; letter-spacing: 0.05em; padding: 14px 20px; }
    .custom-table td { border-bottom: 1px solid #f1f5f9; padding: 16px 20px; font-size: 13px; vertical-align: middle; color: #334155; }
    .custom-table tr:last-child td { border-bottom: none; }
    .custom-table tr:hover td { background: #f8fafc; }

    .action-btn { width: 32px; height: 32px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; font-size: 12px; transition: all 0.2s; cursor: pointer; }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sidebar-logo flex items-center justify-between">
    <div>Job<span>Board</span></div>
    <span class="text-[9px] font-mono uppercase bg-rose-50 text-rose-500 border border-rose-200 px-2 py-0.5 rounded-md">Admin</span>
  </div>

  <div class="sidebar-nav">
    <div class="nav-section">Main Management</div>
    <a href="<%= request.getContextPath() %>/admin/admin-dashboard" class="nav-item">
      <i class="fas fa-chart-pie text-indigo-500"></i> Dashboard
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-application" class="nav-item">
      <i class="fas fa-file-invoice text-indigo-500"></i> Job Applications
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-companies" class="nav-item">
      <i class="fas fa-building-circle-check text-indigo-500"></i> Companies Directory
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-jobs" class="nav-item">
      <i class="fas fa-briefcase text-indigo-500"></i> Job Postings
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-users" class="nav-item">
      <i class="fas fa-users text-indigo-500"></i> User Directory
    </a>
    <a href="<%= request.getContextPath() %>/admin/admin-praposal" class="nav-item active">
      <i class="fas fa-handshake text-indigo-500"></i> Proposals
    </a>

    <div class="nav-section">Session</div>
    <a href="<%= request.getContextPath() %>/admin/admin-login" class="nav-item text-rose-500 hover:bg-rose-50">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>

  <div class="p-4 border-t border-slate-100">
    <div class="flex items-center gap-3">
      <div class="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-500 to-purple-500 flex items-center justify-center font-bold text-xs text-white">
        A
      </div>
      <div>
        <p class="text-xs font-bold text-slate-800">Administrator</p>
        <p class="text-[10px] text-slate-400 font-mono">B2B Deals Desk</p>
      </div>
    </div>
  </div>
</aside>

<!-- MAIN CONTENT -->
<div class="main">

  <!-- TOPBAR -->
  <header class="topbar">
    <div>
      <h1 class="font-sora text-lg font-bold text-slate-900">Company Partnerships & Proposals</h1>
      <p class="text-xs text-slate-500">Draft, review, and track corporate recruitment contract proposals</p>
    </div>
    <div class="flex items-center gap-3">
      <button onclick="openCreateModal()" class="bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-2.5 px-4 rounded-xl transition-all shadow-md shadow-indigo-500/20 flex items-center gap-2">
        <i class="fas fa-plus text-xs"></i> Create Proposal
      </button>
    </div>
  </header>

  <!-- CONTENT WRAPPER -->
  <div class="p-8 flex-1 space-y-6">

    <!-- ALERT TOASTS -->
    <% if ("success".equals(msg)) { %>
      <div class="p-4 bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-check-circle text-emerald-500"></i> New proposal created and dispatched successfully!
        </div>
        <button onclick="this.parentElement.remove()" class="text-emerald-500"><i class="fas fa-times"></i></button>
      </div>
    <% } else if ("updated".equals(msg)) { %>
      <div class="p-4 bg-indigo-50 border border-indigo-200 text-indigo-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-info-circle text-indigo-500"></i> Proposal status updated successfully!
        </div>
        <button onclick="this.parentElement.remove()" class="text-indigo-500"><i class="fas fa-times"></i></button>
      </div>
    <% } else if ("deleted".equals(msg)) { %>
      <div class="p-4 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold flex items-center justify-between">
        <div class="flex items-center gap-2">
          <i class="fas fa-trash-alt text-rose-500"></i> Proposal record permanently deleted.
        </div>
        <button onclick="this.parentElement.remove()" class="text-rose-500"><i class="fas fa-times"></i></button>
      </div>
    <% } %>

    <!-- STATS ROW -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Total Proposals</span>
          <i class="fas fa-handshake text-indigo-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-slate-900"><%= totalProposals %></p>
      </div>

      <div class="stat-card green">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Accepted Deals</span>
          <i class="fas fa-check-circle text-emerald-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-emerald-500"><%= totalAccepted %></p>
      </div>

      <div class="stat-card yellow">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Pending Review</span>
          <i class="fas fa-clock text-amber-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-amber-500"><%= totalPending %></p>
      </div>

      <div class="stat-card red">
        <div class="flex items-center justify-between mb-3">
          <span class="text-[11px] font-mono uppercase text-slate-400 font-bold">Declined / Closed</span>
          <i class="fas fa-ban text-rose-500"></i>
        </div>
        <p class="font-sora text-3xl font-extrabold text-rose-500"><%= totalRejected %></p>
      </div>
    </div>

    <!-- TABLE SECTION -->
    <div class="table-section">
      <div class="p-5 border-b border-slate-100 flex items-center justify-between">
        <div>
          <h2 class="font-sora text-sm font-bold text-slate-900">Active Corporate Proposals</h2>
          <p class="text-[11px] text-slate-400">Comprehensive overview of all commercial agreements</p>
        </div>
        <span class="text-xs font-mono font-bold text-slate-400">
          Total: <%= totalProposals %> Contracts
        </span>
      </div>

      <% if (proposals == null || proposals.isEmpty()) { %>
        <div class="py-16 text-center space-y-3">
          <div class="w-14 h-14 rounded-2xl bg-slate-50 border border-slate-200 text-slate-400 flex items-center justify-center mx-auto text-2xl">
            <i class="fas fa-file-contract"></i>
          </div>
          <p class="font-sora font-bold text-slate-800 text-sm">No Proposals Created Yet</p>
          <p class="text-xs text-slate-400">Click the button above to generate a new commercial proposal.</p>
        </div>
      <% } else { %>
        <div class="overflow-x-auto">
          <table class="custom-table text-left">
            <thead>
              <tr>
                <th># ID</th>
                <th>Company Entity</th>
                <th>Corporate Email</th>
                <th>Proposal Title</th>
                <th>Deal Amount</th>
                <th>Date Logged</th>
                <th>Contract Status</th>
                <th class="text-right">Actions</th>
              </tr>
            </thead>
            <tbody>
              <%
                for (Proposal p : proposals) {
                  String st = p.getStatus() != null ? p.getStatus().toLowerCase() : "pending";
                  String statusBadge = "bg-amber-50 text-amber-600 border-amber-200";
                  if ("accepted".equals(st) || "approved".equals(st)) {
                      statusBadge = "bg-emerald-50 text-emerald-600 border-emerald-200";
                  } else if ("rejected".equals(st)) {
                      statusBadge = "bg-rose-50 text-rose-600 border-rose-200";
                  }

                  String rawTitle = p.getProposalTitle() != null ? p.getProposalTitle() : "";
                  String rawCompany = p.getCompanyName() != null ? p.getCompanyName() : "";
                  String rawAmount = p.getDealAmount() != null ? p.getDealAmount() : "0";
                  String rawDesc = p.getProposalDesc() != null ? p.getProposalDesc() : "";
                  String rawTerms = p.getTerms() != null ? p.getTerms() : "";

                  String initial = (!rawCompany.isEmpty()) ? String.valueOf(rawCompany.charAt(0)).toUpperCase() : "C";
                  String dateStr = p.getCreatedDate() != null && p.getCreatedDate().length() >= 10 ? p.getCreatedDate().substring(0,10) : "Recent";

                  // Safe Entity Encoding for HTML Data Attributes
                  String cleanTitle = rawTitle.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanCompany = rawCompany.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanAmount = rawAmount.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanDesc = rawDesc.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
                  String cleanTerms = rawTerms.replace("&", "&amp;").replace("\"", "&quot;").replace("'", "&#39;");
              %>
              <tr>
                <td class="font-mono text-slate-400">#<%= p.getProposalId() %></td>
                <td>
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-200 text-indigo-600 font-sora font-bold text-xs flex items-center justify-center flex-shrink-0">
                      <%= initial %>
                    </div>
                    <span class="font-bold text-slate-800 text-xs"><%= rawCompany %></span>
                  </div>
                </td>
                <td class="font-mono text-slate-500 text-xs"><%= p.getCompanyEmail() %></td>
                <td>
                  <button type="button"
                          data-title="<%= cleanTitle %>"
                          data-company="<%= cleanCompany %>"
                          data-amount="<%= cleanAmount %>"
                          data-desc="<%= cleanDesc %>"
                          data-terms="<%= cleanTerms %>"
                          onclick="handleProposalView(this)"
                          class="font-semibold text-indigo-600 hover:underline text-xs text-left cursor-pointer">
                    <%= rawTitle %>
                  </button>
                </td>
                <td class="font-mono font-bold text-emerald-600 text-xs">&#8377;<%= rawAmount %></td>
                <td class="font-mono text-slate-400 text-xs"><%= dateStr %></td>
                <td>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold uppercase tracking-wider border <%= statusBadge %>">
                    <%= st %>
                  </span>
                </td>
                <td class="text-right">
                  <div class="inline-flex items-center gap-1.5">
                    <!-- Accept Status -->
                   <a href="<%= request.getContextPath() %>/admin/admin-praposal/status?id=<%= p.getProposalId() %>&status=accepted"
                      class="action-btn bg-emerald-50 hover:bg-emerald-600 text-emerald-500 hover:text-white border border-emerald-200"
                      title="Accept Proposal"
                      onclick="return confirm('Mark this proposal as ACCEPTED?')">

                       <i class="fas fa-check"></i>

                   </a>
                  <a href="<%= request.getContextPath() %>/admin/admin-praposal/status?id=<%= p.getProposalId() %>&status=rejected"
                     class="action-btn bg-rose-50 hover:bg-rose-600 text-rose-500 hover:text-white border border-rose-200"
                     title="Reject Proposal"
                     onclick="return confirm('Mark this proposal as REJECTED?')">

                      <i class="fas fa-times"></i>

                  </a>
                    <!-- View Details Modal -->
                    <button type="button"
                            data-title="<%= cleanTitle %>"
                            data-company="<%= cleanCompany %>"
                            data-amount="<%= cleanAmount %>"
                            data-desc="<%= cleanDesc %>"
                            data-terms="<%= cleanTerms %>"
                            onclick="handleProposalView(this)"
                            class="action-btn bg-indigo-50 hover:bg-indigo-600 text-indigo-500 hover:text-white border border-indigo-200" title="View Full Details">
                      <i class="fas fa-eye"></i>
                    </button>
                    <!-- Delete -->
                <a href="<%= request.getContextPath() %>/admin/admin-praposal/delete?id=<%= p.getProposalId() %>"
                   class="action-btn bg-slate-50 hover:bg-rose-600 text-slate-400 hover:text-white border border-slate-200"
                   title="Delete Proposal"
                   onclick="return confirm('Permanently delete this proposal?')">

                    <i class="fas fa-trash-alt"></i>

                </a>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      <% } %>
    </div>

  </div>

  <!-- FOOTER -->
  <footer class="p-6 border-t border-slate-200 text-center text-xs text-slate-400 font-mono mt-auto">
    &copy; 2026 JobBoard Master Admin Control Center. All rights reserved.
  </footer>
</div>

<!-- CREATE PROPOSAL MODAL -->
 <div id="createModal"
      class="hidden fixed inset-0 z-[100] bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">

   <div class="bg-white border border-slate-200 rounded-3xl w-full max-w-2xl
               max-h-[90vh] overflow-hidden shadow-2xl relative">

     <!-- MODAL HEADER -->
     <div class="px-7 py-5 border-b border-slate-200 flex items-center justify-between bg-white">

       <div>
         <h3 class="font-sora font-extrabold text-lg text-slate-900">
           Create New Corporate Proposal
         </h3>

         <p class="text-xs text-slate-400 mt-1">
           Create partnership terms for employer onboarding
         </p>
       </div>

       <button type="button"
               onclick="closeCreateModal()"
               class="w-9 h-9 rounded-xl bg-slate-100 hover:bg-rose-50
                      text-slate-500 hover:text-rose-500
                      flex items-center justify-center transition-all">

         <i class="fas fa-times text-sm"></i>

       </button>

     </div>


     <!-- MODAL BODY -->
     <div class="max-h-[calc(90vh-145px)] overflow-y-auto px-7 py-6">

       <form method="POST"
             action="<%= pageUrl %>"
             class="space-y-5">

         <!-- Hidden Action -->
         <input type="hidden" name="action" value="create">


         <!-- COMPANY INFORMATION -->
         <div class="space-y-3">

           <div class="flex items-center gap-2">
             <div class="w-7 h-7 rounded-lg bg-indigo-50 text-indigo-600
                         flex items-center justify-center">
               <i class="fas fa-building text-xs"></i>
             </div>

             <div>
               <h4 class="font-sora text-xs font-bold text-slate-800">
                 Company Information
               </h4>

               <p class="text-[10px] text-slate-400">
                 Enter employer/company details
               </p>
             </div>
           </div>


           <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">

             <!-- COMPANY NAME -->
             <div>
               <label class="block font-bold uppercase tracking-wider
                             text-slate-400 text-[10px] mb-1.5 font-mono">
                 Company Name *
               </label>

               <input type="text"
                      name="company_name"
                      required
                      class="w-full bg-slate-50 border border-slate-200
                             rounded-xl px-4 py-3 text-xs text-slate-800
                             outline-none focus:bg-white focus:border-indigo-400
                             focus:ring-2 focus:ring-indigo-100 transition-all"
                      placeholder="e.g. Tata Consultancy Services">
             </div>


             <!-- COMPANY EMAIL -->
             <div>
               <label class="block font-bold uppercase tracking-wider
                             text-slate-400 text-[10px] mb-1.5 font-mono">
                 Company Email *
               </label>

               <input type="email"
                      name="company_email"
                      required
                      class="w-full bg-slate-50 border border-slate-200
                             rounded-xl px-4 py-3 text-xs text-slate-800
                             outline-none focus:bg-white focus:border-indigo-400
                             focus:ring-2 focus:ring-indigo-100 transition-all"
                      placeholder="corporate@company.com">
             </div>

           </div>

         </div>


         <!-- PROPOSAL INFORMATION -->
         <div class="space-y-3 pt-2">

           <div class="flex items-center gap-2">

             <div class="w-7 h-7 rounded-lg bg-emerald-50 text-emerald-600
                         flex items-center justify-center">
               <i class="fas fa-file-contract text-xs"></i>
             </div>

             <div>
               <h4 class="font-sora text-xs font-bold text-slate-800">
                 Proposal Information
               </h4>

               <p class="text-[10px] text-slate-400">
                 Define the proposal and contract value
               </p>
             </div>

           </div>


           <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">

             <!-- PROPOSAL TITLE -->
             <div class="sm:col-span-2">

               <label class="block font-bold uppercase tracking-wider
                             text-slate-400 text-[10px] mb-1.5 font-mono">
                 Proposal Title *
               </label>

               <input type="text"
                      name="proposal_title"
                      required
                      class="w-full bg-slate-50 border border-slate-200
                             rounded-xl px-4 py-3 text-xs text-slate-800
                             outline-none focus:bg-white focus:border-indigo-400
                             focus:ring-2 focus:ring-indigo-100 transition-all"
                      placeholder="e.g. Annual Campus Recruitment Partnership">

             </div>


             <!-- DEAL AMOUNT -->
             <div>

               <label class="block font-bold uppercase tracking-wider
                             text-slate-400 text-[10px] mb-1.5 font-mono">
                 Deal Amount
               </label>

               <div class="relative">

                 <span class="absolute left-3 top-1/2 -translate-y-1/2
                              text-emerald-500 font-bold text-sm">
                   ₹
                 </span>

                 <input type="text"
                        name="deal_amount"
                        class="w-full bg-slate-50 border border-slate-200
                               rounded-xl pl-8 pr-4 py-3 text-xs
                               text-emerald-600 font-mono font-bold
                               outline-none focus:bg-white focus:border-indigo-400
                               focus:ring-2 focus:ring-indigo-100 transition-all"
                        placeholder="50000">

               </div>

             </div>

           </div>

         </div>
      <!-- PROPOSAL DESCRIPTION -->
      <div>

        <label class="block font-bold uppercase tracking-wider
                      text-slate-400 text-[10px] mb-1.5 font-mono">
          Proposal Description
        </label>

        <textarea name="proposal_desc"
                  id="proposalDescription"
                  rows="4"
                  readonly
                  onclick="this.select()"
                  class="w-full bg-slate-50 border border-slate-200
                         rounded-xl p-4 text-xs text-slate-700
                         outline-none resize-none cursor-pointer
                         focus:bg-white focus:border-indigo-400
                         focus:ring-2 focus:ring-indigo-100 transition-all">JobBoard proposes a corporate recruitment partnership to help the company connect with qualified candidates through job postings, candidate search, recruitment support, and employer branding services. The partnership is designed to simplify hiring and improve access to relevant talent.</textarea>

        <p class="text-[10px] text-slate-400 mt-1.5">
          <i class="fas fa-info-circle mr-1"></i>
          Predefined proposal description
        </p>

      </div>
      <!-- TERMS & CONDITIONS -->
      <div>

        <label class="block font-bold uppercase tracking-wider
                      text-slate-400 text-[10px] mb-1.5 font-mono">
          Terms & Conditions
        </label>

        <textarea name="terms"
                  id="proposalTerms"
                  rows="4"
                  readonly
                  onclick="this.select()"
                  class="w-full bg-slate-50 border border-slate-200
                         rounded-xl p-4 text-xs text-slate-700
                         outline-none resize-none cursor-pointer
                         focus:bg-white focus:border-indigo-400
                         focus:ring-2 focus:ring-indigo-100 transition-all">1. The proposal is subject to mutual agreement between JobBoard and the company.
      2. The agreed deal amount shall be payable according to the finalized payment schedule.
      3. The partnership period will be as mutually agreed by both parties.
      4. Any cancellation or modification must be communicated and mutually approved.
      5. JobBoard will provide recruitment and employer support services according to the agreed proposal scope.</textarea>

        <p class="text-[10px] text-slate-400 mt-1.5">
          <i class="fas fa-info-circle mr-1"></i>
          Predefined terms and conditions
        </p>

      </div>
<!-- FORM ACTIONS -->
        <div class="pt-5 border-t border-slate-200
                    flex items-center justify-end gap-3">

          <!-- CANCEL -->
          <button type="button"
                  onclick="closeCreateModal()"
                  class="px-5 py-3 rounded-xl bg-slate-100
                         hover:bg-slate-200 text-slate-600
                         text-xs font-bold transition-all">

            <i class="fas fa-times mr-1.5"></i>


          </button>


          <!-- SUBMIT -->
          <button type="submit"
                  class="px-6 py-3 rounded-xl bg-indigo-600
                         hover:bg-indigo-700 text-white
                         font-sora font-bold text-xs
                         uppercase tracking-wider transition-all
                         shadow-md shadow-indigo-500/20">

            <i class="fas fa-paper-plane mr-1.5"></i>
            Save & Send Proposal

          </button>

        </div>

      </form>

    </div>

  </div>

</div>

<!-- VIEW DETAILS MODAL -->
<div id="viewModal" class="hidden fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm flex items-center justify-center p-4">
  <div class="bg-white border border-slate-200 rounded-3xl max-w-xl w-full p-8 space-y-6 shadow-2xl relative text-left">
    <div class="flex items-center justify-between border-b border-slate-200 pb-4">
      <div>
        <h3 id="viewTitle" class="font-sora font-extrabold text-lg text-slate-900">Proposal Overview</h3>
        <p id="viewCompany" class="text-xs text-indigo-600 font-mono font-bold"></p>
      </div>
      <button onclick="closeViewModal()" class="w-8 h-8 rounded-full bg-slate-100 text-slate-500 hover:text-slate-800 flex items-center justify-center text-xs">
        <i class="fas fa-times"></i>
      </button>
    </div>

    <div class="space-y-4 text-xs">
      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200 flex items-center justify-between">
        <span class="font-bold uppercase tracking-wider text-slate-400 text-[10px] font-mono">Contract Value</span>
        <span id="viewAmount" class="font-mono text-base font-extrabold text-emerald-600"></span>
      </div>

      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Scope & Description</p>
        <p id="viewDesc" class="text-slate-600 leading-relaxed max-h-36 overflow-y-auto whitespace-pre-wrap"></p>
      </div>

      <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200">
        <p class="font-bold uppercase tracking-wider text-slate-400 text-[10px] mb-1 font-mono">Commercial Terms</p>
        <p id="viewTerms" class="text-slate-600 leading-relaxed max-h-28 overflow-y-auto whitespace-pre-wrap"></p>
      </div>
    </div>

    <div class="pt-2">
      <button onclick="closeViewModal()" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-sora font-bold text-xs uppercase tracking-wider py-3 rounded-xl transition-all">
        Close Window
      </button>
    </div>
  </div>
</div>

<!-- SCRIPTS -->
<script>
  function openCreateModal() {
      document.getElementById('createModal').classList.remove('hidden');
      document.body.style.overflow = 'hidden';
  }

  function closeCreateModal() {
      document.getElementById('createModal').classList.add('hidden');
      document.body.style.overflow = '';
  }

  function handleProposalView(elem) {
    const title = elem.getAttribute('data-title');
    const company = elem.getAttribute('data-company');
    const amount = elem.getAttribute('data-amount');
    const desc = elem.getAttribute('data-desc');
    const terms = elem.getAttribute('data-terms');

    openViewModal(title, company, amount, desc, terms);
  }

  function openViewModal(title, company, amount, desc, terms) {
    document.getElementById('viewTitle').textContent   = title || 'Proposal Overview';
    document.getElementById('viewCompany').textContent = 'Partner: ' + (company || 'N/A');
    document.getElementById('viewAmount').textContent  = '₹' + (amount || '0');
    document.getElementById('viewDesc').textContent    = desc || 'No description entered.';
    document.getElementById('viewTerms').textContent   = terms || 'Standard JobBoard agreement terms apply.';
    document.getElementById('viewModal').classList.remove('hidden');
  }

  function closeViewModal() {
    document.getElementById('viewModal').classList.add('hidden');
  }
</script>

</body>
</html>
