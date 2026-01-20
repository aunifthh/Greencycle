<% String currentPage=(String) request.getAttribute("currentPage"); String currentSub=(String)
    request.getAttribute("currentSub"); %>
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="brand-link">
            <img src="${pageContext.request.contextPath}/images/truck.png" alt="Logo" class="brand-image" />
            <span class="brand-text font-weight-light">Greencycle</span>
        </a>
        <div class="sidebar">
            <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                <div class="info">
                    <a class="d-block"><i class="fas fa-user-shield mr-2"></i> Admin </a>
                </div>
            </div>
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="nav-link">
                            <i class="nav-icon fas fa-tachometer-alt"></i>
                            <p>Dashboard</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/RequestServlet?action=list" class="nav-link">
                            <i class="nav-icon fas fa-truck"></i>
                            <p>Request Management</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin/ratemgmt.jsp" class="nav-link">
                            <i class="nav-icon fas fa-dollar-sign"></i>
                            <p>Rate Management</p>
                        </a>
                    </li>
                    <li class="nav-item has-treeview">
                        <a href="#" class="nav-link">
                            <i class="nav-icon fas fa-users"></i>
                            <p>Users <i class="right fas fa-angle-left"></i></p>
                        </a>
                        <ul class="nav nav-treeview">
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/StaffMgmtServlet?action=list"
                                    class="nav-link">
                                    <i class="far fa-circle nav-icon"></i>
                                    <p>Staff</p>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/CustomerMgmtServlet?action=list"
                                    class="nav-link">
                                    <i class="far fa-circle nav-icon"></i>
                                    <p>Customer</p>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </div>
    </aside>