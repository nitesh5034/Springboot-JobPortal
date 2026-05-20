<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JobBoard | All Job Listings</title>
    <link rel="stylesheet" href="css/custom-bs.css">
    <link rel="stylesheet" href="css/bootstrap-select.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="fonts/icomoon/style.css">
</head>
<body id="top">
<%@include file="header.jsp"%>

<%
    // --- DELETE LOGIC  ---
    String deleteTitle = request.getParameter("delete_title");
    if (deleteTitle != null) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "");
            String delSql = "DELETE FROM `company job-update` WHERE Job_Title = ?";
            PreparedStatement pdel = con.prepareStatement(delSql);
            pdel.setString(1, deleteTitle);
            pdel.executeUpdate();
            con.close();
            response.sendRedirect("comjob.jsp"); 
        } catch(Exception e) { out.println("<p class='text-danger'>Delete Error: " + e.getMessage() + "</p>"); }
    }
%>

<div class="site-wrap">
    <section class="site-section">
      <div class="container">
        <h2 class="section-title mb-5 text-center">All Listed Jobs</h2>
        <ul class="job-listings mb-5">
          <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "");
                
                // --- Search Logic (Optional parameters) ---
                String keyword = request.getParameter("keyword");
                StringBuilder sql = new StringBuilder("SELECT * FROM `company job-update` WHERE 1=1");
                
                if(keyword != null && !keyword.trim().isEmpty()) {
                    sql.append(" AND Job_Title LIKE ?");
                }

                PreparedStatement ps = con.prepareStatement(sql.toString());
                if(keyword != null && !keyword.trim().isEmpty()) {
                    ps.setString(1, "%" + keyword.trim() + "%");
                }

                ResultSet rs = ps.executeQuery();
                boolean hasData = false;
                
                while(rs.next()) {
                    hasData = true;
          %>
                    <li class="job-listing d-block d-sm-flex pb-3 pb-sm-0 align-items-center border mb-3 p-3">
                      <div class="job-listing-about d-sm-flex custom-width w-100 justify-content-between mx-4">
                        <div class="job-listing-position custom-width w-50">
                          <h2><%= rs.getString("Job_Title") %></h2>
                          <strong><%= rs.getString("company_name") %></strong>
                        </div>
                        <div class="job-listing-location mb-3 mb-sm-0 custom-width w-25">
                          <span class="icon-room"></span> Opening: <%= rs.getInt("opening") %>
                        </div>
                        <div class="job-listing-meta">
                          <span class="badge badge-success"><%= rs.getString("Job_Type") %></span>
                          <br>
                          <a href="comjob.jsp?delete_title=<%= java.net.URLEncoder.encode(rs.getString("Job_Title"), "UTF-8") %>" 
                     class="delete" 
                     style="display: block !important; visibility: visible !important;"
                     onclick="return confirm('Do you want to remove this job?')">
                     Remove Job
                  </a>
                        </div>
                      </div>
                    </li>
          <%
                }
                if(!hasData) {
                    out.println("<li class='p-4 text-center'>no more jobs are posting.</li>");
                }
                con.close();
            } catch(Exception e) { 
                out.println("<p class='text-danger'>SQL Error: " + e.getMessage() + "</p>"); 
            }
          %>
        </ul>
      </div>
    </section>
</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>
<script src="js/custom.js"></script>
</body>
</html>