<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="brand-link">
            <img src="${pageContext.request.contextPath}/images/truck.png" alt="Logo" class="brand-image" />
            <span class="brand-text font-weight-light">Greencycle</span>
        </a>
        <div class="sidebar">
            <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                <div class="info">
                    <a class="d-block"><i class="fas fa-user mr-2"></i> Customer</a>
                </div>
            </div>
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="nav-link">
                            <i class="nav-icon fas fa-tachometer-alt"></i>
                            <p>Dashboard</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/customer/pickups.jsp" class="nav-link">
                            <i class="nav-icon fas fa-truck"></i>
                            <p>Pickup Request</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/customer/profile" class="nav-link">
                            <i class="nav-icon fas fa-user-cog"></i>
                            <p>Profile Management</p>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </aside>