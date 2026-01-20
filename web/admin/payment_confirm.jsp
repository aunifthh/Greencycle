<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ page import="Greencycle.model.RequestBean" %>
        <%@ page import="Greencycle.dao.RequestDao" %>
            <%@ page import="java.text.DecimalFormat" %>
                <% String role=(String) session.getAttribute("role"); if (role==null || !"admin".equals(role)) {
                    response.sendRedirect("../index.jsp"); return; } String reqIdStr=request.getParameter("requestID");
                    if (reqIdStr==null || reqIdStr.isEmpty()) { response.sendRedirect("requestmgmt.jsp"); return; } int
                    requestID=Integer.parseInt(reqIdStr); RequestDao rDao=new RequestDao(); RequestBean
                    reqBean=rDao.getRequestById(requestID); if (reqBean==null) {
                    response.sendRedirect("requestmgmt.jsp"); return; } DecimalFormat df=new DecimalFormat("#,##0.00");
                    %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <title>Confirm Payment Release | Greencycle</title>
                        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                        <link rel="stylesheet"
                            href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                    </head>

                    <body class="hold-transition sidebar-mini">
                        <div class="wrapper">

                            <jsp:include page="/navbar/adminnavbar.jsp" />
                            <jsp:include page="/sidebar/adminsidebar.jsp" />

                            <div class="content-wrapper">
                                <section class="content-header">
                                    <div class="container-fluid">
                                        <h1>Confirm Payment Release</h1>
                                    </div>
                                </section>

                                <section class="content">
                                    <div class="container-fluid">
                                        <div class="row justify-content-center">
                                            <div class="col-md-8">
                                                <div class="card card-primary">
                                                    <div class="card-header">
                                                        <h3 class="card-title">Payment Details</h3>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="callout callout-warning">
                                                            <h5><i class="fas fa-exclamation-triangle"></i> Confirmation
                                                                Required</h5>
                                                            <p>Please review the details below before releasing the
                                                                payment.</p>
                                                        </div>
                                                        <hr>

                                                        <dl class="row">
                                                            <dt class="col-sm-4">Request ID</dt>
                                                            <dd class="col-sm-8">REQ<%= reqBean.getRequestID() %>
                                                            </dd>

                                                            <dt class="col-sm-4">Customer Name</dt>
                                                            <dd class="col-sm-8">
                                                                <%= reqBean.getCustomerName() %>
                                                            </dd>

                                                            <dt class="col-sm-4">Bank Name</dt>
                                                            <dd class="col-sm-8">
                                                                <%= reqBean.getBankName() !=null ? reqBean.getBankName()
                                                                    : "N/A" %>
                                                            </dd>

                                                            <dt class="col-sm-4">Account Number</dt>
                                                            <dd class="col-sm-8">
                                                                <%= reqBean.getBankAccountNumber() !=null ?
                                                                    reqBean.getBankAccountNumber() : "N/A" %>
                                                            </dd>

                                                            <dt class="col-sm-4">Amount to Release</dt>
                                                            <dd class="col-sm-8"><strong>RM <%=
                                                                        df.format(reqBean.getQuotationAmount()) %>
                                                                        </strong></dd>
                                                        </dl>

                                                        <div class="alert alert-info">
                                                            Confirm to release <strong>RM <%=
                                                                    df.format(reqBean.getQuotationAmount()) %></strong>
                                                            to <strong>
                                                                <%= reqBean.getCustomerName() %>
                                                            </strong> at <strong>
                                                                <%= reqBean.getBankName() %> - <%=
                                                                        reqBean.getBankAccountNumber() %>
                                                            </strong>?
                                                        </div>

                                                        <form action="${pageContext.request.contextPath}/RequestServlet"
                                                            method="post">
                                                            <input type="hidden" name="action" value="release_payment">
                                                            <input type="hidden" name="requestID"
                                                                value="<%= reqBean.getRequestID() %>">

                                                            <div class="text-center mt-4">
                                                                <a href="requestmgmt.jsp"
                                                                    class="btn btn-secondary mr-2">
                                                                    <i class="fas fa-times"></i> Cancel
                                                                </a>
                                                                <button type="submit" class="btn btn-primary">
                                                                    <i class="fas fa-check"></i> Confirm Release
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                            </div>

                            <jsp:include page="/footer/footer.jsp" />

                        </div>

                        <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
                        <script
                            src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
                        <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
                    </body>

                    </html>