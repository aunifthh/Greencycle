package Greencycle.controller;

import Greencycle.dao.AddressDao;
import Greencycle.dao.CategoryDao;
import Greencycle.dao.PickupDao;
import Greencycle.model.PickupBean;
import Greencycle.model.PickupItemBean;
import Greencycle.model.AddressBean;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/pickups")
public class PickupController extends HttpServlet {

    private PickupDao pickupDao = new PickupDao();
    private CategoryDao categoryDao = new CategoryDao();
    private AddressDao addressDao = new AddressDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String customerID = (String) session.getAttribute("customerId");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Load categories & addresses for pickup form
            request.setAttribute("categories", categoryDao.getAll()); // must return categoryID + categoryName + rate
            request.setAttribute("addresses", addressDao.getAddressesByCustomerID(customerID));
            request.getRequestDispatcher("/customer/pickupForm.jsp").forward(request, response);

        } else {
            // Show pickup list
            List<PickupBean> pickups = pickupDao.getAllPickups(customerID);

            // Populate items and address
            for (PickupBean pickup : pickups) {
                // Fetch pickup items with category names
                pickup.setItems(pickupDao.getItemsByRequestID(pickup.getRequestID()));

                // Fetch address object
                if (pickup.getAddressID() != null) {
                    pickup.setAddress(addressDao.getAddressByID(pickup.getAddressID()));
                }

                // Ensure items list is not null
                if (pickup.getItems() == null) {
                    pickup.setItems(new ArrayList<>());
                }
            }

            request.setAttribute("pickups", pickups);
            // ✅ Forward to JSP
            request.getRequestDispatcher("/customer/pickups.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String customerID = (String) session.getAttribute("customerId");

        // Build PickupBean
        PickupBean pickup = new PickupBean();
        pickup.setCustomerID(customerID);
        pickup.setAddressID(request.getParameter("pickupAddress")); // from form
        pickup.setPickupDate(request.getParameter("pickupDate"));
        pickup.setPickupTime(request.getParameter("pickupTime"));
        pickup.setRemarks(request.getParameter("remarks"));
        pickup.setTotalPrice(Double.parseDouble(request.getParameter("totalPrice")));

        // Pickup items
        String[] categoryIDs = request.getParameterValues("category[]"); // use categoryID
        String[] quantities = request.getParameterValues("quantity[]");
        String[] subtotals = request.getParameterValues("subtotal[]");

        List<PickupItemBean> items = new ArrayList<>();
        if (categoryIDs != null) {
            for (int i = 0; i < categoryIDs.length; i++) {
                double qty = Double.parseDouble(quantities[i]);
                if (qty < 3) qty = 3; // minimum 3 kg

                PickupItemBean item = new PickupItemBean();
                item.setCategoryID(categoryIDs[i]); // matches your bean
                item.setQuantity(qty);
                item.setSubtotal(Double.parseDouble(subtotals[i]));
                items.add(item);
            }
        }
        pickup.setItems(items);

        // Save pickup to database
        pickupDao.addPickup(pickup);

        // Redirect to list
        response.sendRedirect(request.getContextPath() + "/pickups");
    }
}
