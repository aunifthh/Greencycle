<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <% request.setAttribute("currentPage", "pickups" ); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Pending Pickups | Greencycle</title>
                <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
            </head>

            <body class="hold-transition sidebar-mini layout-fixed">
                <div class="wrapper">
                    <!-- Navbar -->
                    <jsp:include page="/navbar/staffnavbar.jsp" />
                    <!-- Sidebar -->
                    <jsp:include page="/sidebar/staffsidebar.jsp" />

                    <div class="content-wrapper">
                        <div class="content-header">
                            <h1>Assigned Pickups</h1>
                        </div>
                        <div class="content">
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-body">
                                        <table id="pickupTable" class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Req ID</th>
                                                    <th>Customer</th>
                                                    <th>Address</th>
                                                    <th>Estimated</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${pendingList}" var="r">
                                                    <tr>
                                                        <td>${r.requestID}</td>
                                                        <td>${r.customerName}</td>
                                                        <td>${r.fullAddress}</td>
                                                        <td>${r.estimatedWeight} kg</td>
                                                        <td>
                                                            <button class="btn btn-success btn-sm process-btn"
                                                                data-id="${r.requestID}" data-cust="${r.customerName}"
                                                                data-plastic="${r.plasticWeight}"
                                                                data-paper="${r.paperWeight}"
                                                                data-metal="${r.metalWeight}">
                                                                <i class="fas fa-check"></i> Process Job
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <jsp:include page="/footer/footer.jsp" />
                </div>

                <!-- Process Modal -->
                <div class="modal fade" id="processModal">
                    <div class="modal-dialog">
                        <form action="${pageContext.request.contextPath}/RequestServlet" method="POST"
                            class="modal-content">
                            <input type="hidden" name="action" value="verify_weight">
                            <input type="hidden" name="staffID" value="${sessionScope.staff.staffID}">
                            <input type="hidden" name="requestID" id="procReqID">
                            <!-- Default to "no" for now, or could add UI for it later -->
                            <input type="hidden" name="customerAccepts" value="no">

                            <div class="modal-header">
                                <h5 class="modal-title">Process Pickup & Verify Weight</h5>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <label>Customer</label>
                                    <input type="text" class="form-control" id="procCust" readonly>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Plastic (kg)</label>
                                            <input type="number" step="0.1" name="plasticWeight" id="procPlastic"
                                                class="form-control" value="0.00" required>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Paper (kg)</label>
                                            <input type="number" step="0.1" name="paperWeight" id="procPaper"
                                                class="form-control" value="0.00" required>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Metal (kg)</label>
                                            <input type="number" step="0.1" name="metalWeight" id="procMetal"
                                                class="form-control" value="0.00" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="acceptCheck"
                                            name="customerAccepts" value="yes">
                                        <label class="custom-control-label" for="acceptCheck">Customer accepts verified
                                            amount on-site?</label>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer"><button type="submit" class="btn btn-success">Verify & Generate
                                    Quote</button></div>
                        </form>
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
                        $("#pickupTable").DataTable();

                        $(".process-btn").click(function () {
                            $("#procReqID").val($(this).data("id"));
                            $("#procCust").val($(this).data("cust"));
                            $("#procPlastic").val($(this).data("plastic"));
                            $("#procPaper").val($(this).data("paper"));
                            $("#procMetal").val($(this).data("metal"));
                            $("#processModal").modal("show");
                        });
                    });
                </script>
            </body>

            </html>