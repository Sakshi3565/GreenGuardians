package green;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

@WebServlet("/assignStaff")
public class AssignStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int staffId = Integer.parseInt(request.getParameter("staffId"));
        int campaignId = Integer.parseInt(request.getParameter("campaignId"));

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Insert assignment
            ps = conn.prepareStatement("INSERT INTO campaign_assignment (staff_id, campaign_id) VALUES (?, ?)");
            ps.setInt(1, staffId);
            ps.setInt(2, campaignId);
            ps.executeUpdate();

            // Get staff info
            String staffName = "", staffEmail = "", role = "";
            ps = conn.prepareStatement("SELECT name, email, role FROM staff WHERE staff_id = ?");
            ps.setInt(1, staffId);
            rs = ps.executeQuery();
            if (rs.next()) {
                staffName = rs.getString("name");
                staffEmail = rs.getString("email");
                role = rs.getString("role");
            }

            // Get campaign title
            String campaignTitle = "";
            ps = conn.prepareStatement("SELECT title FROM campaigns WHERE campaign_id = ?");
            ps.setInt(1, campaignId);
            rs = ps.executeQuery();
            if (rs.next()) {
                campaignTitle = rs.getString("title");
            }

            // Send email
            String subject = "🗂️ New Campaign Assignment";
            String body = "Hi " + staffName + ",\n\n" +
                    "You've been assigned as a " + role + " to the campaign: \"" + campaignTitle + "\".\n\n" +
                    "Please log in to your dashboard to view details.\n\n" +
                    "Best,\nGreenGuardians Team";
            sendEmail(staffEmail, subject, body);

            // Insert notification
            ps = conn.prepareStatement("INSERT INTO notifications (staff_id, subject, message) VALUES (?, ?, ?)");
            ps.setInt(1, staffId);
            ps.setString(2, "Campaign Assignment");
            ps.setString(3, staffName+"You have been assigned to the campaign: " + campaignTitle);
            ps.executeUpdate();

            request.setAttribute("success", "Staff assigned, email sent, and notification saved.");

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("error", "This staff is already assigned to the selected campaign.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        request.getRequestDispatcher("loadAssignmentForm").forward(request, response);
    }

    private void sendEmail(String to, String subject, String body) throws MessagingException {
        final String from = "your email"; // your email
        final String pass = "your key";           // app password

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
