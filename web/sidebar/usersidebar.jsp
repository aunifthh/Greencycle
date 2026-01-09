<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get currentPage from request attribute (set in dashboard.jsp or other pages)
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) {
        currentPage = "";
    }
%>

<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="brand-link">
        <img src="${pageContext.request.contextPath}/images/truck.png" 
             alt="Recycle Logo" 
             class="brand-image" />
        <span class="brand-text font-weight-light">Greencycle</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="info">
                <a class="d-block">
                    <i class="bi bi-person" style="margin-right: 3px;"></i> Customer
                </a>
            </div>
        </div>

        <!-- Sidebar Menu -->
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">

                <!-- Dashboard -->
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" 
                       class="nav-link <%= "dashboard".equals(currentPage) ? "active" : "" %>">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>Dashboard</p>
                    </a>
                </li>

                <!-- Pickup Requests -->
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/customer/pickups.jsp" 
                       class="nav-link <%= "pickups".equals(currentPage) ? "active" : "" %>">
                        <i class="nav-icon fas fa-truck"></i>
                        <p>Pickup Requests</p>
                    </a>
                </li>

                <!-- Profile Management -->
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/customer/profile.jsp" 
                       class="nav-link <%= "profile".equals(currentPage) ? "active" : "" %>">
                        <i class="nav-icon fas fa-user-cog"></i>
                        <p>Profile Management</p>
                    </a>
                </li>

            </ul>
        </nav>
        <!-- /.sidebar-menu -->
    </div>
</aside>

<!-- Bootstrap Icons (only needed if not already loaded in layout) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">