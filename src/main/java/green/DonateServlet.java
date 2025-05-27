package green;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
@WebServlet("/DonateServlet")
public class DonateServlet extends HttpServlet {
   	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("User_Login.jsp?error=Please login first");
            return;
        }

        String userEmail = (String) session.getAttribute("email");
        String campaignId = request.getParameter("campaignId");
        String amountStr = request.getParameter("amount");
        String method = request.getParameter("method");
        String upiId = request.getParameter("upi_id");
        String cardNo = request.getParameter("card_no");

        if (amountStr == null || method == null || amountStr.isEmpty()) {
            response.sendRedirect("errorPage.jsp?error=Please fill in all required fields.");
            return;
        }

        double amount = Double.parseDouble(amountStr);

        boolean isDonationSuccessful = processDonation(userEmail, campaignId, amount, method, upiId, cardNo);

        if (isDonationSuccessful) {
            response.sendRedirect("donationSuccess.jsp?message=Thank you for your donation!");
        } else {
            response.sendRedirect("errorPage.jsp?error=Something went wrong. Try again.");
        }
    }

    private boolean processDonation(String email, String campaignId, double amount, String method, String upiId, String cardNo) {
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement getUserStmt = conn.prepareStatement("SELECT user_id FROM users WHERE email = ?");
            getUserStmt.setString(1, email);
            ResultSet rs = getUserStmt.executeQuery();
            if (!rs.next()) return false;
            int userId = rs.getInt("user_id");

            String sql = "INSERT INTO donations (user_id, campaign_id, amount, method, upi_id, card_no) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, Integer.parseInt(campaignId));
            stmt.setDouble(3, amount);
            stmt.setString(4, method);
            stmt.setString(5, "UPI".equals(method) ? upiId : null);
            stmt.setString(6, "Card".equals(method) ? cardNo : null);

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
