<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>JobBoard — Apply</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" href="css/custom-bs.css">
  <link rel="stylesheet" href="css/jquery.fancybox.min.css">
  <link rel="stylesheet" href="css/bootstrap-select.min.css">
  <link rel="stylesheet" href="fonts/icomoon/style.css">
  <link rel="stylesheet" href="fonts/line-icons/style.css">
  <link rel="stylesheet" href="css/owl.carousel.min.css">
  <link rel="stylesheet" href="css/animate.min.css">
  <link rel="stylesheet" href="css/style.css">

  <style>
    .apply-card {
      background: #fff;
      border-radius: 16px;
      border: 1px solid #e2e8f0;
      box-shadow: 0 4px 24px rgba(0,0,0,0.07);
      padding: 36px;
      max-width: 640px;
      margin: 0 auto;
    }
    .apply-card h3 {
      font-size: 22px;
      font-weight: 700;
      color: #0f172a;
      margin-bottom: 6px;
    }
    .apply-card .subtitle {
      font-size: 13px;
      color: #94a3b8;
      margin-bottom: 28px;
    }
    .form-label {
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      color: #64748b;
      margin-bottom: 6px;
    }
    .form-control {
      border: 1.5px solid #e2e8f0 !important;
      border-radius: 10px !important;
      padding: 10px 14px !important;
      font-size: 14px !important;
      color: #0f172a !important;
      transition: border-color 0.2s, box-shadow 0.2s !important;
    }
    .form-control:focus {
      border-color: #1a56db !important;
      box-shadow: 0 0 0 3px rgba(26,86,219,0.08) !important;
    }
    .form-control::placeholder { color: #cbd5e1 !important; }
    .input-icon-wrap { position: relative; }
    .input-icon-wrap i {
      position: absolute; left: 13px; top: 50%;
      transform: translateY(-50%);
      color: #94a3b8; font-size: 13px; pointer-events: none;
    }
    .input-icon-wrap .form-control { padding-left: 36px !important; }
    .form-divider {
      font-size: 10px; font-weight: 700;
      text-transform: uppercase; letter-spacing: 1px;
      color: #1a56db; margin: 20px 0 14px;
      display: flex; align-items: center; gap: 10px;
    }
    .form-divider::after { content: ''; flex: 1; height: 1px; background: #e2e8f0; }
    .btn-apply-submit {
      background: linear-gradient(135deg, #1a56db, #2563eb);
      color: white; border: none;
      padding: 13px 24px; border-radius: 12px;
      font-size: 14px; font-weight: 600;
      width: 100%; cursor: pointer;
      transition: all 0.2s;
      box-shadow: 0 4px 14px rgba(26,86,219,0.3);
    }
    .btn-apply-submit:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(26,86,219,0.4); }
    .file-upload-wrap {
      border: 2px dashed #e2e8f0; border-radius: 12px;
      padding: 20px; text-align: center;
      cursor: pointer; transition: border-color 0.2s;
    }
    .file-upload-wrap:hover { border-color: #1a56db; }
    .file-upload-wrap input { display: none; }
    .job-info-banner {
      background: #eff6ff; border: 1px solid #bfdbfe;
      border-radius: 12px; padding: 14px 18px;
      display: flex; align-items: center; gap: 12px;
      margin-bottom: 24px;
    }

    /* ✅ Error/Success msg */
    .alert-success-custom {
      background: #f0fdf4; border: 1px solid #bbf7d0;
      color: #16a34a; border-radius: 10px;
      padding: 12px 16px; font-size: 13px; font-weight: 600;
      display: flex; align-items: center; gap: 8px;
      margin-bottom: 20px;
    }
    .alert-error-custom {
      background: #fef2f2; border: 1px solid #fecaca;
      color: #dc2626; border-radius: 10px;
      padding: 12px 16px; font-size: 13px; font-weight: 600;
      display: flex; align-items: center; gap: 8px;
      margin-bottom: 20px;
    }
  </style>
</head>
<body id="top">

<div id="overlayer"></div>
<div class="loader">
  <div class="spinner-border text-primary" role="status">
    <span class="sr-only">Loading...</span>
  </div>
</div>

<div class="site-wrap">

  <!-- MOBILE MENU -->
  <div class="site-mobile-menu site-navbar-target">
    <div class="site-mobile-menu-header">
      <div class="site-mobile-menu-close mt-3">
        <span class="icon-close2 js-menu-toggle"></span>
      </div>
    </div>
    <div class="site-mobile-menu-body"></div>
  </div>

  <!-- NAVBAR -->
  <header class="site-navbar mt-3">
    <div class="container-fluid">
      <div class="row align-items-center">
        <div class="site-logo col-6"><a href="index.jsp">JobBoard</a></div>
        <nav class="mx-auto site-navigation">
          <ul class="site-menu js-clone-nav d-none d-xl-block ml-0 pl-0">
            <li><a href="index.jsp" class="nav-link">Home</a></li>
            <li><a href="about.jsp">About</a></li>
            <li><a href="job-listings.jsp">Job Listings</a></li>
            <li><a href="contact.html">Contact</a></li>
            <li class="d-lg-none"><a href="login.jsp">Log In</a></li>
          </ul>
        </nav>
        <div class="right-cta-menu text-right d-flex aligin-items-center col-6">
          <div class="ml-auto">
            <a href="login.jsp" class="btn btn-primary border-width-2 d-none d-lg-inline-block">
              <span class="mr-2 icon-lock_outline"></span>Log In
            </a>
          </div>
          <a href="#" class="site-menu-toggle js-menu-toggle d-inline-block d-xl-none mt-lg-2 ml-3">
            <span class="icon-menu h3 m-0 p-0 mt-2"></span>
          </a>
        </div>
      </div>
    </div>
  </header>

  <!-- HERO -->
  <section class="section-hero overlay inner-page bg-image" style="background-image: url('images/hero_1.jpg');" id="home-section">
    <div class="container">
      <div class="row">
        <div class="col-md-7">
          <h1 class="text-white font-weight-bold">Apply for Job</h1>
          <div class="custom-breadcrumbs">
            <a href="index.jsp">Home</a> <span class="mx-2 slash">/</span>
            <a href="job-listings.jsp">Jobs</a> <span class="mx-2 slash">/</span>
            <span class="text-white"><strong>Apply</strong></span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- FORM SECTION -->
  <section class="site-section" id="next-section">
    <div class="container">
      <div class="apply-card">

        <!-- Job Info Banner -->
        <div class="job-info-banner">
          <div style="width:40px;height:40px;border-radius:10px;background:#dbeafe;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
            <i class="fas fa-briefcase" style="color:#2563eb;font-size:16px;"></i>
          </div>
          <div>
            <p style="font-size:13px;font-weight:700;color:#1e40af;margin:0;">Applying for Job #<%= request.getParameter("job_id") != null ? request.getParameter("job_id") : "—" %></p>
            <p style="font-size:11px;color:#3b82f6;margin:0;">Fill all details carefully</p>
          </div>
        </div>

        <h3>Job Application</h3>
        <p class="subtitle">Please fill in your details below to apply for this position.</p>

        <!-- ✅ MSG Show -->
        <% String msg = request.getParameter("msg"); %>
        <% if ("error".equals(msg)) { %>
          <div class="alert-error-custom">
            <i class="fas fa-exclamation-circle"></i> Something went wrong. Please try again.
          </div>
        <% } %>

        <!-- ✅ FORM — action fix, button fix -->
        <form action="ApplyServlet" method="post" enctype="multipart/form-data">
          <input type="hidden" name="action" value="apply">
          <input type="hidden" name="job_id" value="<%= request.getParameter("job_id") != null ? request.getParameter("job_id") : "" %>">

          <!-- Personal Info -->
          <div class="form-divider"><i class="fas fa-user mr-1"></i> Personal Info</div>

          <div class="row">
            <div class="col-md-6 form-group">
              <label class="form-label">Full Name <span class="text-danger">*</span></label>
              <div class="input-icon-wrap">
                <i class="fas fa-user"></i>
                <input type="text" name="fullname" class="form-control" placeholder="John Doe" required>
              </div>
            </div>
            <div class="col-md-6 form-group">
              <label class="form-label">Email <span class="text-danger">*</span></label>
              <div class="input-icon-wrap">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" class="form-control" placeholder="john@email.com" required>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 form-group">
              <label class="form-label">Mobile Number <span class="text-danger">*</span></label>
              <div class="input-icon-wrap">
                <i class="fas fa-phone"></i>
                <input type="text" name="mobileno" class="form-control" placeholder="9876543210" required>
              </div>
            </div>
            <div class="col-md-6 form-group">
              <label class="form-label">Current City <span class="text-danger">*</span></label>
              <div class="input-icon-wrap">
                <i class="fas fa-map-marker-alt"></i>
                <input type="text" name="city" class="form-control" placeholder="Ahmedabad" required>
              </div>
            </div>
          </div>

          <!-- Experience -->
          <div class="form-divider"><i class="fas fa-briefcase mr-1"></i> Experience</div>
          <div class="form-group">
            <label class="form-label">Experience (Years) <span class="text-danger">*</span></label>
            <div class="input-icon-wrap">
              <i class="fas fa-clock"></i>
              <input type="text" name="experience" class="form-control" placeholder="e.g. 2" required>
            </div>
          </div>

          <!-- Resume Upload -->
          <div class="form-divider"><i class="fas fa-file-pdf mr-1"></i> Resume</div>
          <div class="form-group">
            <label class="form-label">Upload Resume (PDF) <span class="text-danger">*</span></label>
            <div class="file-upload-wrap" onclick="document.getElementById('resumeFile').click()">
              <input type="file" id="resumeFile" name="resume" accept=".pdf" required
                onchange="document.getElementById('fileName').textContent = this.files[0].name">
              <i class="fas fa-cloud-upload-alt" style="font-size:24px;color:#94a3b8;margin-bottom:8px;display:block;"></i>
              <p style="font-size:13px;color:#64748b;margin:0;" id="fileName">Click to upload PDF resume</p>
              <p style="font-size:11px;color:#94a3b8;margin:4px 0 0;">Max 10MB • PDF only</p>
            </div>
          </div>

          <!-- ✅ Submit button fix — no onclick redirect -->
          <button type="submit" class="btn-apply-submit">
            <i class="fas fa-paper-plane mr-2"></i> Submit Application
          </button>

          <p style="text-align:center;font-size:12px;color:#94a3b8;margin-top:14px;">
            By applying you agree to our <a href="#" style="color:#1a56db;">Terms of Service</a>
          </p>
        </form>
      </div>
    </div>
  </section>

  <!-- FOOTER -->
  <footer class="site-footer">
    <a href="#top" class="smoothscroll scroll-top">
      <span class="icon-keyboard_arrow_up"></span>
    </a>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>