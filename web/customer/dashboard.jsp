<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Greencycle.model.CustomerBean" %>
<%
    // Retrieve session data
    CustomerBean customer = (CustomerBean) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    // Redirect if not logged in as customer
    if (customer == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
        return;
    }

    // Set current page for sidebar highlighting
    request.setAttribute("currentPage", "dashboard");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard | Greencycle</title>
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <!-- AdminLTE CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
</head>

<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- Navbar -->
    <jsp:include page="/navbar/usernavbar.jsp" />

    <!-- Sidebar -->
    <jsp:include page="/sidebar/usersidebar.jsp" />

    <!-- Content Wrapper -->
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
                                <h3>2</h3>
                                <p>Total Requests</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-recycle"></i>
                            </div>
                            <a href="${pageContext.request.contextPath}/customer/pickups.jsp" class="small-box-footer">
                                New Request <i class="fas fa-arrow-circle-right"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-4 col-6">
                        <div class="small-box bg-success">
                            <div class="inner">
                                <h3>RM 120.00</h3>
                                <p>Total Earned</p>
                            </div>
                            <div class="icon">
                                <i class="fas fa-wallet"></i>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4 col-6">
                        <div class="small-box bg-warning">
                            <div class="inner">
                                <h3>1</h3>
                                <p>Pending Request</p>
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
                                <h3 class="card-title">
                                    <i class="fas fa-history mr-1"></i>
                                    Your Recent Requests
                                </h3>
                            </div>
                            <div class="card-body">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Recyclable Type</th>
                                            <th>Quantity</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>REQ101</td>
                                            <td>Plastic, Paper</td>
                                            <td>4.5 kg</td>
                                            <td><span class="badge badge-warning">Pending</span></td>
                                            <td>2025-11-28</td>
                                        </tr>
                                        <tr>
                                            <td>REQ098</td>
                                            <td>Metal</td>
                                            <td>2.1 kg</td>
                                            <td><span class="badge badge-success">Completed</span></td>
                                            <td>2025-11-20</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </section>
    </div>

    <!-- Footer -->
    <jsp:include page="/footer/footer.jsp" />

</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>

</body>
</html>