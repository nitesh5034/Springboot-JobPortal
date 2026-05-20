<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <title>JobBoard - Register</title>
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
  <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    :root {
      --primary: #1a56db;
      --accent: #f59e0b;
      --dark: #0f172a;
      --muted: #94a3b8;
      --border: #e2e8f0;
      --white: #ffffff;
      --radius: 12px;
    }
    body { font-family: 'DM Sans', sans-serif; background: #f8fafc; }

    /* HERO */
    .section-hero {
      background: linear-gradient(135deg, #060b14 0%, #0f172a 50%, #1a56db 100%) !important;
      padding: 60px 0 80px;
      position: relative;
    }
    .section-hero::after {
      content: '';
      position: absolute;
      inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 28px 28px;
      pointer-events: none;
    }
    .section-hero h1 {
      font-family: 'Sora', sans-serif;
      font-size: 2.2rem;
      font-weight: 800;
    }

    /* CARD */
    .register-card {
      background: var(--white);
      border-radius: 20px;
      border: 1px solid var(--border);
      box-shadow: 0 8px 40px rgba(15,23,42,0.12);
      padding: 40px;
      position: relative;
      overflow: hidden;
    }
    .register-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--primary), var(--accent));
      border-radius: 20px 20px 0 0;
    }
    .register-card h2 {
      font-family: 'Sora', sans-serif;
      font-size: 1.6rem;
      font-weight: 700;
      color: var(--dark);
      margin-bottom: 4px;
    }
    .register-card .subtitle {
      color: var(--muted);
      font-size: 14px;
      margin-bottom: 28px;
    }

    /* LABELS */
    label.text-black {
      font-size: 12px !important;
      font-weight: 600 !important;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      color: var(--muted) !important;
      margin-bottom: 6px;
      display: block;
    }

    /* INPUTS */
    .form-control {
      border: 1.5px solid var(--border) !important;
      border-radius: var(--radius) !important;
      padding: 11px 14px 11px 36px !important;
      font-size: 14px !important;
      color: var(--dark) !important;
      background: var(--white) !important;
      height: auto !important;
      transition: border-color 0.2s, box-shadow 0.2s !important;
    }
    .form-control:focus {
      border-color: var(--primary) !important;
      box-shadow: 0 0 0 3px rgba(26,86,219,0.08) !important;
      outline: none !important;
    }
    .form-control::placeholder { color: #cbd5e1 !important; }
    select.form-control { padding-left: 36px !important; }

    /* INPUT ICON WRAP */
    .input-wrap { position: relative; }
    .input-icon {
      position: absolute;
      left: 13px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--muted);
      font-size: 13px;
      pointer-events: none;
      z-index: 2;
    }

    /* SECTION TITLE */
    .form-section-title {
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: var(--primary);
      margin: 24px 0 16px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .form-section-title::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    /* SUBMIT BUTTON */
    .btn-register {
      width: 100%;
      background: linear-gradient(135deg, #1a56db, #2563eb);
      color: white;
      font-family: 'Sora', sans-serif;
      font-weight: 600;
      font-size: 15px;
      padding: 13px 24px;
      border-radius: var(--radius);
      border: none;
      cursor: pointer;
      transition: all 0.25s;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      box-shadow: 0 4px 16px rgba(26,86,219,0.3);
      margin-top: 8px;
    }
    .btn-register:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 24px rgba(26,86,219,0.4);
    }

    /* PASSWORD TOGGLE */
    .pass-wrap { position: relative; }
    .pass-toggle {
      position: absolute;
      right: 12px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: var(--muted);
      cursor: pointer;
      font-size: 13px;
      padding: 0;
    }
    .pass-toggle:hover { color: var(--primary); }

    /* INFO PANEL */
    .info-panel {
      background: linear-gradient(145deg, #0f172a, #1e3a8a);
      border-radius: 20px;
      padding: 40px 32px;
      color: white;
      position: relative;
      overflow: hidden;
      height: 100%;
    }
    .info-panel::before {
      content: '';
      position: absolute;
      inset: 0;
      background-image: radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px);
      background-size: 24px 24px;
    }
    .info-panel h3 {
      font-family: 'Sora', sans-serif;
      font-size: 1.4rem;
      font-weight: 700;
      margin-bottom: 8px;
      position: relative;
      z-index: 1;
    }
    .info-panel > p {
      color: rgba(255,255,255,0.6);
      font-size: 13px;
      line-height: 1.7;
      position: relative;
      z-index: 1;
    }
    .badge-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: rgba(245,158,11,0.15);
      border: 1px solid rgba(245,158,11,0.3);
      color: #fbbf24;
      border-radius: 999px;
      padding: 5px 12px;
      font-size: 11px;
      font-weight: 600;
      margin-bottom: 20px;
      position: relative;
      z-index: 1;
    }
    .info-feature {
      display: flex;
      align-items: flex-start;
      gap: 14px;
      padding: 16px 0;
      border-bottom: 1px solid rgba(255,255,255,0.08);
      position: relative;
      z-index: 1;
    }
    .info-feature:last-child { border-bottom: none; }
    .info-feature-icon {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      background: rgba(255,255,255,0.1);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      font-size: 16px;
    }
    .info-feature-text strong {
      display: block;
      font-size: 14px;
      font-weight: 600;
      margin-bottom: 3px;
      color: white;
    }
    .info-feature-text span {
      font-size: 12px;
      color: rgba(255,255,255,0.5);
    }

    /* LOGIN LINK */
    .login-link {
      text-align: center;
      margin-top: 20px;
      font-size: 13px;
      color: var(--muted);
    }
    .login-link a {
      color: var(--primary);
      font-weight: 600;
      text-decoration: none;
    }

    /* ANIMATION */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-up   { animation: fadeUp 0.5s ease both; }
    .fade-up-2 { animation: fadeUp 0.5s 0.1s ease both; }
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
        <div class="site-logo col-6"><a href="index.html">JobBoard</a></div>
        <nav class="mx-auto site-navigation">
          <ul class="site-menu js-clone-nav d-none d-xl-block ml-0 pl-0">
            <li><a href="index.html" class="nav-link">Home</a></li>
            <li><a href="about.html">About</a></li>
            <li class="has-children">
              <a href="job-listings.html">Job Listings</a>
              <ul class="dropdown">
                <li><a href="job-single.html">Job Single</a></li>
              </ul>
            </li>
            <li><a href="blog.html">Blog</a></li>
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
  <section class="section-hero overlay inner-page" id="home-section">
    <div class="container">
      <div class="row">
        <div class="col-md-7">
          <h1 class="text-white font-weight-bold">Sign Up / Register</h1>
          <div class="custom-breadcrumbs">
            <span class="text-white"><strong>Register</strong></span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- REGISTER SECTION -->
  <section class="site-section">
    <div class="container">
      <div class="row align-items-start">

        <!-- FORM -->
        <div class="col-lg-7 mb-5 mb-lg-0 fade-up">
          <div class="register-card">
            <h2>Create Your Account</h2>
            <p class="subtitle">Fill in the details below to get started on JobBoard.</p>

            <form action="UserController" method="post">
              <input type="hidden" name="action" value="register">

              <!-- Personal Info -->
              <div class="form-section-title">
                <i class="fas fa-user"></i> Personal Info
              </div>

              <div class="row form-group">
                <div class="col-md-6 mb-3 mb-md-0">
                  <label class="text-black">First Name *</label>
                  <div class="input-wrap">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" name="fname" class="form-control" placeholder="John" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <label class="text-black">Last Name *</label>
                  <div class="input-wrap">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" name="lname" class="form-control" placeholder="Doe" required>
                  </div>
                </div>
              </div>

              <div class="row form-group">
                <div class="col-md-6 mb-3 mb-md-0">
                  <label class="text-black">Email *</label>
                  <div class="input-wrap">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" name="email" class="form-control" placeholder="john@email.com" required>
                  </div>
                </div>
                <div class="col-md-6">
                  <label class="text-black">Contact *</label>
                  <div class="input-wrap">
                    <i class="fas fa-phone input-icon"></i>
                    <input type="text" name="contact" class="form-control" placeholder="9876543210" required>
                  </div>
                </div>
              </div>

              <!-- Address -->
              <div class="form-section-title">
                <i class="fas fa-map-marker-alt"></i> Address
              </div>

              <div class="row form-group">
                <div class="col-md-12">
                  <label class="text-black">Address</label>
                  <div class="input-wrap">
                    <i class="fas fa-home input-icon"></i>
                    <input type="text" name="address" class="form-control" placeholder="Street address">
                  </div>
                </div>
              </div>

              <div class="row form-group">
                <div class="col-md-4 mb-3 mb-md-0">
                  <label class="text-black">City</label>
                  <div class="input-wrap">
                    <i class="fas fa-city input-icon"></i>
                    <input type="text" name="city" class="form-control" placeholder="Ahmedabad">
                  </div>
                </div>
                <div class="col-md-4 mb-3 mb-md-0">
                  <label class="text-black">State</label>
                  <div class="input-wrap">
                    <i class="fas fa-map input-icon"></i>
                    <input type="text" name="state" class="form-control" placeholder="Gujarat">
                  </div>
                </div>
                <div class="col-md-4">
                  <label class="text-black">Pincode</label>
                  <div class="input-wrap">
                    <i class="fas fa-hashtag input-icon"></i>
                    <input type="text" name="pincode" class="form-control" placeholder="380001">
                  </div>
                </div>
              </div>

              <!-- Account Setup -->
              <div class="form-section-title">
                <i class="fas fa-shield-alt"></i> Account Setup
              </div>

              <div class="row form-group">
                <div class="col-md-12">
                  <label class="text-black">Register As *</label>
                  <div class="input-wrap">
                    <i class="fas fa-briefcase input-icon"></i>
                    <select name="role" class="form-control" required>
                      <option value="">-- Select Role --</option>
                      <option value="JOBSEEKER">Job Seeker</option>
                      <option value="EMPLOYER">Employer</option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="row form-group">
                <div class="col-md-6 mb-3 mb-md-0">
                  <label class="text-black">Password *</label>
                  <div class="input-wrap pass-wrap">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" name="password" id="pass1" class="form-control" placeholder="Min 6 characters" required>
                    <button type="button" class="pass-toggle" onclick="togglePass('pass1','eye1')">
                      <i class="fas fa-eye" id="eye1"></i>
                    </button>
                  </div>
                </div>
                <div class="col-md-6">
                  <label class="text-black">Retype Password *</label>
                  <div class="input-wrap pass-wrap">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" name="repassword" id="pass2" class="form-control" placeholder="Repeat password" required>
                    <button type="button" class="pass-toggle" onclick="togglePass('pass2','eye2')">
                      <i class="fas fa-eye" id="eye2"></i>
                    </button>
                  </div>
                </div>
              </div>

              <!-- Submit -->
              <button type="submit" class="btn-register">
                <i class="fas fa-user-plus"></i>
                Create Account
              </button>

              <div class="login-link">
                Already have an account? <a href="login.jsp">Sign In</a>
              </div>

            </form>
          </div>
        </div>

        <!-- INFO PANEL -->
        <div class="col-lg-5 d-none d-lg-block fade-up-2">
          <div class="info-panel">
            <div class="badge-pill">
              <span style="width:6px;height:6px;border-radius:50%;background:#fbbf24;display:inline-block;"></span>
              Why Join JobBoard?
            </div>
            <h3>Find Your Dream Job Today</h3>
            <p>Join thousands of professionals and employers on India's fastest growing job platform.</p>

            <div style="margin-top:28px;">
              <div class="info-feature">
                <div class="info-feature-icon" style="color:#60a5fa;">
                  <i class="fas fa-search"></i>
                </div>
                <div class="info-feature-text">
                  <strong>Smart Job Search</strong>
                  <span>Find jobs matching your skills instantly</span>
                </div>
              </div>
              <div class="info-feature">
                <div class="info-feature-icon" style="color:#34d399;">
                  <i class="fas fa-bell"></i>
                </div>
                <div class="info-feature-text">
                  <strong>Instant Alerts</strong>
                  <span>Get notified for new matching jobs</span>
                </div>
              </div>
              <div class="info-feature">
                <div class="info-feature-icon" style="color:#f59e0b;">
                  <i class="fas fa-file-alt"></i>
                </div>
                <div class="info-feature-text">
                  <strong>Easy Apply</strong>
                  <span>One-click apply to top companies</span>
                </div>
              </div>
              <div class="info-feature">
                <div class="info-feature-icon" style="color:#c084fc;">
                  <i class="fas fa-chart-line"></i>
                </div>
                <div class="info-feature-text">
                  <strong>Career Growth</strong>
                  <span>Track applications and grow faster</span>
                </div>
              </div>
            </div>
          </div>
        </div>

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
          </ul>
        </div>
        <div class="col-6 col-md-3 mb-4 mb-md-0">
          <h3>Company</h3>
          <ul class="list-unstyled">
            <li><a href="#">About Us</a></li>
            <li><a href="#">Career</a></li>
            <li><a href="#">Blog</a></li>
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

<script>
  function togglePass(fieldId, iconId) {
    const f = document.getElementById(fieldId);
    const i = document.getElementById(iconId);
    if (f.type === 'password') {
      f.type = 'text';
      i.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
      f.type = 'password';
      i.classList.replace('fa-eye-slash', 'fa-eye');
    }
  }
</script>

</body>
</html>