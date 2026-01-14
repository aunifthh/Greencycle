<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="Greencycle.dao.RateDao" %>
        <%@page import="java.util.Map" %>
            <% request.setAttribute("currentPage", "settings" ); %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Rate Management | Greencycle</title>
                    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
                </head>

                <body class="hold-transition sidebar-mini layout-fixed">
                    <div class="wrapper">
                        <jsp:include page="/navbar/adminnavbar.jsp" />
                        <jsp:include page="/sidebar/adminsidebar.jsp" />

                        <div class="content-wrapper">
                            <section class="content-header">
                                <h1>Recyclable Rates</h1>
                            </section>
                            <section class="content">
                                <div class="container-fluid">
                                    <% RateDao rDao=new RateDao(); Map<String, Double> rates = rDao.getAllRates();

                                        if ("POST".equalsIgnoreCase(request.getMethod())) {
                                        boolean updated = false;
                                        for (String key : rates.keySet()) {
                                        String paramName = "rate_" + key;
                                        String val = request.getParameter(paramName);
                                        if (val != null && !val.trim().isEmpty()) {
                                        try {
                                        double price = Double.parseDouble(val);
                                        rDao.updateRate(key, price);
                                        updated = true;
                                        } catch (NumberFormatException e) {
                                        // Ignore invalid numbers
                                        }
                                        }
                                        }
                                        rates = rDao.getAllRates(); // Refresh
                                        if (updated) {
                                        %>
                                        <div class="alert alert-success">
                                            <i class="fas fa-check"></i> All rates updated successfully!
                                        </div>
                                        <% } } %>

                                            <div class="card">
                                                <div class="card-header">
                                                    <h3 class="card-title">Current Market Prices (per kg)</h3>
                                                </div>
                                                <div class="card-body">
                                                    <form method="POST">
                                                        <table class="table table-bordered">
                                                            <thead>
                                                                <tr>
                                                                    <th>Item</th>
                                                                    <th>Current Price (RM)</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (rates.isEmpty()) { %>
                                                                    <tr>
                                                                        <td colspan="2" class="text-danger">No items
                                                                            found.</td>
                                                                    </tr>
                                                                    <% } else { for (Map.Entry<String, Double> entry :
                                                                        rates.entrySet()) {
                                                                        %>
                                                                        <tr>
                                                                            <td>
                                                                                <b>
                                                                                    <%= entry.getKey() %>
                                                                                </b>
                                                                            </td>
                                                                            <td>
                                                                                <div class="input-group">
                                                                                    <div class="input-group-prepend">
                                                                                        <span
                                                                                            class="input-group-text">RM</span>
                                                                                    </div>
                                                                                    <input type="number" step="0.01"
                                                                                        name="rate_<%= entry.getKey() %>"
                                                                                        class="form-control"
                                                                                        value="<%= String.format("%.2f", entry.getValue()) %>"
                                                                                    required>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                        <% } } %>
                                                            </tbody>
                                                        </table>

                                                        <% if (!rates.isEmpty()) { %>
                                                            <div class="card-footer text-right">
                                                                <button type="submit" class="btn btn-primary btn-lg">
                                                                    <i class="fas fa-save"></i> Save All Rates
                                                                </button>
                                                            </div>
                                                            <% } %>
                                                    </form>
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