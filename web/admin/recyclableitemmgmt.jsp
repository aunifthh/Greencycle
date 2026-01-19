<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% request.setAttribute("currentPage", "recyclable"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Recyclable Items | Greencycle</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
    <jsp:include page="/navbar/adminnavbar.jsp" />
    <jsp:include page="/sidebar/adminsidebar.jsp" />

    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid"><h3>Manage Recyclable Items</h3></div>
        </section>

        <section class="content">
            <div class="container-fluid">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3 class="card-title">Item List & Market Rates</h3>
                        <button class="btn btn-success ml-auto" data-toggle="modal" data-target="#addModal">
                            <i class="fas fa-plus"></i> Add Item
                        </button>
                    </div>
                    <div class="card-body">
                        <table id="recycleTable" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Material Name</th>
                                    <th>Rate (RM/KG)</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${itemList}" var="item">
                                    <tr>
                                        <td>${item.recyclableItemID}</td>
                                        <td>${item.recyclableItemName}</td>
                                        <td>RM ${String.format("%.2f", item.ratePerKg)}</td>
                                        <td>
                                            <button class="btn btn-primary btn-sm edit-btn" 
                                                    data-id="${item.recyclableItemID}" 
                                                    data-name="${item.recyclableItemName}" 
                                                    data-rate="${item.ratePerKg}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger btn-sm delete-trigger" data-id="${item.recyclableItemID}">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <jsp:include page="/footer/footer.jsp" />
</div>

<!-- ADD MODAL -->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/RecyclableItemServlet?action=add" method="POST" class="modal-content">
            <div class="modal-header"><h5 class="modal-title">New Recyclable Item</h5></div>
            <div class="modal-body">
                <label>Item Name</label>
                <input type="text" name="itemName" class="form-control mb-2" placeholder="e.g. Aluminum Cans" required>
                <label>Rate per KG (RM)</label>
                <input type="number" step="0.01" name="rate" class="form-control" placeholder="0.00" required>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Save Item</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/RecyclableItemServlet?action=update" method="POST" class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Update Rate</h5></div>
            <div class="modal-body">
                <label>Item ID</label>
                <input type="text" name="id" id="editID" class="form-control mb-2" readonly>
                <label>Item Name</label>
                <input type="text" name="itemName" id="editName" class="form-control mb-2" required>
                <label>Rate (RM)</label>
                <input type="number" step="0.01" name="rate" id="editRate" class="form-control" required>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Update Changes</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    $(function () {
        // Edit Button Click
        $(".edit-btn").click(function() {
            $("#editID").val($(this).data("id"));
            $("#editName").val($(this).data("name"));
            $("#editRate").val($(this).data("rate"));
            $("#editModal").modal("show");
        });

        // Delete Button Click
        $(".delete-trigger").click(function() {
            const id = $(this).data("id");
            Swal.fire({
                title: 'Remove item?',
                text: "ID: " + id,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                confirmButtonText: 'Yes, delete'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "${pageContext.request.contextPath}/RecyclableItemServlet?action=delete&id=" + id;
                }
            });
        });

        // Alerts
        const params = new URLSearchParams(window.location.search);
        if(params.has('status')) {
            Swal.fire({ icon: 'success', title: 'Success', text: 'Item updated!', timer: 1500 });
        }
    });
</script>
</body>
</html>