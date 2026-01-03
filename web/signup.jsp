<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Greencycle | Sign Up</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/truck.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Icons + Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body.register-page {
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .register-box {
            width: 380px;
        }

        .login-logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .login-logo h3 {
            font-weight: 600;
            color: #28a745;
        }

        .card-wider {
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.11);
        }

        .register-card-body {
            padding: 25px;
        }

        .register-icon {
            font-size: 3.5rem;
            display: block;
            text-align: center;
            margin-bottom: 1rem;
            color: #28a745;
        }

        button.btn-green {
            background: #28a745;
            color: white;
            border: none;
            transition: 0.3s;
        }

        button.btn-green:hover {
            background: #218838;
            color: white;
        }
    </style>
</head>

<body class="register-page">

    <div class="register-box">

        <div class="login-logo">
            <div class="d-flex justify-content-center align-items-center gap-2">
                <img src="${pageContext.request.contextPath}/images/truck.png" alt="Greencycle Logo" width="40">
                <h3 class="mb-0">Greencycle</h3>
            </div>
            <small class="text-muted d-block mt-1">
                Community Recycling Collection System
            </small>
        </div>

        <div class="card card-wider">
            <div class="card-body register-card-body">
                
                <i class="bi bi-person-plus register-icon"></i>
                <p class="text-center text-muted mb-4">Create a new account</p>

                <form action="SignupServlet" method="POST">
                    <!-- Full Name -->
                    <div class="input-group mb-3">
                        <input type="text" name="fullName" class="form-control" placeholder="Full Name" required>
                        <div class="input-group-text">
                            <i class="bi bi-person"></i>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="input-group mb-3">
                        <input type="email" name="email" class="form-control" placeholder="Email" required>
                        <div class="input-group-text">
                            <i class="bi bi-envelope"></i>
                        </div>
                    </div>

                    <!-- Phone -->
                    <div class="input-group mb-3">
                        <input type="text" name="phoneNo" class="form-control" placeholder="Phone Number (e.g. 012...)" required>
                        <div class="input-group-text">
                            <i class="bi bi-telephone"></i>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="input-group mb-4">
                        <input type="password" name="password" class="form-control" id="regPass" placeholder="Password" required>
                        <div class="input-group-text">
                            <i class="bi bi-eye-slash" id="toggleRegPass" style="cursor:pointer;"></i>
                        </div>
                    </div>

                    <!-- Register Button -->
                    <div class="text-end">
                        <button type="submit" class="btn btn-green rounded-pill px-4 py-2 w-100">Register</button>
                    </div>
                </form>

                <div class="text-center mt-3">
                    <p class="small mb-0">Already have an account? <a href="index.jsp">Login</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        document.getElementById("toggleRegPass").onclick = function () {
            const pw = document.getElementById("regPass");
            if (pw.type === "password") {
                pw.type = "text";
                this.classList.replace("bi-eye-slash", "bi-eye");
            } else {
                pw.type = "password";
                this.classList.replace("bi-eye", "bi-eye-slash");
            }
        };
    </script>
</body>

</html>