<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JobBoard | Job Listings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- MAIN CSS -->
    <link rel="stylesheet" href="css/custom-bs.css">
    <link rel="stylesheet" href="css/bootstrap-select.min.css">
    <link rel="stylesheet" href="fonts/icomoon/style.css">
    <link rel="stylesheet" href="fonts/line-icons/style.css">
    <link rel="stylesheet" href="css/style.css">    

    <style>
        body {
            font-family: 'DM Sans', sans-serif;
            background-color: #f8fafc;
            color: #334155;
            margin: 0;
            padding: 0;
        }

        /* Hero Section */
        .modern-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #1e40af 100%);
            position: relative;
            padding: 100px 0 80px;
            overflow: hidden;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
        }

        .modern-hero::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            border-radius: 50%;
        }

        .modern-hero-content {
            position: relative;
            z-index: 10;
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
        }

        .modern-hero h1 {
            font-family: 'Sora', sans-serif;
            font-weight: 700;
            font-size: 42px;
            color: #ffffff;
            margin-bottom: 16px;
            line-height: 1.2;
        }

        .modern-hero p {
            font-size: 18px;
            color: #cbd5e1;
            margin-bottom: 40px;
        }

        /* Search Form Modernization */
        .search-wrapper {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .search-wrapper .form-control, .search-wrapper .btn.dropdown-toggle {
            height: 54px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            font-family: 'DM Sans', sans-serif;
            font-size: 15px;
            color: #475569;
            box-shadow: none;
            background-color: #f8fafc;
        }

        .search-wrapper .form-control:focus, .search-wrapper .btn.dropdown-toggle:focus {
            border-color: #3b82f6;
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(59,130,246,0.1);
            outline: none;
        }

        .btn-modern-search {
            height: 54px;
            border-radius: 12px;
            background: #1a56db;
            color: white;
            font-family: 'Sora', sans-serif;
            font-weight: 600;
            font-size: 16px;
            border: none;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
        }

        .btn-modern-search:hover {
            background: #1e40af;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26,86,219,0.3);
            color: white;
        }

        .trending-keywords {
            margin-top: 24px;
            font-size: 14px;
            color: #94a3b8;
        }

        .trending-keywords a {
            color: #bfdbfe;
            background: rgba(255,255,255,0.1);
            padding: 4px 12px;
            border-radius: 20px;
            margin-left: 8px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .trending-keywords a:hover {
            background: rgba(255,255,255,0.2);
            color: #ffffff;
        }

        /* Listings Section */
        .listings-section {
            padding: 80px 0;
        }

        .section-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-header h2 {
            font-family: 'Sora', sans-serif;
            font-weight: 700;
            color: #0f172a;
            font-size: 32px;
            position: relative;
            display: inline-block;
        }

        .section-header h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: #3b82f6;
            border-radius: 2px;
        }

        /* Modern Job List */
        .modern-job-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            gap: 24px;
        }

        .modern-job-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 24px;
            display: flex;
            align-items: center;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }

        .modern-job-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            border-color: #cbd5e1;
        }

        .modern-job-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: #1a56db;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .modern-job-card:hover::before {
            opacity: 1;
        }

        .modern-job-link {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 10;
        }

        .job-logo-wrapper {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 24px;
            flex-shrink: 0;
            overflow: hidden;
        }

        .job-logo-wrapper img {
            max-width: 100%;
            height: auto;
        }

        .job-details-wrapper {
            flex-grow: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .job-main-info h3 {
            font-family: 'Sora', sans-serif;
            font-weight: 600;
            font-size: 18px;
            color: #0f172a;
            margin-bottom: 6px;
            transition: color 0.2s;
        }

        .modern-job-card:hover .job-main-info h3 {
            color: #1a56db;
        }
        
        .company-name {
            font-size: 14px;
            color: #64748b;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .job-meta-chips {
            display: flex;
            gap: 12px;
            margin-top: 12px;
        }

        .job-meta-chip {
            background: #f1f5f9;
            color: #475569;
            font-size: 13px;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }

        .job-end-info {
            text-align: right;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 12px;
        }

        .location-text {
            color: #475569;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .job-type-badge {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .cta-section {
            background: linear-gradient(135deg, #1e3a8a 0%, #172554 100%);
            padding: 80px 0;
            text-align: center;
            border-radius: 40px;
            margin: 0 20px 80px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .cta-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,%3Csvg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"%3E%3Cg fill="none" fill-rule="evenodd"%3E%3Cg fill="%23ffffff" fill-opacity="0.05"%3E%3Cpath d="M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z"/%3E%3C/g%3E%3C/g%3E%3C/svg%3E');
        }

        .cta-content {
            position: relative;
            z-index: 10;
        }

        .cta-content h2 {
            font-family: 'Sora', sans-serif;
            font-weight: 700;
            font-size: 36px;
            color: white;
            margin-bottom: 16px;
        }

        .cta-content p {
            color: #bfdbfe;
            font-size: 18px;
            margin-bottom: 32px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
        }

        @media (max-width: 768px) {
            .job-details-wrapper {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            .job-end-info {
                text-align: left;
                align-items: flex-start;
                width: 100%;
            }
            .job-meta-chips {
                flex-wrap: wrap;
            }
            .modern-hero h1 {
                font-size: 32px;
            }
            .cta-buttons {
                flex-direction: column;
                padding: 0 20px;
            }
        }
    </style>
</head>
<body id="top">

    <!-- HEADER INCLUSION -->
    <jsp:include page="cheader.jsp"></jsp:include>

    <!-- HERO SECTION -->
    <section class="modern-hero">
        <div class="container">
            <div class="modern-hero-content">
                <h1>Discover Your Next Career Move</h1>
                <p>Browse thousands of job openings from top companies around the world.</p>
                
                <form method="post" class="search-wrapper">
                    <div class="row m-0">
                        <div class="col-12 col-md-4 p-2">
                            <input type="text" class="form-control" placeholder="Job title, keywords, or company">
                        </div>
                        <div class="col-12 col-md-3 p-2">
                            <select class="selectpicker" data-style="btn-white" data-width="100%" data-live-search="true" title="Location">
                                <option>Anywhere</option>
                                <option>Ahmedabad</option>
                                <option>Surat</option>
                                <option>Mehsana</option>
                                <option>Jaipur</option>
                                <option>Delhi</option>
                                <option>Bangalore</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-3 p-2">
                            <select class="selectpicker" data-style="btn-white" data-width="100%" title="Job Type">
                                <option>Full Time</option>
                                <option>Part Time</option>
                                <option>Remote</option>
                                <option>Freelance</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-2 p-2">
                            <button type="submit" class="btn-modern-search">
                                <i class="fas fa-search"></i> Search
                            </button>
                        </div>
                    </div>
                </form>
                
                <div class="trending-keywords">
                    Trending searches: 
                    <a href="#">UI Designer</a>
                    <a href="#">Python Developer</a>
                    <a href="#">Marketing Manager</a>
                </div>
            </div>
        </div>
    </section>

    <!-- JOB LISTINGS -->
    <section class="listings-section">
        <div class="container">
            <div class="section-header">
                <h2>Latest Opportunities</h2>
            </div>
            
            <%@ page import="java.sql.*" %>
            <%
                Object userObj = session.getAttribute("userObj");
            %>
            
            <ul class="modern-job-list">
                <%
                    try {
                        Class.forName("com.mysql.jdbc.Driver"); 
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", ""); 
                        Statement stmt = con.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM `company job-update` ORDER BY job_id DESC"); 

                        while(rs.next()) {
                            String jobTitle = rs.getString("Job_Title");
                            String targetURL = (userObj != null) ? "apply.jsp?job_id=" + rs.getInt("job_id") : "login.jsp";
                %>
                    <li class="modern-job-card">
                        <a href="<%= targetURL %>" class="modern-job-link"></a>
                        
                        <div class="job-logo-wrapper">
                            <i class="fas fa-building fa-2x" style="color: #cbd5e1;"></i>
                        </div>
                        
                        <div class="job-details-wrapper">
                            <div class="job-main-info">
                                <h3><%= jobTitle %></h3>
                                <div class="company-name">
                                    <i class="fas fa-briefcase" style="color: #94a3b8;"></i> 
                                    <%= rs.getString("company_name") %>
                                </div>
                                
                                <div class="job-meta-chips">
                                    <span class="job-meta-chip">
                                        <i class="fas fa-money-bill-wave"></i> <%= rs.getString("salary") %>
                                    </span>
                                    <span class="job-meta-chip">
                                        <i class="fas fa-history"></i> Exp: <%= rs.getString("experience") %>
                                    </span>
                                    <span class="job-meta-chip">
                                        <i class="fas fa-users"></i> Openings: <%= rs.getInt("opening") %>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="job-end-info">
                                <div class="location-text">
                                    <i class="fas fa-map-marker-alt"></i> <%= rs.getString("Location") %>
                                </div>
                                <div class="job-type-badge">
                                    <%= rs.getString("Job_Type") %>
                                </div>
                            </div>
                        </div>
                    </li>
                <%
                        }
                        con.close();
                    } catch(Exception e) {
                        out.println("<div class='alert alert-danger'><i class='fas fa-exclamation-triangle'></i> Database connection error or no jobs found.</div>");
                    }
                %>
            </ul>
        </div>
    </section>

    <!-- CALL TO ACTION -->
    <div class="cta-section">
        <div class="cta-content container">
            <h2>Accelerate Your Career</h2>
            <p>Join thousands of professionals finding great opportunities on JobBoard. Get matched with jobs that fit your skills and preferences.</p>
            <div class="cta-buttons">
                <% if(userObj == null) { %>
                    <a href="registration.jsp" class="btn btn-primary" style="background:#3b82f6; border:none; padding:14px 32px; font-weight:600; border-radius:12px; font-family:'Sora',sans-serif;">Sign Up Now</a>
                    <a href="login.jsp" class="btn btn-outline-light" style="padding:14px 32px; font-weight:600; border-radius:12px; font-family:'Sora',sans-serif;">Log In</a>
                <% } else { %>
                    <a href="user-dashboard.jsp" class="btn btn-primary" style="background:#3b82f6; border:none; padding:14px 32px; font-weight:600; border-radius:12px; font-family:'Sora',sans-serif;">View Dashboard</a>
                <% } %>
            </div>
        </div>
    </div>

    <!-- FOOTER INCLUSION -->
    <jsp:include page="footer.jsp"></jsp:include>

    <!-- SCRIPTS -->
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="js/bootstrap-select.min.js"></script>
</body>
</html>