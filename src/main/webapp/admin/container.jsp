<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.CompanyDao" %>
<%@ page import="com.dao.postjobdao" %>
<%@ page import="com.model.Postjob" %>
<%@ page import="java.util.List" %>
<%
CompanyDao companyDao = new CompanyDao();
postjobdao jobDao     = new postjobdao();

int totalCandidates   = companyDao.getTotalCandidates();
int totalJobs         = jobDao.getTotalJobs();
int verifiedCompanies = companyDao.getTotalCompanies(); // Verified
int pendingCompanies  = companyDao.getPendingCount();   // Pending
int rejectedCompanies = companyDao.getRejectedCount();  // Rejected
int totalCompanies    = verifiedCompanies + pendingCompanies + rejectedCompanies; 

int totalApplications = companyDao.getTotalApplications();
int maxVal = Math.max(Math.max(totalCandidates, totalJobs), Math.max(totalCompanies, totalApplications));
if (maxVal == 0) maxVal = 1;
int pCandidates   = (totalCandidates   * 100) / maxVal;
int pJobs         = (totalJobs         * 100) / maxVal;
int pCompanies    = (totalCompanies    * 100) / maxVal;
int pApplications = (totalApplications * 100) / maxVal;

List<Postjob> recentJobs = jobDao.getAllJobs();
%>

    List<Postjob> recentJobs = jobDao.getAllJobs();
%>

