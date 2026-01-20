package Greencycle.controller;

import Greencycle.dao.RequestDao;
import Greencycle.dao.RateDao;
import Greencycle.model.RequestBean;
import Greencycle.model.StaffBean;
import Greencycle.model.CustomerBean;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RequestServlet")
public class RequestServlet extends HttpServlet {

    private RequestDao requestDao = new RequestDao();
    private RateDao rateDao = new RateDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (action == null)
            action = "list";

        switch (action) {
            case "staff_view":
                handleStaffView(request, response, session);
                break;

            case "accept_verified":
                handleAcceptVerified(request, response);
                break;

            case "reject_verified":
                handleRejectVerified(request, response);
                break;

            case "release_payment":
                handleReleasePayment(request, response);
                break;

            case "list":
                // Admin/Staff View: All Requests
                if ("admin".equals(role) || "staff".equals(role)) {
                    List<RequestBean> allRequests = requestDao.getAllRequests();
                    request.setAttribute("requestList", allRequests);
                    request.getRequestDispatcher("admin/requestmgmt.jsp").forward(request, response);
                } else {
                    response.sendRedirect("index.jsp");
                }
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        switch (action) {
            case "create_request":
                handleCreateRequest(request, response, session);
                break;

            case "accept_quotation":
                handleAcceptQuotation(request, response);
                break;

            case "reject_quotation":
                handleRejectQuotation(request, response);
                break;

            case "verify_weight":
                handleVerifyWeight(request, response, session);
                break;

            case "accept_verified":
                handleAcceptVerified(request, response);
                break;

            case "reject_verified":
                handleRejectVerified(request, response);
                break;

            case "release_payment":
                handleReleasePayment(request, response);
                break;

            case "cancel_pickup":
                handleCancelPickup(request, response);
                break;

            default:
                response.sendRedirect("index.jsp");
                break;
        }
    }

    // Customer creates pickup request
    private void handleCreateRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        CustomerBean customer = (CustomerBean) session.getAttribute("user");
        if (customer == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String addressID = request.getParameter("addressID");
        double plasticWeight = Double.parseDouble(request.getParameter("plasticWeight"));
        double paperWeight = Double.parseDouble(request.getParameter("paperWeight"));
        double metalWeight = Double.parseDouble(request.getParameter("metalWeight"));

        // Parse Pickup Date and Time
        String dateStr = request.getParameter("pickupDate");
        String timeStr = request.getParameter("pickupTime");
        Date pickupDate = null;
        if (dateStr != null && !dateStr.isEmpty()) {
            pickupDate = Date.valueOf(dateStr);
        }

        // Create request
        int requestID = requestDao.createRequest(customer.getCustomerID(), addressID, plasticWeight, paperWeight,
                metalWeight, pickupDate, timeStr);

        if (requestID > 0) {
            // Get rates and create initial quotation
            Map<String, Double> rates = rateDao.getAllRates();
            double plasticRate = rates.get("Plastic");
            double paperRate = rates.get("Paper");
            double metalRate = rates.get("Metal");

            boolean quotationCreated = requestDao.createInitialQuotation(requestID, plasticWeight, paperWeight,
                    metalWeight,
                    plasticRate, paperRate, metalRate);

            if (quotationCreated) {
                // Redirect to History since status is Pending Pickup now, not directly showing
                // Quote for scheduling
                response.sendRedirect("customer/pickups?status=success");
            } else {
                response.sendRedirect("customer/pickuprequest.jsp?error=quotation");
            }
        } else {
            response.sendRedirect("customer/pickuprequest.jsp?error=request");
        }
    }

    // Customer accepts quotation and schedules pickup
    private void handleAcceptQuotation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        Date pickupDate = Date.valueOf(request.getParameter("pickupDate"));
        String pickupTime = request.getParameter("pickupTime");

        boolean success = requestDao.updatePickupSchedule(requestID, pickupDate, pickupTime);

