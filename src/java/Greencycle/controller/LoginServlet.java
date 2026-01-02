package Greencycle.controller;

// Import your Model and DAO classes
import Greencycle.model.CustomerBean;
import Greencycle.model.StaffBean;
import Greencycle.dao.CustomerDao;
import Greencycle.dao.StaffDao;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve parameters from login.jsp
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String userType = request.getParameter("userType");
        
        HttpSession session = request.getSession();

        // 2. Initialize DAOs
        CustomerDao customerDao = new CustomerDao();
        StaffDao staffDao = new StaffDao();

        if ("customer".equals(userType)) {
            // DATABASE LOGIC: Authenticate Customer using DAO
            CustomerBean customer = customerDao.authenticateCustomer(email, pass);

            if (customer != null) {
                // Login successful
                session.setAttribute("user", customer);
                session.setAttribute("role", "customer");
                response.sendRedirect("customer/dashboard.jsp");
            } else {
                // Login failed
                response.sendRedirect("index.jsp?error=1");
            }
        } 
        else if ("staff".equals(userType)) {
            // DATABASE LOGIC: Authenticate Staff using DAO
            StaffBean staff = staffDao.authenticateStaff(email, pass);

            if (staff != null) {
                // Login successful
                session.setAttribute("staff", staff);
                String role = staff.getRole().toLowerCase(); // admin or staff
                session.setAttribute("role", role);

                // Redirect based on role to specific folders
                if ("admin".equals(role)) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else {
                    response.sendRedirect("staff/dashboard.jsp");
                }
            } else {
                // Login failed
                response.sendRedirect("index.jsp?error=1");
            }
        }
    }
}