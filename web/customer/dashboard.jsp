<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Greencycle.model.CustomerBean" %>
<%@ page import="Greencycle.dao.RequestDao" %>
<%@ page import="Greencycle.model.RequestBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>

<% 
    CustomerBean customer = (CustomerBean) session.getAttribute("user"); 
    String role = (String) session.getAttribute("role"); 
    
    if (customer == null || !"customer".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=1"); 
        return; 
    }
    
    request.setAttribute("currentPage", "dashboard");
    RequestDao rDao = new RequestDao();
    List<RequestBean> dashReqs = rDao.getRequestsByCustomer(customer.getCustomerID());
    
    int totalRequests = (dashReqs != null) ? dashReqs.size() : 0;
    double totalEarned = 0.0;
    int pendingRequests = 0;
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
    if (dashReqs != null) {
        for (RequestBean r : dashReqs) {
            double amount = rDao.getQuotationAmount(r.getRequestID());
            
            // Only count completed payments towards earned total
            if ("Payment Completed".equals(r.getStatus()) || "Completed".equals(r.getStatus())) {
                totalEarned += amount;
            }
            
            // Count active/pending requests
            // FIX: "Pending Payment" kept on one line
            if ("Pending Pickup".equals(r.getStatus()) || 
                "Pending".equals(r.getStatus()) || 
                "Pending Payment".equals(r.getStatus()) || 
                "Quoted".equals(r.getStatus()) || 
                "Verified".equals(r.getStatus())) {
                pendingRequests++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Dashboard | Greencycle</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app/dist/css/adminlte.min.css">
</head>

<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">

        <jsp:include page="/navbar/customernavbar.jsp" />
        <jsp:include page="/sidebar/customersidebar.jsp" />

        <div class="content-wrapper">
            <section class="content-header">
                <div class="container-fluid">
                    <h3>Welcome back, <%= customer.getFullName() %>!</h3>
                </div>
            </section>

            <section class="content">
                <div class="container-fluid">

                    <div class="row">
                        <div class="col-lg-4 col-6">
                            <div class="small-box bg-info">
                                <div class="inner">
                                    <h3><%= totalRequests %></h3>
                                    <p>Total Requests</p>
                                </div>
                                <div class="icon">
                                    <i class="fas fa-recycle"></i>
                                </div>
                                <a href="${pageContext.request.contextPath}/customer/pickups" class="small-box-footer">
                                    New Request <i class="fas fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div>

                        <div class="col-lg-4 col-6">
                            <div class="small-box bg-success">
                                <div class="inner">
                                    <h3>RM <%= df.format(totalEarned) %></h3>
                                    <p>Total Earned</p>
                                </div>
                                <div class="icon">
                                    <i class="fas fa-wallet"></i>
                                </div>
                                <div class="small-box-footer">&nbsp;</div>
                            </div>
                        </div>

                        <div class="col-lg-4 col-6">
                            <div class="small-box bg-warning">
                                <div class="inner">
                                    <h3><%= pendingRequests %></h3>
                                    <p>Pending Requests</p>
                                </div>
                                <div class="icon">
                                    <i class="fas fa-truck"></i>
                                </div>
                                <a href="${pageContext.request.contextPath}/customer/pickups" class="small-box-footer">
                                    Track Requests <i class="fas fa-arrow-circle-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title"><i class="fas fa-history mr-1"></i> Your Recent Requests</h3>
                                </div>
                                <div class="card-body">
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Items</th>
                                                <th>Location</th>
                                                <th>Qty</th>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Status</th>
                                                <th>Total (RM)</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                            if (dashReqs != null && !dashReqs.isEmpty()) {
                                                for (RequestBean r : dashReqs) {
                                                    StringBuilder itemList = new StringBuilder();
                                                    
                                                    // FIX: Strings kept on one line
                                                    if (r.getPlasticWeight() > 0) {
                                                        itemList.append("Plastic (" + df.format(r.getPlasticWeight()) + "kg)");
                                                    }
                                                    if (r.getPaperWeight() > 0) { 
                                                        if (itemList.length() > 0) itemList.append("<br>");
                                                        itemList.append("Paper (" + df.format(r.getPaperWeight()) + "kg)"); 
                                                    }
                                                    if (r.getMetalWeight() > 0) { 
                                                        if (itemList.length() > 0) itemList.append("<br>");
                                                        itemList.append("Metal (" + df.format(r.getMetalWeight()) + "kg)"); 
                                                    }
                                                    if (itemList.length() == 0) {
                                                        itemList.append("-");
                                                    }

                                                    double totalAmount = rDao.getQuotationAmount(r.getRequestID());
                                                    String status = r.getStatus();
                                                    String badgeClass;
                                                    
                                                    // FIX: Strings kept on one line
                                                    if ("Quoted".equals(status) || "Verified".equals(status)) { 
                                                        badgeClass = "badge-info"; 
                                                    } else if ("Pending Payment".equals(status) || "Pending".equals(status) || "Pending Pickup".equals(status)) { 
                                                        badgeClass = "badge-warning"; 
                                                    } else if ("Cancelled".equals(status) || "Quotation Rejected".equals(status)) { 
                                                        badgeClass = "badge-secondary"; 
                                                    } else if ("Completed".equals(status) || "Payment Completed".equals(status)) { 
                                                        badgeClass = "badge-success"; 
                                                    } else { 
                                                        badgeClass = "badge-danger"; 
                                                    }
                                            %>
                                            <tr>
                                                <td>REQ<%= r.getRequestID() %></td>
                                                <td><%= itemList.toString() %></td>
                                                <td><%= r.getFullAddress() != null ? r.getFullAddress() : "-" %></td>
                                                <td><%= df.format(r.getEstimatedWeight()) %></td>
                                                <td><%= r.getPickupDate() != null ? r.getPickupDate() : "-" %></td>
                                                <td><%= r.getPickupTime() != null ? r.getPickupTime() : "-" %></td>
                                                <td>
                                                    <span class="badge <%= badgeClass %>">
                                                        <%= "Verified".equals(status) ? "Quoted" : status %>
                                                    </span>
                                                </td>
                                                <td><%= df.format(totalAmount) %></td>
                                                <td>
                                                    <% if ("Quoted".equals(status)) { %>
                                                        <a href="${pageContext.request.contextPath}/customer/quotation.jsp?requestID=<%= r.getRequestID() %>" class="btn btn-info btn-sm">
                                                            <i class="fas fa-eye"></i> Quote
                                                        </a>
                                                    <%-- FIX: "Pending Pickup" on one line --%>
                                                    <% } else if ("Pending Pickup".equals(status)) { %>
                                                        <a href="${pageContext.request.contextPath}/customer/pickups" class="btn btn-warning btn-sm">
                                                            <i class="fas fa-truck"></i> Track
                                                        </a>
                                                    <% } else { %>
                                                        <a href="${pageContext.request.contextPath}/customer/pickups" class="btn btn-secondary btn-sm">
                                                            <i class="fas fa-list"></i> View
                                                        </a>
                                                    <% } %>
                                                </td>
                                            </tr>
                                            <% 
                                                } 
                                            } else { 
                                            %>
                                            <tr>
                                                <td colspan="9" class="text-center">No recent requests</td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </section>
        </div>

        <jsp:include page="/footer/footer.jsp" />

        <script src="${pageContext.request.contextPath}/app/plugins/jquery/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/app/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/app/dist/js/adminlte.min.js"></script>
    </div>
</body>
</html>