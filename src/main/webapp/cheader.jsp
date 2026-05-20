<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ page import="com.model.UserModel" %>
    <% UserModel u=(UserModel) session.getAttribute("Model"); %>

      <link
        href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Inter:wght@400;500;600&display=swap"
        rel="stylesheet">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

      <style>
        /* Advanced Premium Header Styles */
        :root {
          --primary-color: #4f46e5;
          --secondary-color: #818cf8;
          --text-dark: #1e293b;
          --text-light: #64748b;
          --bg-glass: rgba(255, 255, 255, 0.85);
          --border-glass: rgba(255, 255, 255, 0.4);
          --shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
          --shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.03);
        }

        .advanced-header {
          position: sticky;
          top: 15px;
          z-index: 1000;
          max-width: 1400px;
          margin: 0 auto;
          padding: 0 20px;
          transition: all 0.3s ease;
        }

        .advanced-navbar {
          background: var(--bg-glass);
          backdrop-filter: blur(16px);
          -webkit-backdrop-filter: blur(16px);
          border: 1px solid var(--border-glass);
          border-radius: 24px;
          padding: 12px 24px;
          box-shadow: var(--shadow-sm);
          display: flex;
          align-items: center;
          justify-content: space-between;
        }

        /* Logo Styling */
        .adv-logo {
          font-family: 'Outfit', sans-serif;
          font-size: 24px;
          font-weight: 700;
          text-decoration: none !important;
          display: flex;
          align-items: center;
          gap: 8px;
          color: var(--text-dark) !important;
        }

        .adv-logo-icon {
          width: 36px;
          height: 36px;
          background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
          border-radius: 12px;
          display: flex;
          align-items: center;
          justify-content: center;
          color: white;
          font-size: 18px;
          box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
          transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .adv-logo:hover .adv-logo-icon {
          transform: rotate(-10deg) scale(1.05);
        }

        .adv-logo-text {
          background: linear-gradient(90deg, #1e293b, #4f46e5);
          -webkit-background-clip: text;
          background-clip: text;
          -webkit-text-fill-color: transparent;
          letter-spacing: -0.5px;
        }

        /* Navigation Menu */
        .adv-nav {
          display: none;
        }

        @media (min-width: 992px) {
          .adv-nav {
            display: flex;
            align-items: center;
            gap: 8px;
            list-style: none;
            margin: 0;
            padding: 0;
          }
        }

        .adv-nav-item {
          position: relative;
        }

        .adv-nav-link {
          font-family: 'Inter', sans-serif;
          font-size: 15px;
          font-weight: 500;
          color: var(--text-light) !important;
          text-decoration: none !important;
          padding: 8px 16px;
          border-radius: 12px;
          transition: all 0.3s ease;
          display: inline-flex;
          align-items: center;
          gap: 6px;
        }

        .adv-nav-link:hover,
        .adv-nav-link.active {
          color: var(--primary-color) !important;
          background: rgba(79, 70, 229, 0.05);
        }

        .adv-nav-link::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 50%;
          width: 0;
          height: 2px;
          background: var(--primary-color);
          transition: all 0.3s ease;
          transform: translateX(-50%);
          border-radius: 2px;
        }

        .adv-nav-link:hover::after,
        .adv-nav-link.active::after {
          width: 50%;
        }

        /* Dropdown Submenu */
        .adv-dropdown {
          position: absolute;
          top: calc(100% + 15px);
          left: 50%;
          transform: translateX(-50%) translateY(10px);
          background: rgba(255, 255, 255, 0.98);
          backdrop-filter: blur(20px);
          min-width: 220px;
          border: 1px solid rgba(226, 232, 240, 0.8);
          border-radius: 16px;
          box-shadow: var(--shadow-md);
          padding: 10px;
          opacity: 0;
          visibility: hidden;
          transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
          z-index: 1001;
          list-style: none;
        }

        .adv-dropdown::before {
          content: '';
          position: absolute;
          top: -6px;
          left: 50%;
          transform: translateX(-50%) rotate(45deg);
          width: 12px;
          height: 12px;
          background: white;
          border-top: 1px solid rgba(226, 232, 240, 0.8);
          border-left: 1px solid rgba(226, 232, 240, 0.8);
        }

        .adv-nav-item:hover .adv-dropdown {
          opacity: 1;
          visibility: visible;
          transform: translateX(-50%) translateY(0);
        }

        .adv-dropdown-item {
          margin-bottom: 2px;
        }

        .adv-dropdown-item:last-child {
          margin-bottom: 0;
        }

        .adv-dropdown-link {
          font-family: 'Inter', sans-serif;
          font-size: 14px;
          font-weight: 500;
          color: var(--text-dark) !important;
          text-decoration: none !important;
          padding: 10px 14px;
          border-radius: 10px;
          display: flex;
          align-items: center;
          gap: 12px;
          transition: all 0.2s ease;
        }

        .adv-dropdown-link:hover {
          background: rgba(79, 70, 229, 0.08);
          color: var(--primary-color) !important;
          transform: translateX(4px);
        }

        .adv-dropdown-link i {
          color: var(--text-light);
          font-size: 14px;
          width: 16px;
          text-align: center;
          transition: all 0.2s ease;
        }

        .adv-dropdown-link:hover i {
          color: var(--primary-color);
        }

        .adv-dropdown-divider {
          height: 1px;
          background: rgba(226, 232, 240, 0.8);
          margin: 6px 0;
        }

        /* User Action Buttons */
        .adv-actions {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .adv-btn {
          font-family: 'Inter', sans-serif;
          font-size: 14px;
          font-weight: 600;
          padding: 10px 20px;
          border-radius: 12px;
          text-decoration: none !important;
          transition: all 0.3s ease;
          display: inline-flex;
          align-items: center;
          gap: 8px;
        }

        .adv-btn-outline {
          color: var(--text-dark) !important;
          background: transparent;
          border: 1px solid rgba(226, 232, 240, 0.8);
        }

        .adv-btn-outline:hover {
          border-color: var(--primary-color);
          color: var(--primary-color) !important;
          background: rgba(79, 70, 229, 0.05);
        }

        .adv-btn-primary {
          color: white !important;
          background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
          border: none;
          box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .adv-btn-primary:hover {
          transform: translateY(-2px);
          box-shadow: 0 6px 16px rgba(79, 70, 229, 0.3);
        }

        /* User Avatar Profile */
        .adv-user-profile {
          display: flex;
          align-items: center;
          gap: 8px;
          padding: 4px 12px 4px 4px;
          background: white;
          border: 1px solid rgba(226, 232, 240, 0.8);
          border-radius: 40px;
          text-decoration: none !important;
          color: var(--text-dark) !important;
          font-family: 'Inter', sans-serif;
          font-weight: 600;
          font-size: 14px;
          transition: all 0.3s ease;
          cursor: pointer;
        }

        .adv-user-profile:hover {
          border-color: var(--secondary-color);
          background: #f8fafc;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .adv-avatar {
          width: 32px;
          height: 32px;
          border-radius: 50%;
          background: linear-gradient(135deg, #10b981, #059669);
          color: white;
          display: flex;
          align-items: center;
          justify-content: center;
          font-weight: 700;
          font-size: 13px;
          font-family: 'Outfit', sans-serif;
        }

        .adv-logout-btn {
          color: #ef4444 !important;
        }

        .adv-logout-btn:hover {
          background: #fef2f2 !important;
          color: #dc2626 !important;
        }

        .adv-logout-btn:hover i {
          color: #dc2626 !important;
        }

        /* Right Dropdown Position Fix */
        .adv-dropdown-right {
          left: auto;
          right: 0;
          transform: translateX(0) translateY(10px);
        }

        .adv-nav-item:hover .adv-dropdown-right {
          transform: translateX(0) translateY(0);
        }

        .adv-dropdown-right::before {
          left: auto;
          right: 20px;
          transform: rotate(45deg);
        }

        /* Mobile Menu Toggle */
        .adv-mobile-toggle {
          display: none;
          background: none;
          border: none;
          font-size: 20px;
          color: var(--text-dark);
          cursor: pointer;
          padding: 8px;
          margin-left: 8px;
        }

        @media (max-width: 991px) {
          .adv-mobile-toggle {
            display: block;
          }

          .adv-nav {
            display: none;
          }

          .advanced-navbar {
            border-radius: 16px;
            padding: 10px 16px;
          }
        }
      </style>

      <div class="advanced-header">
        <header class="advanced-navbar">

          <!-- Logo -->
          <a href="userhome.jsp" class="adv-logo">
            <div class="adv-logo-icon">
              <i class="fas fa-briefcase"></i>
            </div>
            <span class="adv-logo-text">JobBoard</span>
          </a>

          <!-- Navigation -->
          <ul class="adv-nav">
            <li class="adv-nav-item">
              <a href="userhome.jsp" class="adv-nav-link active">Home</a>
            </li>
            <li class="adv-nav-item">
              <a href="about.jsp" class="adv-nav-link">About</a>
            </li>
            <li class="adv-nav-item">
              <a href="joblisting.jsp" class="adv-nav-link">
                Job Listings <i class="fas fa-chevron-down ms-1" style="font-size: 10px;"></i>
              </a>
              <ul class="adv-dropdown">
                <li class="adv-dropdown-item">
                  <a href="jobsingle.jsp" class="adv-dropdown-link">
                    <i class="fas fa-file-alt"></i> Job Details
                  </a>
                </li>
              </ul>
            </li>
            <li class="adv-nav-item">
              <a href="blog.jsp" class="adv-nav-link">Blog</a>
            </li>
            <li class="adv-nav-item">
              <a href="contact.jsp" class="adv-nav-link">Contact</a>
            </li>
          </ul>

          <!-- Actions -->
          <div class="adv-actions">
            <% if (u !=null) { %>
              <!-- Logged In State -->
              <div class="adv-nav-item">
                <div class="adv-user-profile">
                  <div class="adv-avatar">
                    <%= (u.getFirstname() !=null && u.getFirstname().length()> 0) ? u.getFirstname().substring(0,
                      1).toUpperCase() : "U" %>
                  </div>
                  <span>
                    <%= u.getFirstname() %>
                  </span>
                  <i class="fas fa-chevron-down ms-1" style="font-size: 10px; color: #64748b;"></i>
                </div>
                <ul class="adv-dropdown adv-dropdown-right">
                  <li class="adv-dropdown-item">
                    <a href="newProfile.jsp" class="adv-dropdown-link">
                      <i class="fas fa-user-circle"></i> My Profile
                    </a>
                  </li>
                  <li class="adv-dropdown-item">
                    <a href="Application-track.jsp" class="adv-dropdown-link">
                      <i class="fas fa-chart-line"></i> Applications
                    </a>
                  </li>
                  <li class="adv-dropdown-item">
                    <a href="resumeupload.jsp" class="adv-dropdown-link">
                      <i class="fas fa-file-upload"></i> Resume
                    </a>
                  </li>
                  <li class="adv-dropdown-item">
                    <a href="Setting.jsp" class="adv-dropdown-link">
                      <i class="fas fa-cog"></i> Settings
                    </a>
                  </li>
                  <li class="adv-dropdown-divider"></li>
                  <li class="adv-dropdown-item">
                    <a href="logout" class="adv-dropdown-link adv-logout-btn">
                      <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                  </li>
                </ul>
              </div>
              <% } else { %>
                <!-- Logged Out State -->
                <div class="d-none d-lg-flex" style="gap: 12px; align-items: center;">
                  <a href="login.jsp" class="adv-btn adv-btn-outline">Log in</a>
                  <a href="register.jsp" class="adv-btn adv-btn-primary">
                    Sign up <i class="fas fa-arrow-right" style="font-size: 12px; margin-left: 4px;"></i>
                  </a>
                </div>
                <% } %>

                  <!-- Mobile Toggle -->
                  <a href="#" class="adv-mobile-toggle site-menu-toggle js-menu-toggle">
                    <i class="fas fa-bars"></i>
                  </a>
          </div>

        </header>
      </div>