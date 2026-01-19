package Greencycle.controller;

import Greencycle.dao.RecyclableItemDao;
import Greencycle.model.RecyclableItemBean;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RecyclableItemServlet")
public class RecyclableItemServlet extends HttpServlet {
    private RecyclableItemDao itemDao = new RecyclableItemDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            if ("delete".equals(action)) {
                itemDao.deleteItem(request.getParameter("id"));
                response.sendRedirect("RecyclableItemServlet?action=list&status=deleted");
            } else {
                List<RecyclableItemBean> itemList = itemDao.getAllItems();
                request.setAttribute("itemList", itemList);
                request.getRequestDispatcher("admin/recyclableitemmgmt.jsp").forward(request, response);
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        RecyclableItemBean item = new RecyclableItemBean();
        item.setRecyclableItemName(request.getParameter("itemName"));
        item.setRatePerKg(Double.parseDouble(request.getParameter("rate")));

        if ("add".equals(action)) {
            itemDao.addItem(item);
            response.sendRedirect("RecyclableItemServlet?action=list&status=added");
        } else if ("update".equals(action)) {
            item.setRecyclableItemID(request.getParameter("id"));
            itemDao.updateItem(item);
            response.sendRedirect("RecyclableItemServlet?action=list&status=updated");
        }
    }
}