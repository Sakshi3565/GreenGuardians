package green;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import java.util.UUID;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/addStaff")
public class AddStaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String dob = request.getParameter("dob");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(true);

         
            ps = conn.prepareStatement(
                "INSERT INTO staff (name, email, role, phone, address, city, state, date_of_birth) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", 
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, role);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, city);
            ps.setString(7, state);
            ps.setString(8, dob);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            int staffId = 0;
            if (rs.next()) {
                staffId = rs.getInt(1);
                System.out.println("Staff inserted successfully with ID: " + staffId);
            } else {
                System.out.println("Failed to retrieve staff ID.");
            }

            String username = email.split("@")[0];
            String password = UUID.randomUUID().toString().substring(0, 8);
            ps = conn.prepareStatement("INSERT INTO staff_login (staff_id, username, password) VALUES (?, ?, ?)");
            ps.setInt(1, staffId);
            ps.setString(2, username);
            ps.setString(3, password); // store hash in real case
            ps.executeUpdate();
            System.out.println("Login created for staff.");
            String emailSubject = "🎉Welcome to GreenGuardians!";
            String emailBody = "Hi " + name + ",\n\n" +
                "Welcome to *GreenGuardians*! You've been added as a **" + role + "** in our system.\n\n" +
                "Here are your login credentials:\n" +
                "•Username: " + username + "\n" +
                "•Password: " + password + "\n\n" +
                "Please use these to log in and get started.\n\n" +
                "If you have any questions, feel free to reach out to our team.\n\n" +
                "Cheers,\nGreenGuardians Team";
            System.out.println("Generated password: " + password);
            sendEmail(email, emailSubject, emailBody);
            System.out.println("Email sent successfully to: " + email);
            String notifSubject = "New " + role + " Joined";
            String notifMessage = name + " (" + role + ") has been added to the system.";

            try {
                ps = conn.prepareStatement("INSERT INTO notifications (staff_id, subject, message) VALUES (?, ?, ?)");
                ps.setInt(1, staffId);
                ps.setString(2, notifSubject);
                ps.setString(3, notifMessage);
                ps.executeUpdate();
                System.out.println("Notification inserted for staff ID: " + staffId);
            } catch (SQLException se) {
                System.out.println("Failed to insert notification:");
                se.printStackTrace();
            }


            request.setAttribute("success", "Staff added, credentials sent via email, and notification recorded.");

        } catch (Exception e) {
            e.printStackTrace(); 
            request.setAttribute("error", "Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("addStaff.jsp").forward(request, response);
    }

    private void sendEmail(String to, String subject, String body) throws MessagingException {
        final String from = "your email id"; 
        final String pass = "your key";           
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, pass);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setText(body);
        Transport.send(msg);
    }
}
