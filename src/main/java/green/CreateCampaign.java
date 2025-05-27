package green;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CreateCampaign")
public class CreateCampaign extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String campaignType = request.getParameter("campaign_type");
        String location = request.getParameter("location");
        String startDate = request.getParameter("start_date");
        String endDate = request.getParameter("end_date");
        String status = request.getParameter("status");

        int peopleRequired = Integer.parseInt(request.getParameter("people_required"));
        double donationRequired = Double.parseDouble(request.getParameter("donation_required"));

        int treesToPlant = 0;
        if ("Planting".equals(campaignType) && request.getParameter("trees_to_plant") != null) {
            treesToPlant = Integer.parseInt(request.getParameter("trees_to_plant"));
        }

        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO campaigns (title, description, campaign_type, location, start_date, end_date, status, people_required, donation_required, trees_to_plant) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, campaignType);
            ps.setString(4, location);
            ps.setString(5, startDate);
            ps.setString(6, endDate);
            ps.setString(7, status);
            ps.setInt(8, peopleRequired);
            ps.setDouble(9, donationRequired);
            ps.setInt(10, treesToPlant);

            int rowsInserted = ps.executeUpdate();
            ps.close();
            con.close();

            if (rowsInserted > 0) {
                response.sendRedirect("Admin_Dashboard.jsp?message=Campaign Created Successfully");
            } else {
                response.sendRedirect("CreateCampaign.jsp?error=Error Creating Campaign");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CreateCampaign.jsp?error=Database Error");
        }
    }
}
