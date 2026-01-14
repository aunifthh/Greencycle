<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.dao.RequestDao" %>
        <%@page import="Greencycle.model.RequestBean" %>
            <%@page import="Greencycle.model.CustomerBean" %>
                <%@page import="java.util.List" %>
                    <% CustomerBean customer=(CustomerBean) session.getAttribute("user"); if (customer==null) {
                        response.sendRedirect("../index.jsp"); return; } RequestDao requestDao=new RequestDao();
                        List<RequestBean> requests = requestDao.getRequestsByCustomer(customer.getCustomerID());
                        request.setAttribute("currentPage", "pickuprequest");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <title>Request History | Greencycle</title>
                            <link rel="icon" type="image/png"
                                href="${pageContext.request.contextPath}/images/truck.png">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
                            <link rel="stylesheet"
                                href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                        </head>

                        <body class="hold-transition sidebar-mini">
                            <div class="wrapper">
                                <jsp:include page="/navbar/customernavbar.jsp" />
                                <jsp:include page="/sidebar/customersidebar.jsp" />

                                <div class="content-wrapper">
                                    <section class="content-header">
                                        <div class="container-fluid">
                                            <div class="row mb-2">
                                                <div class="col-sm-6">
                                                    <h1>Request History</h1>
                                                </div>
                                                <div class="col-sm-6 text-right">
                                                    <a href="pickuprequest.jsp" class="btn btn-primary"><i
                                                            class="fas fa-plus"></i> New Request</a>
                                                </div>
                                            </div>
                                        </div>
                                    </section>

                                    <section class="content">
                                        <div class="container-fluid">
                                            <div class="card">
                                                <div class="card-body">
                                                    <table id="requestTable" class="table table-bordered table-striped">
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Date</th>
                                                                <th>Address</th>
                                                                <th>Est. Weight (kg)</th>
                                                                <th>Status</th>
                                                                <th>Pickup Date</th>
                                                                <th>Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (RequestBean req : requests) { %>
                                                                <tr>
                                                                    <td>
                                                                        <%= req.getRequestID() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= req.getRequestedDate() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= req.getFullAddress() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= String.format("%.2f",
                                                                            req.getEstimatedWeight()) %>
                                                                    </td>
                                                                    <td><span class="badge badge-info">
                                                                            <%= req.getStatus() %>
                                                                        </span></td>
                                                                    <td>
                                                                        <% if (req.getPickupDate() !=null) { %>
                                                                            <%= req.getPickupDate() %>
                                                                                <%= req.getPickupTime() %>
                                                                                    <% } else { %>
                                                                                        -
                                                                                        <% } %>
                                                                    </td>
                                                                    <td>
                                                                        <% if ("Quoted".equals(req.getStatus())) { %>
                                                                            <a href="quotation.jsp?requestID=<%= req.getRequestID() %>"
                                                                                class="btn btn-sm btn-info">View
                                                                                Quote</a>
                                                                            <% } else if
                                                                                ("Verified".equals(req.getStatus())) {
                                                                                %>
                                                                                <a href="quotation.jsp?requestID=<%= req.getRequestID() %>"
                                                                                    class="btn btn-sm btn-success">Accept
                                                                                    Verified Amount</a>
                                                                                <% } else { %>
                                                                                    <a href="quotation.jsp?requestID=<%= req.getRequestID() %>"
                                                                                        class="btn btn-sm btn-secondary">View
                                                                                        Details</a>
                                                                                    <% } %>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </section>
                                </div>
                            </div>

                            <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                            <script
                                src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                            <script
                                src="${pageContext.request.contextPath}/app/plugins/datatables/jquery.dataTables.min.js"></script>
                            <script
                                src="${pageContext.request.contextPath}/app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
                            <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                            <script>
                                $(function () {
                                    $('#requestTable').DataTable({ "order": [[0, "desc"]] });
                                });
                            </script>
                        </body>

                        </html>