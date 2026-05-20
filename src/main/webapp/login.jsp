<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>JobBoard | Login</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link
            href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@300;400;500;600&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- MAIN CSS -->
        <link rel="stylesheet" href="css/custom-bs.css">
        <link rel="stylesheet" href="css/style.css">

        <style>
            body {
                font-family: 'DM Sans', sans-serif;
                margin: 0;
                background-color: #f8fafc;
            }

            .auth-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, #f0f4ff 0%, #e2e8f0 100%);
                padding: 40px 20px;
                position: relative;
                overflow: hidden;
            }

            /* Decorative Background Elements */
            .auth-container::before {
                content: '';
                position: absolute;
                top: -150px;
                right: -100px;
                width: 500px;
                height: 500px;
                background: radial-gradient(circle, rgba(26, 86, 219, 0.1) 0%, rgba(26, 86, 219, 0) 70%);
                border-radius: 50%;
                pointer-events: none;
            }

            .auth-container::after {
                content: '';
                position: absolute;
                bottom: -150px;
                left: -100px;
                width: 600px;
                height: 600px;
                background: radial-gradient(circle, rgba(59, 130, 246, 0.08) 0%, rgba(59, 130, 246, 0) 70%);
                border-radius: 50%;
                pointer-events: none;
            }

            .auth-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.4);
                border-radius: 24px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08), 0 1px 3px rgba(0, 0, 0, 0.05);
                width: 100%;
                max-width: 440px;
                padding: 40px;
                position: relative;
                z-index: 10;
                animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
                opacity: 0;
                transform: translateY(30px);
            }

            @keyframes slideUp {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .auth-header {
                text-align: center;
                margin-bottom: 32px;
            }

            .auth-header h1 {
                font-family: 'Sora', sans-serif;
                font-weight: 700;
                font-size: 28px;
                color: #0f172a;
                margin-bottom: 8px;
            }

            .auth-header p {
                font-size: 15px;
                color: #64748b;
            }

            .auth-form .form-group {
                margin-bottom: 20px;
                position: relative;
            }

            .auth-form label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #475569;
                margin-bottom: 8px;
            }

            .auth-form .form-control,
            .auth-form select {
                width: 100%;
                padding: 14px 16px;
                border-radius: 12px;
                border: 1px solid #cbd5e1;
                background: #ffffff;
                font-size: 15px;
                color: #334155;
                transition: all 0.3s ease;
                box-sizing: border-box;
                font-family: 'DM Sans', sans-serif;
                height: auto;
            }

            .auth-form select {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2364748b' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: calc(100% - 16px) center;
                padding-right: 40px;
            }

            .auth-form .form-control:focus,
            .auth-form select:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
                background: #ffffff;
            }

            .input-icon-wrapper {
                position: relative;
            }

            .input-icon-wrapper i {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #94a3b8;
                font-size: 16px;
                pointer-events: none;
                z-index: 2;
            }

            .input-icon-wrapper .form-control {
                padding-left: 44px;
            }

            .btn-auth {
                width: 100%;
                padding: 14px;
                border-radius: 12px;
                background: linear-gradient(135deg, #1a56db 0%, #3b82f6 100%);
                color: white;
                font-weight: 600;
                font-size: 16px;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 12px rgba(26, 86, 219, 0.25);
                font-family: 'Sora', sans-serif;
                margin-top: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-auth:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(26, 86, 219, 0.35);
            }

            .btn-auth:active {
                transform: translateY(0);
            }

            .auth-footer {
                margin-top: 24px;
                text-align: center;
                font-size: 14px;
                color: #64748b;
            }

            .auth-footer a {
                color: #1a56db;
                font-weight: 600;
                text-decoration: none;
                transition: color 0.2s;
            }

            .auth-footer a:hover {
                color: #1e40af;
                text-decoration: underline;
            }

            .home-link {
                position: absolute;
                top: 24px;
                left: 24px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #475569;
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                padding: 8px 16px;
                background: rgba(255, 255, 255, 0.7);
                backdrop-filter: blur(10px);
                border-radius: 40px;
                transition: all 0.2s;
                z-index: 20;
                border: 1px solid rgba(255, 255, 255, 0.8);
            }

            .home-link:hover {
                background: rgba(255, 255, 255, 0.9);
                color: #1a56db;
                transform: translateX(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            }
        </style>
    </head>

    <body>

        <a href="" class="home-link">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>

        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>Welcome Back</h1>
                    <p>Log in to your JobBoard account</p>
                </div>

                <form action="UserController" method="post" class="auth-form">
                    <input type="hidden" name="action" value="login">

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="input-icon-wrapper">
                            <i class="fas fa-envelope"></i>
                            <input type="text" id="email" name="email" class="form-control"
                                placeholder="Enter your email" required autocomplete="email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-icon-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" class="form-control"
                                placeholder="Enter your password" required autocomplete="current-password">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="role">Login As</label>
                        <div class="input-icon-wrapper">
                            <i class="fas fa-user-tag"></i>
                            <select name="role" id="role" class="form-control">
                                <option value="JOBSEEKER">Job Seeker</option>
                                <option value="EMPLOYER">Employer</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn-auth">
                        Sign In <i class="fas fa-arrow-right" style="font-size: 14px;"></i>
                    </button>

                    <div class="auth-footer">
                        Don't have an account? <a href="registration.jsp">Create an account</a>
                    </div>
                     <div class="auth-footer">
					Forgot Password ? <a href="forgotpassword.jsp">Create an account</a>
                    </div>
                </form>
            </div>
        </div>

    </body>

    </html>