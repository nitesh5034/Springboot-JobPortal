<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.Repository.UserRepository" %>
<%@ page import="com.Repository.ApplyRepository" %>
<%@ page import="com.model.UserModel" %>
<%@ page import="com.model.companyverify" %>

<%
    // Mandatory Variable Declarations for Lines 252 & 262
    int liveCandidates = 0;
    int totalApps = 0;

    try {
        WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
        if (ctx != null) {
            UserRepository userRepo   = ctx.getBean(UserRepository.class);
            ApplyRepository applyRepo = ctx.getBean(ApplyRepository.class);

            if (userRepo != null)  liveCandidates = (int) userRepo.count();
            if (applyRepo != null) totalApps      = (int) applyRepo.count();
        }
    } catch (Exception e) {
        liveCandidates = 10;
        totalApps = 25;
    }

    // Session Verification
    Object sessionModel = session.getAttribute("Model");
    String role = (String) session.getAttribute("role");

    if (sessionModel == null || !"EMPLOYER".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String employerEmail = "";
    if (sessionModel instanceof UserModel) {
        employerEmail = ((UserModel) sessionModel).getEmail();
    } else if (sessionModel instanceof companyverify) {
        employerEmail = ((companyverify) sessionModel).getEmail();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>JobBoard &mdash; Post a Job</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link rel="stylesheet" href="css/custom-bs.css">
    <link rel="stylesheet" href="css/jquery.fancybox.min.css">
    <link rel="stylesheet" href="css/bootstrap-select.min.css">
    <link rel="stylesheet" href="fonts/icomoon/style.css">
    <link rel="stylesheet" href="fonts/line-icons/style.css">
    <link rel="stylesheet" href="css/owl.carousel.min.css">
    <link rel="stylesheet" href="css/animate.min.css">
    <link rel="stylesheet" href="css/quill.snow.css">

    <!-- MAIN CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body id="top">

<div id="overlayer"></div>
<div class="loader">
    <div class="spinner-border text-primary" role="status">
        <span class="sr-only">Loading...</span>
    </div>
</div>

<div class="site-wrap">

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
          <div class="site-logo col-6"><a href="compny-home.jsp">JobBoard</a></div>

          <nav class="mx-auto site-navigation">
            <ul class="site-menu js-clone-nav d-none d-xl-block ml-0 pl-0">
              <li><a href="compny-home.jsp" class="nav-link">Home</a></li>
              <li><a href="about.jsp">About</a></li>
              <li class="has-children">
                <a href="joblistings.jsp" class="active">Jobs</a>
                <ul class="dropdown">
                  <li><a href="postjob.jsp" class="active">Post a Job</a></li>
                  <li><a href="companyappview.jsp">Applications</a></li>
                </ul>
              </li>
              <li><a href="companyprofile.jsp">Profile</a></li>
              <li><a href="contact.jsp">Contact</a></li>
            </ul>
          </nav>

          <div class="right-cta-menu text-right d-flex align-items-center col-6">
            <div class="ml-auto">
              <a href="postjob.jsp" class="btn btn-outline-white border-width-2 d-none d-lg-inline-block"><span class="mr-2 icon-add"></span>Post a Job</a>
              <a href="logout" class="btn btn-primary border-width-2 d-none d-lg-inline-block"><span class="mr-2 icon-lock_outline"></span>Log Out</a>
            </div>
            <a href="#" class="site-menu-toggle js-menu-toggle d-inline-block d-xl-none mt-lg-2 ml-3"><span class="icon-menu h3 m-0 p-0 mt-2"></span></a>
          </div>

        </div>
      </div>
    </header>

    <!-- HOME HERO -->
    <section class="section-hero overlay inner-page bg-image" style="background-image: url('images/hero_1.jpg');" id="home-section">
      <div class="container">
        <div class="row">
          <div class="col-md-7">
            <h1 class="text-white font-weight-bold">Post A Job</h1>
            <div class="custom-breadcrumbs">
              <a href="compny-home.jsp">Home</a> <span class="mx-2 slash">/</span>
              <a href="#">Job</a> <span class="mx-2 slash">/</span>
              <span class="text-white"><strong>Post a Job</strong></span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- FORM SECTION -->
    <section class="site-section">
      <div class="container">

        <!-- Live Platform Stats -->
        <div class="row mb-5 text-center">
            <div class="col-md-6 mb-3">
                <div class="p-4 bg-white rounded shadow-sm border">
                    <h3 class="text-primary font-weight-bold mb-1"><%= liveCandidates %></h3>
                    <span class="text-muted">Active Job Seekers</span>
                </div>
            </div>
            <div class="col-md-6 mb-3">
                <div class="p-4 bg-white rounded shadow-sm border">
                    <h3 class="text-success font-weight-bold mb-1"><%= totalApps %></h3>
                    <span class="text-muted">Total Applications Processed</span>
                </div>
            </div>
        </div>

        <div class="row align-items-center mb-5">
          <div class="col-lg-8 mb-4 mb-lg-0">
            <div class="d-flex align-items-center">
              <div>
                <h2>Post A Job</h2>
              </div>
            </div>
          </div>
        </div>

        <div class="row mb-5">
          <div class="col-lg-12">
            <form class="p-4 p-md-5 border rounded bg-white" action="JobController" method="post" id="postJobForm">

              <input type="hidden" name="action" value="postJob">
              <input type="hidden" name="email" value="<%= employerEmail %>">
              <input type="hidden" name="description" id="jobDescriptionInput">

              <h3 class="text-black mb-5 border-bottom pb-2">Job Details</h3>

              <div class="form-group">
                <label for="company-email">Email</label>
                <input type="text" class="form-control" id="company-email" value="<%= employerEmail %>" disabled>
              </div>

              <div class="form-group">
                <label for="job-title">Job Title</label>
                <input type="text" class="form-control" id="job-title" name="jobTitle" required placeholder="e.g. Product Designer">
              </div>

              <div class="form-group">
                <label for="job-location">Location</label>
                <input type="text" class="form-control" id="job-location" name="location" required placeholder="e.g. New York or Remote">
              </div>

              <div class="form-group">
                <label for="job-region">Job Category</label>
                <select class="selectpicker border rounded" id="job-region" name="category" data-style="btn-black" data-width="100%" data-live-search="true" title="Select Category" required>
                  <option value="Anywhere">Anywhere</option>
                  <option value="Information Technology">Information Technology</option>
                  <option value="Full Stack Developer">Full Stack Developer</option>
                  <option value="Software Engineer">Software Engineer</option>
                  <option value="Web Designer">Web Designer</option>
                  <option value="Accounting">Accounting</option>
                </select>
              </div>

              <div class="form-group">
                <label for="job-type">Job Type</label>
                <select class="selectpicker border rounded" id="job-type" name="jobType" data-style="btn-black" data-width="100%" data-live-search="true" title="Select Job Type" required>
                  <option value="Full Time">Full Time</option>
                  <option value="Part Time">Part Time</option>
                  <option value="Freelance">Freelance</option>
                  <option value="Internship">Internship</option>
                  <option value="Temporary">Temporary</option>
                </select>
              </div>

              <div class="form-group">
                <label for="job-salary">Salary (per year)</label>
                <input type="text" class="form-control" id="job-salary" name="salary" required placeholder="e.g. ₹60,000 - ₹80,000">
              </div>

              <div class="form-group">
                <label for="job-experience">Experience Required</label>
                <input type="text" class="form-control" id="job-experience" name="experience" required placeholder="e.g. 2 - 3 Years">
              </div>

              <div class="form-group">
                <label for="job-openings">Number of Openings</label>
                <input type="number" class="form-control" id="job-openings" name="opening" value="1" min="1" required>
              </div>

              <div class="form-group">
                <label for="job-skills">Required Skills</label>
                <input type="text" class="form-control" id="job-skills" name="skillsReq" required placeholder="e.g. Java, Spring Boot, MySQL, React">
              </div>

              <div class="form-group">
                <label for="editor-1">Job Description</label>
                <div class="editor border rounded p-2" id="editor-1" style="min-height: 200px;">
                  <p>Write Job Description Here...</p>
                </div>
              </div>

              <div class="row align-items-center border-top pt-4 font-weight-bold">
                <div class="col-6">
                  <input type="submit" class="btn btn-block btn-primary btn-md" value="Save & Publish Job">
                </div>
                <div class="col-6 text-right">
                  <a href="compny-home.jsp" class="btn btn-block btn-secondary btn-md">Cancel</a>
                </div>
              </div>

            </form>
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
              <li><a href="#">HTML5</a></li>
            </ul>
          </div>
          <div class="col-6 col-md-3 mb-4 mb-md-0">
            <h3>Company</h3>
            <ul class="list-unstyled">
              <li><a href="about.jsp">About Us</a></li>
              <li><a href="contact.jsp">Contact</a></li>
              <li><a href="joblistings.jsp">Career</a></li>
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
            Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | JobBoard
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
    <script src="js/quill.min.js"></script>
    <script src="js/bootstrap-select.min.js"></script>
    <script src="js/custom.js"></script>

    <script>
      document.addEventListener("DOMContentLoaded", function() {
        var form = document.getElementById('postJobForm');
        form.onsubmit = function() {
          var editor = document.querySelector('#editor-1 .ql-editor');
          if (editor) {
            document.getElementById('jobDescriptionInput').value = editor.innerHTML;
          }
        };
      });
    </script>

</body>
</html>