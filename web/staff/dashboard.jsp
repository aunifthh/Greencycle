<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentPage", "dashboard" ); %>
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
                        <h1>Staff Dashboard</h1>
                    </div>
                    <div class="content">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="card card-primary card-outline">
                                        <div class="card-header">
                                            <h5 class="m-0">Welcome</h5>
                                        </div>
                                        <div class="card-body">
                                            <h6 class="card-title">Assigned Tasks</h6>
                                            <p class="card-text">You have pending pickups assigned to you.</p>
                                            <a href="${pageContext.request.contextPath}/RequestServlet?action=list"
                                                class="btn btn-primary">View Pickups</a>
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
            <script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
        </body>

        </html>