import com.vimal.utils.DatabaseManager;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class Offers_add extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
    {
        String title = request.getParameter("offer_title");
        String desc  = request.getParameter("offer_desc");
        String sdate = request.getParameter("start_date");
        String edate = request.getParameter("end_date");

        try
        {
            Class.forName("com.mysql.jdbc.Driver");

            Connection con = DatabaseManager.getConnection();

            String q = "insert into offers(offer_title,offer_desc,start_date,end_date) values(?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(q);

            ps.setString(1,title);
            ps.setString(2,desc);
            ps.setString(3,sdate);
            ps.setString(4,edate);

            ps.executeUpdate();

            response.sendRedirect("offers.jsp");
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}
