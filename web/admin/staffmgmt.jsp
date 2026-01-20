<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <% request.setAttribute("currentPage", "users" ); request.setAttribute("currentSub", "staff" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Staff Management | Greencycle</title>
                <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
            </head>

            <body class="hold-transition sidebar-mini layout-fixed">
                <div class="wrapper">
                    <jsp:include page="/navbar/adminnavbar.jsp" />
                    <jsp:include page="/sidebar/adminsidebar.jsp" />

                    <div class="content-wrapper">
                        <section class="content-header">
                            <h1>User Management</h1>
                        </section>
                        <section class="content">
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header d-flex justify-content-between">
                                        <h3 class="card-title">Manage Staff</h3>
                                        <button class="btn btn-success ml-auto" data-toggle="modal"
                                            data-target="#addModal"><i class="fas fa-user-plus"></i> Add Staff</button>
                                    </div>
                                    <div class="card-body">
                                        <table id="userTable" class="table table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Staff ID</th>
                                                    <th>Name</th>
                                                    <th>Email</th>
                                                    <th>Phone</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${staffList}" var="s">
                                                    <tr>
                                                        <td>${s.staffID}</td>
                                                        <td>${s.staffName}</td>
                                                        <td>${s.staffEmail}</td>
                                                        <td>${s.staffPhoneNo}</td>
                                                        <td>
                                                            <button class="btn btn-primary btn-sm edit-btn"
                                                                data-id="${s.staffID}" data-name="${s.staffName}"
                                                                data-email="${s.staffEmail}"
                                                                data-phone="${s.staffPhoneNo}">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <a href="${pageContext.request.contextPath}/StaffMgmtServlet?action=delete&id=${s.staffID}"
                                                                class="btn btn-danger btn-sm delete-confirm"><i
                                                                    class="fas fa-trash"></i></a>
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

                <!-- MODALS (Update Form Actions) -->
                <div class="modal fade" id="addModal">
                    <div class="modal-dialog">
                        <form action="${pageContext.request.contextPath}/StaffMgmtServlet?action=add" method="POST"
                            class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Add Staff</h5>
                            </div>
                            <div class="modal-body">
                                <input type="text" name="name" class="form-control mb-2" placeholder="Name" required>
                                <input type="email" name="email" class="form-control mb-2" placeholder="Email" required>
                                <input type="text" name="phone" class="form-control mb-2" placeholder="Phone" required>
                            </div>
                            <div class="modal-footer"><button type="submit" class="btn btn-success">Save</button></div>
                        </form>
                    </div>
                </div>

                <div class="modal fade" id="editModal">
                    <div class="modal-dialog">
                        <form action="${pageContext.request.contextPath}/StaffMgmtServlet?action=update" method="POST"
                            class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Edit Staff</h5>
                            </div>
                            <div class="modal-body">
                                <input type="text" name="id" id="editID" class="form-control mb-2" readonly>
                                <input type="text" name="name" id="editName" class="form-control mb-2" required>
                                <input type="email" name="email" id="editEmail" class="form-control mb-2" required>
                                <input type="text" name="phone" id="editPhone" class="form-control mb-2" required>
                            </div>
                            <div class="modal-footer"><button type="submit" class="btn btn-primary">Update</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                <script
                    src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                <script
                    src="${pageContext.request.contextPath}/app/plugins/datatables/jquery.dataTables.min.js"></script>
                <script
                    src="${pageContext.request.contextPath}/app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
                <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <script>
                    $(function () {
                        $("#userTable").DataTable();

                        // Populate Edit Modal
                        $(".edit-btn").click(function () {
                            $("#editID").val($(this).data("id"));
                            $("#editName").val($(this).data("name"));
                            $("#editEmail").val($(this).data("email"));
                            $("#editPhone").val($(this).data("phone"));
                            $("#editModal").modal("show");
                        });

                        // SweetAlert for status messages
                        const urlParams = new URLSearchParams(window.location.search);
                        if (urlParams.has('status')) {
                            Swal.fire({ icon: 'success', title: 'Success!', text: 'Staff ' + urlParams.get('status'), timer: 2000 });
                        }
                    });
                </script>
            </body>

            </html>