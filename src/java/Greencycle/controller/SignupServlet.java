/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Greencycle.controller;

import Greencycle.dao.CustomerDao;
import Greencycle.model.CustomerBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get data from form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNo = request.getParameter("phoneNo");
        String password = request.getParameter("password");

        // 2. Populate the Bean
        CustomerBean newCustomer = new CustomerBean();
        newCustomer.setFullName(fullName);
        newCustomer.setEmail(email);
        newCustomer.setPhoneNo(phoneNo);
        newCustomer.setPassword(password);

        // 3. Call DAO to save to Derby
        CustomerDao dao = new CustomerDao();
        boolean isSuccess = dao.registerCustomer(newCustomer);

        // 4. Redirect with status
        if (isSuccess) {
            // Redirect to login page with a success parameter
            response.sendRedirect("index.jsp?status=registered");
        } else {
            // Redirect back to signup with an error parameter
            response.sendRedirect("signup.jsp?error=1");
        }
    }
}
