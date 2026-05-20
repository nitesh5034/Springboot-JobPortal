<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String action = request.getParameter("action");
    String msg = "";

    // Delete job
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("DELETE FROM `company job-update` WHERE job_id=?");
            ps.setInt(1, id);
            ps.executeUpdate(); ps.close(); cn.close();
            msg = "deleted";
        } catch (Exception e) { e.printStackTrace(); }
    }

    // Search + Filter
    String search     = request.getParameter("search");
    String filterType = request.getParameter("filter");

    List<Map<String, String>> jobs = new ArrayList<>();
    int totalJobs = 0, totalFullTime = 0, totalPartTime = 0;

    try {
        Connection cn = new DBUtil().getConnection();

        // Stats
        ResultSet rs2 = cn.createStatement().executeQuery(
            "SELECT Job_Type, COUNT(*) as cnt FROM `company job-update` GROUP BY Job_Type");
        while (rs2.next()) {
            String t = rs2.getString("Job_Type");
            int c    = rs2.getInt("cnt");
            totalJobs += c;
            if (t != null && t.toLowerCase().contains("full")) totalFullTime += c;
            if (t != null && t.toLowerCase().contains("part")) totalPartTime += c;
        }
        rs2.close();

        // Build query
        String sql = "SELECT * FROM `company job-update` WHERE 1=1";
        if (search != null && !search.isEmpty())
            sql += " AND (Job_Title LIKE '%" + search + "%' OR company_name LIKE '%" + search + "%' OR Location LIKE '%" + search + "%')";
        if (filterType != null && !filterType.isEmpty())
            sql += " AND Job_Type LIKE '%" + filterType + "%'";
        sql += " ORDER BY job_id DESC";

        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("job_id",      rs.getString("job_id"));
            m.put("job_title",   rs.getString("Job_Title"));
            m.put("company",     rs.getString("company_name"));
            m.put("email",       rs.getString("Email"));
            m.put("location",    rs.getString("Location"));
            m.put("job_type",    rs.getString("Job_Type"));
            m.put("salary",      rs.getString("salary"));
            m.put("opening",     rs.getString("opening"));
            m.put("experience",  rs.getString("experience"));
            m.put("skills",      rs.getString("skills_req"));
            m.put("region",      rs.getString("Job_Region"));
            m.put("applied",     rs.getString("applied_count"));
            m.put("description", rs.getString("Job_Description"));
            jobs.add(m);
        }
        rs.close(); ps.close(); cn.close();
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin — Job Listings</title>
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
                    <h5 class="m-b-10">Job Listings</h5>
                </div>
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                    <li class="breadcrumb-item">Jobs</li>
                </ul>
            </div>
        </div>

        <div class="main-content">

            <% if ("deleted".equals(msg)) { %>
                <div class="alert alert-warning alert-dismissible fade show">
                    Job deleted! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-primary text-primary">
                                    <i class="feather-briefcase"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalJobs %></div>
                                    <div class="fs-13 text-muted">Total Jobs</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-success text-success">
                                    <i class="feather-clock"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalFullTime %></div>
                                    <div class="fs-13 text-muted">Full Time</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-warning text-warning">
                                    <i class="feather-sun"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalPartTime %></div>
                                    <div class="fs-13 text-muted">Part Time</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search + Filter -->
            <div class="card mb-3">
                <div class="card-body py-3">
                    <form method="GET" action="admin-jobs.jsp" class="d-flex align-items-center gap-3 flex-wrap">
                        <input type="text" name="search" class="form-control" style="max-width:250px;"
                               placeholder="Search title, company, location..."
                               value="<%= search != null ? search : "" %>">
                        <select name="filter" class="form-select" style="max-width:160px;">
                            <option value="">All Types</option>
                            <option value="Full" <%= "Full".equals(filterType) ? "selected" : "" %>>Full Time</option>
                            <option value="Part" <%= "Part".equals(filterType) ? "selected" : "" %>>Part Time</option>
                            <option value="Contract" <%= "Contract".equals(filterType) ? "selected" : "" %>>Contract</option>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="feather-search me-2"></i>Filter
                        </button>
                        <a href="admin-jobs.jsp" class="btn btn-light">
                            <i class="feather-refresh-cw me-2"></i>Reset
                        </a>
                    </form>
                </div>
            </div>

            <!-- Jobs Table -->
            <div class="card stretch stretch-full">
                <div class="card-header">
                    <h5 class="card-title">All Jobs (<%= jobs.size() %>)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Job Title</th>
                                    <th>Company</th>
                                    <th>Location</th>
                                    <th>Type</th>
                                    <th>Salary</th>
                                    <th>Opening</th>
                                    <th>Applied</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (jobs.isEmpty()) { %>
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">No jobs found.</td>
                                </tr>
                                <% } else {
                                    int i = 1;
                                    for (Map<String, String> job : jobs) {
                                        String jt = job.get("job_type") != null ? job.get("job_type").toLowerCase() : "";
                                        String bc = jt.contains("full") ? "bg-soft-primary text-primary" :
                                                    jt.contains("part") ? "bg-soft-success text-success" :
                                                    "bg-soft-warning text-warning";
                                        String initial = job.get("company") != null && !job.get("company").isEmpty()
                                                         ? job.get("company").substring(0,1).toUpperCase() : "C";
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width:36px;height:36px;border-radius:8px;background:#eff6ff;color:#1a56db;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;">
                                                <%= initial %>
                                            </div>
                                            <div>
                                                <div class="fw-semibold text-dark"><%= job.get("job_title") %></div>
                                                <div class="fs-12 text-muted">Exp: <%= job.get("experience") %> yr</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold"><%= job.get("company") %></div>
                                        <div class="fs-12 text-muted"><%= job.get("email") %></div>
                                    </td>
                                    <td>
                                        <i class="feather-map-pin me-1 text-muted fs-12"></i><%= job.get("location") %>
                                        <div class="fs-12 text-muted"><%= job.get("region") %></div>
                                    </td>
                                    <td><span class="badge <%= bc %>"><%= job.get("job_type") %></span></td>
                                    <td>&#8377;<%= job.get("salary") %></td>
                                    <td><%= job.get("opening") %></td>
                                    <td><strong class="text-primary"><%= job.get("applied") %></strong></td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <!-- View Details -->
                                            <button class="btn btn-sm btn-soft-info" title="View Details"
                                                data-bs-toggle="modal" data-bs-target="#viewModal"
                                                data-title="<%= job.get("job_title") %>"
                                                data-company="<%= job.get("company") %>"
                                                data-location="<%= job.get("location") %>"
                                                data-type="<%= job.get("job_type") %>"
                                                data-salary="<%= job.get("salary") %>"
                                                data-opening="<%= job.get("opening") %>"
                                                data-experience="<%= job.get("experience") %>"
                                                data-skills="<%= job.get("skills") %>"
                                                data-desc="<%= job.get("description") %>"
                                                onclick="fillJobModal(this)">
                                                <i class="feather-eye"></i>
                                            </button>
                                            <!-- Delete -->
                                            <a href="admin-jobs.jsp?action=delete&id=<%= job.get("job_id") %>"
                                               class="btn btn-sm btn-soft-danger" title="Delete"
                                               onclick="return confirm('Job delete karvu chhe?')">
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

<!-- View Job Modal -->
<div class="modal fade" id="viewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalJobTitle"></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Company</label>
                        <p id="modalCompany" class="mb-0 fw-semibold"></p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Location</label>
                        <p id="modalLocation" class="mb-0"></p>
                    </div>
                    <div class="col-md-4">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Job Type</label>
                        <p id="modalType" class="mb-0"></p>
                    </div>
                    <div class="col-md-4">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Salary</label>
                        <p id="modalSalary" class="mb-0 fw-bold text-primary"></p>
                    </div>
                    <div class="col-md-4">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Openings</label>
                        <p id="modalOpening" class="mb-0"></p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Experience</label>
                        <p id="modalExp" class="mb-0"></p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Skills Required</label>
                        <p id="modalSkills" class="mb-0"></p>
                    </div>
                    <div class="col-12">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Job Description</label>
                        <p id="modalDesc" class="mb-0"></p>
                    </div>
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
function fillJobModal(el) {
    document.getElementById('modalJobTitle').textContent = el.dataset.title;
    document.getElementById('modalCompany').textContent  = el.dataset.company;
    document.getElementById('modalLocation').textContent = el.dataset.location;
    document.getElementById('modalType').textContent     = el.dataset.type;
    document.getElementById('modalSalary').textContent   = '₹' + el.dataset.salary;
    document.getElementById('modalOpening').textContent  = el.dataset.opening + ' seats';
    document.getElementById('modalExp').textContent      = el.dataset.experience + ' years';
    document.getElementById('modalSkills').textContent   = el.dataset.skills || 'N/A';
    document.getElementById('modalDesc').textContent     = el.dataset.desc || 'No description';
}
</script>

<%@include file="footer.jsp" %>
</body>
</html>