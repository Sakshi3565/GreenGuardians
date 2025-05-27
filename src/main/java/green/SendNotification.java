package green;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
@WebServlet("/sendNotification")
public class SendNotification extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String recipientType = request.getParameter("recipientType");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String staffIdParam = request.getParameter("staffId");

        try (Connection conn = DBConnection.getConnection()) {
            List<StaffInfo> recipients = new ArrayList<>();
            PreparedStatement ps;

            if ("all_trackers".equals(recipientType)) {
                ps = conn.prepareStatement("SELECT staff_id, role, email FROM staff WHERE role = 'Tracker'");
            } else if ("all_managers".equals(recipientType)) {
                ps = conn.prepareStatement("SELECT staff_id, role, email FROM staff WHERE role = 'Campaign Manager'");
            } else if ("specific".equals(recipientType) && staffIdParam != null && !staffIdParam.trim().isEmpty()) {
                ps = conn.prepareStatement("SELECT staff_id, role, email FROM staff WHERE staff_id = ?");
                ps.setInt(1, Integer.parseInt(staffIdParam));
            } else {
                request.setAttribute("error", "Invalid recipient selection.");
                request.getRequestDispatcher("sendNotification.jsp").forward(request, response);
                return;
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                recipients.add(new StaffInfo(rs.getInt("staff_id"), rs.getString("role"), rs.getString("email")));
            }

            ps = conn.prepareStatement("INSERT INTO notifications (staff_id, subject, message) VALUES (?, ?, ?)");
            for (StaffInfo staff : recipients) {
                ps.setInt(1, staff.id);
                ps.setString(2, subject);
                ps.setString(3, message);
                ps.addBatch();

              
                sendEmail(staff.email, subject, message);
            }
            ps.executeBatch();

            request.setAttribute("success", "Notifications sent and emails delivered successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("sendNotification.jsp").forward(request, response);
    }

    private void sendEmail(String to, String subject, String body) throws MessagingException {
        final String from = "your email";
        final String pass = "app pass";

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

    private static class StaffInfo {
        int id;
        String role;
        String email;
        StaffInfo(int id, String role, String email) {
            this.id = id;
            this.role = role;
            this.email = email;
        }
    }
}

