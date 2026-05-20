<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.util.DBUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String action = request.getParameter("action");
    String msg = "";

    // Delete user
    if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection cn = new DBUtil().getConnection();
            PreparedStatement ps = cn.prepareStatement("DELETE FROM userregister WHERE userid=?");
            ps.setInt(1, id);
            ps.executeUpdate(); ps.close(); cn.close();
            msg = "deleted";
        } catch (Exception e) { e.printStackTrace(); }
    }

    String search = request.getParameter("search");
    String filterRole = request.getParameter("filter");

    List<Map<String, String>> users = new ArrayList<>();
    int totalUsers = 0, totalJobseekers = 0, totalEmployers = 0;

    try {
        Connection cn = new DBUtil().getConnection();

        // Stats
        ResultSet rs2 = cn.createStatement().executeQuery(
            "SELECT role, COUNT(*) as cnt FROM userregister GROUP BY role");
        while (rs2.next()) {
            String r = rs2.getString("role");
            int c    = rs2.getInt("cnt");
            totalUsers += c;
            if ("jobseeker".equalsIgnoreCase(r)) totalJobseekers = c;
            if ("employer".equalsIgnoreCase(r))  totalEmployers  = c;
        }
        rs2.close();

        // Build query
        String sql = "SELECT * FROM userregister WHERE 1=1";
        if (search != null && !search.isEmpty())
            sql += " AND (firstname LIKE '%" + search + "%' OR lastname LIKE '%" + search + "%' OR email LIKE '%" + search + "%' OR city LIKE '%" + search + "%')";
        if (filterRole != null && !filterRole.isEmpty())
            sql += " AND role = '" + filterRole + "'";
        sql += " ORDER BY userid DESC";

        PreparedStatement ps = cn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> m = new HashMap<>();
            m.put("userid",    rs.getString("userid"));
            m.put("firstname", rs.getString("firstname"));
            m.put("lastname",  rs.getString("lastname"));
            m.put("email",     rs.getString("email"));
            m.put("mobileno",  rs.getString("mobileno"));
            m.put("city",      rs.getString("city"));
            m.put("state",     rs.getString("state"));
            m.put("role",      rs.getString("role"));
            users.add(m);
        }
        rs.close(); ps.close(); cn.close();
    } catch (Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin — Users</title>
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
                    <h5 class="m-b-10">Users</h5>
                </div>
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                    <li class="breadcrumb-item">Users</li>
                </ul>
            </div>
        </div>

        <div class="main-content">

            <% if ("deleted".equals(msg)) { %>
                <div class="alert alert-warning alert-dismissible fade show">
                    User deleted! <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Stats -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-center gap-3">
                                <div class="avatar-text avatar-lg bg-soft-primary text-primary">
                                    <i class="feather-users"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalUsers %></div>
                                    <div class="fs-13 text-muted">Total Users</div>
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
                                    <i class="feather-user"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalJobseekers %></div>
                                    <div class="fs-13 text-muted">Job Seekers</div>
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
                                    <i class="feather-briefcase"></i>
                                </div>
                                <div>
                                    <div class="fs-4 fw-bold text-dark"><%= totalEmployers %></div>
                                    <div class="fs-13 text-muted">Employers</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search + Filter -->
            <div class="card mb-3">
                <div class="card-body py-3">
                    <form method="GET" action="admin-users.jsp" class="d-flex align-items-center gap-3 flex-wrap">
                        <input type="text" name="search" class="form-control" style="max-width:250px;"
                               placeholder="Search name, email, city..."
                               value="<%= search != null ? search : "" %>">
                        <select name="filter" class="form-select" style="max-width:160px;">
                            <option value="">All Roles</option>
                            <option value="jobseeker" <%= "jobseeker".equals(filterRole) ? "selected" : "" %>>Job Seeker</option>
                            <option value="employer"  <%= "employer".equals(filterRole)  ? "selected" : "" %>>Employer</option>
                        </select>
                        <button type="submit" class="btn btn-primary">
                            <i class="feather-search me-2"></i>Filter
                        </button>
                        <a href="admin-users.jsp" class="btn btn-light">
                            <i class="feather-refresh-cw me-2"></i>Reset
                        </a>
                    </form>
                </div>
            </div>

            <!-- Users Table -->
            <div class="card stretch stretch-full">
                <div class="card-header">
                    <h5 class="card-title">All Users (<%= users.size() %>)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>User</th>
                                    <th>Email</th>
                                    <th>Mobile</th>
                                    <th>City</th>
                                    <th>State</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (users.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">No users found.</td>
                                </tr>
                                <% } else {
                                    int i = 1;
                                    for (Map<String, String> u : users) {
                                        String role = u.get("role");
                                        String rc = "jobseeker".equalsIgnoreCase(role) ? "bg-soft-success text-success" : "bg-soft-warning text-warning";
                                        String initial = u.get("firstname") != null && !u.get("firstname").isEmpty()
                                                         ? u.get("firstname").substring(0,1).toUpperCase() : "U";
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width:36px;height:36px;border-radius:50%;background:#eff6ff;color:#1a56db;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;">
                                                <%= initial %>
                                            </div>
                                            <div>
                                                <div class="fw-semibold text-dark"><%= u.get("firstname") %> <%= u.get("lastname") %></div>
                                                <div class="fs-12 text-muted">ID: <%= u.get("userid") %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%= u.get("email") %></td>
                                    <td><i class="feather-phone me-1 text-muted fs-12"></i><%= u.get("mobileno") %></td>
                                    <td><%= u.get("city") %></td>
                                    <td><%= u.get("state") %></td>
                                    <td><span class="badge <%= rc %>"><%= role %></span></td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <!-- View -->
                                            <button class="btn btn-sm btn-soft-info" title="View Details"
                                                data-bs-toggle="modal" data-bs-target="#viewModal"
                                                data-name="<%= u.get("firstname") %> <%= u.get("lastname") %>"
                                                data-email="<%= u.get("email") %>"
                                                data-mobile="<%= u.get("mobileno") %>"
                                                data-city="<%= u.get("city") %>"
                                                data-state="<%= u.get("state") %>"
                                                data-role="<%= role %>"
                                                onclick="fillModal(this)">
                                                <i class="feather-eye"></i>
                                            </button>
                                            <!-- Delete -->
                                            <a href="admin-users.jsp?action=delete&id=<%= u.get("userid") %>"
                                               class="btn btn-sm btn-soft-danger" title="Delete"
                                               onclick="return confirm('User delete karvu chhe?')">
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

<!-- View User Modal -->
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
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Mobile</label>
                        <p id="modalMobile" class="mb-0"></p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">Role</label>
                        <p id="modalRole" class="mb-0"></p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">City</label>
                        <p id="modalCity" class="mb-0"></p>
                    </div>
                    <div class="col-md-6">
                        <label class="fw-semibold text-muted fs-12 text-uppercase">State</label>
                        <p id="modalState" class="mb-0"></p>
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
    document.getElementById('modalName').textContent   = el.dataset.name;
    document.getElementById('modalEmail').textContent  = el.dataset.email;
    document.getElementById('modalMobile').textContent = el.dataset.mobile;
    document.getElementById('modalRole').textContent   = el.dataset.role;
    document.getElementById('modalCity').textContent   = el.dataset.city  || 'N/A';
    document.getElementById('modalState').textContent  = el.dataset.state || 'N/A';
}
</script>

<%@include file="footer.jsp" %>
</body>
</html>