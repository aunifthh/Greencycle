<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="Greencycle.model.RequestBean" %>
<%@page import="Greencycle.dao.RequestDao" %>
<%@page import="java.util.List" %>
<%@page import="java.text.DecimalFormat" %>
<% 
    request.setAttribute("currentPage", "dashboard");
    RequestDao rDao = new RequestDao();
    int pendingCount = rDao.getRequestsByStatus("Pending").size() + rDao.getRequestsByStatus("Pending Pickup").size();
    int quotedCount = rDao.getRequestsByStatus("Quoted").size() + rDao.getRequestsByStatus("Pending Payment").size();
    
    // FETCH ANALYTICS DATA
    double totalRevenue = rDao.getTotalRevenue();
    double[] wasteWeights = rDao.getTotalWasteWeights(); // [Plastic, Paper, Metal]
    double totalWaste = wasteWeights[0] + wasteWeights[1] + wasteWeights[2];
    
    List<RequestBean> recentTransactions = rDao.getRecentTransactions();
    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat df1 = new DecimalFormat("#,##0.0");
    
    // Calculate Percentages for Progress Bars
    double plasticPct = (totalWaste > 0) ? (wasteWeights[0] / totalWaste) * 100 : 0;
    double paperPct = (totalWaste > 0) ? (wasteWeights[1] / totalWaste) * 100 : 0;
    double metalPct = (totalWaste > 0) ? (wasteWeights[2] / totalWaste) * 100 : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Greencycle</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- 1. NAVBAR -->
    <jsp:include page="/navbar/adminnavbar.jsp" />

    <!-- 2. SIDEBAR -->
    <jsp:include page="/sidebar/adminsidebar.jsp" />

    <!-- 3. CONTENT WRAPPER -->
    <div class="content-wrapper">
        <section class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Dashboard Analytics</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="content">
            <div class="container-fluid">

                <!-- START: STAT BOXES -->
                <div class="row">
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-warning">
                            <div class="inner">
                                <h3><%= pendingCount %></h3>
                                <p>Action Required</p>
                            </div>
                            <div class="icon"><i class="fas fa-exclamation-circle"></i></div>
                            <a href="${pageContext.request.contextPath}/RequestServlet?action=list" class="small-box-footer">View Requests <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-info">
                            <div class="inner">
                                <h3><%= quotedCount %></h3>
                                <p>In Progress</p>
                            </div>
                            <div class="icon"><i class="fas fa-truck-loading"></i></div>
                            <a href="${pageContext.request.contextPath}/RequestServlet?action=list" class="small-box-footer">View Requests <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-success">
                            <div class="inner">
                                <h3>RM <%= df.format(totalRevenue) %></h3>
                                <p>Total Revenue</p>
                            </div>
                            <div class="icon"><i class="fas fa-money-bill-wave"></i></div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-6">
                        <div class="small-box bg-danger">
                            <div class="inner">
                                <h3><%= df1.format(totalWaste) %> kg</h3>
                                <p>Waste Collected</p>
                            </div>
                            <div class="icon"><i class="fas fa-recycle"></i></div>
                        </div>
                    </div>
                </div>
                <!-- END: STAT BOXES -->

                <!-- START: ANALYTICS ROW -->
                <div class="row">
                    <!-- Waste Composition Chart (Progress Bars) -->
                    <div class="col-md-6">
                        <div class="card card-primary">
                            <div class="card-header">
                                <h3 class="card-title">Waste Composition</h3>
                            </div>
                            <div class="card-body">
                                <p class="text-center"><strong>Total Collected by Material</strong></p>

                                <div class="progress-group">
                                    Plastic
                                    <span class="float-right"><b><%= df1.format(wasteWeights[0]) %></b>/<%= df1.format(totalWaste) %> kg</span>
                                    <div class="progress progress-sm">
                                        <div class="progress-bar bg-primary" style="width: <%= plasticPct %>%"></div>
                                    </div>
                                </div>

                                <div class="progress-group">
                                    Paper
                                    <span class="float-right"><b><%= df1.format(wasteWeights[1]) %></b>/<%= df1.format(totalWaste) %> kg</span>
                                    <div class="progress progress-sm">
                                        <div class="progress-bar bg-danger" style="width: <%= paperPct %>%"></div>
                                    </div>
                                </div>

                                <div class="progress-group">
                                    Metal
                                    <span class="float-right"><b><%= df1.format(wasteWeights[2]) %></b>/<%= df1.format(totalWaste) %> kg</span>
                                    <div class="progress progress-sm">
                                        <div class="progress-bar bg-success" style="width: <%= metalPct %>%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Transactions -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header border-transparent">
                                <h3 class="card-title">Recent Completed Transactions</h3>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table m-0">
                                        <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer</th>
                                            <th>Amount</th>
                                            <th>Date</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <% if(recentTransactions.isEmpty()) { %>
                                            <tr><td colspan="4" class="text-center">No recent transactions.</td></tr>
                                        <% } else { 
                                            for(RequestBean t : recentTransactions) { %>
                                            <tr>
                                                <td><a href="#">REQ<%= t.getRequestID() %></a></td>
                                                <td><%= t.getCustomerName() %></td>
                                                <td><span class="badge badge-success">RM <%= df.format(t.getQuotationAmount()) %></span></td>
                                                <td><%= t.getPickupDate() %></td>
                                            </tr>
                                        <% }} %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer clearfix">
                                <a href="${pageContext.request.contextPath}/RequestServlet?action=list" class="btn btn-sm btn-secondary float-right">View All Requests</a>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- END: ANALYTICS ROW -->

            </div>
        </section>
    </div>

    <jsp:include page="/footer/footer.jsp" />
</div>

<script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
</body>
</html>
