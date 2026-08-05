import com.vimal.utils.DatabaseManager;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class Contact_add extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException
    {
        response.setContentType("text/html");
        response.getWriter().println("Contact_add servlet working");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String cno = request.getParameter("cno");
        String message = request.getParameter("message");

        Connection cn = null;
        PreparedStatement st = null;

        try {

            // 🔹 Load Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 🔹 Connection
            cn = DatabaseManager.getConnection();

            // 🔹 Insert Query
            st = cn.prepareStatement(
                "INSERT INTO contact_us (name, email, cno, message) VALUES (?, ?, ?, ?)"
            );

            st.setString(1, name);
            st.setString(2, email);
            st.setString(3, cno);
            st.setString(4, message);

            int no = st.executeUpdate();

            if (no > 0)
            {
                // ✅ Success message JSP ma mokalse
                request.setAttribute("success","1");
            }
            else
            {
                request.setAttribute("success","0");
            }

            // ✅ CONTACT PAGE PAR BACK
            request.getRequestDispatcher("contactus.jsp").forward(request,response);

        }
        catch(Exception e)
        {
            request.setAttribute("error", e.toString());
            request.getRequestDispatcher("contactus.jsp").forward(request,response);
        }
        finally
        {
            try{
                if(st!=null) st.close();
                if(cn!=null) cn.close();
            }catch(Exception ex){}
        }
    }
}
