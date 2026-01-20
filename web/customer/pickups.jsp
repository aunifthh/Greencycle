<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="Greencycle.model.RequestBean" %>
<%@ page import="Greencycle.dao.RequestDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Load requests from controller
    List<RequestBean> requests = (List<RequestBean>) request.getAttribute("requests");
    if (requests == null) {
        response.sendRedirect(request.getContextPath() + "/customer/pickups");
        return;
    }

    DecimalFormat df = new DecimalFormat("#,##0.00");
    RequestDao rDao = new RequestDao();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pickup Request | Greencycle</title>
    <link rel="icon" href="../images/truck.png">
    <link rel="stylesheet" href="../app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../app/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="../app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .badge-status { min-width: 90px; text-align: center; }
        button:disabled { opacity:0.6; cursor:not-allowed; }
        .gap-2 { gap: 0.5rem; }
    </style>
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

    <jsp:include page="../navbar/customernavbar.jsp" />
    <jsp:include page="../sidebar/customersidebar.jsp" />

    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <h3 class="mb-2">Pickup Request</h3>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center w-100">
                            <h3 class="card-title mb-0">Manage Recyclable Types</h3>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/customer/pickups?action=add" class="btn btn-success">
                                    <i class="fas fa-plus"></i> Add Request
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="card-body">
                        <table id="pickupTable" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Item</th>
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
                                if (requests != null && !requests.isEmpty()) {
                                    for (int i = 0; i < requests.size(); i++) {
                                        RequestBean r = requests.get(i);
                                        double totalQty = r.getEstimatedWeight();

                                        // Build item list
                                        StringBuilder itemList = new StringBuilder();
                                        if (r.getPlasticWeight() > 0) itemList.append("Plastic (").append(df.format(r.getPlasticWeight())).append("kg)");
                                        if (r.getPaperWeight() > 0) {
                                            if (itemList.length() > 0) itemList.append("<br>");
                                            itemList.append("Paper (").append(df.format(r.getPaperWeight())).append("kg)");
                                        }
                                        if (r.getMetalWeight() > 0) {
                                            if (itemList.length() > 0) itemList.append("<br>");
                                            itemList.append("Metal (").append(df.format(r.getMetalWeight())).append("kg)");
                                        }
                                        if (itemList.length() == 0) itemList.append("-");

                                        double totalAmount = rDao.getQuotationAmount(r.getRequestID());

                                        String status = r.getStatus();
                                        String badgeClass;
                                        if ("Quoted".equals(status) || "Verified".equals(status)) badgeClass = "badge-info";
                                        else if ("Pending Payment".equals(status) || "Pending".equals(status) || "Pending Pickup".equals(status)) badgeClass = "badge-warning";
                                        else if ("Cancelled".equals(status) || "Quotation Rejected".equals(status)) badgeClass = "badge-secondary";
                                        else if ("Completed".equals(status)) badgeClass = "badge-success";
                                        else badgeClass = "badge-danger";

                                        String displayLabel = "Verified".equals(status) ? "Quoted" : ("Cancelled".equals(status) ? "Quotation Rejected" : status);

                                        java.time.LocalDate today = java.time.LocalDate.now();
                                        java.time.LocalDate pickupDate = r.getPickupDate() != null ? r.getPickupDate().toLocalDate() : null;
                                        boolean canCancel = "Pending Pickup".equals(status) && pickupDate != null && pickupDate.isAfter(today.plusDays(1));
                            %>
                                <tr data-index="<%= i %>">
                                    <td data-order="<%= r.getRequestID() %>">REQ<%= r.getRequestID() %></td>
                                    <td><%= itemList.toString() %></td>
                                    <td><%= r.getFullAddress() != null ? r.getFullAddress() : "-" %></td>
                                    <td><%= df.format(totalQty) %></td>
                                    <td><%= r.getPickupDate() != null ? r.getPickupDate() : "-" %></td>
                                    <td><%= r.getPickupTime() != null ? r.getPickupTime() : "-" %></td>
                                    <td><span class="badge <%= badgeClass %> badge-status status"><%= displayLabel %></span></td>
                                    <td><%= df.format(totalAmount) %></td>
                                    <td>
                                        <% if (!"Cancelled".equals(status) && !"Completed".equals(status)) { %>
                                        <div style="margin-bottom:5px;">
                                            <form method="post" action="${pageContext.request.contextPath}/RequestServlet" class="cancel-form">
                                                <input type="hidden" name="action" value="cancel_pickup">
                                                <input type="hidden" name="requestID" value="<%= r.getRequestID() %>">
                                                <button type="button"
                                                        class="btn btn-sm btn-block cancelBtn <%= canCancel ? "btn-danger" : "btn-secondary" %>"
                                                        <%= canCancel ? "" : "disabled" %>>
                                                    <i class="fas fa-times"></i> Cancel
                                                </button>
                                            </form>
                                        </div>
                                        <% } %>

                                        <% if (("Quoted".equals(status) || "Verified".equals(status)) && totalAmount > 0) { %>
                                        <div>
                                            <button type="button"
                                            type="button" class="btn btn-secondary btn-sm view-btn"
                                            data-mode="quote"
                                            data-requestid="<%= r.getRequestID() %>"
                                            data-status="<%= displayLabel %>"
                                            data-address="<%= r.getFullAddress() != null ? r.getFullAddress() : "-" %>"
                                            data-date="<%= r.getPickupDate() != null ? r.getPickupDate() : "-" %>"
                                            data-time="<%= r.getPickupTime() != null ? r.getPickupTime() : "-" %>"
                                            data-plastic="<%= r.getPlasticWeight() %>"
                                            data-paper="<%= r.getPaperWeight() %>"
                                            data-metal="<%= r.getMetalWeight() %>"
                                            data-total="<%= totalAmount %>">
                                            <i class="fas fa-eye"></i> View Quotation
                                            </button>
                                        </div>
                                        <% } %>

                                        <% if ("Completed".equals(status) || "Cancelled".equals(status) || "Quotation Rejected".equals(status)) { %>
                                        <div style="margin-top:5px;">
                                            <button type="button"
                                                class="btn btn-secondary btn-sm btn-block open-quote-modal"
                                                data-mode="view"
                                                data-requestid="<%= r.getRequestID() %>"
                                                data-status="<%= displayLabel %>"
                                                data-address="<%= r.getFullAddress() != null ? r.getFullAddress() : "-" %>"
                                                data-date="<%= r.getPickupDate() != null ? r.getPickupDate() : "-" %>"
                                                data-time="<%= r.getPickupTime() != null ? r.getPickupTime() : "-" %>"
                                                data-plastic="<%= r.getPlasticWeight() %>"
                                                data-paper="<%= r.getPaperWeight() %>"
                                                data-metal="<%= r.getMetalWeight() %>"
                                                data-total="<%= totalAmount %>">
                                                <i class="fas fa-eye"></i> View
                                            </button>

                                        </div>
                                        <% } %>
                                    </td>
                                </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="9" class="text-center">
                                        <div class="alert alert-info mt-3">
                                            <i class="fas fa-info-circle"></i> No pickup requests found. 
                                            <a href="${pageContext.request.contextPath}/customer/pickups?action=add" class="alert-link">Create your first request</a>
                                        </div>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <jsp:include page="/footer/footer.jsp" />

    <!-- Modal -->
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
                <!-- Hidden form for Accept / Reject -->
                <form id="acceptRejectForm" method="post" action="${pageContext.request.contextPath}/RequestServlet" style="display:inline-block;">
                    <input type="hidden" name="requestID" id="modalRequestID" value="">
                    <input type="hidden" name="action" id="modalAction" value="">
                    <button type="button" class="btn btn-success" id="acceptQuoteBtn">Accept</button>
                    <button type="button" class="btn btn-danger" id="rejectQuoteBtn">Reject</button>
                </form>

                <!-- Close button outside the form -->
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>

            </div>
        </div>
    </div>

    <script src="../app/plugins/jquery/jquery.min.js"></script>
    <script src="../app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../app/plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>

<script>
$(document).ready(function() {
    // Initialize DataTable
    $('#pickupTable').DataTable({ order: [[0, 'desc']] });

    // ================= Cancel Button =================
    // Use delegated event to handle dynamically rendered buttons
    $(document).on('click', '.cancelBtn', function() {
        const $btn = $(this);
        if ($btn.is(':disabled')) {
            Swal.fire(
                'Cannot Cancel',
                'Pickup can be cancelled at least 2 days before pickup date!',
                'warning'
            );
            return;
        }

        const $form = $btn.closest('form');

        Swal.fire({
            title: 'Are you sure?',
            text: 'Do you want to cancel this pickup request?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Yes, cancel it!'
        }).then((result) => {
            if (result.isConfirmed) {
                $form.submit(); // Submit the form to servlet
            }
        });
    });

    // ================= View Quotation / Details Modal =================
$(document).on('click', '.view-quote-btn', function() {
    const $btn = $(this);
    const requestID = $btn.data('requestid');
    const status = $btn.data('status');
    const address = $btn.data('address');
    const date = $btn.data('date');
    const time = $btn.data('time');
    const plastic = parseFloat($btn.data('plastic')) || 0;
    const paper = parseFloat($btn.data('paper')) || 0;
    const metal = parseFloat($btn.data('metal')) || 0;
    const total = parseFloat($btn.data('total')) || 0;

    // Populate modal
    $('#q_id').text('REQ' + requestID);
    $('#q_status').text(status);
    $('#q_address').text(address);
    $('#q_date').text(date);
    $('#q_time').text(time);
    $('#q_plastic').text(plastic.toFixed(2));
    $('#q_paper').text(paper.toFixed(2));
    $('#q_metal').text(metal.toFixed(2));
    $('#q_est').text((plastic + paper + metal).toFixed(2));
    $('#quoteTotal').text(total.toFixed(2));

    $('#quoteItems').empty();
    if (plastic > 0) $('#quoteItems').append('<li>Plastic: ' + plastic.toFixed(2) + ' kg</li>');
    if (paper > 0) $('#quoteItems').append('<li>Paper: ' + paper.toFixed(2) + ' kg</li>');
    if (metal > 0) $('#quoteItems').append('<li>Metal: ' + metal.toFixed(2) + ' kg</li>');

    // Set requestID in hidden form
    $('#modalRequestID').val(requestID);

    // Show Accept / Reject buttons only for Quotation statuses
    if (status === 'Quoted' || status === 'Verified') {
        $('#acceptQuoteBtn').show();
        $('#rejectQuoteBtn').show();
    } else {
        $('#acceptQuoteBtn').hide();
        $('#rejectQuoteBtn').hide();
    }

    // Accept click
    $('#acceptQuoteBtn').off('click').on('click', function() {
        $('#modalAction').val('accept_quotation'); // servlet action
        $('#acceptRejectForm').submit();
    });

    // Reject click
    $('#rejectQuoteBtn').off('click').on('click', function() {
        $('#modalAction').val('reject_quotation'); // servlet action
        $('#acceptRejectForm').submit();
    });

    $('#quoteModal').modal('show');
});

        $(document).on('click', '.view-btn', function(){
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

</div>
</body>
</html>
