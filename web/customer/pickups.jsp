<%@ page import="Greencycle.model.PickupBean" %>
<%@ page import="Greencycle.model.PickupItemBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                                <div class="d-flex gap-2" data-toggle="modal" data-target="#addModal">
                                    <a href="${pageContext.request.contextPath}/customer/pickupForm.jsp" class="btn btn-success">
                                        <i class="fas fa-plus"></i> Add Request
                                    </a>



                                </div>
                            </div>
                        </div>

                    <div class="card-body">
                        <%
                            List<PickupBean> pickups = (List<PickupBean>) request.getAttribute("pickups");
                            DecimalFormat df = new DecimalFormat("#,##0.00");
                        %>
                        <table id="pickupTable" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Item</th>
                                    <th>Location</th>
                                    <th>Qty (KG)</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Status</th>
                                    <th>Total (RM)</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                if (pickups != null) {
                                    for (int i = 0; i < pickups.size(); i++) {
                                        PickupBean pickup = pickups.get(i);
                                        double totalQty = pickup.getTotalQuantity();
                                        List<PickupItemBean> items = pickup.getItems();
                                %>
                                <tr data-index="<%= i %>">
                                    <td>REQ<%= String.format("%03d", i+1) %></td>
                                    <td>
                                        <%
                                        for (PickupItemBean item : items) {
                                            out.print(item.getCategoryID() + " (" + item.getQuantity() + "kg)<br>");
                                        }
                                        %>
                                    </td>
                                    <td>
                                        <%
                                        if (pickup.getAddress() != null) {
                                            out.print(pickup.getAddress().getCategoryOfAddress() + " — " +
                                                      pickup.getAddress().getAddressLine1() + ", " +
                                                      pickup.getAddress().getCity() + ", " +
                                                      pickup.getAddress().getState() + ", " +
                                                      pickup.getAddress().getPoscode());
                                        } else {
                                            out.print("N/A");
                                        }
                                        %>
                                    </td>
                                    <td><%= df.format(totalQty) %></td>
                                    <td><%= pickup.getPickupDate() %></td>
                                    <td><%= pickup.getPickupTime() != null ? pickup.getPickupTime() : "-" %></td>
                                    <td>
                                        <%
                                        String status = pickup.getStatus();
                                        String badgeClass = "badge-info";
                                        if ("Quoted".equals(status)) badgeClass = "badge-info";
                                        else if ("Pending Payment".equals(status) || "Pending".equals(status)) badgeClass = "badge-warning";
                                        else if ("Cancelled".equals(status)) badgeClass = "badge-secondary";
                                        else badgeClass = "badge-danger";
                                        %>
                                        <span class="badge <%= badgeClass %> badge-status status"><%= status %></span>
                                    </td>
                                    <td><%= df.format(pickup.getTotalPrice()) %></td>
                                    <td>
                                        <%
                                        if ("Quoted".equals(status)) {
                                        %>
                                            <button class="btn btn-info btn-sm viewQuote"><i class="fas fa-eye"></i> See Quotation</button>
                                        <%
                                        } else {
                                        %>
                                            <button class="btn btn-danger btn-sm cancel" <%= "Cancelled".equals(status) ? "disabled" : "" %>>
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        <%
                                        }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    }
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

    <!-- Quote Modal -->
    <div class="modal fade" id="quoteModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">Quotation Details</h5>
                </div>
                <div class="modal-body">
                    <ul id="quoteList"></ul>
                    <strong>Total: RM <span id="quoteTotal"></span></strong>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-success" id="accept">Accept</button>
                    <button class="btn btn-danger" id="reject">Reject</button>
                    <button class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

<script src="../app/plugins/jquery/jquery.min.js"></script>
<script src="../app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="../app/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="../app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>

<script>
$('#pickupTable').DataTable();

let pickups = [];
<%
if (pickups != null) {
    for (PickupBean pickup : pickups) {
%>
pickups.push({
    status: "<%= pickup.getStatus() %>",
    totalPrice: <%= pickup.getTotalPrice() %>,
    items: [
        <% for (PickupItemBean item : pickup.getItems()) { %>
        { category: "<%= item.getCategoryID() %>", quantity: <%= item.getQuantity() %>, subtotal: <%= item.getSubtotal() %> },
        <% } %>
    ]
});
<%
    }
}
%>

let currentIndex = null;

// VIEW QUOTE
$('.viewQuote').click(function(){
    currentIndex = $(this).closest('tr').data('index');
    const r = pickups[currentIndex];
    $('#quoteList').html(r.items.map(i=>`<li>${i.category} — ${i.quantity}kg (RM ${i.subtotal.toFixed(2)})</li>`));
    $('#quoteTotal').text(r.totalPrice.toFixed(2));

    if(['Pending Payment','Quotation Rejected','Cancelled'].includes(r.status)){
        $('#accept,#reject').prop('disabled', true);
    } else {
        $('#accept,#reject').prop('disabled', false);
    }

    $('#quoteModal').modal('show');
});

// ACCEPT QUOTE
$('#accept').click(()=>{
    if(currentIndex===null) return;
    pickups[currentIndex].status = "Pending Payment";
    updateRowStatus(currentIndex, "Pending Payment", "badge-warning");
    disableQuoteButton(currentIndex);
    Swal.fire('Accepted','Quotation accepted','success');
    $('#quoteModal').modal('hide');
});

// REJECT QUOTE
$('#reject').click(()=>{
    if(currentIndex===null) return;
    pickups[currentIndex].status = "Quotation Rejected";
    updateRowStatus(currentIndex, "Quotation Rejected", "badge-danger");
    disableQuoteButton(currentIndex);
    Swal.fire('Rejected','Quotation rejected','success');
    $('#quoteModal').modal('hide');
});

// CANCEL user-added requests
$('.cancel').click(function(){
    let idx = $(this).closest('tr').data('index');
    Swal.fire({
        title:'Cancel pickup?',
        icon:'warning',
        showCancelButton:true
    }).then(res=>{
        if(res.isConfirmed){
            pickups[idx].status = "Cancelled";
            updateRowStatus(idx, "Cancelled", "badge-secondary");
            $(this).prop('disabled',true);
            Swal.fire('Cancelled','Pickup request cancelled','success');
        }
    });
});

function updateRowStatus(index, text, badgeClass){
    let row = $('#pickupTable tbody tr').eq(index);
    let $status = row.find('.status');
    $status.removeClass().addClass(`badge ${badgeClass} badge-status`).text(text);
}

function disableQuoteButton(index){
    let row = $('#pickupTable tbody tr').eq(index);
    row.find('.viewQuote').prop('disabled',true);
}
</script>

</body>
</html>
