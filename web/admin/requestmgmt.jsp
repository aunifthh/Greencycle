<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.model.RequestBean" %>
        <%@page import="java.util.List" %>
            <% String role=(String) session.getAttribute("role"); if (role==null || (!role.equals("admin") &&
                !role.equals("staff"))) { response.sendRedirect("../index.jsp"); return; } List<RequestBean> requests =
                (List<RequestBean>) request.getAttribute("requestList"); %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <title>Request Management | Greencycle</title>
                        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                    </head>

                    <body class="hold-transition sidebar-mini">
                        <div class="wrapper">
                            <% if ("admin".equals(role)) { %>
                                <jsp:include page="/navbar/adminnavbar.jsp" />
                                <jsp:include page="/sidebar/adminsidebar.jsp" />
                                <% } else { %>
                                    <jsp:include page="/navbar/staffnavbar.jsp" />
                                    <jsp:include page="/sidebar/staffsidebar.jsp" />
                                    <% } %>

                                        <div class="content-wrapper">
                                            <section class="content-header">
                                                <div class="container-fluid">
                                                    <div class="row mb-2">
                                                        <div class="col-sm-6">
                                                            <h1>Request Management</h1>
                                                        </div>
                                                    </div>
                                                </div>
                                            </section>

                                            <section class="content">
                                                <div class="container-fluid">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <table id="mgmtTable"
                                                                class="table table-bordered table-striped">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th>Customer</th>
                                                                        <th>Address</th>
                                                                        <th>Status</th>
                                                                        <th>Pickup Date</th>
                                                                        <th>Weights (P/P/M)</th>
                                                                        <th>Actions</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <% if (requests !=null) { for (RequestBean req :
                                                                        requests) { boolean hasDate=req.getPickupDate()
                                                                        !=null; %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= req.getRequestID() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= req.getCustomerID() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= req.getFullAddress() %>
                                                                            </td>
                                                                            <td>
                                                                                <%
                                                                                    String status = req.getStatus();
                                                                                    String badgeClass;
                                                                                    if ("Pending Pickup".equals(status)) {
                                                                                        badgeClass = "badge-warning";
                                                                                    } else if ("Quoted".equals(status) || "Verified".equals(status)) {
                                                                                        badgeClass = "badge-info";
                                                                                    } else if ("Pending Payment".equals(status)) {
                                                                                        badgeClass = "badge-warning";
                                                                                    } else if ("Quotation Rejected".equals(status) || "Cancelled".equals(status)) {
                                                                                        badgeClass = "badge-secondary";
                                                                                    } else if ("Completed".equals(status)) {
                                                                                        badgeClass = "badge-success";
                                                                                    } else {
                                                                                        badgeClass = "badge-danger";
                                                                                    }
                                                                                    String textLabel = "Verified".equals(status) ? "Quoted" : status;
                                                                                %>
                                                                                <span class="badge <%= badgeClass %>"><%= textLabel %></span>
                                                                            </td>
                                                                            <td>
                                                                                <%= hasDate ? req.getPickupDate() + " "
                                                                                    + req.getPickupTime() : "Not Set" %>
                                                                            </td>
                                                                            <td>
                                                                                <%= req.getPlasticWeight() %> / <%=
                                                                                        req.getPaperWeight() %> / <%=
                                                                                            req.getMetalWeight() %>
                                                                            </td>
                                                                            <td>
                                                                                <%-- Staff Actions --%>
                                                                                    <% if ("staff".equals(role)) { %>
                                                                                        <% if ("Pending Pickup".equals(req.getStatus()))
                                                                                            { %>
                                                                                            <button
                                                                                                class="btn btn-warning btn-sm"
                                                                                                onclick="openReweigh(<%= req.getRequestID() %>)">
                                                                                                <i
                                                                                                    class="fas fa-balance-scale"></i>
                                                                                                Reweigh
                                                                                            </button>
                                                                                            <% } else if
                                                                                                ("Quoted".equals(req.getStatus()) && hasDate) { %>
                                                                                                <a href="${pageContext.request.contextPath}/RequestServlet?action=accept_verified&requestID=<%= req.getRequestID() %>"
                                                                                                    class="btn btn-success btn-sm">
                                                                                                    <i
                                                                                                        class="fas fa-check"></i>
                                                                                                    Accept
                                                                                                </a>
                                                                                                <a href="${pageContext.request.contextPath}/RequestServlet?action=reject_verified&requestID=<%= req.getRequestID() %>"
                                                                                                    class="btn btn-danger btn-sm">
                                                                                                    <i
                                                                                                        class="fas fa-times"></i>
                                                                                                    Reject
                                                                                                </a>
                                                                                                <% } %>
                                                                                                    <% } %>

                                                                                                        <%-- Admin
                                                                                                            Actions --%>
                                                                                                            <% if
                                                                                                                ("admin".equals(role))
                                                                                                                { %>
                                                                                                                <% if
                                                                                                                    ("Pending Payment".equals(req.getStatus()))
                                                                                                                    { %>
                                                                                                                    <a href="${pageContext.request.contextPath}/RequestServlet?action=release_payment&requestID=<%= req.getRequestID() %>"
                                                                                                                        class="btn btn-primary btn-sm">
                                                                                                                        <i
                                                                                                                            class="fas fa-money-bill-wave"></i>
                                                                                                                        Release
                                                                                                                        Payment
                                                                                                                    </a>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                                        <% }
                                                                                                                            %>
                                                                            </td>
                                                                        </tr>
                                                                        <% }} %>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </section>
                                        </div>
                        </div>

                        <!-- Reweigh Modal -->
                        <div class="modal fade" id="reweighModal">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form action="${pageContext.request.contextPath}/RequestServlet" method="post">
                                        <input type="hidden" name="action" value="verify_weight">
                                        <input type="hidden" name="requestID" id="reweighID">
                                        <div class="modal-header">
                                            <h4 class="modal-title">Verify Weights</h4>
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <label>Plastic Weight (kg)</label>
                                                <input type="number" step="0.01" name="plasticWeight"
                                                    class="form-control" required>
                                            </div>
                                            <div class="form-group">
                                                <label>Paper Weight (kg)</label>
                                                <input type="number" step="0.01" name="paperWeight" class="form-control"
                                                    required>
                                            </div>
                                            <div class="form-group">
                                                <label>Metal Weight (kg)</label>
                                                <input type="number" step="0.01" name="metalWeight" class="form-control"
                                                    required>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default"
                                                data-dismiss="modal">Close</button>
                                            <button type="submit" class="btn btn-primary">Save & Quote</button>
                                        </div>
                                    </form>
                                </div>
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
                                $('#mgmtTable').DataTable({ "order": [[0, "desc"]] });
                            });
                            function openReweigh(id) {
                                $('#reweighID').val(id);
                                $('#reweighModal').modal('show');
                            }
                        </script>
                    </body>
 </html>
