<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel, java.sql.*" %>
<%
    
    UserModel m = (UserModel) session.getAttribute("Model");
    if(m == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String userEmail = m.getEmail();

    String fullname = m.getFirstname() + " " + m.getLastname();
    String email     = userEmail;
    String mobileno  = "", city = "", experience = "", resumePath = "";
    String status    = "Pending", appliedDate = "N/A";
    int jobId        = 0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "");

        // ✅ Table name "apply" - tamara DB mujab
        String sql = "SELECT * FROM apply WHERE email = ? ORDER BY app_id DESC LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            mobileno    = rs.getString("mobileno")   != null ? rs.getString("mobileno")   : "";
            city        = rs.getString("city")        != null ? rs.getString("city")       : "";
            experience  = rs.getString("experience")  != null ? rs.getString("experience") : "";
            resumePath  = rs.getString("resume")      != null ? rs.getString("resume")     : "";
            status      = rs.getString("status")      != null ? rs.getString("status")     : "Pending";
            jobId       = rs.getInt("job_id");
            appliedDate = rs.getString("applied_date")!= null ? rs.getString("applied_date") : "N/A";
        }
        rs.close(); ps.close(); conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    String badgeClass = "badge-warning";
    if ("Approved".equalsIgnoreCase(status)) badgeClass = "badge-success";
    if ("Rejected".equalsIgnoreCase(status)) badgeClass = "badge-danger";
    if ("Reviewed".equalsIgnoreCase(status)) badgeClass = "badge-info";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Application View – JobBoard</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="css/custom-bs.css">
    <link rel="stylesheet" href="fonts/icomoon/style.css">
    <link rel="stylesheet" href="fonts/line-icons/style.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .appview-wrapper { max-width: 780px; margin: 60px auto 80px; padding: 0 15px; }
        .appview-card { background: #fff; border-radius: 12px; box-shadow: 0 8px 40px rgba(0,0,0,0.10); overflow: hidden; }
        .appview-header { background: linear-gradient(135deg, #2d6a4f 0%, #1b4332 100%); padding: 36px 40px 28px; color: #fff; position: relative; }
        .appview-header .job-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 4px; }
        .appview-header .company-name { font-size: 1rem; opacity: .85; margin-bottom: 0; }
        .appview-header .status-badge { position: absolute; top: 36px; right: 40px; font-size: .85rem; padding: 6px 18px; border-radius: 30px; font-weight: 600; text-transform: uppercase; }
        .badge-warning { background:#ffc107; color:#333; }
        .badge-success { background:#28a745; color:#fff; }
        .badge-danger  { background:#dc3545; color:#fff; }
        .badge-info    { background:#17a2b8; color:#fff; }
        .appview-body { padding: 36px 40px; }
        .section-label { font-size: .75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1.5px; color: #2d6a4f; border-bottom: 2px solid #e8f5e9; padding-bottom: 8px; margin-bottom: 24px; }
        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 32px; margin-bottom: 36px; }
        @media(max-width:576px){ .detail-grid{grid-template-columns:1fr;} .appview-header{padding:28px 24px;} .appview-header .status-badge{position:static;display:inline-block;margin-top:12px;} .appview-body{padding:28px 24px;} }
        .detail-item label { display: block; font-size: .75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: #999; margin-bottom: 4px; }
        .detail-item .value { font-size: 1rem; color: #222; font-weight: 500; }
        .meta-bar { background: #f0faf4; border-radius: 8px; padding: 14px 20px; display: flex; align-items: center; gap: 10px; margin-bottom: 32px; font-size: .9rem; color: #555; }
        .resume-box { background: #f8f9fa; border: 2px dashed #c8e6c9; border-radius: 10px; padding: 22px 28px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 36px; flex-wrap: wrap; gap: 12px; }
        .resume-info { display: flex; align-items: center; gap: 14px; }
        .resume-icon { width: 48px; height: 48px; background: #2d6a4f; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 1.3rem; }
        .resume-name { font-weight: 600; color: #222; margin: 0; }
        .resume-sub  { font-size: .82rem; color: #888; margin: 0; }
        .action-row { display: flex; gap: 12px; flex-wrap: wrap; }
        .btn-back { background: #fff; border: 2px solid #2d6a4f; color: #2d6a4f; padding: 10px 28px; border-radius: 6px; font-weight: 600; text-decoration: none; }
        .btn-back:hover { background: #2d6a4f; color: #fff; }
        .btn-track { background: #2d6a4f; color: #fff; padding: 10px 28px; border-radius: 6px; font-weight: 600; text-decoration: none; display: inline-block; }
        .btn-track:hover { background: #1b4332; color: #fff; }
    </style>
</head>
<body id="top">

<div id="overlayer"></div>
<div class="loader">
    <div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>
</div>

<div class="site-wrap">

    <div class="site-mobile-menu site-navbar-target">
        <div class="site-mobile-menu-header">
            <div class="site-mobile-menu-close mt-3"><span class="icon-close2 js-menu-toggle"></span></div>
        </div>
        <div class="site-mobile-menu-body"></div>
    </div>

    <header class="site-navbar mt-3">
        <div class="container-fluid">
            <div class="row align-items-center">
                <div class="site-logo col-6"><a href="index.jsp">JobBoard</a></div>
                <nav class="mx-auto site-navigation">
                    <ul class="site-menu js-clone-nav d-none d-xl-block ml-0 pl-0">
                        <li><a href="user-home.jsp" class="nav-link">Home</a></li>
                        <li><a href="about.jsp">About</a></li>
                        <li class="has-children">
                            <a href="job-listings.jsp">Job Listings</a>
                            <ul class="dropdown"></ul>
                        </li>
                        <li><a href="Application-track.jsp">My Applications</a></li>
                        <li class="d-lg-none"><a href="logout.jsp">Logout</a></li>
                    </ul>
                </nav>
                <div class="right-cta-menu text-right d-flex aligin-items-center col-6">
                    <div class="ml-auto">
                        <a href="logout.jsp" class="btn btn-primary border-width-2 d-none d-lg-inline-block">
                            <span class="mr-2 icon-lock_outline"></span>Logout
                        </a>
                    </div>
                    <a href="#" class="site-menu-toggle js-menu-toggle d-inline-block d-xl-none mt-lg-2 ml-3">
                        <span class="icon-menu h3 m-0 p-0 mt-2"></span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <section class="section-hero overlay inner-page bg-image" style="background-image: url('images/hero_1.jpg');" id="home-section">
        <div class="container">
            <div class="row">
                <div class="col-md-7">
                    <h1 class="text-white font-weight-bold">Application Details</h1>
                    <div class="custom-breadcrumbs">
                        <a href="user-home.jsp">Home</a> <span class="mx-2 slash">/</span>
                        <a href="Application-track.jsp">My Applications</a> <span class="mx-2 slash">/</span>
                        <span class="text-white"><strong>Application View</strong></span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="appview-wrapper">
        <div class="appview-card">

            <div class="appview-header">
                <p class="job-title">Job ID: #<%= jobId %></p>
                <p class="company-name">Applied by: <%= m.getFirstname() %> <%= m.getLastname() %></p>
                <span class="status-badge <%= badgeClass %>"><%= status %></span>
            </div>

            <div class="appview-body">

                <div class="meta-bar">
                    &#128197; &nbsp; Applied on: <strong>&nbsp;<%= appliedDate %></strong>
                </div>

                <p class="section-label">Applicant Information</p>
                <div class="detail-grid">
                    <div class="detail-item">
                        <label>Full Name</label>
                        <span class="value"><%= fullname %></span>
                    </div>
                    <div class="detail-item">
                        <label>Email Address</label>
                        <span class="value"><%= email %></span>
                    </div>
                    <div class="detail-item">
                        <label>Mobile Number</label>
                        <span class="value"><%= mobileno.isEmpty() ? "—" : mobileno %></span>
                    </div>
                    <div class="detail-item">
                        <label>Current City</label>
                        <span class="value"><%= city.isEmpty() ? "—" : city %></span>
                    </div>
                    <div class="detail-item">
                        <label>Experience</label>
                        <span class="value"><%= experience.isEmpty() ? "—" : experience + " Year(s)" %></span>
                    </div>
                    <div class="detail-item">
                        <label>Application Status</label>
                        <span class="value">
                            <span class="badge <%= badgeClass %>" style="font-size:.85rem;padding:5px 14px;border-radius:20px;">
                                <%= status %>
                            </span>
                        </span>
                    </div>
                </div>

                <p class="section-label">Uploaded Resume</p>
                <div class="resume-box">
                    <div class="resume-info">
                        <div class="resume-icon">&#128196;</div>
                        <div>
                            <p class="resume-name"><%= resumePath.isEmpty() ? "resume.pdf" : resumePath %></p>
                            <p class="resume-sub">PDF Document</p>
                        </div>
                    </div>
                    <% if (!resumePath.isEmpty()) { %>
                        <a href="uploads/<%= resumePath %>" target="_blank" class="btn-track">&#8681; View Resume</a>
                    <% } else { %>
                        <span style="color:#bbb;font-size:.9rem;">No resume uploaded</span>
                    <% } %>
                </div>

                <div class="action-row">
                    <a href="user-home.jsp" class="btn-back">&#8592; Back to Home</a>
                    <a href="Application-track.jsp" class="btn-track">My Applications &#8594;</a>
                </div>

            </div>
        </div>
    </div>

    <footer class="site-footer">
        <a href="#top" class="smoothscroll scroll-top"><span class="icon-keyboard_arrow_up"></span></a>
        <div class="container">
            <div class="row mb-5">
                <div class="col-6 col-md-3 mb-4 mb-md-0">
                    <h3>Search Trending</h3>
                    <ul class="list-unstyled">
                        <li><a href="#">Web Design</a></li>
                        <li><a href="#">Graphic Design</a></li>
                        <li><a href="#">Web Developers</a></li>
                        <li><a href="#">Python</a></li>
                        <li><a href="#">HTML5</a></li>
                        <li><a href="#">CSS3</a></li>
                    </ul>
                </div>
                <div class="col-6 col-md-3 mb-4 mb-md-0">
                    <h3>Company</h3>
                    <ul class="list-unstyled">
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">Career</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">Resources</a></li>
                    </ul>
                </div>
                <div class="col-6 col-md-3 mb-4 mb-md-0">
                    <h3>Support</h3>
                    <ul class="list-unstyled">
                        <li><a href="#">Support</a></li>
                        <li><a href="#">Privacy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
                <div class="col-6 col-md-3 mb-4 mb-md-0">
                    <h3>Contact Us</h3>
                    <div class="footer-social">
                        <a href="#"><span class="icon-facebook"></span></a>
                        <a href="#"><span class="icon-twitter"></span></a>
                        <a href="#"><span class="icon-instagram"></span></a>
                        <a href="#"><span class="icon-linkedin"></span></a>
                    </div>
                </div>
            </div>
            <div class="row text-center">
                <div class="col-12">
                    <p class="copyright"><small>
                        Copyright &copy;<script>document.write(new Date().getFullYear());</script>
                        All rights reserved | Made with <i class="icon-heart text-danger"></i> by
                        <a href="https://colorlib.com" target="_blank">Colorlib</a>
                    </small></p>
                </div>
            </div>
        </div>
    </footer>

</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>
<script src="js/isotope.pkgd.min.js"></script>
<script src="js/stickyfill.min.js"></script>
<script src="js/jquery.fancybox.min.js"></script>
<script src="js/jquery.easing.1.3.js"></script>
<script src="js/jquery.waypoints.min.js"></script>
<script src="js/jquery.animateNumber.min.js"></script>
<script src="js/owl.carousel.min.js"></script>
<script src="js/bootstrap-select.min.js"></script>
<script src="js/custom.js"></script>

</body>
</html>