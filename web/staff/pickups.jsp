<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.text.DecimalFormat" %>
<%@ page import="Greencycle.model.RequestBean, Greencycle.dao.RequestDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    List<RequestBean> requests = (List<RequestBean>) request.getAttribute("requests");
    if (requests == null) {
        response.sendRedirect(request.getContextPath() + "/RequestServlet?action=list");
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
<h3 class="mb-2">Pickup Request</h3>
</section>

<section class="content">
<div class="container-fluid">
<div class="card">
<div class="card-header d-flex justify-content-between">
<h3 class="card-title">Manage Recyclable Types</h3>
<a href="${pageContext.request.contextPath}/customer/pickups?action=add" class="btn btn-success">
<i class="fas fa-plus"></i> Add Request</a>
</div>

<div class="card-body">
<table id="pickupTable" class="table table-bordered table-hover">
<thead>
<tr>
<th>ID</th><th>Item</th><th>Location</th><th>Qty</th><th>Date</th><th>Time</th><th>Status</th><th>Total (RM)</th><th>Action</th>
</tr>
</thead>
<tbody>
<%
for (RequestBean r : requests) {
    double totalQty = r.getEstimatedWeight();
    StringBuilder itemList = new StringBuilder();
    if (r.getPlasticWeight()>0) itemList.append("Plastic (").append(df.format(r.getPlasticWeight())).append("kg)");
    if (r.getPaperWeight()>0) { if(itemList.length()>0)itemList.append("<br>"); itemList.append("Paper (").append(df.format(r.getPaperWeight())).append("kg)"); }
    if (r.getMetalWeight()>0) { if(itemList.length()>0)itemList.append("<br>"); itemList.append("Metal (").append(df.format(r.getMetalWeight())).append("kg)"); }
    if (itemList.length()==0)itemList.append("-");

    double totalAmount = rDao.getQuotationAmount(r.getRequestID());

    String status = r.getStatus();
    String badgeClass = "badge-secondary";
    if ("Quoted".equals(status) || "Verified".equals(status)) badgeClass="badge-info";
    else if ("Pending Pickup".equals(status) || "Pending Payment".equals(status)) badgeClass="badge-warning";
    else if ("Completed".equals(status)) badgeClass="badge-success";
    else if ("Cancelled".equals(status) || "Quotation Rejected".equals(status)) badgeClass="badge-secondary";

    java.time.LocalDate today = java.time.LocalDate.now();
    java.time.LocalDate pickupDate = r.getPickupDate()!=null?r.getPickupDate().toLocalDate():null;
    boolean canCancel = "Pending Pickup".equals(status) && pickupDate!=null && pickupDate.isAfter(today.plusDays(1));
%>
<tr>
<td>REQ<%=r.getRequestID()%></td>
<td><%=itemList.toString()%></td>
<td><%=r.getFullAddress()!=null?r.getFullAddress():"-"%></td>
<td><%=df.format(totalQty)%></td>
<td><%=r.getPickupDate()!=null?r.getPickupDate():"-"%></td>
<td><%=r.getPickupTime()!=null?r.getPickupTime():"-"%></td>
<td><span class="badge <%=badgeClass%> badge-status"><%=status%></span></td>
<td><%=df.format(totalAmount)%></td>
<td>
<% if (!"Completed".equals(status) && !"Cancelled".equals(status) && !"Quotation Rejected".equals(status)) { %>
<form method="post" action="${pageContext.request.contextPath}/RequestServlet">
<input type="hidden" name="action" value="cancel_pickup">
<input type="hidden" name="requestID" value="<%=r.getRequestID()%>">
<button type="button" class="btn btn-sm <%=canCancel?"btn-danger":"btn-secondary"%> cancelBtn" <%=canCancel?"":"disabled"%>>
<i class="fas fa-times"></i> Cancel</button>
</form>
<% } %>

<% if ("Quoted".equals(status) || "Verified".equals(status)) { %>
<button type="button" class="btn btn-info btn-sm view-quote-btn"
data-requestid="<%=r.getRequestID()%>" data-status="<%=status%>"
data-address="<%=r.getFullAddress()%>" data-date="<%=r.getPickupDate()%>" data-time="<%=r.getPickupTime()%>"
data-plastic="<%=r.getPlasticWeight()%>" data-paper="<%=r.getPaperWeight()%>" data-metal="<%=r.getMetalWeight()%>" data-total="<%=totalAmount%>">
<i class="fas fa-eye"></i> View Quotation</button>
<% } %>

<% if ("Completed".equals(status) || "Cancelled".equals(status) || "Quotation Rejected".equals(status)) { %>
<button type="button" class="btn btn-secondary btn-sm view-details-btn"
                                                        data-requestid="<%= r.getRequestID() %>" data-status="<%= status %>"
                                                        data-address="<%= r.getFullAddress() != null ? r.getFullAddress() : "-" %>"
                                                        data-date="<%= r.getPickupDate() != null ? r.getPickupDate() : "-" %>"
                                                        data-time="<%= r.getPickupTime() != null ? r.getPickupTime() : "-" %>"
                                                        data-plastic="<%= r.getPlasticWeight() %>"
                                                        data-paper="<%= r.getPaperWeight() %>"
                                                        data-metal="<%= r.getMetalWeight() %>"
                                                        data-total="<%= totalAmount %>">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
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

<jsp:include page="/footer/footer.jsp"/>

<!-- Modal -->
<div class="modal fade" id="quoteModal">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header bg-info text-white">
<h5 class="modal-title">Quotation / Details</h5>
<button type="button" class="close text-white" data-dismiss="modal">&times;</button>
</div>
<div class="modal-body">
<div><strong>Request ID:</strong> <span id="q_id"></span></div>
<div><strong>Status:</strong> <span id="q_status"></span></div>
<div><strong>Address:</strong> <span id="q_address"></span></div>
<div><strong>Date:</strong> <span id="q_date"></span></div>
<div><strong>Time:</strong> <span id="q_time"></span></div>
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
<form id="acceptRejectForm" method="post" action="${pageContext.request.contextPath}/RequestServlet">
<input type="hidden" name="requestID" id="modalRequestID" value="">
<input type="hidden" name="action" id="modalAction" value="">
<button type="button" class="btn btn-success" id="acceptQuoteBtn">Accept</button>
<button type="button" class="btn btn-danger" id="rejectQuoteBtn">Reject</button>
</form>
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
$(document).ready(function() {
    $('#pickupTable').DataTable({ order:[[0,'desc']] });

    $(document).on('click','.cancelBtn',function(){
        const $btn=$(this);
        if($btn.is(':disabled')){ Swal.fire('Cannot Cancel','Pickup can be cancelled at least 2 days before pickup date!','warning'); return; }
        const $form=$btn.closest('form');
        Swal.fire({title:'Are you sure?',text:'Do you want to cancel this pickup request?',icon:'warning',showCancelButton:true,
        confirmButtonColor:'#d33',cancelButtonColor:'#3085d6',confirmButtonText:'Yes, cancel it!'}).then((result)=>{ if(result.isConfirmed) $form.submit(); });
    });

    $(document).on('click', '.view-quote-btn', function() {
        const $btn = $(this);
        const requestID = $btn.data('requestid');
        const status = $btn.data('status');

        // populate modal fields here...

        // 👇 PUT IT RIGHT HERE
        if (status === 'Quoted') {
            $('#acceptQuoteBtn').show();
            $('#rejectQuoteBtn').show();
        } else {
            $('#acceptQuoteBtn').hide();
            $('#rejectQuoteBtn').hide();
        }

        $('#quoteModal').modal('show');
    });
});
</script>
</body>
</html>
