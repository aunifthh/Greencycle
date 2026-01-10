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

    private String escapeJs(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
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

        String customerID = customer.getCustomerID();
        CustomerDao customerDao = new CustomerDao();
        CustomerBean fullCustomer = customerDao.getCustomerById(customerID);
        if (fullCustomer == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
            return;
        }

        AddressDao addressDao = new AddressDao();
        List<AddressBean> addresses = addressDao.getAddressesByCustomerID(customerID);

        // Build customer JSON
        StringBuilder custJson = new StringBuilder();
        custJson.append("{")
                .append("\"fullName\":\"").append(escapeJs(fullCustomer.getFullName())).append("\",")
                .append("\"email\":\"").append(escapeJs(fullCustomer.getEmail())).append("\",")
                .append("\"phoneNo\":\"").append(escapeJs(fullCustomer.getPhoneNo())).append("\",")
                .append("\"bankName\":\"").append(escapeJs(fullCustomer.getBankName())).append("\",")
                .append("\"bankAccountNo\":\"").append(escapeJs(fullCustomer.getBankAccountNo())).append("\"")
                .append("}");

        // Build addresses JSON (with poscode!)
        StringBuilder addrJson = new StringBuilder();
        addrJson.append("[");
        for (int i = 0; i < addresses.size(); i++) {
            AddressBean a = addresses.get(i);
            addrJson.append("{")
                    .append("\"addressID\":\"").append(a.getAddressID()).append("\",")
                    .append("\"categoryOfAddress\":\"").append(escapeJs(a.getCategoryOfAddress())).append("\",")
                    .append("\"addressLine1\":\"").append(escapeJs(a.getAddressLine1())).append("\",")
                    .append("\"addressLine2\":\"").append(escapeJs(a.getAddressLine2())).append("\",")
                    .append("\"poscode\":\"").append(escapeJs(a.getPoscode())).append("\",") // ✅ poscode
                    .append("\"city\":\"").append(escapeJs(a.getCity())).append("\",")
                    .append("\"state\":\"").append(escapeJs(a.getState())).append("\",")
                    .append("\"remarks\":\"").append(escapeJs(a.getRemarks())).append("\",") // ✅ Added remarks!
                    .append("\"isDefault\":false")
                    .append("}");
            if (i < addresses.size() - 1) {
                addrJson.append(",");
            }
        }
        addrJson.append("]");

        request.setAttribute("customerJson", custJson.toString());
        request.setAttribute("addressesJson", addrJson.toString());
        request.setAttribute("currentPage", "profile");

        request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
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
        AddressDao addressDao = new AddressDao(); // ✅ Must initialize!

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
                String addressID = request.getParameter("addressID");
                String label = request.getParameter("label");
                String addressLine1 = request.getParameter("addressLine1");
                String addressLine2 = request.getParameter("addressLine2");
                String poscode = request.getParameter("poscode"); // ✅ poscode
                String city = request.getParameter("city");
                String state = request.getParameter("state");
                String remarks = request.getParameter("remarks");

                AddressBean addr = new AddressBean();
                if (addressID != null && !addressID.isEmpty()) {
                    // Update existing
                    addr.setAddressID(addressID);
                    addr.setCategoryOfAddress(label);
                    addr.setAddressLine1(addressLine1);
                    addr.setAddressLine2(addressLine2);
                    addr.setPoscode(poscode); // ✅ poscode
                    addr.setCity(city);
                    addr.setState(state);
                    addr.setRemarks(remarks);
                    boolean success = addressDao.updateAddress(addr);
                    response.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                } else {
                    // Create new
                    String newId = addressDao.generateNextID();
                    addr.setAddressID(newId);
                    addr.setCategoryOfAddress(label);
                    addr.setAddressLine1(addressLine1);
                    addr.setAddressLine2(addressLine2);
                    addr.setPoscode(poscode); // ✅ poscode
                    addr.setCity(city);
                    addr.setState(state);
                    addr.setRemarks(remarks);
                    addr.setCustomerID(customerID);
                    boolean success = addressDao.saveAddress(addr);
                    response.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            } else if ("deleteAddress".equals(action)) {
                String addressID = request.getParameter("addressID");
                boolean success = addressDao.deleteAddress(addressID);
                response.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
