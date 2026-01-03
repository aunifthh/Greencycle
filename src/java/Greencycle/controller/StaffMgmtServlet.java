package Greencycle.controller;

import Greencycle.dao.StaffDao;
import Greencycle.model.StaffBean;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/StaffMgmtServlet")
public class StaffMgmtServlet extends HttpServlet {
    
    private StaffDao staffDao = new StaffDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
    
        // If someone just types /StaffMgmtServlet without an action, default to "list"
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        try {
            if (action.equals("list")) {
                List<StaffBean> staffList = staffDao.getAllStaff();
                request.setAttribute("staffList", staffList);
                request.getRequestDispatcher("admin/staffmgmt.jsp").forward(request, response);
            } else if (action.equals("delete")) {
                deleteStaff(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                insertStaff(request, response);
            } else if ("update".equals(action)) {
                updateStaff(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listStaff(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<StaffBean> staffList = staffDao.getAllStaff();
        request.setAttribute("staffList", staffList);
        // Forward to the JSP file
        request.getRequestDispatcher("admin/staffmgmt.jsp").forward(request, response);
    }

    private void insertStaff(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        StaffBean newStaff = new StaffBean();
        newStaff.setStaffName(request.getParameter("name"));
        newStaff.setStaffEmail(request.getParameter("email"));
        newStaff.setStaffPhoneNo(request.getParameter("phone"));
        
        // Default role for new entries from this page
        newStaff.setRole("staff"); 

        staffDao.addStaff(newStaff);
        response.sendRedirect("StaffMgmtServlet?action=list&status=added");
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        StaffBean staff = new StaffBean();
        staff.setStaffID(request.getParameter("id"));
        staff.setStaffName(request.getParameter("name"));
        staff.setStaffEmail(request.getParameter("email"));
        staff.setStaffPhoneNo(request.getParameter("phone"));

        staffDao.updateStaff(staff);
        response.sendRedirect("StaffMgmtServlet?action=list&status=updated");
    }

    private void deleteStaff(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String id = request.getParameter("id");
        staffDao.deleteStaff(id);
        response.sendRedirect("StaffMgmtServlet?action=list&status=deleted");
    }
}