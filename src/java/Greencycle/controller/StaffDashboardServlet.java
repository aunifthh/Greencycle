package Greencycle.controller;

import Greencycle.dao.RequestDao;
import Greencycle.model.RequestBean;
import Greencycle.model.StaffBean;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class StaffDashboardServlet extends HttpServlet {

    private RequestDao requestDao;

    @Override
    public void init() {
        requestDao = new RequestDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        StaffBean staff = (StaffBean) session.getAttribute("staff");
        String staffID = staff.getStaffID();

        // Fetch Analytics Data
        int pendingPickupCount = requestDao.getPendingPickupCount();
        int myVerificationCount = requestDao.getStaffVerificationCount(staffID);
        double myTotalWeight = requestDao.getStaffTotalVerifiedWeight(staffID);
        List<RequestBean> todaysPickups = requestDao.getTodayPickups();

        // Set Attributes
        request.setAttribute("pendingPickupCount", pendingPickupCount);
        request.setAttribute("myVerificationCount", myVerificationCount);
        request.setAttribute("myTotalWeight", myTotalWeight);
        request.setAttribute("todaysPickups", todaysPickups);

        // Forward to the dashboard view
        request.getRequestDispatcher("staff/dashboard.jsp").forward(request, response);
    }
}
