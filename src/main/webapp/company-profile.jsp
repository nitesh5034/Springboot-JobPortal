<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.UserModel" %>
<%
  UserModel u = (UserModel) session.getAttribute("Model");
  if (u == null) {
    u = new UserModel();
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Company Profile Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="shortcut icon" href="ftco-32x32.png">

  <!-- Core Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
  
  <!-- FontAwesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <link rel="stylesheet" href="css/custom-bs.css">
  <link rel="stylesheet" href="css/bootstrap-select.min.css">
  <link rel="stylesheet" href="fonts/icomoon/style.css">
  <link rel="stylesheet" href="css/style.css">
  
  <style>
    body {
        font-family: 'DM Sans', sans-serif;
        background-color: #f8fafc;
        color: #334155;
    }
    
    /* Premium Glassmorphic Navbar Custom for Company */
    .site-navbar {
        background: rgba(255,255,255,0.95) !important;
        backdrop-filter: blur(10px) !important;
        border-bottom: 1px solid rgba(226, 232, 240, 0.8) !important;
        box-shadow: 0 4px 20px rgba(0,0,0,0.03) !important;
        position: sticky;
        top: 0;
        z-index: 999;
    }
    .site-logo a {
        font-family: 'Sora', sans-serif !important;
        font-weight: 800 !important;
        color: #0f172a !important;
        font-size: 24px !important;
        letter-spacing: -0.5px;
    }
    .site-logo a span { color: #2563eb; }
    
    .site-menu > li > a {
        font-family: 'DM Sans', sans-serif;
        font-weight: 600 !important;
        color: #64748b !important;
        transition: all 0.3s ease;
    }
    .site-menu > li > a:hover,
    .site-menu > li > a.active {
        color: #2563eb !important;
    }

    /* Hero Section */
    .hero-dashboard {
        background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
        padding: 80px 0 100px 0;
        position: relative;
    }
    .hero-dashboard::after {
        content: '';
        position: absolute;
        bottom: 0; left: 0; right: 0;
        height: 50px;
        background: #f8fafc;
        clip-path: polygon(0 100%, 100% 0, 100% 100%);
    }
    .hero-title {
        font-family: 'Sora', sans-serif;
        color: #ffffff;
        font-weight: 700;
        font-size: 36px;
        margin-bottom: 10px;
    }
    .hero-subtitle {
        color: #bfdbfe;
        font-size: 16px;
        font-weight: 400;
    }

    /* Premium Profile Cards container overlapping the Hero */
    .dashboard-container {
        margin-top: -60px;
        position: relative;
        z-index: 10;
    }

    /* Glass Card Style */
    .premium-card {
        background: #ffffff;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(15, 23, 42, 0.08);
        border: 1px solid rgba(255, 255, 255, 0.8);
        padding: 30px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .premium-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 50px rgba(15, 23, 42, 0.12);
    }
    
    /* User Avatar */
    .avatar-wrapper {
        position: relative;
        width: 140px;
        height: 140px;
        margin: 0 auto 20px auto;
    }
    .company-avatar {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        color: #fff;
        font-size: 56px;
        font-weight: 800;
        font-family: 'Sora', sans-serif;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 8px 25px rgba(37, 99, 235, 0.4);
        border: 4px solid #fff;
        position: relative;
        z-index: 2;
    }
    .avatar-ring {
        position: absolute;
        top: -8px; left: -8px; right: -8px; bottom: -8px;
        border-radius: 50%;
        border: 2px dashed #93c5fd;
        animation: spin 15s linear infinite;
        z-index: 1;
    }
    @keyframes spin { 100% { transform: rotate(360deg); } }

    .company-name {
        font-family: 'Sora', sans-serif;
        font-weight: 700;
        font-size: 24px;
        color: #0f172a;
        margin-bottom: 5px;
    }
    .company-role {
        color: #64748b;
        font-weight: 500;
        font-size: 14px;
        background: #f1f5f9;
        display: inline-block;
        padding: 5px 15px;
        border-radius: 20px;
    }

    .btn-edit-profile {
        background: #2563eb;
        color: #fff;
        border-radius: 12px;
        padding: 12px 24px;
        font-weight: 600;
        border: none;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        width: 100%;
        justify-content: center;
        margin-top: 25px;
    }
    .btn-edit-profile:hover {
        background: #1d4ed8;
        color: #ffffff;
        transform: scale(1.02);
    }

    /* Details Grid */
    .details-header {
        font-family: 'Sora', sans-serif;
        font-weight: 700;
        font-size: 20px;
        color: #0f172a;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 10px;
        padding-bottom: 15px;
        border-bottom: 1px solid #f1f5f9;
    }
    .details-header i {
        color: #3b82f6;
        background: #eff6ff;
        padding: 10px;
        border-radius: 10px;
        font-size: 18px;
    }

    .info-box {
        background: #f8fafc;
        border: 1px solid #f1f5f9;
        border-radius: 16px;
        padding: 20px;
        margin-bottom: 20px;
        transition: all 0.3s ease;
        display: flex;
        align-items: flex-start;
        gap: 15px;
    }
    .info-box:hover {
        background: #ffffff;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        border-color: #e2e8f0;
    }
    .info-icon {
        background: #eff6ff;
        color: #2563eb;
        width: 45px;
        height: 45px;
        min-width: 45px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
    }
    .info-content {
        flex: 1;
    }
    .info-label {
        font-size: 12px;
        color: #64748b;
        text-transform: uppercase;
        font-weight: 700;
        letter-spacing: 0.5px;
        margin-bottom: 4px;
    }
    .info-value {
        font-size: 16px;
        color: #0f172a;
        font-weight: 600;
    }
  </style>
</head>
<body id="top">

<div class="site-wrap">

  <div class="site-mobile-menu site-navbar-target">
    <div class="site-mobile-menu-header">
      <div class="site-mobile-menu-close mt-3">
        <span class="icon-close2 js-menu-toggle"></span>
      </div>
    </div>
    <div class="site-mobile-menu-body"></div>
  </div>

  <!-- MODERN NAVBAR -->
  <header class="site-navbar mt-3">
    <div class="container-fluid">
      <div class="row align-items-center">
        <!-- Logo -->
        <div class="site-logo col-6">
          <a href="compny-home.jsp">Job<span>Board</span></a>
        </div>
        
        <!-- Navigation -->
        <nav class="mx-auto site-navigation col-auto d-none d-xl-block">
          <ul class="site-menu js-clone-nav ml-0 pl-0 d-flex align-items-center" style="gap:5px;">
            <li><a href="compny-home.jsp">Home</a></li>
            <li><a href="postjob.jsp">Post a Job</a></li>
            <li><a href="applicationview.jsp">Applications</a></li>
          </ul>
        </nav>
        
        <!-- Right User Actions -->
        <div class="right-cta-menu text-right d-flex align-items-center col-6 justify-content-end">
          <div class="ml-auto d-none d-lg-flex align-items-center" style="gap:15px;">
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center active" data-toggle="dropdown" style="gap:8px; font-weight:600; color:#0f172a; text-decoration:none;">
                    <img src="https://ui-avatars.com/api/?name=<%= u.getFirstname() != null ? u.getFirstname() : "A" %>&background=e2e8f0&color=0f172a" style="width:36px; border-radius:10px;">
                    <%= u.getFirstname() != null ? u.getFirstname() : "Admin" %> <i class="fa-solid fa-chevron-down ms-1" style="font-size:12px; color:#64748b;"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-right" style="border:none; border-radius:12px; box-shadow:0 10px 40px rgba(0,0,0,0.1); padding:10px; margin-top:15px;">
                    <a class="dropdown-item" href="company-profile.jsp" style="border-radius:8px; padding:10px 15px;"><i class="fa-regular fa-user mr-2 text-primary"></i> View Profile</a>
                    <a class="dropdown-item" href="settings.jsp" style="border-radius:8px; padding:10px 15px;"><i class="fa-solid fa-gear mr-2 text-primary"></i> Settings</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item text-danger" href="logout" style="border-radius:8px; padding:10px 15px;"><i class="fa-solid fa-arrow-right-from-bracket mr-2"></i> Logout</a>
                </div>
            </div>
          </div>
          <a href="#" class="site-menu-toggle js-menu-toggle d-inline-block d-xl-none mt-lg-2 ml-3">
            <span class="icon-menu h3 m-0 p-0 mt-2"></span>
          </a>
        </div>
      </div>
    </div>
  </header>

  <!-- HERO SECTION -->
  <section class="hero-dashboard text-center">
    <div class="container">
      <h1 class="hero-title">Company Dashboard</h1>
      <p class="hero-subtitle">Manage your company profile, settings, and job postings.</p>
    </div>
  </section>

  <!-- MAIN DASHBOARD CONTENT -->
  <section class="dashboard-container pb-5">
    <div class="container">
      <div class="row">
          
        <!-- LEFT: Profile Summary Card -->
        <div class="col-lg-4 mb-4">
            <div class="premium-card text-center">
                <div class="avatar-wrapper">
                    <div class="avatar-ring"></div>
                    <div class="company-avatar">
                       <%= (u.getFirstname() != null && !u.getFirstname().isEmpty()) ? u.getFirstname().substring(0,1).toUpperCase() : "C" %>
                    </div>
                </div>
                <h3 class="company-name">
                    <%= u.getFirstname() != null ? u.getFirstname() : "Company" %> 
                    <%= u.getLastname() != null ? u.getLastname() : "" %>
                </h3>
                <span class="company-role"><i class="fa-solid fa-briefcase mr-1"></i> <%= u.getRole() != null ? u.getRole() : "Enterprise Account" %></span>
                
                <a href="EditProfile.jsp" class="btn-edit-profile">
                    <i class="fa-regular fa-pen-to-square"></i> Edit Profile
                </a>
            </div>
            
            <!-- Quick Stats Optional Idea -->
            <div class="premium-card mt-4" style="padding:20px;">
                <h6 style="font-family:'Sora',sans-serif; font-weight:700; color:#0f172a; margin-bottom:15px;"><i class="fa-solid fa-chart-line text-primary mr-2"></i> Quick Overview</h6>
                <div class="d-flex justify-content-between align-items-center mb-2 pb-2 border-bottom">
                    <span style="color:#64748b; font-weight:500;">Status</span>
                    <span class="badge badge-success" style="background:#10b981; color:#fff; padding:6px 12px; border-radius:8px;">Active</span>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <span style="color:#64748b; font-weight:500;">Member Since</span>
                    <span style="color:#0f172a; font-weight:600;">2024</span>
                </div>
            </div>
        </div>
        
        <!-- RIGHT: Profile Details Grid -->
        <div class="col-lg-8">
            <div class="premium-card h-100">
                <div class="details-header">
                    <i class="fa-regular fa-id-card"></i> Company Information
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="info-icon"><i class="fa-regular fa-user"></i></div>
                            <div class="info-content">
                                <div class="info-label">Full Name</div>
                                <div class="info-value"><%= u.getFirstname() != null ? u.getFirstname() : "Not Provided" %> <%= u.getLastname() != null ? u.getLastname() : "" %></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="info-icon"><i class="fa-regular fa-envelope"></i></div>
                            <div class="info-content">
                                <div class="info-label">Email Address</div>
                                <div class="info-value"><%= u.getEmail() != null ? u.getEmail() : "Not Provided" %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="info-icon"><i class="fa-solid fa-phone"></i></div>
                            <div class="info-content">
                                <div class="info-label">Contact Number</div>
                                <div class="info-value"><%= u.getContact() != null ? u.getContact() : "Not Provided" %></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="info-icon"><i class="fa-regular fa-building"></i></div>
                            <div class="info-content">
                                <div class="info-label">City</div>
                                <div class="info-value"><%= u.getCity() != null ? u.getCity() : "Not Provided" %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-box">
                            <div class="info-icon"><i class="fa-solid fa-map-location-dot"></i></div>
                            <div class="info-content">
                                <div class="info-label">State</div>
                                <div class="info-value"><%= u.getState() != null ? u.getState() : "Not Provided" %></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-box" style="margin-bottom:0;">
                            <div class="info-icon"><i class="fa-solid fa-thumbtack"></i></div>
                            <div class="info-content">
                                <div class="info-label">Pincode</div>
                                <div class="info-value"><%= u.getPincode() != 0 ? u.getPincode() : "Not Provided" %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
        
      </div>
    </div>
  </section>

</div>

<!-- SCRIPTS -->
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
