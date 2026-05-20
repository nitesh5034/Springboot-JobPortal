<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String action = request.getParameter("action");
    String msg = "";

    if ("status".equals(action)) {
        int id    = Integer.parseInt(request.getParameter("id"));
        String st = request.getParameter("status");
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("UPDATE applications SET status=? WHERE app_id=?");
            ps.setString(1, st); ps.setInt(2, id);
            ps.executeUpdate(); ps.close(); cn.close();
            msg = "updated";
        } catch (Exception e) { e.printStackTrace(); }
    }

    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("DELETE FROM applications WHERE app_id=?");
            ps.setInt(1, id);
            ps.executeUpdate(); ps.close(); cn.close();
            msg = "deleted";
        } catch (Exception e) { e.printStackTrace(); }
    }

    String filterStatus = request.getParameter("filter");
    String search       = request.getParameter("search");

    List<Map<String, String>> apps = new ArrayList<>();
    int totalPending = 0, totalAccepted = 0, totalRejected = 0;

    try {
        Connection cn = new DBUtil().getConnection();

        ResultSet rs2 = cn.createStatement().executeQuery("SELECT status, COUNT(*) as cnt FROM applications GROUP BY status");
        while (rs2.next()) {
            String s = rs2.getString("status");
            int c    = rs2.getInt("cnt");
            if ("pending".equals(s))  totalPending  = c;
            if ("accepted".equals(s)) totalAccepted = c;
            if ("rejected".equals(s)) totalRejected = c;
        }
        rs2.close();

        String sql = "SELECT a.*, j.Job_Title FROM applications a LEFT JOIN `company job-update` j ON a.job_id = j.job_id WHERE 1=1";
        if (filterStatus != null && !filterStatus.isEmpty()) sql += " AND a.status = '" + filterStatus + "'";
        if (search != null && !search.isEmpty()) sql += " AND (a.fullname LIKE '%" + search + "%' OR a.email LIKE '%" + search + "%')";
        sql += " ORDER BY a.app_id DESC";

        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("app_id",     rs.getString("app_id"));
            m.put("job_title",  rs.getString("Job_Title") != null ? rs.getString("Job_Title") : "N/A");
            m.put("fullname",   rs.getString("fullname"));
            m.put("email",      rs.getString("email"));
            m.put("mobileno",   rs.getString("mobileno"));
            m.put("city",       rs.getString("city"));
            m.put("experience", rs.getString("experience"));
            m.put("resume",     rs.getString("resume"));
            m.put("status",     rs.getString("status"));
            apps.add(m);
        }
        rs.close(); ps.close(); cn.close();
    } catch (Exception e) { e.printStackTrace(); }

    int totalApps = totalPending + totalAccepted + totalRejected;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin — Applications</title>
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
                    <h5 class="m-b-10">Job Applications</h5>
                </div>
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                    <li class="breadcrumb-item">Applications</li>
                </ul>
            </div>
        </div>

        <div class="main-content">

            <% if ("updated".equals(msg)) { %>
                <div class="alert alert-info alert-dismissible fade show">
                    Status updated! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } else if ("deleted".equals(msg)) { %>
                <div class="alert alert-warning alert-dismissible fade show">
                    Application deleted! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Stats Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-primary text-primary">
                                    <i class="feather-file-text"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalApps %></div>
                                    <div class="fs-13 text-muted">Total Applications</div>
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
                                <div class="avatar-text avatar-lg bg-soft-success text-success">
                                    <i class="feather-check-circle"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalAccepted %></div>
                                    <div class="fs-13 text-muted">Accepted</div>
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
                                    <div class="fs-4 fw-bold text-dark"><%= totalRejected %></div>
                                    <div class="fs-13 text-muted">Rejected</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter + Search -->
            <div class="card mb-3">
                <div class="card-body py-3">
                    <form method="GET" action="admin-applications.jsp" class="d-flex align-items-center gap-3 flex-wrap">
                        <input type="text" name="search" class="form-control" style="max-width:250px;"
                               placeholder="Search name or email..."
                               value="<%= search != null ? search : "" %>">
                        <select name="filter" class="form-select" style="max-width:160px;">
                            <option value="">All Status</option>
                            <option value="pending"  <%= "pending".equals(filterStatus)  ? "selected" : "" %>>Pending</option>
                            <option value="accepted" <%= "accepted".equals(filterStatus) ? "selected" : "" %>>Accepted</option>
                            <option value="rejected" <%= "rejected".equals(filterStatus) ? "selected" : "" %>>Rejected</option>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="feather-search me-2"></i>Filter
                        </button>
                        <a href="admin-applications.jsp" class="btn btn-light">
                            <i class="feather-refresh-cw me-2"></i>Reset
                        </a>
                    </form>
                </div>
            </div>

            <!-- Applications Table -->
            <div class="card stretch stretch-full">
                <div class="card-header">
                    <h5 class="card-title">All Applications (<%= apps.size() %>)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Applicant</th>
                                    <th>Job Title</th>
                                    <th>Contact</th>
                                    <th>City</th>
                                    <th>Experience</th>
                                    <th>Resume</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (apps.isEmpty()) { %>
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">No applications found.</td>
                                </tr>
                                <% } else {
                                    int i = 1;
                                    for (Map<String, String> app : apps) {
                                        String st = app.get("status");
                                        String bc = "pending".equals(st)  ? "bg-soft-warning text-warning"  :
                                                    "accepted".equals(st) ? "bg-soft-success text-success" :
                                                    "bg-soft-danger text-danger";
                                        String initial = app.get("fullname") != null && !app.get("fullname").isEmpty()
                                                         ? app.get("fullname").substring(0,1).toUpperCase() : "?";
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width:36px;height:36px;border-radius:50%;background:#eff6ff;color:#1a56db;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;">
                                                <%= initial %>
                                            </div>
                                            <div>
                                                <div class="fw-semibold text-dark"><%= app.get("fullname") %></div>
                                                <div class="fs-12 text-muted"><%= app.get("email") %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-soft-primary text-primary"><%= app.get("job_title") %></span></td>
                                    <td><i class="feather-phone me-1 text-muted fs-12"></i><%= app.get("mobileno") %></td>
                                    <td><%= app.get("city") %></td>
                                    <td><span class="badge bg-soft-info text-info"><%= app.get("experience") %> yr</span></td>
                                    <td>
                                        <% if (app.get("resume") != null && !app.get("resume").isEmpty()) { %>
                                            <a href="uploads/<%= app.get("resume") %>" target="_blank" class="btn btn-sm btn-soft-primary">
                                                <i class="feather-download me-1"></i>View
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted fs-12">No resume</span>
                                        <% } %>
                                    </td>
                                    <td><span class="badge <%= bc %>"><%= st %></span></td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <a href="admin-applications.jsp?action=status&id=<%= app.get("app_id") %>&status=accepted"
                                               class="btn btn-sm btn-soft-success" title="Accept"
                                               onclick="return confirm('Accept karvu chhe?')">
                                               <i class="feather-check"></i>
                                            </a>
                                            <a href="admin-applications.jsp?action=status&id=<%= app.get("app_id") %>&status=rejected"
                                               class="btn btn-sm btn-soft-danger" title="Reject"
                                               onclick="return confirm('Reject karvu chhe?')">
                                               <i class="feather-x"></i>
                                            </a>
                                            <a href="admin-applications.jsp?action=status&id=<%= app.get("app_id") %>&status=pending"
                                               class="btn btn-sm btn-soft-warning" title="Set Pending">
                                               <i class="feather-clock"></i>
                                            </a>
                                            <a href="admin-applications.jsp?action=delete&id=<%= app.get("app_id") %>"
                                               class="btn btn-sm btn-soft-dark" title="Delete"
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

<script src="assets/vendors/js/vendors.min.js"></script>
<script src="assets/vendors/js/bootstrap.min.js"></script>
<script src="assets/js/common-init.min.js"></script>

<%@include file="footer.jsp" %>
</body>
</html>