// File: src/Greencycle/controller/CustomerDashboardServlet.java

package Greencycle.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/customer/dashboard")
public class CustomerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // If not logged in, redirect to login
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Optional: Set current page for sidebar highlighting
        request.setAttribute("currentPage", "dashboard");

        // Forward to dashboard JSP
        request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
    }
}