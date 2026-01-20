<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Greencycle.model.CustomerBean" %>
<%@ page import="Greencycle.dao.RequestDao" %>
<%@ page import="Greencycle.model.RequestBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    CustomerBean customer = (CustomerBean) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (customer == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
        return;
    }
    request.setAttribute("currentPage", "dashboard");

    // DAO
    RequestDao rDao = new RequestDao();
    List<RequestBean> dashReqs = rDao.getRequestsByCustomer(customer.getCustomerID());

    // Stats calculation
    int totalRequests = dashReqs.size();
    double totalEarned = 0.0;
    int pendingRequests = 0;
    DecimalFormat df = new DecimalFormat("#,##0.00");
    for (RequestBean r : dashReqs) {
        double amount = rDao.getQuotationAmount(r.getRequestID());
        totalEarned += amount;
        if ("Pending Pickup".equals(r.getStatus()) || "Pending".equals(r.getStatus()) || "Pending Payment".equals(r.getStatus())) {
            pendingRequests++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard | Greencycle</title>

    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <jsp:include page="/navbar/customernavbar.jsp" />
    <jsp:include page="/sidebar/customersidebar.jsp" />

    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <h3>Welcome back, <%= customer.getFullName() %>!</h3>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <!-- Stats Boxes -->
                <div class="row">
                    <div class="col-lg-4 col-6">
                        <div class="small-box bg-info">
                            <div class="inner">
                                <h3><%= totalRequests %></h3>
                                <p>Total Requests</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-recycle"></i>
                            </div>
                            <a href="${pageContext.request.contextPath}/customer/pickups.jsp" class="small-box-footer">
                                Track Requests <i class="fas fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-4 col-6">
                        <div class="small-box bg-success">
                            <div class="inner">
                                <h3>RM <%= df.format(totalEarned) %></h3>
                                <p>Total Earned</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-wallet"></i>
                            </div>
                            <div class="small-box-footer">&nbsp;</div>
                        </div>
                    </div>

                    <div class="col-lg-4 col-6">
                        <div class="small-box bg-warning">
                            <div class="inner">
                                <h3><%= pendingRequests %></h3>
                                <p>Pending Requests</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-truck"></i>
                            </div>
                            <a href="${pageContext.request.contextPath}/customer/pickups.jsp" class="small-box-footer">
                                Track Requests <i class="fas fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Recent Requests Table -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title"><i class="fas fa-history mr-1"></i> Your Recent Requests</h3>
                            </div>
                            <div class="card-body">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Items</th>
                                            <th>Location</th>
                                            <th>Qty</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Status</th>
                                            <th>Total (RM)</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        if (dashReqs != null && !dashReqs.isEmpty()) {
                                            for (RequestBean r : dashReqs) {
                                                StringBuilder itemList = new StringBuilder();
                                                if (r.getPlasticWeight() > 0) itemList.append("Plastic ("+df.format(r.getPlasticWeight())+"kg)");
                                                if (r.getPaperWeight() > 0) { if (itemList.length()>0) itemList.append("<br>"); itemList.append("Paper ("+df.format(r.getPaperWeight())+"kg)"); }
                                                if (r.getMetalWeight() > 0) { if (itemList.length()>0) itemList.append("<br>"); itemList.append("Metal ("+df.format(r.getMetalWeight())+"kg)"); }
                                                if (itemList.length()==0) itemList.append("-");
                                                double totalAmount = rDao.getQuotationAmount(r.getRequestID());
                                                String status = r.getStatus();
                                                String badgeClass;
                                                if ("Quoted".equals(status) || "Verified".equals(status)) badgeClass = "badge-info";
                                                else if ("Pending Payment".equals(status) || "Pending".equals(status) || "Pending Pickup".equals(status)) badgeClass = "badge-warning";
                                                else if ("Cancelled".equals(status) || "Quotation Rejected".equals(status)) badgeClass = "badge-secondary";
                                                else if ("Completed".equals(status)) badgeClass = "badge-success";
                                                else badgeClass = "badge-danger";
                                        %>
                                        <tr>
                                            <td>REQ<%= r.getRequestID() %></td>
                                            <td><%= itemList.toString() %></td>
                                            <td><%= r.getFullAddress() != null ? r.getFullAddress() : "-" %></td>
                                            <td><%= df.format(r.getEstimatedWeight()) %></td>
                                            <td><%= r.getPickupDate() != null ? r.getPickupDate() : "-" %></td>
                                            <td><%= r.getPickupTime() != null ? r.getPickupTime() : "-" %></td>
                                            <td><span class="badge <%= badgeClass %>"><%= "Verified".equals(status) ? "Quoted" : status %></span></td>
                                            <td><%= df.format(totalAmount) %></td>
                                            <td>
    <c:if test="${r.status == 'Quoted'}">
        <button type="button"
            class="btn btn-info btn-sm open-quote-modal"
            data-mode="quote"
            data-requestid="${r.requestID}"
            data-status="Quoted"
            data-address="${r.fullAddress}"
            data-date="${r.pickupDate}"
            data-time="${r.pickupTime}"
            data-plastic="${r.plasticWeight}"
            data-paper="${r.paperWeight}"
            data-metal="${r.metalWeight}"
            data-total="${r.quotationTotal}">
            <i class="fas fa-eye"></i> See Quotation
        </button>
    </c:if>

    <c:if test="${r.status == 'Completed' || r.status == 'Quotation Rejected'}">
        <button type="button"
            class="btn btn-secondary btn-sm open-quote-modal"
            data-mode="view"
            data-requestid="${r.requestID}"
            data-status="${r.status}"
            data-address="${r.fullAddress}"
            data-date="${r.pickupDate}"
            data-time="${r.pickupTime}"
            data-plastic="${r.plasticWeight}"
            data-paper="${r.paperWeight}"
            data-metal="${r.metalWeight}"
            data-total="${r.quotationTotal}">
            <i class="fas fa-eye"></i> View
        </button>
    </c:if>
</td>

                                        </tr>
                                        <% } } else { %>
                                        <tr><td colspan="9" class="text-center">No recent requests</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </section>
    </div>

    <jsp:include page="/footer/footer.jsp" />

    <!-- Modal (Quotation / Details) -->
    <div class="modal fade" id="quoteModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">Quotation / Details</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <div><strong>Request ID:</strong> <span id="q_id"></span></div>
                    <div><strong>Status:</strong> <span id="q_status"></span></div>
                    <div><strong>Address:</strong> <span id="q_address"></span></div>
                    <div><strong>Pickup Date:</strong> <span id="q_date"></span></div>
                    <div><strong>Pickup Time:</strong> <span id="q_time"></span></div>
                    <hr>
                    <ul id="quoteItems"></ul>
                    <div><strong>Plastic (kg):</strong> <span id="q_plastic"></span></div>
                    <div><strong>Paper (kg):</strong> <span id="q_paper"></span></div>
                    <div><strong>Metal (kg):</strong> <span id="q_metal"></span></div>
                    <div><strong>Total Weight (kg):</strong> <span id="q_est"></span></div>
                    <hr>
                    <strong>Total (RM): <span id="quoteTotal"></span></strong>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
    <script>
    $(function(){
        // View Quotation
        $(document).on('click', '.view-quote-btn, .view-details-btn', function(){
            const $btn = $(this);
            $('#q_id').text('REQ' + $btn.data('requestid'));
            $('#q_status').text($btn.data('status'));
            $('#q_address').text($btn.data('address'));
            $('#q_date').text($btn.data('date'));
            $('#q_time').text($btn.data('time'));
            let p = parseFloat($btn.data('plastic')) || 0;
            let pa = parseFloat($btn.data('paper')) || 0;
            let m = parseFloat($btn.data('metal')) || 0;
            $('#q_plastic').text(p.toFixed(2));
            $('#q_paper').text(pa.toFixed(2));
            $('#q_metal').text(m.toFixed(2));
            $('#q_est').text((p+pa+m).toFixed(2));
            $('#quoteTotal').text(parseFloat($btn.data('total')).toFixed(2));
            $('#quoteModal').modal('show');
        });
    });
    </script>

</body>
</html>
