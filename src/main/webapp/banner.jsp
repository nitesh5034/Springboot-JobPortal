<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<section class="home-section section-hero overlay bg-image" style="background-image: url('images/hero_1.jpg');" id="home-section">

      <div class="container">
        <div class="row align-items-center justify-content-center">
          <div class="col-md-12">
            <div class="mb-5 text-center">
              <h1 class="text-white font-weight-bold">The Easiest Way To Get Your Dream Job</h1>
              
            </div>
          <%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%-- 1. Form Section --%>
<form method="GET" action="" class="search-jobs-form">
  <div class="row mb-5">
    <div class="col-12 col-sm-6 col-md-6 col-lg-3 mb-4 mb-lg-0">
      <input type="text" name="keyword" class="form-control form-control-lg" placeholder="Job title, Company..." 
             value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    </div>
    
    <div class="col-12 col-sm-6 col-md-6 col-lg-3 mb-4 mb-lg-0">
      <select name="region" class="selectpicker" data-style="btn-white btn-lg" data-width="100%" data-live-search="true" title="Select Region">
        <option value="">Anywhere</option>
        <option value="Surat">Surat</option>
        <option value="Ahmedabad">Ahmedabad</option>
      </select>
    </div>
    
    <div class="col-12 col-sm-6 col-md-6 col-lg-3 mb-4 mb-lg-0">
      <select name="job_type" class="selectpicker" data-style="btn-white btn-lg" data-width="100%" data-live-search="true" title="Select Job Type">
        <option value="">Select Job Type</option>
        <option value="Part Time">Part Time</option>
        <option value="Full Time">Full Time</option>
      </select>
    </div>
    
    <div class="col-12 col-sm-6 col-md-6 col-lg-3 mb-4 mb-lg-0">
      <button type="submit" class="btn btn-primary btn-lg btn-block text-white btn-search">
        <span class="icon-search icon mr-2"></span>Search Job
      </button>
    </div>
  </div>
</form>

<hr>

<%-- 2. Database Search Results Section --%>
<div class="row mt-4">
<%
    String keyword = request.getParameter("keyword");
    String region = request.getParameter("region");
    String jobType = request.getParameter("job_type"); // Form ma name 'job_type' che

    if ((keyword != null && !keyword.trim().isEmpty()) || 
        (region != null && !region.trim().isEmpty()) || 
        (jobType != null && !jobType.trim().isEmpty())) {
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // New Driver (mysql-connector-j mate)
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "");

            // 1. Dynamic Query Building - TAMARA DATABASE COLUMNS MUJAB
            StringBuilder query = new StringBuilder("SELECT * FROM `company job-update` WHERE 1=1");
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.append(" AND (Job_Title LIKE ? OR company_name LIKE ?)");
            }
            if (region != null && !region.trim().isEmpty()) {
                // Photo mujab 'Job_Region' column name che
                query.append(" AND Job_Region = ?");
            }
            if (jobType != null && !jobType.trim().isEmpty()) {
                // Photo mujab 'Job_Type' column name che
                query.append(" AND Job_Type = ?");
            }

            ps = conn.prepareStatement(query.toString());
            int idx = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchStr = "%" + keyword.trim() + "%";
                ps.setString(idx++, searchStr);
                ps.setString(idx++, searchStr);
            }
            if (region != null && !region.trim().isEmpty()) {
                ps.setString(idx++, region.trim());
            }
            if (jobType != null && !jobType.trim().isEmpty()) {
                ps.setString(idx++, jobType.trim());
            }

            rs = ps.executeQuery();
            boolean hasData = false;

            while (rs.next()) {
                hasData = true;
%>
                <div class="col-md-12 mb-4 p-3 shadow-sm border rounded">
                    <h4><%= rs.getString("Job_Title") %></h4>
                    <p class="text-muted"><%= rs.getString("company_name") %> - <strong><%= rs.getString("Job_Region") %></strong></p>
                    <span class="badge badge-primary"><%= rs.getString("Job_Type") %></span>
                </div>
<%
            }
            if (!hasData) {
                out.println("<div class='col-12'><p class='alert alert-warning'>Tame shodheli job mali nathi.</p></div>");
            }

        } catch (Exception e) {
            out.println("<div class='col-12 text-danger'>Error: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
%>
</div>
          </div>
        </div>
      </div>

      <a href="#next" class="scroll-button smoothscroll">
        <span class=" icon-keyboard_arrow_down"></span>
      </a>

    </section>


</body>
</html>