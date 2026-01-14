<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <% // This attribute tells the sidebar which link to highlight as "active"
        request.setAttribute("currentPage", "dashboard" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Dashboard | Greencycle</title>

            <!-- Favicon -->
            <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">

            <!-- AdminLTE & Plugins CSS -->
            <!-- Font Awesome -->
            <link rel="stylesheet"
                href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
            <!-- Theme style -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
            <!-- DataTables -->
            <link rel="stylesheet"
                href="${pageContext.request.contextPath}/app/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
            <link rel="stylesheet"
                href="${pageContext.request.contextPath}/app/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
        </head>

        <body class="hold-transition sidebar-mini layout-fixed">
            <div class="wrapper">

                <!-- 1. NAVBAR -->
                <jsp:include page="/navbar/adminnavbar.jsp" />

                <!-- 2. SIDEBAR -->
                <jsp:include page="/sidebar/adminsidebar.jsp" />

                <!-- 3. CONTENT WRAPPER (Everything inside this moves to the right of the sidebar) -->
                <div class="content-wrapper">

                    <!-- Content Header (Page header) -->
                    <section class="content-header">
                        <div class="container-fluid">
                            <div class="row mb-2">
                                <div class="col-sm-6">
                                    <h1 class="m-0">Dashboard</h1>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Main content -->
                    <section class="content">
                        <div class="container-fluid">

                            <!-- START: STAT BOXES -->
                            <% Greencycle.dao.RequestDao rDao=new Greencycle.dao.RequestDao(); int
                                pendingCount=rDao.getRequestsByStatus("Pending").size(); int
                                quotedCount=rDao.getRequestsByStatus("Quoted").size(); %>
                                <div class="row">
                                    <div class="col-lg-4 col-6">
                                        <div class="small-box bg-warning">
                                            <div class="inner">
                                                <h3>
                                                    <%= pendingCount %>
                                                </h3>
                                                <p>New Requests (Pending)</p>
                                            </div>
                                            <div class="icon"><i class="fas fa-exclamation-circle"></i></div>
                                            <a href="${pageContext.request.contextPath}/RequestServlet?action=list"
                                                class="small-box-footer">More info <i
                                                    class="fas fa-arrow-circle-right"></i></a>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-6">
                                        <div class="small-box bg-info">
                                            <div class="inner">
                                                <h3>
                                                    <%= quotedCount %>
                                                </h3>
                                                <p>Quoted / In Progress</p>
                                            </div>
                                            <div class="icon"><i class="fas fa-truck-loading"></i></div>
                                            <a href="${pageContext.request.contextPath}/RequestServlet?action=list"
                                                class="small-box-footer">More info <i
                                                    class="fas fa-arrow-circle-right"></i></a>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-6">
                                        <div class="small-box bg-success">
                                            <div class="inner">
                                                <h3>RM 0.00</h3>
                                                <p>Total Revenue (Placeholder)</p>
                                            </div>
                                            <div class="icon"><i class="fas fa-money-bill-wave"></i></div>
                                        </div>
                                    </div>
                                </div>
                                <!-- END: STAT BOXES -->

                                <!-- START: MAIN CONTENT AREA -->
                                <div class="row">
                                    <div class="col-12">
                                        <div class="card">
                                            <div class="card-header">
                                                <h3 class="card-title">
                                                    <i class="fas fa-list mr-1"></i>
                                                    Main Content Title
                                                </h3>
                                            </div>
                                            <div class="card-body">
                                                <!-- Your team members will put their tables/forms here -->
                                                <p>This is where your page content goes.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- END: MAIN CONTENT AREA -->

                        </div><!-- /.container-fluid -->
                    </section>
                    <!-- /.content -->
                </div>

                <!-- 4. FOOTER -->
                <jsp:include page="/footer/footer.jsp" />

            </div>
            <!-- ./wrapper -->

            <!-- REQUIRED SCRIPTS -->
            <!-- jQuery -->
            <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
            <!-- Bootstrap 4 -->
            <script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
            <!-- DataTables & Plugins -->
            <script src="${pageContext.request.contextPath}/app/plugins/datatables/jquery.dataTables.min.js"></script>
            <script
                src="${pageContext.request.contextPath}/app/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
            <!-- AdminLTE App -->
            <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>

        </body>

        </html>