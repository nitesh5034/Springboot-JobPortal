<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String action = request.getParameter("action");
    String msg = "";

    // Delete company
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection cn = new DBUtil().getConnection();
            // ✅ company table email get karva mate
            PreparedStatement getEmail = cn.prepareStatement("SELECT email FROM company WHERE id=?");
            getEmail.setInt(1, id);
            ResultSet emailRs = getEmail.executeQuery();
            if (emailRs.next()) {
                String compEmail = emailRs.getString("email");
                // ✅ userregister delete
                PreparedStatement ps2 = cn.prepareStatement("DELETE FROM userregister WHERE email=?");
                ps2.setString(1, compEmail);
                ps2.executeUpdate();
                ps2.close();
            }
            // ✅ company delete
            PreparedStatement ps = cn.prepareStatement("DELETE FROM company WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            ps.close(); cn.close();
            msg = "deleted";
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ✅ Update status — BOTH tables
    if ("status".equals(action)) {
        int id    = Integer.parseInt(request.getParameter("id"));
        String st = request.getParameter("status");
        try {
            Connection cn = new DBUtil().getConnection();

            // ✅ company table status update
            PreparedStatement ps = cn.prepareStatement("UPDATE company SET status=? WHERE id=?");
            ps.setString(1, st); ps.setInt(2, id);
            ps.executeUpdate(); ps.close();

            // ✅ company email get karo
            PreparedStatement getEmail = cn.prepareStatement("SELECT email FROM company WHERE id=?");
            getEmail.setInt(1, id);
            ResultSet emailRs = getEmail.executeQuery();
            if (emailRs.next()) {
                String compEmail = emailRs.getString("email");

                // ✅ is_verified update in userregister
                int isVerified = "active".equals(st) ? 1 : ("inactive".equals(st) ? 2 : 0);
                PreparedStatement ps2 = cn.prepareStatement("UPDATE userregister SET is_verified=? WHERE email=?");
                ps2.setInt(1, isVerified);
                ps2.setString(2, compEmail);
                ps2.executeUpdate();
                ps2.close();
            }
            cn.close();
            msg = "updated";
        } catch (Exception e) { e.printStackTrace(); }
    }

    String search = request.getParameter("search");
    String filterStatus = request.getParameter("filter");

    List<Map<String, String>> companies = new ArrayList<>();
    int totalCompanies = 0, totalActive = 0, totalInactive = 0, totalPending = 0;

    try {
        Connection cn = new DBUtil().getConnection();

        // ✅ Total
        ResultSet rs2 = cn.createStatement().executeQuery("SELECT COUNT(*) as cnt FROM company");
        if (rs2.next()) totalCompanies = rs2.getInt("cnt");
        rs2.close();

        // ✅ Active
        ResultSet rs3 = cn.createStatement().executeQuery("SELECT COUNT(*) as cnt FROM company WHERE status='active'");
        if (rs3.next()) totalActive = rs3.getInt("cnt");
        rs3.close();

        // ✅ Inactive
        ResultSet rs4 = cn.createStatement().executeQuery("SELECT COUNT(*) as cnt FROM company WHERE status='inactive'");
        if (rs4.next()) totalInactive = rs4.getInt("cnt");
        rs4.close();

        // ✅ Pending
        ResultSet rs5 = cn.createStatement().executeQuery("SELECT COUNT(*) as cnt FROM company WHERE status='pending'");
        if (rs5.next()) totalPending = rs5.getInt("cnt");
        rs5.close();

        // ✅ Build query
        String sql = "SELECT c.*, COUNT(j.job_id) as job_count " +
                     "FROM company c " +
                     "LEFT JOIN `company job-update` j ON c.email = j.Email " +
                     "WHERE 1=1";

        if (search != null && !search.isEmpty())
            sql += " AND (c.companyname LIKE '%" + search + "%' OR c.email LIKE '%" + search + "%' OR c.location LIKE '%" + search + "%')";

        if (filterStatus != null && !filterStatus.isEmpty())
            sql += " AND c.status = '" + filterStatus + "'";

        sql += " GROUP BY c.id ORDER BY c.id DESC";

        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("company_id",  rs.getString("id"));
            m.put("companyname", rs.getString("companyname"));
            m.put("email",       rs.getString("email"));
            m.put("website",     rs.getString("website"));
            m.put("location",    rs.getString("location"));
            m.put("about",       rs.getString("about"));
            m.put("status",      rs.getString("status"));
            m.put("job_count",   rs.getString("job_count"));
            companies.add(m);
        }
        rs.close(); ps.close(); cn.close();
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin — Companies</title>
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
                <div class="page-header-title"><h5 class="m-b-10">Companies</h5></div>
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                    <li class="breadcrumb-item">Companies</li>
                </ul>
            </div>
        </div>

        <div class="main-content">

            <% if ("deleted".equals(msg)) { %>
                <div class="alert alert-warning alert-dismissible fade show">
                    Company deleted! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if ("updated".equals(msg)) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    Status updated successfully! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- ✅ Stats — Pending ઉમેર્યો -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-primary text-primary">
                                    <i class="feather-home"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalCompanies %></div>
                                    <div class="fs-13 text-muted">Total Companies</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-success text-success">
                                    <i class="feather-check-circle"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalActive %></div>
                                    <div class="fs-13 text-muted">Active</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-warning text-warning">
                                    <i class="feather-clock"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalPending %></div>
                                    <div class="fs-13 text-muted">Pending</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-danger text-danger">
                                    <i class="feather-x-circle"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalInactive %></div>
                                    <div class="fs-13 text-muted">Inactive</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search + Filter -->
            <div class="card mb-3">
                <div class="card-body py-3">
                    <form method="GET" action="admin-companies.jsp" class="d-flex align-items-center gap-3 flex-wrap">
                        <input type="text" name="search" class="form-control" style="max-width:250px;"
                               placeholder="Search company, email, location..."
                               value="<%= search != null ? search : "" %>">
                        <!-- ✅ Pending option ઉમેર્યો -->
                        <select name="filter" class="form-select" style="max-width:160px;">
                            <option value="">All Status</option>
                            <option value="active"   <%= "active".equals(filterStatus)   ? "selected" : "" %>>Active</option>
                            <option value="pending"  <%= "pending".equals(filterStatus)  ? "selected" : "" %>>Pending</option>
                            <option value="inactive" <%= "inactive".equals(filterStatus) ? "selected" : "" %>>Inactive</option>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="feather-search me-2"></i>Filter
                        </button>
                        <a href="admin-companies.jsp" class="btn btn-light">
                            <i class="feather-refresh-cw me-2"></i>Reset
                        </a>
                    </form>
                </div>
            </div>

            <!-- Companies Table -->
            <div class="card stretch stretch-full">
                <div class="card-header">
                    <h5 class="card-title">All Companies (<%= companies.size() %>)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Company</th>
                                    <th>Email</th>
                                    <th>Location</th>
                                    <th>Website</th>
                                    <th>Jobs Posted</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (companies.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">No companies found.</td>
                                </tr>
                                <% } else {
                                    int i = 1;
                                    for (Map<String, String> c : companies) {
                                        String st = c.get("status");
                                        // ✅ Pending badge ઉમેર્યો
                                        String bc = "active".equals(st)  ? "bg-soft-success text-success" :
                                                    "pending".equals(st) ? "bg-soft-warning text-warning" :
                                                                           "bg-soft-danger text-danger";
                                        String initial = c.get("companyname") != null && !c.get("companyname").isEmpty()
                                                         ? c.get("companyname").substring(0,1).toUpperCase() : "C";
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width:38px;height:38px;border-radius:8px;background:#eff6ff;color:#1a56db;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:14px;flex-shrink:0;">
                                                <%= initial %>
                                            </div>
                                            <div>
                                                <div class="fw-semibold text-dark"><%= c.get("companyname") %></div>
                                                <div class="fs-12 text-muted">
                                                    <%= c.get("about") != null && c.get("about").length() > 30
                                                        ? c.get("about").substring(0,30) + "..."
                                                        : c.get("about") %>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%= c.get("email") %></td>
                                    <td><i class="feather-map-pin me-1 text-muted fs-12"></i><%= c.get("location") %></td>
                                    <td>
                                        <% if (c.get("website") != null && !c.get("website").isEmpty()) { %>
                                            <a href="<%= c.get("website") %>" target="_blank" class="text-primary fs-12">
                                                <i class="feather-external-link me-1"></i>Visit
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted fs-12">N/A</span>
                                        <% } %>
                                    </td>
                                    <td><strong class="text-primary"><%= c.get("job_count") %></strong> jobs</td>
                                    <td><span class="badge <%= bc %>"><%= st %></span></td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <!-- ✅ Activate -->
                                            <a href="admin-companies.jsp?action=status&id=<%= c.get("company_id") %>&status=active"
                                               class="btn btn-sm btn-soft-success" title="Activate"
                                               onclick="return confirm('Activate karvu chhe?')">
                                               <i class="feather-check"></i>
                                            </a>
                                            <!-- ✅ Deactivate -->
                                            <a href="admin-companies.jsp?action=status&id=<%= c.get("company_id") %>&status=inactive"
                                               class="btn btn-sm btn-soft-warning" title="Deactivate"
                                               onclick="return confirm('Deactivate karvu chhe?')">
                                               <i class="feather-slash"></i>
                                            </a>
                                            <!-- View Details -->
                                            <button class="btn btn-sm btn-soft-info" title="View Details"
                                                data-bs-toggle="modal" data-bs-target="#viewModal"
                                                data-name="<%= c.get("companyname") %>"
                                                data-email="<%= c.get("email") %>"
                                                data-location="<%= c.get("location") %>"
                                                data-website="<%= c.get("website") %>"
                                                data-about="<%= c.get("about") %>"
                                                data-jobs="<%= c.get("job_count") %>"
                                                onclick="fillModal(this)">
                                                <i class="feather-eye"></i>
                                            </button>
                                            <!-- Delete -->
                                            <a href="admin-companies.jsp?action=delete&id=<%= c.get("company_id") %>"
                                               class="btn btn-sm btn-soft-danger" title="Delete"
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

<!-- View Company Modal -->
<div class="modal fade" id="viewModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalName"></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-12">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Email</label>
                        <p id="modalEmail" class="mb-0"></p>
                    </div>
                    <div class="col-12">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Location</label>
                        <p id="modalLocation" class="mb-0"></p>
                    </div>
                    <div class="col-12">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Website</label>
                        <p id="modalWebsite" class="mb-0"></p>
                    </div>
                    <div class="col-12">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Jobs Posted</label>
                        <p id="modalJobs" class="mb-0 fw-bold text-primary"></p>
                    </div>
                    <div class="col-12">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">About</label>
                        <p id="modalAbout" class="mb-0"></p>
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
function fillModal(el) {
    document.getElementById('modalName').textContent     = el.dataset.name;
    document.getElementById('modalEmail').textContent    = el.dataset.email;
    document.getElementById('modalLocation').textContent = el.dataset.location || 'N/A';
    document.getElementById('modalWebsite').textContent  = el.dataset.website || 'N/A';
    document.getElementById('modalJobs').textContent     = el.dataset.jobs + ' jobs posted';
    document.getElementById('modalAbout').textContent    = el.dataset.about || 'No description';
}
</script>

<%@include file="footer.jsp" %>
</body>
</html>