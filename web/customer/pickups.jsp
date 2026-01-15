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

    <style>
        .badge-status { min-width: 90px; text-align: center; }
    </style>
</head>

<body class="hold-transition sidebar-mini">
<div class="wrapper">

    <jsp:include page="../navbar/usernavbar.jsp" />
    <jsp:include page="../sidebar/usersidebar.jsp" />

    <div class="content-wrapper">

        <section class="content-header">
            <div class="container-fluid">
                <h3>Pickup Requests</h3>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <div class="card">
                    <div class="card-header d-flex justify-content-between">
                        <h3 class="card-title">My Pickup Requests</h3>
                        <a href="${pageContext.request.contextPath}/customer/pickupForm.jsp"
                           class="btn btn-success btn-sm">
                            <i class="fas fa-plus"></i> New Pickup
                        </a>
                    </div>

                    <div class="card-body">
                        <table id="pickupTable" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Items</th>
                                    <th>Location</th>
                                    <th>Total Qty (KG)</th>
                                    <th>Date</th>
                                    <th>Status</th>
                                    <th>Total (RM)</th>
                                    <th>Action</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    List<PickupBean> pickups = (List<PickupBean>) request.getAttribute("pickups");
                                    DecimalFormat df = new DecimalFormat("#,##0.00");
                                    if (pickups != null) {
                                        for (PickupBean pickup : pickups) {
                                %>
                       
                                <tr data-id="<%= pickup.getRequestID() %>">
                                <td><%= pickup.getRequestID() %></td>

                                <td>
                                        <%
                                        for (PickupItemBean item : pickup.getItems()) {
                                            // display categoryID as placeholder
                                            out.print(item.getCategoryID() + " (" + item.getQuantity() + " kg)<br>");
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
                                                          pickup.getAddress().getPostcode());
                                            } else {
                                                out.print("N/A");
                                            }
                                        %>

                                </td>

                                  <td><%= df.format(pickup.getTotalQuantity()) %></td>
                                    <td><%= pickup.getPickupDate() %></td>

                                <td>
                                    <span class="badge badge-warning">
                                        <%= pickup.getStatus() %>
                                    </span>
                                </td>

                                <td><%= df.format(pickup.getTotalPrice()) %></td>

                                <td>
                                    <button class="btn btn-danger btn-sm">Cancel</button>
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
</div>

<script src="../app/plugins/jquery/jquery.min.js"></script>

<script>
    $('.cancelBtn').click(function () {
        if (!confirm('Cancel this pickup request?')) return;

        let reqId = $(this).closest('tr').data('id');

        $.post(
            '${pageContext.request.contextPath}/PickupServlet',
            {
                action: 'cancel',
                requestId: reqId
            },
            function () {
                location.reload();
            }
        );
    });
</script>

</body>
</html>
