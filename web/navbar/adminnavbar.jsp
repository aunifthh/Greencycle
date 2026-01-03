<%@page import="Greencycle.model.StaffBean"%>
<%
    StaffBean admin = (StaffBean) session.getAttribute("staff");
    String name = (admin != null) ? admin.getStaffName() : "Admin";
%>
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
    <ul class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
        </li>
    </ul>

    <ul class="navbar-nav ml-auto">
        <li class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <i class="fas fa-user"></i>&nbsp; <%= name %>
            </a>
            <div class="dropdown-menu dropdown-menu-right">
                <a href="#" id="logoutBtn" class="dropdown-item text-danger">
                    <i class="fas fa-sign-out-alt mr-2"></i> Logout
                </a>
            </div>
        </li>
    </ul>
</nav>

<!-- Logout Script -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.getElementById("logoutBtn").addEventListener("click", function (e) {
        e.preventDefault(); 
        Swal.fire({
            title: "Log Out?",
            text: "Are you sure you want to end your session?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#d33",
            confirmButtonText: "Yes, Logout"
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "${pageContext.request.contextPath}/LogoutServlet";
            }
        });
    });
</script>