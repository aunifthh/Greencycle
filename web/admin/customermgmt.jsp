<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% request.setAttribute("currentPage", "users"); request.setAttribute("currentSub", "customer"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Management | Greencycle</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">
    <jsp:include page="/navbar/adminnavbar.jsp" />
    <jsp:include page="/sidebar/adminsidebar.jsp" />

    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid"><h3>Customer Management</h3></div>
        </section>

        <section class="content">
            <div class="container-fluid">
                <div class="card">
                    <div class="card-header"><h3 class="card-title">Manage Registered Customers</h3></div>
                    <div class="card-body">
                        <table id="customerTable" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Bank Info</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${customerList}" var="c">
                                    <tr>
                                        <td>${c.customerID}</td>
                                        <td>${c.fullName}</td>
                                        <td>${c.email}</td>
                                        <td>${c.phoneNo}</td>
                                        <td>${c.bankName} (${c.bankAccountNo})</td>
                                        <td>
                                            <button class="btn btn-primary btn-sm edit-btn" 
                                                    data-id="${c.customerID}" data-name="${c.fullName}" 
                                                    data-email="${c.email}" data-phone="${c.phoneNo}"
                                                    data-bank="${c.bankName}" data-acc="${c.bankAccountNo}">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn btn-danger btn-sm delete-trigger" data-id="${c.customerID}">
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

<!-- EDIT CUSTOMER MODAL -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/CustomerMgmtServlet?action=update" method="POST" class="modal-content">
            <div class="modal-header"><h5 class="modal-title">Edit Customer Details</h5></div>
            <div class="modal-body">
                <label>Customer ID</label>
                <input type="text" name="id" id="editID" class="form-control mb-2" readonly>
                
                <label>Full Name</label>
                <input type="text" name="name" id="editName" class="form-control mb-2" required>
                
                <label>Email</label>
                <input type="email" name="email" id="editEmail" class="form-control mb-2" required>
                
                <label>Phone</label>
                <input type="text" name="phone" id="editPhone" class="form-control mb-2" required>
                
                <hr>
                <label>Bank Name</label>
                <input type="text" name="bankName" id="editBank" class="form-control mb-2">
                
                <label>Account Number</label>
                <input type="text" name="bankAcc" id="editAcc" class="form-control mb-2">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/app/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
<script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
    $(function () {
        $("#customerTable").DataTable();

        // Populate Modal
        $(".edit-btn").click(function() {
            $("#editID").val($(this).data("id"));
            $("#editName").val($(this).data("name"));
            $("#editEmail").val($(this).data("email"));
            $("#editPhone").val($(this).data("phone"));
            $("#editBank").val($(this).data("bank"));
            $("#editAcc").val($(this).data("acc"));
            $("#editModal").modal("show");
        });

        // Delete Confirmation
        $(".delete-trigger").click(function() {
            const id = $(this).data("id");
            Swal.fire({
                title: 'Are you sure?',
                text: "User " + id + " will be permanently removed!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                confirmButtonText: 'Yes, Delete'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "${pageContext.request.contextPath}/CustomerMgmtServlet?action=delete&id=" + id;
                }
            });
        });

        // Status Alerts
        const params = new URLSearchParams(window.location.search);
        if(params.has('status')) {
            Swal.fire({ icon: 'success', title: 'Done!', text: 'Customer data ' + params.get('status'), timer: 2000 });
        }
    });
</script>
</body>
</html>