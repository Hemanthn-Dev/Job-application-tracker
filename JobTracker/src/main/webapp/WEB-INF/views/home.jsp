<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>Job Application Tracker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://unpkg.com/lucide@latest"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery -->
</head>
<body>

    <!-- Navigation Bar -->
    <nav>
        <div class="container">
            <div class="nav-content">
                <div class="logo">
                    <i data-lucide="briefcase"></i>
                    <span>Job Tracker</span>
                </div>
                <div class="nav-buttons">
                    <button id="homeBtn" class="nav-btn active" onclick="window.location.href='${pageContext.request.contextPath}/home'">
                        <i data-lucide="home"></i>
                        Home
                    </button>

                    <c:if test="${not empty sessionScope.loggedInUserId}">
                        <button id="addJobBtn" class="nav-btn"
                            onclick="window.location.href='${pageContext.request.contextPath}/jobs/add'">
                            <i data-lucide="plus-circle"></i>
                            Add Job
                        </button>
                    </c:if>

                    <c:if test="${not empty sessionScope.loggedInUserId}">
                        <div class="profile">
                            <i data-lucide="user"></i>
                            <span class="username">${sessionScope.loggedInUserName}</span>
                            <form action="${pageContext.request.contextPath}/auth/logout" method="post" style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <button id="logoutBtn" type="submit" class="nav-btn logout">
                                    <i data-lucide="log-out"></i>
                                    Logout
                                </button>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${empty sessionScope.loggedInUserId}">
                        <button id="loginBtn" class="nav-btn login" onclick="window.location.href='${pageContext.request.contextPath}/auth/login'">
                            <i data-lucide="log-in"></i>
                            Login
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </nav>

    <main class="container">
        <h2>Job Applications</h2>

        <!-- Filter Buttons -->
        <div class="filters">
            <button class="filter-btn active" data-status="all">All Applications</button>
            <button class="filter-btn" data-status="Applied">Applied</button>
            <button class="filter-btn" data-status="Interviewing">Interviewing</button>
            <button class="filter-btn" data-status="Rejected">Rejected</button>
        </div>

        <!-- Job Applications Table -->
        <div id="dashboardView">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Company</th>
                            <th>Position</th>
                            <th>Status</th>
                            <th>Applied Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="jobsTableBody">
                        <c:choose>
                            <c:when test="${not empty jobs}">
                                <c:forEach var="job" items="${jobs}">
                                    <tr class="job-row" data-status="${job.status}">
                                        <td>${job.company}</td>
                                        <td>${job.position}</td>
                                        <td>${job.status}</td>
                                        <td class="applied-date" data-date="${job.appliedDate}"></td> <!-- Applied Date Column -->
                                        <td>
                                            <button onclick="editApplication(${job.id})" class="action-btn edit">Update</button>
                                            <button onclick="confirmDelete(${job.id})" class="action-btn delete">Delete</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr id="no-jobs-message">
                                    <td colspan="5" class="empty-state">
                                        <p>No job applications found</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        lucide.createIcons();

        function confirmDelete(jobId) {
            if (confirm("Are you sure you want to delete this job application?")) {
                fetch("${pageContext.request.contextPath}/jobs/" + jobId, {
                    method: "DELETE",
                    headers: {
                        [document.querySelector('meta[name="_csrf_header"]').content]:
                            document.querySelector('meta[name="_csrf"]').content
                    }
                }).then(response => {
                    if (response.ok) {
                        alert("Job deleted successfully!");
                        location.reload();
                    } else {
                        alert("Error deleting job.");
                    }
                });
            }
        }

        function editApplication(jobId) {
            window.location.href = "${pageContext.request.contextPath}/jobs/edit/" + jobId;
        }

        // Formatting the Applied Date to "Feb 25, 2025"
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".applied-date").forEach(function (td) {
                let dateStr = td.getAttribute("data-date"); // Get raw date from JSP
                if (dateStr) {
                    let date = new Date(dateStr);
                    let options = { month: "short", day: "2-digit", year: "numeric" };
                    td.innerText = date.toLocaleDateString("en-US", options);
                }
            });
        });

        // Filtering jobs without changing the URL
        document.querySelectorAll(".filter-btn").forEach(button => {
            button.addEventListener("click", function () {
                let status = this.getAttribute("data-status").toLowerCase(); // Convert filter status to lowercase

                // Remove 'active' class from all buttons and set it to the clicked one
                document.querySelectorAll(".filter-btn").forEach(btn => btn.classList.remove("active"));
                this.classList.add("active");

                let rows = document.querySelectorAll(".job-row");
                let hasJobs = false;

                rows.forEach(row => {
                    let jobStatus = row.getAttribute("data-status").toLowerCase(); // Convert job status to lowercase

                    if (status === "all" || jobStatus === status) {
                        row.style.display = "";
                        hasJobs = true;
                    } else {
                        row.style.display = "none";
                    }
                });

                // Handle the "No jobs found" message
                let noJobsMessageRow = document.getElementById("no-jobs-message");

                if (hasJobs) {
                    if (noJobsMessageRow) noJobsMessageRow.style.display = "none";
                } else {
                    if (!noJobsMessageRow) {
                        // Create the row dynamically if it doesn't exist
                        let tbody = document.querySelector("#jobsTableBody");
                        let tr = document.createElement("tr");
                        tr.id = "no-jobs-message";
                        tr.innerHTML = `<td colspan="5" class="empty-state"><p>No job applications found</p></td>`;
                        tbody.appendChild(tr);
                    } else {
                        noJobsMessageRow.style.display = "table-row";
                    }
                }
            });
        });


    </script>

</body>
</html>