<main class="nxl-container">
    <div class="nxl-content">

        <div class="page-header">
            <div class="page-header-left d-flex align-items-center">
                <div class="page-header-title">
                    <h5 class="m-b-10">Dashboard</h5>
                </div>
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="dashboard.jsp">Home</a></li>
                    <li class="breadcrumb-item">Dashboard</li>
                </ul>
            </div>
        </div>

        <div class="main-content">

            <!-- ===== STATS ROW ===== -->
            <div class="row">

                <!-- Total Candidates -->
                <div class="col-xxl-3 col-md-6">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-start justify-content-between mb-4">
                                <div class="d-flex gap-4 align-items-center">
                                    <div class="avatar-text avatar-lg bg-soft-primary text-primary">
                                        <i class="feather-users"></i>
                                    </div>
                                    <div>
                                        <div class="fs-4 fw-bold text-dark">
                                            <span class="counter"><%= totalCandidates %></span>
                                        </div>
                                        <h3 class="fs-13 fw-semibold">Total Candidates</h3>
                                    </div>
                                </div>
                                <span class="badge bg-soft-success text-success">Live</span>
                            </div>
                            <div class="d-flex justify-content-between mb-1">
                                <small class="text-muted">Registered</small>
                                <small class="text-primary fw-bold"><%= pCandidates %>%</small>
                            </div>
                            <div class="progress mt-1 ht-3">
                                <div class="progress-bar bg-primary" style="width:<%= pCandidates %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Jobs Posted -->
                <div class="col-xxl-3 col-md-6">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-start justify-content-between mb-4">
                                <div class="d-flex gap-4 align-items-center">
                                    <div class="avatar-text avatar-lg bg-soft-warning text-warning">
                                        <i class="feather-briefcase"></i>
                                    </div>
                                    <div>
                                        <div class="fs-4 fw-bold text-dark">
                                            <span class="counter"><%= totalJobs %></span>
                                        </div>
                                        <h3 class="fs-13 fw-semibold">Jobs Posted</h3>
                                    </div>
                                </div>
                                <span class="badge bg-soft-success text-success">Live</span>
                            </div>
                            <div class="d-flex justify-content-between mb-1">
                                <small class="text-muted">Active Jobs</small>
                                <small class="text-warning fw-bold"><%= pJobs %>%</small>
                            </div>
                            <div class="progress mt-1 ht-3">
                                <div class="progress-bar bg-warning" style="width:<%= pJobs %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Applications -->
                <div class="col-xxl-3 col-md-6">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-start justify-content-between mb-4">
                                <div class="d-flex gap-4 align-items-center">
                                    <div class="avatar-text avatar-lg bg-soft-success text-success">
                                        <i class="feather-file-text"></i>
                                    </div>
                                    <div>
                                        <div class="fs-4 fw-bold text-dark">
                                            <span class="counter"><%= totalApplications %></span>
                                        </div>
                                        <h3 class="fs-13 fw-semibold">Applications</h3>
                                    </div>
                                </div>
                                <span class="badge bg-soft-success text-success">Live</span>
                            </div>
                            <div class="d-flex justify-content-between mb-1">
                                <small class="text-muted">Total Applied</small>
                                <small class="text-success fw-bold"><%= pApplications %>%</small>
                            </div>
                            <div class="progress mt-1 ht-3">
                                <div class="progress-bar bg-success" style="width:<%= pApplications %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Companies -->
                <div class="col-xxl-3 col-md-6">
                    <div class="card stretch stretch-full">
                        <div class="card-body">
                            <div class="d-flex align-items-start justify-content-between mb-4">
                                <div class="d-flex gap-4 align-items-center">
                                    <div class="avatar-text avatar-lg bg-soft-danger text-danger">
                                        <i class="feather-home"></i>
                                    </div>
                                    <div>
                                       <div class="fs-4 fw-bold text-dark">
										  <span class="counter"><%= totalCompanies %></span> </div>
											<h3 class="fs-13 fw-semibold">Total Registered Companies</h3>
                                        <h3 class="fs-13 fw-semibold">Verified Companies</h3>
                                    </div>
                                </div>
                                <span class="badge bg-soft-success text-success">Live</span>
                            </div>
                            <!-- ✅ Pending + Rejected badges -->
                            <div class="d-flex gap-2 mb-2">
                                <span class="badge bg-soft-warning text-warning">
                                    Pending: <%= pendingCompanies %>
                                </span>
                                <span class="badge bg-soft-danger text-danger">
                                    Rejected: <%= rejectedCompanies %>
                                </span>
                            </div>
                            <div class="progress mt-1 ht-3">
                                <div class="progress-bar bg-danger" style="width:<%= pCompanies %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <!-- STATS ROW END -->

            <!-- ===== RECENT JOBS + QUICK ACTIONS ===== -->
            <div class="row">

                <!-- Recent Jobs Table -->
                <div class="col-xxl-8">
                    <div class="card stretch stretch-full">
                        <div class="card-header">
                            <h5 class="card-title">Recent Job Postings</h5>
                            <div class="card-header-action">
                                <a href="admin-jobs.jsp" class="btn btn-sm btn-light-brand">View All</a>
                            </div>
                        </div>
                        <div class="card-body custom-card-action p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr class="border-b">
                                            <th>#</th>
                                            <th>Job Title</th>
                                            <th>Company</th>
                                            <th>Location</th>
                                            <th>Type</th>
                                            <th>Applied</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (recentJobs != null && !recentJobs.isEmpty()) {
                                            int i = 1;
                                            for (Postjob job : recentJobs) {
                                                if (i > 8) break;
                                                String jt = job.getJob_Type() != null ? job.getJob_Type().toLowerCase() : "";
                                        %>
                                        <tr>
                                            <td><%= i++ %></td>
                                            <td>
                                                <strong><%= job.getJob_Title() %></strong><br>
                                                <span class="fs-12 text-muted"><%= job.getJob_Region() %></span>
                                            </td>
                                            <td><%= job.getCompany_name() %></td>
                                            <td><%= job.getLocation() %></td>
                                            <td>
                                                <% if (jt.contains("full")) { %>
                                                    <span class="badge bg-soft-primary text-primary"><%= job.getJob_Type() %></span>
                                                <% } else if (jt.contains("part")) { %>
                                                    <span class="badge bg-soft-success text-success"><%= job.getJob_Type() %></span>
                                                <% } else { %>
                                                    <span class="badge bg-soft-warning text-warning"><%= job.getJob_Type() %></span>
                                                <% } %>
                                            </td>
                                            <td><strong class="text-primary"><%= job.getAppliedCount() %></strong></td>
                                        </tr>
                                        <% } } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">No jobs found</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <a href="admin-jobs.jsp" class="card-footer fs-11 fw-bold text-uppercase text-center py-3">View All Jobs</a>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="col-xxl-4">
                    <div class="card stretch stretch-full">
                        <div class="card-header">
                            <h5 class="card-title">Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <a href="admin-users.jsp" class="d-flex align-items-center gap-3 p-3 border border-dashed rounded-3 mb-3 text-decoration-none">
                                <div class="avatar-text avatar-lg bg-soft-primary text-primary">
                                    <i class="feather-users"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark">Manage Job Seekers</div>
                                    <div class="fs-12 text-muted">View & manage all candidates</div>
                                </div>
                                <i class="feather-chevron-right ms-auto text-muted"></i>
                            </a>
                            <a href="admin-companies.jsp" class="d-flex align-items-center gap-3 p-3 border border-dashed rounded-3 mb-3 text-decoration-none">
                                <div class="avatar-text avatar-lg bg-soft-warning text-warning">
                                    <i class="feather-home"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark">Manage Companies</div>
                                    <div class="fs-12 text-muted">View & approve companies</div>
                                </div>
                                <i class="feather-chevron-right ms-auto text-muted"></i>
                            </a>
                            <a href="admin-jobs.jsp" class="d-flex align-items-center gap-3 p-3 border border-dashed rounded-3 mb-3 text-decoration-none">
                                <div class="avatar-text avatar-lg bg-soft-success text-success">
                                    <i class="feather-briefcase"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark">Manage Jobs</div>
                                    <div class="fs-12 text-muted">View all job listings</div>
                                </div>
                                <i class="feather-chevron-right ms-auto text-muted"></i>
                            </a>
                            <a href="admin-application.jsp" class="d-flex align-items-center gap-3 p-3 border border-dashed rounded-3 mb-3 text-decoration-none">
                                <div class="avatar-text avatar-lg bg-soft-danger text-danger">
                                    <i class="feather-file-text"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark">View Applications</div>
                                    <div class="fs-12 text-muted">All job applications</div>
                                </div>
                                <i class="feather-chevron-right ms-auto text-muted"></i>
                            </a>
                            <a href="admin-resumes.jsp" class="d-flex align-items-center gap-3 p-3 border border-dashed rounded-3 text-decoration-none">
                                <div class="avatar-text avatar-lg bg-soft-info text-info">
                                    <i class="feather-upload"></i>
                                </div>
                                <div>
                                    <div class="fw-semibold text-dark">View Resumes</div>
                                    <div class="fs-12 text-muted">Uploaded resumes</div>
                                </div>
                                <i class="feather-chevron-right ms-auto text-muted"></i>
                            </a>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</main>