<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>Register - Job Application Tracker</title>
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
                <h1>Create Account</h1>
                <p>Sign up to start tracking your job applications</p>
            </div>

            <form action="${pageContext.request.contextPath}/auth/register" method="post" class="auth-form">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <div class="form-group">
                    <label for="userName">Full Name</label>
                    <div class="input-icon-wrapper">
                        <i data-lucide="user"></i>
                        <input type="text" name="userName" id="userName" placeholder="Enter your full name" required>
                    </div>
                </div>

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
                        <input type="password" name="password" id="password" placeholder="Create a password" required>
                    </div>
                </div>

                <button type="submit" class="btn-primary btn-full">Create Account</button>
            </form>

            <%-- Show error message if registration fails --%>
            <c:if test="${not empty error}">
                <p style="color:red;">${error}</p>
            </c:if>

            <div class="auth-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/auth/login" class="text-link">Sign In</a></p>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div id="toastContainer"></div>

</body>
</html>
