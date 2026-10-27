<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>Login - Job Application Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="logo">
                    <i data-lucide="briefcase"></i>
                    <span>Job Tracker</span>
                </div>
                <h1>Welcome Back</h1>
                <p>Sign in to continue tracking your job applications</p>
            </div>

            <form action="<%= request.getContextPath() %>/auth/login" method="post" class="auth-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="form-group">
                    <label for="email">Email</label>
                    <div class="input-icon-wrapper">
                        <i data-lucide="mail"></i>
                        <input type="email" name="email" id="email" placeholder="Enter your email" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-icon-wrapper">
                        <i data-lucide="lock"></i>
                        <input type="password" name="password" id="password" placeholder="Enter your password" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary btn-full">Log In</button>
            </form>

            <!-- Show error message if login fails -->
            <c:if test="${not empty error}">
                <p style="color:red;">${error}</p>
            </c:if>

            <div class="auth-footer">
                <p>Don't have an account? <a href="<%= request.getContextPath() %>/auth/register" class="text-link">Create Account</a></p>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toastContainer"></div>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>
