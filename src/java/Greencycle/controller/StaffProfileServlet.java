package Greencycle.controller;

import Greencycle.dao.StaffDao;
import Greencycle.model.StaffBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class StaffProfileServlet extends HttpServlet {

    private StaffDao staffDao;

    @Override
    public void init() {
        staffDao = new StaffDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"staff".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        StaffBean sessionStaff = (StaffBean) session.getAttribute("staff");
        if (sessionStaff == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String staffID = sessionStaff.getStaffID();
        StaffBean staff = staffDao.getStaffById(staffID);

        if (staff != null) {
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("staff/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"staff".equals(role) && !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        StaffBean sessionStaff = (StaffBean) session.getAttribute("staff");
        if (sessionStaff == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        String staffID = sessionStaff.getStaffID();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate password change if requested
        String passwordToUpdate = null;
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("StaffProfileServlet?status=password_mismatch");
                return;
            }
            // In production, verify currentPassword against database
            passwordToUpdate = newPassword;
        }

        String result = staffDao.updateStaffProfile(staffID, name, email, phone, passwordToUpdate);

        if ("SUCCESS".equals(result)) {
            // Update session if email changed
            session.setAttribute("userName", name);
            response.sendRedirect("StaffProfileServlet?status=updated");
        } else {
            // URL Encode the error message (simple replacement for spaces/special chars)
            String encodedMsg = java.net.URLEncoder.encode(result, "UTF-8");
            response.sendRedirect("StaffProfileServlet?status=error&msg=" + encodedMsg);
        }
    }
}
