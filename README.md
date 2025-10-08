# Dental Clinic - Spring Boot + JSP Starter

## How to run

1. Make sure you have Java 17 and Maven installed.
2. Ensure a local MySQL server is running. The project default config uses:
   - database: project_db (will be created automatically)
   - username: root
   - password: root
   If your MySQL credentials differ, update `src/main/resources/application.properties`.

3. From the project root run:
   mvn clean package
   mvn spring-boot:run

4. Open these URLs:
   - Register: http://localhost:8080/register
   - Login: http://localhost:8080/login
   - Admin login: http://localhost:8080/admin/login (username/password both: Admin123!)

Notes:
- `src/main/resources/data.sql` inserts dentists and services only if they don't already exist (to avoid duplicates on repeated runs).
- Passwords are stored in plain text for demo purposes. For production use hashing and Spring Security.
