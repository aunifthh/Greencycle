<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.text.DecimalFormat" %>
            <%@ page import="Greencycle.model.RequestBean" %>
                <%@ page import="Greencycle.dao.RequestDao" %>
                    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                        <% List<RequestBean> requests = (List<RequestBean>) request.getAttribute("requests");
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
                                    <link rel="stylesheet"
                                        href="../app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
                                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                                    <style>
                                        .badge-status {
                                            min-width: 90px;
                                            text-align: center;
                                        }

                                        button:disabled {
                                            opacity: 0.6;
                                            cursor: not-allowed;
                                        }

                                        .gap-2 {
                                            gap: 0.5rem;
                                        }
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
                                                            <div
                                                                class="d-flex justify-content-between align-items-center w-100">
                                                                <h3 class="card-title mb-0">Manage Recyclable Types</h3>
                                                                <div class="d-flex gap-2">
                                                                    <a href="${pageContext.request.contextPath}/customer/pickups?action=add"
                                                                        class="btn btn-success">
                                                                        <i class="fas fa-plus"></i> Add Request
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="card-body">
                                                            <table id="pickupTable"
                                                                class="table table-bordered table-hover">
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
                                                                    <% if(requests !=null && !requests.isEmpty()){
                                                                        for(int i=0; i<requests.size(); i++){
                                                                        RequestBean r=requests.get(i); 
                                                                        double totalQty=r.getEstimatedWeight(); 
                                                                        StringBuilder itemList=new StringBuilder(); if
                                                                        (r.getPlasticWeight()> 0) {
                                                                        itemList.append("Plastic(").append(df.format(r.getPlasticWeight())).append("kg)");
                                                                        }
                                                                        if (r.getPaperWeight() > 0) {
                                                                        if (itemList.length() > 0)
                                                                        itemList.append("<br>");
                                                                        itemList.append("Paper(").append(df.format(r.getPaperWeight())).append("kg)");
                                                                        }
                                                                        if (r.getMetalWeight() > 0) {
                                                                        if (itemList.length() > 0)
                                                                        itemList.append("<br>");
                                                                        itemList.append("Metal(").append(df.format(r.getMetalWeight())).append("kg)");
                                                                        }
                                                                        if (itemList.length() == 0)
                                                                        itemList.append("-");

                                                                        double totalAmount =
                                                                        rDao.getQuotationAmount(r.getRequestID());
                                                                        String status = r.getStatus();
                                                                        String badgeClass;

                                                                        if ("Quoted".equals(status)) {
                                                                        badgeClass = "badge-info";
                                                                        } else if ("Pending Payment".equals(status) ||
                                                                        "Pending".equals(status) || "Pending Pickup".equals(status)) {
                                                                        badgeClass = "badge-warning";
                                                                        } else if ("Cancelled".equals(status)) {
                                                                        badgeClass = "badge-secondary";
                                                                        } else if ("Completed".equals(status) ||
                                                                        "Payment Completed".equals(status)) {
                                                                        badgeClass = "badge-success";
                                                                        } else {
                                                                        badgeClass = "badge-danger";
                                                                        }
                                                                        %>
                                                                        <tr data-index="<%= i %>">
                                                                            <td>REQ<%= String.format("%03d", i + 1) %>
                                                                            </td>
                                                                            <td>
                                                                                <%= itemList.toString() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getFullAddress() !=null ?
                                                                                    r.getFullAddress() : "-" %>
                                                                            </td>
                                                                            <td>
                                                                                <%= df.format(totalQty) %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getPickupDate() !=null ?
                                                                                    r.getPickupDate() : "-" %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getPickupTime() !=null ?
                                                                                    r.getPickupTime() : "-" %>
                                                                            </td>
                                                                            <td><span
                                                                                    class="badge <%= badgeClass %> badge-status status">
                                                                                    <%= status %>
                                                                                </span></td>
                                                                            <td>
                                                                                <%= df.format(totalAmount) %>
                                                                            </td>
                                                                            <td>
                                                                                <% java.time.LocalDate
                                                                                    today=java.time.LocalDate.now();
                                                                                    java.time.LocalDate
                                                                                    pickupDate=r.getPickupDate() !=null
                                                                                    ? r.getPickupDate().toLocalDate() :
                                                                                    null; boolean canCancel=false; if
                                                                                    (pickupDate !=null) {
                                                                                    canCancel=pickupDate.isAfter(today.plusDays(1));
                                                                                    } %>

                                                                                    <% if ("Pending Pickup".equals(status)) { %>
                                                                                        <div style="margin-bottom:5px;">
                                                                                            <form method="post"
                                                                                                action="${pageContext.request.contextPath}/RequestServlet?action=cancel_pickup"
                                                                                                style="display:inline-block; width:100%; text-align:center;">
                                                                                                <input type="hidden"
                                                                                                    name="requestID"
                                                                                                    value="<%= r.getRequestID() %>">
                                                                                                <button type="button"
                                                                                                    class="btn btn-sm btn-block <%= canCancel ? " btn-danger cancelBtn": "btn-secondary"
                                                                                                    %>"
                                                                                                    <%= canCancel ? ""
                                                                                                        : "disabled" %>
                                                                                                        data-cancancel="
                                                                                                        <%= canCancel %>
                                                                                                            "data-date="
                                                                                                            <%= pickupDate
                                                                                                                %>">
                                                                                                                <i
                                                                                                                    class="fas fa-times"></i>
                                                                                                                Cancel
                                                                                                </button>
                                                                                            </form>
                                                                                        </div>
                                                                                        <% } %>

                                                                                            <% if
                                                                                                ("Quoted".equals(status)
                                                                                                && totalAmount> 0) { %>
                                                                                                <div>
                                                                                                    <a class="btn btn-info btn-sm btn-block"
                                                                                                        href="${pageContext.request.contextPath}/customer/quotation.jsp?requestID=<%= r.getRequestID() %>">
                                                                                                        <i
                                                                                                            class="fas fa-eye"></i>
                                                                                                        See Quotation
                                                                                                    </a>
                                                                                                </div>
                                                                                                <% } %>
                                                                            </td>
                                                                        </tr>
                                                                        <% }} 
                                                                        else { %>
                                                                            <tr>
                                                                                <td colspan="9" class="text-center">
                                                                                    <div class="alert alert-info mt-3">
                                                                                        <i
                                                                                            class="fas fa-info-circle"></i>
                                                                                        No pickup requests found.
                                                                                        <a href="${pageContext.request.contextPath}/customer/pickups?action=add"
                                                                                            class="alert-link">Create
                                                                                            your first request</a>
                                                                                    </div>
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
                                        <jsp:include page="/footer/footer.jsp" />
                                        <div class="modal fade" id="quoteModal">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-info text-white">
                                                        <h5 class="modal-title">Quotation Details</h5>
                                                        <button type="button" class="close text-white"
                                                            data-dismiss="modal"><span>&times;</span></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <ul id="quoteItems"></ul>
                                                        <strong>Total: RM <span id="quoteTotal"></span></strong>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button class="btn btn-success"
                                                            id="acceptQuoteBtn">Accept</button>
                                                        <button class="btn btn-danger"
                                                            id="rejectQuoteBtn">Reject</button>
                                                        <button class="btn btn-secondary"
                                                            data-dismiss="modal">Close</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <script src="../app/plugins/jquery/jquery.min.js"></script>
                                        <script src="../app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                                        <script src="../app/plugins/datatables/jquery.dataTables.min.js"></script>
                                        <script
                                            src="../app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
                                        <script>
                                            $(document).ready(function () {
                                                $('#pickupTable').DataTable();
                                                $('.cancelBtn').click(function () {
                                                    const $btn = $(this);
                                                    const canCancel = $btn.data('cancancel');
                                                    const pickupDate = $btn.data('date');

                                                    if (!canCancel) {
                                                        Swal.fire({
                                                            icon: 'warning',
                                                            title: 'Cannot Cancel',
                                                            text: 'Pickup can be cancelled at least 2 days before the selected pickup date!',
                                                        });
                                                        return;
                                                    }

                                                    const form = $btn.closest('form');
                                                    Swal.fire({
                                                        title: 'Are you sure?',
                                                        text: "Do you want to cancel this pickup request?",
                                                        icon: 'warning',
                                                        showCancelButton: true,
                                                        confirmButtonColor: '#d33',
                                                        cancelButtonColor: '#3085d6',
                                                        confirmButtonText: 'Yes, cancel it!'
                                                    }).then((result) => {
                                                        if (result.isConfirmed) {
                                                            form.submit();
                                                            $btn.prop('disabled', true).removeClass('btn-danger cancelBtn').addClass('btn-secondary').text('Cancelled');
                                                        }
                                                    });
                                                });
                                            });
                                        </script>
                                    </div>
                                </body>

                                </html>