<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.ProposalDao" %>
<%@ page import="com.model.Proposal" %>
<%@ page import="java.util.List" %>
<%
    ProposalDao dao = new ProposalDao();
    String action = request.getParameter("action");
    String msg = "";

    if ("create".equals(action)) {
        Proposal p = new Proposal();
        p.setCompanyName(request.getParameter("company_name"));
        p.setCompanyEmail(request.getParameter("company_email"));
        p.setProposalTitle(request.getParameter("proposal_title"));
        p.setProposalDesc(request.getParameter("proposal_desc"));
        p.setTerms(request.getParameter("terms"));
        p.setDealAmount(request.getParameter("deal_amount"));
        int r = dao.createProposal(p);
        msg = r > 0 ? "success" : "error";
    }

    if ("status".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        dao.updateStatus(id, status);
        msg = "updated";
    }

    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.deleteProposal(id);
        msg = "deleted";
    }

    List<Proposal> proposals = dao.getAllProposals();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin — Proposals</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/vendors/css/vendors.min.css">
    <link rel="stylesheet" href="assets/css/theme.min.css">
</head>
<body>

<%@include file="header.jsp" %>
<%@include file="sidebarmenu.jsp" %>

<main class="nxl-container">
    <div class="nxl-content">

        <div class="page-header">
            <div class="page-header-left d-flex align-items-center">
                <div class="page-header-title">
                    <h5 class="m-b-10">Company Proposals</h5>
                </div>
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                    <li class="breadcrumb-item">Proposals</li>
                </ul>
            </div>
            <div class="page-header-right ms-auto">
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
                    <i class="feather-plus me-2"></i>Create Proposal
                </button>
            </div>
        </div>

        <div class="main-content">

            <% if ("success".equals(msg)) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    Proposal successfully created! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if ("deleted".equals(msg)) { %>
                <div class="alert alert-warning alert-dismissible fade show">
                    Proposal deleted! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if ("updated".equals(msg)) { %>
                <div class="alert alert-info alert-dismissible fade show">
                    Status updated! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="card stretch stretch-full">
                <div class="card-header">
                    <h5 class="card-title">All Proposals (<%= proposals.size() %>)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Company</th>
                                    <th>Email</th>
                                    <th>Proposal Title</th>
                                    <th>Deal Amount</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (proposals.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-4 text-muted">No proposals yet.</td>
                                </tr>
                                <% } else {
                                    int i = 1;
                                    for (Proposal p : proposals) {
                                        String st = p.getStatus();
                                        String bc = "pending".equals(st) ? "bg-soft-warning text-warning" :
                                                    "accepted".equals(st) ? "bg-soft-success text-success" :
                                                    "bg-soft-danger text-danger";
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td><strong><%= p.getCompanyName() %></strong></td>
                                    <td><%= p.getCompanyEmail() %></td>
                                    <td>
                                        <a href="#" data-bs-toggle="modal" data-bs-target="#viewModal"
                                           data-title="<%= p.getProposalTitle() %>"
                                           data-company="<%= p.getCompanyName() %>"
                                           data-amount="<%= p.getDealAmount() %>"
                                           data-desc="<%= p.getProposalDesc() %>"
                                           data-terms="<%= p.getTerms() %>"
                                           onclick="fillViewModal(this)">
                                            <%= p.getProposalTitle() %>
                                        </a>
                                    </td>
                                    <td>&#8377;<%= p.getDealAmount() %></td>
                                    <td><%= p.getCreatedDate() != null ? p.getCreatedDate().substring(0,10) : "" %></td>
                                    <td><span class="badge <%= bc %>"><%= st %></span></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="admin-proposals.jsp?action=status&id=<%= p.getProposalId() %>&status=accepted"
                                               class="btn btn-sm btn-soft-success"
                                               onclick="return confirm('Accept karvu chhe?')">
                                               <i class="feather-check"></i>
                                            </a>
                                            <a href="admin-proposals.jsp?action=status&id=<%= p.getProposalId() %>&status=rejected"
                                               class="btn btn-sm btn-soft-danger"
                                               onclick="return confirm('Reject karvu chhe?')">
                                               <i class="feather-x"></i>
                                            </a>
                                            <a href="admin-proposals.jsp?action=delete&id=<%= p.getProposalId() %>"
                                               class="btn btn-sm btn-soft-dark"
                                               onclick="return confirm('Delete karvu chhe?')">
                                               <i class="feather-trash-2"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</main>

<!-- CREATE MODAL -->
<div class="modal fade" id="createModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Create New Proposal</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="admin-proposals.jsp?action=create">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Company Name *</label>
                            <input type="text" name="company_name" class="form-control" placeholder="e.g. Tata Consultancy" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Company Email *</label>
                            <input type="email" name="company_email" class="form-control" placeholder="company@email.com" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label">Proposal Title *</label>
                            <input type="text" name="proposal_title" class="form-control" placeholder="e.g. Annual Recruitment Partnership" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Deal Amount (&#8377;)</label>
                            <input type="text" name="deal_amount" class="form-control" placeholder="e.g. 50000">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Proposal Description</label>
                            <textarea name="proposal_desc" class="form-control" rows="3" placeholder="Proposal details..."></textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Terms & Conditions</label>
                            <textarea name="terms" class="form-control" rows="3" placeholder="Contract terms..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="feather-send me-2"></i>Send Proposal
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- VIEW MODAL -->
<div class="modal fade" id="viewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="viewTitle"></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="fw-semibold text-muted fs-12 text-uppercase">Company</label>
                    <p id="viewCompany" class="mb-0"></p>
                </div>
                <div class="mb-3">
                    <label class="fw-semibold text-muted fs-12 text-uppercase">Deal Amount</label>
                    <p id="viewAmount" class="mb-0 fs-5 fw-bold text-primary"></p>
                </div>
                <div class="mb-3">
                    <label class="fw-semibold text-muted fs-12 text-uppercase">Description</label>
                    <p id="viewDesc" class="mb-0"></p>
                </div>
                <div class="mb-3">
                    <label class="fw-semibold text-muted fs-12 text-uppercase">Terms & Conditions</label>
                    <p id="viewTerms" class="mb-0"></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="assets/vendors/js/vendors.min.js"></script>
<script src="assets/vendors/js/bootstrap.min.js"></script>
<script src="assets/js/common-init.min.js"></script>
<script>
function fillViewModal(el) {
    document.getElementById('viewTitle').textContent   = el.dataset.title;
    document.getElementById('viewCompany').textContent = el.dataset.company;
    document.getElementById('viewAmount').textContent  = '₹' + el.dataset.amount;
    document.getElementById('viewDesc').textContent    = el.dataset.desc || 'No description';
    document.getElementById('viewTerms').textContent   = el.dataset.terms || 'No terms specified';
}
</script>

<%@include file="footer.jsp" %>
</body>
</html>