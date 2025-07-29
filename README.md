#GreenGuardians – Tree Campaign Management System

This is my Java Web Application project built using **JSP, Servlets, and MySQL**.  
The main goal is to help manage tree plantation campaigns digitally – from creating campaigns to tracking daily plantation reports.

---

# Why I Chose This Project
- I wanted to build something meaningful related to the environment.  
- It gave me a chance to work with **JSP & Servlets** and strengthen my Java web development skills.  
- Managing plantation drives manually is tough, so this project helps automate:
  - Campaign creation
  - Staff assignment
  - Daily plantation tracking
  - Attendance and reporting

---

# What the Project Does
 **Admin:**
  - Create and manage tree plantation campaigns.
  - Assign Trackers and Campaign Managers to campaigns.
  - View daily progress and overall reports.

 **Tracker:**
  - Submit daily reports including:
    - Trees planted
    - Saplings damaged
    - Area covered
    - Notes or challenges

 **Campaign Manager:**
  - Mark daily attendance for planters.
  - Submit a final report after the campaign ends.

 **Users (Planters/Donors):**
  - Register as a planter or donor.
  - View personal contributions and participated campaigns.

 **Email Notifications:**
  - Login details and campaign assignments are sent via JavaMail API.

---

##  Tools & Technologies Used
- **Backend:** Java Servlets
- **Frontend:** JSP, HTML, CSS
- **Database:** MySQL
- **Server:** Apache Tomcat 9
- **IDE:** Eclipse
- **Other:** JavaMail API for email notifications

---

##  How I Built It (Step-by-Step)
 **Created a Dynamic Web Project in Eclipse**
  - Set up Apache Tomcat 9.
  - Added MySQL Connector and JavaMail JARs in `lib`.

 **Designed the Database**
  created tables like:
    - `campaigns`
    - `users`
    - `tracker_records`
    - `campaign_assignment`
  - Connected tables with foreign keys for proper relationships.

 **Wrote DB Connection**
  - Created `DBConnection.java` to handle MySQL connectivity.

**Developed JSP Pages**
  - Admin dashboard for campaign management.
  - Tracker dashboard for daily report submissions.
  - Manager dashboard for attendance and final reports.
  - User dashboard for contributions.

**Created Servlets**
  - For login, campaign creation, assignments, daily reports, attendance, and email notifications.

**Integrated Email**
  - Used JavaMail API with Hotmail SMTP to send user credentials and campaign updates.
  
**Tested Everything**
  - Deployed on Tomcat 9.
  - Checked all user roles (Admin, Tracker, Manager, User).

##  How to Run
- Clone this repository.
- Import into *Eclipse* as a Dynamic Web Project.
- Create a *MySQL database* named `greenguardians` and import the SQL file.
- Update DB credentials in `DBConnection.java`.
- Add the project to *Apache Tomcat 9*.
- Run the server and open:
http://localhost:8080/GreenGuardians/

