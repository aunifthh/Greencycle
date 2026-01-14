<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.dao.AddressDao" %>
        <%@page import="Greencycle.dao.RateDao" %>
            <%@page import="Greencycle.model.AddressBean" %>
                <%@page import="Greencycle.model.CustomerBean" %>
                    <%@page import="java.util.List" %>
                        <%@page import="java.util.Map" %>
                            <% CustomerBean customer=(CustomerBean) session.getAttribute("user"); if (customer==null) {
                                response.sendRedirect("../index.jsp"); return; } AddressDao addressDao=new AddressDao();
                                List<AddressBean> addresses =
                                addressDao.getAddressesByCustomerID(customer.getCustomerID());

                                // FAILSAFE: History Logic REMOVED as per requirements

                                RateDao rateDao = new RateDao();
                                Map<String, Double> rates = rateDao.getAllRates();
                                    %>
                                    <!DOCTYPE html>
                                    <html>

                                    <head>
                                        <meta charset="UTF-8">
                                        <title>New Pickup Request</title>
                                        <link rel="icon" href="${pageContext.request.contextPath}/images/truck.png">
                                        <link rel="stylesheet"
                                            href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                                        <link rel="stylesheet"
                                            href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                                    </head>

                                    <body class="hold-transition sidebar-mini">
                                        <div class="wrapper">
                                            <jsp:include page="/navbar/customernavbar.jsp" />
                                            <jsp:include page="/sidebar/customersidebar.jsp" />

                                            <div class="content-wrapper">
                                                <section class="content-header">
                                                    <h1>New Pickup Request</h1>
                                                </section>
                                                <section class="content">
                                                    <div class="container-fluid">
                                                        <div class="card">
                                                            <div class="card-header">
                                                                <h3>Request Recycling Pickup</h3>
                                                            </div>
                                                            <form method="POST"
                                                                action="${pageContext.request.contextPath}/RequestServlet?action=create_request">
                                                                <div class="card-body">
                                                                    <div class="form-group">
                                                                        <label>Pickup Address <span
                                                                                class="text-danger">*</span></label>
                                                                        <select name="addressID" class="form-control"
                                                                            required>
                                                                            <option value="">-- Select Address --
                                                                            </option>
                                                                            <% for (AddressBean addr : addresses) { %>
                                                                                <option
                                                                                    value="<%= addr.getAddressID() %>">
                                                                                    <%= addr.getAddressLine1() %>, <%=
                                                                                            addr.getCity() %>, <%=
                                                                                                addr.getState() %>
                                                                                </option>
                                                                                <% } %>
                                                                        </select>
                                                                    </div>

                                                                    <div class="row">
                                                                        <div class="col-md-4">
                                                                            <label>Plastic (kg)</label>
                                                                            <input type="number" step="0.01" min="0"
                                                                                name="plasticWeight"
                                                                                class="form-control" value="0">
                                                                            <small>Rate: RM <%= String.format("%.2f",
                                                                                    rates.get("Plastic")) %>/kg</small>
                                                                        </div>
                                                                        <div class="col-md-4">
                                                                            <label>Paper (kg)</label>
                                                                            <input type="number" step="0.01" min="0"
                                                                                name="paperWeight" class="form-control"
                                                                                value="0">
                                                                            <small>Rate: RM <%= String.format("%.2f",
                                                                                    rates.get("Paper")) %>/kg</small>
                                                                        </div>
                                                                        <div class="col-md-4">
                                                                            <label>Metal (kg)</label>
                                                                            <input type="number" step="0.01" min="0"
                                                                                name="metalWeight" class="form-control"
                                                                                value="0">
                                                                            <small>Rate: RM <%= String.format("%.2f",
                                                                                    rates.get("Metal")) %>/kg</small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="card-footer">
                                                                    <button type="submit" class="btn btn-primary">Submit
                                                                        Request</button>
                                                                    <a href="requesthistory.jsp"
                                                                        class="btn btn-default">Cancel</a>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </section>
                                            </div>
                                        </div>
                                        <script
                                            src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                                        <script
                                            src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                                        <script
                                            src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                                    </body>

                                    </html>