# Job Application Tracker

A Spring Boot, JSP and MySQL web application for keeping track of job applications.

## Features

- Register and sign in to a personal account
- Add, edit, and delete job applications
- Track status: Applied, Interviewing, Rejected, or Offer
- Keep each user's applications private to that account
- Persist data with Spring Data JPA and MySQL

## Tech stack

- Java 17
- Spring Boot 3.4.3
- Spring MVC and JSP
- Spring Data JPA / Hibernate
- MySQL
- Maven

## Requirements

- JDK 17
- MySQL 8+
- Git
- Maven 3.9+

## Run locally

1. Clone the repository:

   ```bash
   git clone https://github.com/Hemanthn-Dev/Job-application-tracker.git
   cd Job-application-tracker/JobTracker
   ```

2. Create the database:

   ```sql
   CREATE DATABASE jobtracker;
   ```

3. Set database environment variables. Do not commit real credentials.

   PowerShell:

   ```powershell
   $env:DB_URL="jdbc:mysql://localhost:3306/jobtracker"
   $env:DB_USERNAME="root"
   $env:DB_PASSWORD="your-local-mysql-password"
   ```

   Bash:

   ```bash
   export DB_URL="jdbc:mysql://localhost:3306/jobtracker"
   export DB_USERNAME="root"
   export DB_PASSWORD="your-local-mysql-password"
   ```

4. Start the application:

   ```powershell
   .\mvnw.cmd spring-boot:run
   ```

   On macOS/Linux, run `./mvnw spring-boot:run`.

5. Open http://localhost:8080/auth/register to create an account.

## Security notes

- New passwords are stored as BCrypt hashes.
- Existing accounts with legacy plain-text passwords are upgraded to BCrypt after a successful login.
- Job records are read, edited and deleted only after verifying they belong to the signed-in user.
- Configure database credentials through environment variables. Rotate credentials that were previously exposed in Git history.
- This is a learning project. Before public deployment, add login rate limiting, HTTPS, and automated security tests.

## Screenshots

<img width="1360" height="728" alt="Job Tracker dashboard" src="https://github.com/user-attachments/assets/1cb30400-619a-42ce-9591-f3eb0bf48a6e" />
<img width="1360" height="728" alt="Job Tracker applications" src="https://github.com/user-attachments/assets/e20c00e1-1427-4211-b7b3-625e52f5fb98" />
<img width="1360" height="728" alt="Job Tracker application details" src="https://github.com/user-attachments/assets/5d520227-4459-4271-b82e-efe070003418" />
