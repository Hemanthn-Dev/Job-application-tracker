<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Job | Job Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <main class="container">
        <h2>Edit Job Application</h2>
        <c:if test="${not empty error}"><p role="alert">${error}</p></c:if>
        <form action="${pageContext.request.contextPath}/jobs/update/${job.id}" method="post" class="job-form">
            <label for="company">Company</label>
            <input type="text" id="company" name="company" value="${job.company}" maxlength="150" required>
            <label for="position">Position</label>
            <input type="text" id="position" name="position" value="${job.position}" maxlength="150" required>
            <label for="status">Status</label>
            <select id="status" name="status" required>
                <option value="applied" ${job.status == 'applied' ? 'selected' : ''}>Applied</option>
                <option value="interviewing" ${job.status == 'interviewing' ? 'selected' : ''}>Interviewing</option>
                <option value="rejected" ${job.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                <option value="offer" ${job.status == 'offer' ? 'selected' : ''}>Offer</option>
            </select>
            <label for="appliedDate">Applied Date</label>
            <input type="date" id="appliedDate" name="appliedDate" value="${job.appliedDate}">
            <button type="submit" class="submit-btn">Update Job</button>
            <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/home'">Cancel</button>
        </form>
    </main>
</body>
</html>
