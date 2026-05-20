<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- ===== HEADER ===== -->
<header class="nxl-header">
    <div class="header-wrapper">
        <div class="header-left d-flex align-items-center gap-4">
            <a href="javascript:void(0);" class="nxl-head-mobile-toggler" id="mobile-collapse">
                <div class="hamburger hamburger--arrowturn">
                    <div class="hamburger-box"><div class="hamburger-inner"></div></div>
                </div>
            </a>
            <div class="nxl-navigation-toggle">
                <a href="javascript:void(0);" id="menu-mini-button"><i class="feather-align-left"></i></a>
                <a href="javascript:void(0);" id="menu-expend-button" style="display:none"><i class="feather-arrow-right"></i></a>
            </div>
            <a href="dashboard.jsp" style="text-decoration:none; font-size:18px; font-weight:700; color:#3454d1;">
                Job<span style="color:#0f172a;">Portal</span>
                <span class="badge bg-soft-primary text-primary fs-10 ms-1">Admin</span>
            </a>
        </div>
        <div class="header-right ms-auto d-flex align-items-center gap-3">
            <div class="dropdown nxl-h-item">
                <a href="javascript:void(0);" class="nxl-head-link me-0" data-bs-toggle="dropdown">
                    <div class="d-flex align-items-center gap-2">
                        <div class="avatar-text avatar-md bg-soft-primary text-primary">
                            <i class="feather-user"></i>
                        </div>
                        <div class="d-none d-sm-block">
                            <div class="fs-13 fw-semibold text-dark">Admin</div>
                            <div class="fs-11 text-muted">Administrator</div>
                        </div>
                        <i class="feather-chevron-down fs-12 ms-1"></i>
                    </div>
                </a>
                <div class="dropdown-menu dropdown-menu-end">
                    <a href="settings-general.html" class="dropdown-item"><i class="feather-settings me-3"></i>Settings</a>
                    <div class="dropdown-divider"></div>
                    <a href="logout" class="dropdown-item text-danger"><i class="feather-log-out me-3"></i>Logout</a>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- ===== SIDEBAR ===== -->
<nav class="nxl-navigation">
    <div class="navbar-wrapper">
        <div class="m-header">
            <a href="dashboard.jsp" style="text-decoration:none; font-size:18px; font-weight:700; color:#3454d1;">
                Job<span style="color:#0f172a;">Portal</span>
            </a>
        </div>
        <div class="navbar-content">
            <ul class="nxl-navbar">

                <!-- Main -->
                <li class="nxl-item nxl-caption"><label>Main</label></li>
                <li class="nxl-item">
                    <a href="dashboard.jsp" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-airplay"></i></span>
                        <span class="nxl-mtext">Dashboard</span>
                    </a>
                </li>

                <!-- Job Portal -->
                <li class="nxl-item nxl-caption"><label>Job Portal</label></li>

                <li class="nxl-item">
                    <a href="admin-users.jsp" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-users"></i></span>
                        <span class="nxl-mtext">Job Seekers</span>
                    </a>
                </li>

                <li class="nxl-item">
                    <a href="admin-companies.jsp" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-home"></i></span>
                        <span class="nxl-mtext">Companies</span>
                    </a>
                </li>

                <li class="nxl-item">
                    <a href="admin-jobs.jsp" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-briefcase"></i></span>
                        <span class="nxl-mtext">Job Listings</span>
                    </a>
                </li>

                <li class="nxl-item">
                    <a href="admin-applications.jsp" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-file-text"></i></span>
                        <span class="nxl-mtext">Applications</span>
                    </a>
                </li>

                <li class="nxl-item">
                    <a href="admin-resumes.jsp" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-upload"></i></span>
                        <span class="nxl-mtext">Resumes</span>
                    </a>
                </li>

                <!-- Settings -->
                <li class="nxl-item nxl-caption"><label>Settings</label></li>

                <li class="nxl-item">
                    <a href="settings-general.html" class="nxl-link">
                        <span class="nxl-micon"><i class="feather-settings"></i></span>
                        <span class="nxl-mtext">Settings</span>
                    </a>
                </li>

                <li class="nxl-item">
                    <a href="logout" class="nxl-link" style="color:#ef4444;">
                        <span class="nxl-micon"><i class="feather-log-out"></i></span>
                        <span class="nxl-mtext">Logout</span>
                    </a>
                </li>

            </ul>
        </div>
    </div>
</nav>
