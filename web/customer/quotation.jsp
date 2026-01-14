<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.dao.RequestDao" %>
        <%@page import="Greencycle.model.RequestBean" %>
            <%@page import="Greencycle.model.CustomerBean" %>
                <% CustomerBean customer=(CustomerBean) session.getAttribute("user"); if (customer==null) {
                    response.sendRedirect("../index.jsp"); return; } int
                    requestID=Integer.parseInt(request.getParameter("requestID")); RequestDao requestDao=new
                    RequestDao(); RequestBean req=requestDao.getRequestById(requestID); double
                    quotationAmount=requestDao.getQuotationAmount(requestID); if (req==null ||
                    !req.getCustomerID().equals(customer.getCustomerID())) {
                    response.sendRedirect("requesthistory.jsp"); return; } %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <title>Quotation | Greencycle</title>
                        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                    </head>

                    <body class="hold-transition sidebar-mini layout-fixed">
                        <div class="wrapper">
                            <jsp:include page="/navbar/customernavbar.jsp" />
                            <jsp:include page="/sidebar/customersidebar.jsp" />

                            <div class="content-wrapper">
                                <section class="content-header">
                                    <h1>Quotation Details</h1>
                                </section>
                                <section class="content">
                                    <div class="container-fluid">

                                        <!-- Quotation Summary -->
                                        <div class="card">
                                            <div class="card-header bg-primary">
                                                <h3 class="card-title">Request #<%= req.getRequestID() %>
                                                </h3>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <p><strong>Pickup Address:</strong><br>
                                                            <%= req.getFullAddress() %>
                                                        </p>
                                                        <p><strong>Request Date:</strong>
                                                            <%= req.getRequestedDate() %>
                                                        </p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <p><strong>Status:</strong> <span class="badge badge-info">
                                                                <%= req.getStatus() %>
                                                            </span></p>
                                                    </div>
                                                </div>

                                                <hr>

                                                <h5>Material Breakdown</h5>
                                                <table class="table table-bordered">
                                                    <thead>
                                                        <tr>
                                                            <th>Material</th>
                                                            <th>Weight (kg)</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% if (req.getPlasticWeight()> 0) { %>
                                                            <tr>
                                                                <td>Plastic</td>
                                                                <td>
                                                                    <%= String.format("%.2f", req.getPlasticWeight()) %>
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                                <% if (req.getPaperWeight()> 0) { %>
                                                                    <tr>
                                                                        <td>Paper</td>
                                                                        <td>
                                                                            <%= String.format("%.2f",
                                                                                req.getPaperWeight()) %>
                                                                        </td>
                                                                    </tr>
                                                                    <% } %>
                                                                        <% if (req.getMetalWeight()> 0) { %>
                                                                            <tr>
                                                                                <td>Metal</td>
                                                                                <td>
                                                                                    <%= String.format("%.2f",
                                                                                        req.getMetalWeight()) %>
                                                                                </td>
                                                                            </tr>
                                                                            <% } %>
                                                                                <tr class="font-weight-bold">
                                                                                    <td>Total</td>
                                                                                    <td>
                                                                                        <%= String.format("%.2f",
                                                                                            req.getEstimatedWeight()) %>
                                                                                    </td>
                                                                                </tr>
                                                    </tbody>
                                                </table>

                                                <% if ("Verified".equals(req.getStatus())) { %>
                                                    <div class="alert alert-success">
                                                        <h4><i class="icon fas fa-check-circle"></i> Payment Amount</h4>
                                                        <h3 class="mb-0">RM <%= String.format("%.2f", quotationAmount)
                                                                %>
                                                        </h3>
                                                    </div>
                                                    <% } else { %>
                                                        <div class="alert alert-success">
                                                            <h4><i class="icon fas fa-dollar-sign"></i> Estimated
                                                                Payment</h4>
                                                            <h3 class="mb-0">RM <%= String.format("%.2f",
                                                                    quotationAmount) %>
                                                            </h3>
                                                        </div>

                                                        <div class="alert alert-warning">
                                                            <i class="icon fas fa-exclamation-triangle"></i>
                                                            <strong>Note:</strong> This is an estimated quotation based
                                                            on your provided weights.
                                                            Our staff will verify the actual weight during pickup. Final
                                                            payment may vary.
                                                        </div>
                                                        <% } %>
                                            </div>

                                            <% if ("Quoted".equals(req.getStatus())) { %>
                                                <div class="card-footer">
                                                    <h5>Accept this quotation?</h5>
                                                    <form method="POST"
                                                        action="${pageContext.request.contextPath}/RequestServlet?action=accept_quotation"
                                                        class="d-inline">
                                                        <input type="hidden" name="requestID"
                                                            value="<%= req.getRequestID() %>">

                                                        <div class="form-group">
                                                            <label>Select Pickup Date</label>
                                                            <input type="date" name="pickupDate" class="form-control"
                                                                required
                                                                min="<%= java.time.LocalDate.now().plusDays(1) %>">
                                                        </div>

                                                        <div class="form-group">
                                                            <label>Select Pickup Time</label>
                                                            <select name="pickupTime" class="form-control" required>
                                                                <option value="">-- Select Time --</option>
                                                                <option value="09:00-12:00">Morning (9:00 AM - 12:00 PM)
                                                                </option>
                                                                <option value="14:00-17:00">Afternoon (2:00 PM - 5:00
                                                                    PM)</option>
                                                            </select>
                                                        </div>

                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fas fa-check"></i> Accept & Schedule Pickup
                                                        </button>
                                                    </form>

                                                    <button type="button" class="btn btn-danger" data-toggle="modal"
                                                        data-target="#rejectModal">
                                                        <i class="fas fa-times"></i> Reject Quotation
                                                    </button>

                                                    <a href="requesthistory.jsp" class="btn btn-default">Back to
                                                        History</a>
                                                </div>
                                                <% } else if ("Verified".equals(req.getStatus())) { %>
                                                    <div class="card-footer">
                                                        <h5>Final Verified Quotation</h5>
                                                        <div class="alert alert-warning">
                                                            <i class="fas fa-exclamation-circle"></i>
                                                            <strong>IMPORTANT:</strong><br>
                                                            The items have been weighed and verified by our staff.
                                                            <br>
                                                            By clicking "Accept", you agree that this amount is final.
                                                            <br>
                                                            Payment will be processed and released to your account
                                                            within <strong>1 week</strong>.
                                                        </div>
                                                        <form method="POST"
                                                            action="${pageContext.request.contextPath}/RequestServlet?action=accept_verified"
                                                            class="d-inline">
                                                            <input type="hidden" name="requestID"
                                                                value="<%= req.getRequestID() %>">
                                                            <button type="submit" class="btn btn-success">
                                                                <i class="fas fa-check"></i> Accept Verified Amount
                                                            </button>
                                                        </form>

                                                        <a href="${pageContext.request.contextPath}/RequestServlet?action=reject_verified&requestID=<%= req.getRequestID() %>"
                                                            class="btn btn-danger">
                                                            <i class="fas fa-times"></i> Reject
                                                        </a>
                                                    </div>
                                                    <% } else { %>
                                                        <div class="card-footer">
                                                            <a href="requesthistory.jsp" class="btn btn-primary">Back to
                                                                History</a>
                                                        </div>
                                                        <% } %>
                                        </div>

                                    </div>
                                </section>
                            </div>
                            <jsp:include page="/footer/footer.jsp" />
                        </div>

                        <!-- Reject Modal -->
                        <div class="modal fade" id="rejectModal">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-danger">
                                        <h4 class="modal-title">Reject Quotation</h4>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    </div>
                                    <form method="POST"
                                        action="${pageContext.request.contextPath}/RequestServlet?action=reject_quotation">
                                        <div class="modal-body">
                                            <input type="hidden" name="requestID" value="<%= req.getRequestID() %>">
                                            <p>Are you sure you want to reject this quotation?</p>
                                            <p class="text-danger">This action cannot be undone.</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" class="btn btn-danger">Yes, Reject</button>
                                            <button type="button" class="btn btn-default"
                                                data-dismiss="modal">Cancel</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                        <script
                            src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                        <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                    </body>

                    </html>