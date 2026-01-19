package Greencycle.controller;

import Greencycle.dao.AddressDao;
import Greencycle.dao.RateDao;
import Greencycle.dao.RequestDao;
import Greencycle.model.AddressBean;
import Greencycle.model.RequestBean;
import Greencycle.model.CustomerBean;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/customer/pickups")
public class PickupController extends HttpServlet {

    private final RequestDao requestDao = new RequestDao();
    private final RateDao rateDao = new RateDao();
    private final AddressDao addressDao = new AddressDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        CustomerBean customer = (session != null) ? (CustomerBean) session.getAttribute("user") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String customerID = customer.getCustomerID();
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Load recyclable item rates & addresses for pickup form
            Map<String, Double> rates = rateDao.getAllRates();
            List<AddressBean> addresses = addressDao.getAddressesByCustomerID(customerID);

            request.setAttribute("rates", rates);
            request.setAttribute("addresses", addresses);
            request.getRequestDispatcher("/customer/pickupForm.jsp").forward(request, response);

        } else {
            // Show pickup list for this customer
            List<RequestBean> requests = requestDao.getRequestsByCustomer(customerID);
            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/customer/pickups.jsp").forward(request, response);
        }
        
        if ("check_times".equals(action)) {
        String pickupDateStr = request.getParameter("pickupDate");
        if (pickupDateStr != null && !pickupDateStr.isEmpty()) {
            Date pickupDate = Date.valueOf(pickupDateStr);
            Map<String, Integer> counts = requestDao.getPickupCountsByDate(pickupDate);

            // Return JSON
            response.setContentType("application/json");
            response.setContentType("application/json");
            StringBuilder sb = new StringBuilder("{");
            for (String key : counts.keySet()) {
                sb.append("\"").append(key).append("\":").append(counts.get(key)).append(",");
            }
            if (sb.length() > 1) sb.setLength(sb.length() - 1); // remove trailing comma
            sb.append("}");
            response.getWriter().write(sb.toString());
            return;
        }
    }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        CustomerBean customer = (session != null) ? (CustomerBean) session.getAttribute("user") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String customerID = customer.getCustomerID();

        // Basic pickup request fields
        String addressID = request.getParameter("addressID");
        String pickupDateStr = request.getParameter("pickupDate");
        String pickupTime = request.getParameter("pickupTime");

        double plasticWeight = parseDoubleOrZero(request.getParameter("plasticWeight"));
        double paperWeight = parseDoubleOrZero(request.getParameter("paperWeight"));
        double metalWeight = parseDoubleOrZero(request.getParameter("metalWeight"));

        // Create pickup request in DB
        int requestID = requestDao.createRequest(customerID, addressID, plasticWeight, paperWeight, metalWeight);

        if (requestID > 0) {
            // Create initial quotation using current rates
            Map<String, Double> rates = rateDao.getAllRates();
            double plasticRate = rates.getOrDefault("Plastic", 0.0);
            double paperRate = rates.getOrDefault("Paper", 0.0);
            double metalRate = rates.getOrDefault("Metal", 0.0);

            requestDao.createInitialQuotation(requestID, plasticWeight, paperWeight, metalWeight,
                    plasticRate, paperRate, metalRate);

            // Optionally store preferred pickup schedule immediately (if user already chose date/time)
            if (pickupDateStr != null && !pickupDateStr.isEmpty() && pickupTime != null && !pickupTime.isEmpty()) {
                Date pickupDate = Date.valueOf(pickupDateStr);
                requestDao.updatePickupSchedule(requestID, pickupDate, pickupTime);
            }

            // Redirect back to pickups list for this customer
            response.sendRedirect(request.getContextPath() + "/customer/pickups");
        } else {
            // Failed to create request
            response.sendRedirect(request.getContextPath() + "/customer/pickupForm.jsp?error=request");
        }
    }

    private double parseDoubleOrZero(String val) {
        try {
            return (val == null || val.isEmpty()) ? 0.0 : Double.parseDouble(val);
        } catch (NumberFormatException ex) {
            return 0.0;
        }
    }
}
