import com.vimal.utils.DatabaseManager;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;


public class Feedback_add extends HttpServlet
{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String mail = request.getParameter("mail");      
        String experience = request.getParameter("experience"); 
        String message = request.getParameter("message");

        Connection cn = null;
        PreparedStatement st = null;

        try {


            cn = DatabaseManager.getConnection();

            st = cn.prepareStatement(
                "INSERT INTO feedback (name, mail, experience, message) VALUES (?, ?, ?, ?)"
            );

            st.setString(1, name);
            st.setString(2, mail);
            st.setInt(3, Integer.parseInt(experience));
            st.setString(4, message);

            int no = st.executeUpdate();

            if (no > 0)
            {
                request.getSession().setAttribute("success","1");

            }
            else
            {
                request.getSession().setAttribute("success","0");

            }

            request.getRequestDispatcher("feedback.jsp").forward(request,response);

        }
        catch(Exception e)
        {
            request.setAttribute("error", e.toString());
            request.getRequestDispatcher("feedback.jsp").forward(request,response);
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
