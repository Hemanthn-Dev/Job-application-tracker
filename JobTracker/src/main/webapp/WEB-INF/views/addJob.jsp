<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Job | Job Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <main class="container">
        <div class="form-container">
            <h2>Add New Job Application</h2>
            <c:if test="${not empty error}"><p role="alert">${error}</p></c:if>
            <form id="jobForm" action="${pageContext.request.contextPath}/jobs/add" method="post">
                <div class="form-group">
                    <label for="company">Company Name</label>
                    <input id="company" type="text" name="company" value="${job.company}" maxlength="150" required>
                </div>
                <div class="form-group">
                    <label for="position">Position</label>
                    <input id="position" type="text" name="position" value="${job.position}" maxlength="150" required>
                </div>
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" required>
                        <option value="applied">Applied</option>
                        <option value="interviewing">Interviewing</option>
                        <option value="rejected">Rejected</option>
                        <option value="offer">Offer</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="appliedDate">Applied Date</label>
                    <input id="appliedDate" type="date" name="appliedDate" value="${job.appliedDate}">
                </div>
                <div class="form-buttons">
                    <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/home'">Cancel</button>
                    <button type="submit" class="btn-primary">Save Application</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
