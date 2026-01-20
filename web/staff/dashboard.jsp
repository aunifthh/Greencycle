<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.model.RequestBean" %>
        <%@page import="java.util.List" %>
            <% request.setAttribute("currentPage", "dashboard" ); 
                if (request.getAttribute("pendingPickupCount")==null) {
                response.sendRedirect(request.getContextPath() + "/StaffDashboardServlet" ); return; 
            } 
                Integer pendingPickupCountObj=(Integer)
                request.getAttribute("pendingPickupCount"); int pendingPickupCount=(pendingPickupCountObj !=null) ?
                pendingPickupCountObj : 0; Integer myVerificationCountObj=(Integer)
                request.getAttribute("myVerificationCount"); int myVerificationCount=(myVerificationCountObj !=null) ?
                myVerificationCountObj : 0; Double myTotalWeightObj=(Double) request.getAttribute("myTotalWeight");
                double myTotalWeight=(myTotalWeightObj !=null) ? myTotalWeightObj : 0.0; List<RequestBean> todaysPickups
                = (List<RequestBean>) request.getAttribute("todaysPickups");
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <title>Staff Dashboard | Greencycle</title>
                        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                    </head>

                    <body class="hold-transition sidebar-mini layout-fixed">
                        <div class="wrapper">
                            <jsp:include page="/navbar/staffnavbar.jsp" />
                            <jsp:include page="/sidebar/staffsidebar.jsp" />

                            <!-- Content -->
                            <div class="content-wrapper">
                                <div class="content-header">
                                    <div class="container-fluid">
                                        <div class="row mb-2">
                                            <div class="col-sm-6">
                                                <h1 class="m-0">Staff Dashboard</h1>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="content">
                                    <div class="container-fluid">

                                        <!-- Small Boxes (Stat box) -->
                                        <div class="row">
                                            <!-- Pending Pickups -->
                                            <div class="col-lg-3 col-6">
                                                <div class="small-box bg-info">
                                                    <div class="inner">
                                                        <h3>
                                                            <%= pendingPickupCount %>
                                                        </h3>
                                                        <p>Pending Pickups</p>
                                                    </div>
                                                    <div class="icon">
                                                        <i class="fas fa-truck"></i>
                                                    </div>
                                                    <a href="${pageContext.request.contextPath}/RequestServlet?action=list&status=Pending Pickup"
                                                        class="small-box-footer">View List <i
                                                            class="fas fa-arrow-circle-right"></i></a>
                                                </div>
                                            </div>

                                            <!-- My Verifications -->
                                            <div class="col-lg-3 col-6">
                                                <div class="small-box bg-success">
                                                    <div class="inner">
                                                        <h3>
                                                            <%= myVerificationCount %>
                                                        </h3>
                                                        <p>My Verifications</p>
                                                    </div>
                                                    <div class="icon">
                                                        <i class="fas fa-clipboard-check"></i>
                                                    </div>
                                                    <span class="small-box-footer">Personal Contribution</span>
                                                </div>
                                            </div>

                                            <!-- Total Weight -->
                                            <div class="col-lg-3 col-6">
                                                <div class="small-box bg-warning">
                                                    <div class="inner">
                                                        <h3>
                                                            <%= String.format("%.2f", myTotalWeight) %> <sup
                                                                    style="font-size: 20px">kg</sup>
                                                        </h3>
                                                        <p>Total Weight Verified</p>
                                                    </div>
                                                    <div class="icon">
                                                        <i class="fas fa-weight-hanging"></i>
                                                    </div>
                                                    <span class="small-box-footer">Lifetime Total</span>
                                                </div>
                                            </div>

                                            <!-- Today's Tasks Count -->
                                            <div class="col-lg-3 col-6">
                                                <div class="small-box bg-danger">
                                                    <div class="inner">
                                                        <h3>
                                                            <%= (todaysPickups !=null) ? todaysPickups.size() : 0 %>
                                                        </h3>
                                                        <p>Today's Pickups</p>
                                                    </div>
                                                    <div class="icon">
                                                        <i class="fas fa-calendar-day"></i>
                                                    </div>
                                                    <a href="#todaysTasksWithTable" class="small-box-footer">View
                                                        Schedule <i class="fas fa-arrow-circle-down"></i></a>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /.row -->

                                        <!-- Tasks Table -->
                                        <div class="row" id="todaysTasksWithTable">
                                            <div class="col-12">
                                                <div class="card card-primary card-outline">
                                                    <div class="card-header">
                                                        <h3 class="card-title">
                                                            <i class="far fa-calendar-alt mr-1"></i>
                                                            Today's Tasks
                                                        </h3>
                                                    </div>
                                                    <div class="card-body table-responsive p-0">
                                                        <table class="table table-hover text-nowrap">
                                                            <thead>
                                                                <tr>
                                                                    <th>Time</th>
                                                                    <th>Customer</th>
                                                                    <th>Address</th>
                                                                    <th>Est. Weight</th>
                                                                    <th>Action</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (todaysPickups==null || todaysPickups.isEmpty()) {
                                                                    %>
                                                                    <tr>
                                                                        <td colspan="5" class="text-center">No pickups
                                                                            scheduled for today.</td>
                                                                    </tr>
                                                                    <% } else { for (RequestBean r : todaysPickups) { %>
                                                                        <tr>
                                                                            <td><span class="badge badge-info">
                                                                                    <%= r.getPickupTime() %>
                                                                                </span></td>
                                                                            <td>
                                                                                <%= r.getCustomerName() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getFullAddress() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getEstimatedWeight() %> kg
                                                                            </td>
                                                                            <td>
                                                                                <a href="${pageContext.request.contextPath}/RequestServlet?action=view&id=<%= r.getRequestID() %>"
                                                                                    class="btn btn-sm btn-primary">
                                                                                    <i class="fas fa-eye"></i> Verify
                                                                                </a>
                                                                            </td>
                                                                        </tr>
                                                                        <% } } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <jsp:include page="/footer/footer.jsp" />
                        </div>
                        <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                        <script
                            src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                        <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                    </body>

                    </html>