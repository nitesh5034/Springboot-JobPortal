<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.ApplicationModel" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Application Tracker</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .tracker-header { background: #fff; padding: 20px; border-bottom: 2px solid #eee; margin-bottom: 30px; }
        .tracker-card { 
            border: none; 
            border-radius: 15px; 
            transition: all 0.3s ease; 
            background: #fff;
        }
        .tracker-card:hover { transform: translateY(-10px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
        .status-badge { padding: 8px 15px; border-radius: 50px; font-weight: 600; text-transform: uppercase; font-size: 11px; }
        .view-section { background: #f8f9fa; border-radius: 10px; padding: 15px; margin-top: 15px; }
        .view-count { font-size: 2rem; font-weight: bold; color: #28a745; }
    </style>
</head>
<body>

<div class="tracker-header shadow-sm">
    <div class="container d-flex justify-content-between align-items-center">
        <h3 class="mb-0 text-primary">Application Tracker 🚀</h3>
        <a href="index.jsp" class="btn btn-outline-primary btn-sm">Home</a>
    </div>
</div>

<div class="container">
    <div class="row">
        <%
            // Data fetch kar rahe hain
            List<ApplicationModel> apps = (List<ApplicationModel>) request.getAttribute("userApps");

            if (apps != null && !apps.isEmpty()) { 
                for (ApplicationModel app : apps) { 
        %>
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card tracker-card shadow-sm h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="text-muted mb-0">appid: #<%= app.getAppid() %></h6>
                            <span class="badge bg-primary status-badge">
                                <%= app.getStatus() != null ? app.getStatus() : "Pending" %>
                            </span>
                        </div>

                        <h5 class="card-title">Job Application Entry</h5>

                        <div class="view-section text-center">
                            <p class="mb-1 text-muted small">Profile Views</p>
                            <div class="view-count"><%= app.getViewcount() %></div>
                            <p class="mb-0 small text-success">Companies reviewed your details</p>
                        </div>
                    </div> 
                    <div class="card-footer bg-white border-0 pb-3">
                        <button class="btn btn-sm btn-light w-100 text-primary fw-bold">Check Update</button>
                    </div>
                </div> 
            </div> 
            <% 
                } 
            } else { 
                
        %>
            <div class="col-12 text-center py-5">
                <div class="alert alert-light shadow-sm py-5">
                    <h4 class="text-muted">No Applications Yet!</h4>
                    <a href="jobs.jsp" class="btn btn-primary px-4 mt-2">Find Jobs</a>
                </div>
            </div>
        <% 
            } // If condition band hui
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>