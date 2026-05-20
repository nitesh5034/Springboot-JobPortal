<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html>

  <head>
    <meta charset="UTF-8">
    <title>Job Board Header</title>
    <link
      href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=Inter:wght@400;500;600&display=swap"
      rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
      /* Advanced Premium Public Header Styles */
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
  </head>

  <body>

    <div class="advanced-header">
      <header class="advanced-navbar">

        <!-- Logo -->
        <a href="index.html" class="adv-logo">
          <div class="adv-logo-icon">
            <i class="fas fa-briefcase"></i>
          </div>
          <span class="adv-logo-text">JobBoard</span>
        </a>

        <!-- Navigation -->
        <ul class="adv-nav">
          <li class="adv-nav-item">
            <a href="index.html" class="adv-nav-link active">Home</a>
          </li>
          <li class="adv-nav-item">
            <a href="about.html" class="adv-nav-link">About</a>
          </li>

          <li class="adv-nav-item">
            <a href="job-listings.html" class="adv-nav-link">
              Job Listings <i class="fas fa-chevron-down ms-1" style="font-size: 10px;"></i>
            </a>
            <ul class="adv-dropdown">
              <li class="adv-dropdown-item"><a href="job-single.html" class="adv-dropdown-link"><i
                    class="fas fa-file-alt"></i> Job Single</a></li>
              <li class="adv-dropdown-item"><a href="post-job.html" class="adv-dropdown-link"><i
                    class="fas fa-plus-circle"></i> Post a Job</a></li>
            </ul>
          </li>

          <li class="adv-nav-item">
            <a href="services.html" class="adv-nav-link">
              Pages <i class="fas fa-chevron-down ms-1" style="font-size: 10px;"></i>
            </a>
            <ul class="adv-dropdown">
              <li class="adv-dropdown-item"><a href="services.html" class="adv-dropdown-link"><i
                    class="fas fa-tools"></i> Services</a></li>
              <li class="adv-dropdown-item"><a href="service-single.html" class="adv-dropdown-link"><i
                    class="fas fa-wrench"></i> Service Single</a></li>
              <li class="adv-dropdown-item"><a href="blog-single.html" class="adv-dropdown-link"><i
                    class="fas fa-newspaper"></i> Blog Single</a></li>
              <li class="adv-dropdown-item"><a href="portfolio.html" class="adv-dropdown-link"><i
                    class="fas fa-briefcase"></i> Portfolio</a></li>
              <li class="adv-dropdown-item"><a href="portfolio-single.html" class="adv-dropdown-link"><i
                    class="fas fa-folder-open"></i> Portfolio Single</a></li>
              <li class="adv-dropdown-item"><a href="testimonials.html" class="adv-dropdown-link"><i
                    class="fas fa-comment-dots"></i> Testimonials</a></li>
              <li class="adv-dropdown-item"><a href="faq.html" class="adv-dropdown-link"><i
                    class="fas fa-question-circle"></i> FAQ</a></li>
              <li class="adv-dropdown-item"><a href="gallery.html" class="adv-dropdown-link"><i
                    class="fas fa-images"></i> Gallery</a></li>
            </ul>
          </li>

          <li class="adv-nav-item">
            <a href="blog.html" class="adv-nav-link">Blog</a>
          </li>
          <li class="adv-nav-item">
            <a href="contact.html" class="adv-nav-link">Contact</a>
          </li>
        </ul>

        <!-- Actions -->
        <div class="adv-actions">
          <!-- Logged Out State Actions -->
          <div class="d-none d-lg-flex" style="gap: 12px; align-items: center;">
            <a href="post-job.html" class="adv-btn adv-btn-outline">
              <i class="fas fa-plus"></i> Post a Job
            </a>
            <a href="login.html" class="adv-btn adv-btn-primary">
              <i class="fas fa-lock"></i> Log in
            </a>
          </div>

          <!-- Mobile Toggle -->
          <a href="#" class="adv-mobile-toggle site-menu-toggle js-menu-toggle">
            <i class="fas fa-bars"></i>
          </a>
        </div>

      </header>
    </div>

  </body>

  </html>