        if (success) {
            response.sendRedirect("customer/pickups?status=scheduled");
        } else {
            response.sendRedirect("customer/quotation.jsp?requestID=" + requestID + "&error=schedule");
        }
    }

    // Customer rejects quotation
    private void handleRejectQuotation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        requestDao.cancelRequest(requestID);
        response.sendRedirect("customer/pickups?status=cancelled");
    }

    // Staff verifies weight on-site
    private void handleVerifyWeight(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        StaffBean staff = (StaffBean) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int requestID = Integer.parseInt(request.getParameter("requestID"));
        double plasticWeight = Double.parseDouble(request.getParameter("plasticWeight"));
        double paperWeight = Double.parseDouble(request.getParameter("paperWeight"));
        double metalWeight = Double.parseDouble(request.getParameter("metalWeight"));
        String customerAccepts = request.getParameter("customerAccepts"); // "yes" or "no"

        // Get rates
        // Get rates
        Map<String, Double> rates = rateDao.getAllRates();
        Double plasticRate = rates.getOrDefault("Plastic", 0.0);
        Double paperRate = rates.getOrDefault("Paper", 0.0);
        Double metalRate = rates.getOrDefault("Metal", 0.0);

        // DEBUG LOGGING
        System.out.println("Processing Verify Weight for Request ID: " + requestID);
        System.out.println(
                "Weights -> Plastic: " + plasticWeight + ", Paper: " + paperWeight + ", Metal: " + metalWeight);
        System.out.println("Rates -> Plastic: " + plasticRate + ", Paper: " + paperRate + ", Metal: " + metalRate);
        double totalCalc = (plasticWeight * plasticRate) + (paperWeight * paperRate) + (metalWeight * metalRate);
        System.out.println("Calculated Total: " + totalCalc);

        // Update with verified weight
        boolean success = requestDao.updateVerifiedWeight(requestID, plasticWeight, paperWeight, metalWeight,
                plasticRate, paperRate, metalRate, staff.getStaffID());

        if (success) {
            // Check if customer accepts on-site
            if ("yes".equals(customerAccepts)) {
                requestDao.acceptVerifiedQuotation(requestID);
                response.sendRedirect("RequestServlet?action=list&status=accepted");
            } else {
                // Customer will decide later or rejected
                response.sendRedirect("RequestServlet?action=list&status=verified");
            }
        } else {
            response.sendRedirect("RequestServlet?action=list&error=verify");
        }
    }

    // Customer accepts verified quotation
    private void handleAcceptVerified(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        requestDao.acceptVerifiedQuotation(requestID);
        response.sendRedirect("customer/pickups?status=accepted");
    }

    // Customer rejects verified quotation
    private void handleRejectVerified(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        requestDao.cancelRequest(requestID);
        response.sendRedirect("customer/pickups?status=rejected");
    }

    // Admin releases payment
    private void handleReleasePayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        boolean success = requestDao.releasePayment(requestID);

        if (success) {
            response.sendRedirect("RequestServlet?action=list&status=completed");
        } else {
            response.sendRedirect("RequestServlet?action=list&error=payment");
        }
    }

    // Customer cancels pickup
    private void handleCancelPickup(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        // Use the existing cancelRequest method from DAO
        boolean success = requestDao.cancelRequest(requestID);

        if (success) {
            response.sendRedirect("customer/pickups?status=cancelled");
        } else {
            response.sendRedirect("customer/pickups?error=cancel_failed");
        }
    }

    private void handleStaffView(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        StaffBean staff = (StaffBean) session.getAttribute("staff");
        if (staff == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Fetch requests with status 'Pending Pickup'
        // Assuming RequestDao has a method for this, or we reuse getRequestsByStatus
        List<RequestBean> pendingList = requestDao.getRequestsByStatus("Pending Pickup");
        request.setAttribute("pendingList", pendingList);
        request.getRequestDispatcher("staff/pickups.jsp").forward(request, response);
    }
}
