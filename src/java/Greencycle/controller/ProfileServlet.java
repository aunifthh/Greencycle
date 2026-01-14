package Greencycle.controller;

import Greencycle.model.CustomerBean;
import Greencycle.model.AddressBean;
import Greencycle.dao.CustomerDao;
import Greencycle.dao.AddressDao;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/customer/profile")
public class ProfileServlet extends HttpServlet {

    // Get default address ID from session (now Integer)
    private Integer getDefaultAddressID(HttpSession session) {
        Object attr = session.getAttribute("defaultAddressID");
        return (attr instanceof Integer) ? (Integer) attr : null;
    }

// Set default address ID in session (as Integer)
    private void setDefaultAddressID(HttpSession session, Integer addressID) {
        if (addressID != null) {
            session.setAttribute("defaultAddressID", addressID);
        } else {
            session.removeAttribute("defaultAddressID");
        }
    }

    // In ProfileServlet.java - doGet method
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        CustomerBean customer = null;
        String role = null;

        if (session != null) {
            Object userObj = session.getAttribute("user");
            Object roleObj = session.getAttribute("role");
            if (userObj instanceof CustomerBean) {
                customer = (CustomerBean) userObj;
            }
            if (roleObj instanceof String) {
                role = (String) roleObj;
            }
        }

        if (customer == null || !"customer".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
            return;
        }

        // ✅ LOAD FULL CUSTOMER DATA FROM DATABASE
        String customerID = customer.getCustomerID();
        CustomerDao customerDao = new CustomerDao();
        CustomerBean fullCustomer = customerDao.getCustomerById(customerID); // This must include bank/phone!

        if (fullCustomer == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
            return;
        }

        // Load addresses
        AddressDao addressDao = new AddressDao();
        List<AddressBean> addresses = addressDao.getAddressesByCustomerID(customerID);
        request.setAttribute("defaultAddressID", getDefaultAddressID(session));

        // ✅ SET ATTRIBUTES FOR JSP
        request.setAttribute("customer", fullCustomer); // Full customer with bank/phone
        request.setAttribute("addresses", addresses);
        request.setAttribute("currentPage", "profile");

        request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session == null
                || session.getAttribute("user") == null
                || !"customer".equals(session.getAttribute("role"))) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        CustomerBean customer = (CustomerBean) session.getAttribute("user");
        String customerID = customer.getCustomerID();
        CustomerDao customerDao = new CustomerDao();
        AddressDao addressDao = new AddressDao();

        try {
            if ("updateProfile".equals(action)) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String phoneNo = request.getParameter("phoneNo");
                String password = request.getParameter("password");

                boolean success = customerDao.updateCustomer(customerID, fullName, email, phoneNo, password);
                if (success) {
                    customer.setFullName(fullName);
                    customer.setEmail(email);
                    customer.setPhoneNo(phoneNo);
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

            } else if ("updateBank".equals(action)) {
                String bankName = request.getParameter("bankName");
                String bankAccountNo = request.getParameter("bankAccountNo");

                boolean success = customerDao.updateBankInfo(customerID, bankName, bankAccountNo);
                if (success) {
                    customer.setBankName(bankName);
                    customer.setBankAccountNo(bankAccountNo);
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }

            } else if ("saveAddress".equals(action)) {
                String addressIDStr = request.getParameter("addressID"); // May be null or empty
                String label = request.getParameter("label");
                String addressLine1 = request.getParameter("addressLine1");
                String addressLine2 = request.getParameter("addressLine2");
                String poscode = request.getParameter("poscode");
                String city = request.getParameter("city");
                String state = request.getParameter("state");
                String remarks = request.getParameter("remarks");
                String isDefaultParam = request.getParameter("isDefault");

                AddressBean addr = new AddressBean();
                addr.setCategoryOfAddress(label);
                addr.setAddressLine1(addressLine1);
                addr.setAddressLine2(addressLine2);
                addr.setPoscode(poscode);
                addr.setCity(city);
                addr.setState(state);
                addr.setRemarks(remarks);
                addr.setCustomerID(customerID);

                Integer finalAddressID = null;

                if (addressIDStr != null && !addressIDStr.trim().isEmpty()) {
                    // Update existing
                    try {
                        int addressID = Integer.parseInt(addressIDStr.trim());
                        addr.setAddressID(addressID);
                        boolean success = addressDao.updateAddress(addr);
                        if (!success) {
                            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                            return;
                        }
                        finalAddressID = addressID;
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        return;
                    }
                } else {
                    // Create new — addressID will be auto-generated
                    boolean success = addressDao.saveAddress(addr);
                    if (!success) {
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        return;
                    }
                    // Optional: if saveAddress sets the generated ID in the bean, use it
                    finalAddressID = addr.getAddressID(); // Assumes AddressBean.addressID is int and was set by DAO
                }

                // Handle default address
                boolean isDefault = "on".equals(isDefaultParam) || "true".equals(isDefaultParam);
                if (isDefault && finalAddressID != null) {
                    setDefaultAddressID(session, finalAddressID);
                } else {
                    // If this address was previously default, clear it
                    Integer currentDefault = getDefaultAddressID(session);
                    if (currentDefault != null && currentDefault.equals(finalAddressID)) {
                        session.removeAttribute("defaultAddressID");
                    }
                }

                response.setStatus(HttpServletResponse.SC_OK);

            } else if ("setDefault".equals(action)) {
                String addressIDStr = request.getParameter("addressID");
                if (addressIDStr != null && !addressIDStr.trim().isEmpty()) {
                    try {
                        int addressID = Integer.parseInt(addressIDStr.trim());
                        setDefaultAddressID(session, addressID);
                        response.setStatus(HttpServletResponse.SC_OK);
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }

            } else if ("deleteAddress".equals(action)) {
                String addressIDStr = request.getParameter("addressID");
                if (addressIDStr == null || addressIDStr.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                int addressID;
                try {
                    addressID = Integer.parseInt(addressIDStr.trim());
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    return;
                }

                Integer currentDefault = getDefaultAddressID(session);
                boolean isDeletingDefault = (currentDefault != null && currentDefault == addressID);

                boolean success = addressDao.deleteAddress(addressID);
                if (success) {
                    if (isDeletingDefault) {
                        session.removeAttribute("defaultAddressID");
                    }
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
