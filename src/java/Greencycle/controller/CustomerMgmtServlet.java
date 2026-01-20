package Greencycle.controller;

import Greencycle.dao.CustomerDao;
import Greencycle.model.CustomerBean;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class CustomerMgmtServlet extends HttpServlet {

    private CustomerDao customerDao;

    @Override
    public void init() {
        customerDao = new CustomerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
            default:
                listCustomers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updateCustomer(request, response);
        } else {
            listCustomers(request, response);
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CustomerBean> list = customerDao.getAllCustomers();
        request.setAttribute("customerList", list);
        request.getRequestDispatcher("admin/customermgmt.jsp").forward(request, response);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String bankName = request.getParameter("bankName");
        String item = request.getParameter("bankAcc"); // input name in modal is bankAcc

        CustomerBean c = new CustomerBean();
        c.setCustomerID(id);
        c.setFullName(name);
        c.setEmail(email);
        c.setPhoneNo(phone);
        c.setBankName(bankName);
        c.setBankAccountNo(item);

        boolean success = customerDao.updateCustomer(c);
        if (success) {
            response.sendRedirect("CustomerMgmtServlet?action=list&status=updated");
        } else {
            response.sendRedirect("CustomerMgmtServlet?action=list&status=error");
        }
    }
}
