<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign In / Register | UniVentPortal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <div class="nav-brand">UniVent<span>Portal</span></div>
        <nav class="nav-links"><a href="index.jsp">Back to Home</a></nav>
    </header>

    <div class="container">
        <div class="form-card">
            <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
            <% if (request.getParameter("error") != null) { %><div class="alert alert-danger"><%= request.getParameter("error") %></div><% } %>

            <div style="display:flex; gap:0.5rem; margin-bottom:1.5rem; border-bottom:1px solid #e2e8f0; padding-bottom:0.5rem;">
                <button type="button" class="btn btn-outline btn-sm" id="btnLoginTab" onclick="showForm('login')">Sign In</button>
                <button type="button" class="btn btn-outline btn-sm" id="btnRegTab" onclick="showForm('reg')">Student Sign Up</button>
            </div>

            <!-- Login Form -->
            <form id="formLogin" action="${pageContext.request.contextPath}/portal" method="POST" onsubmit="return validateLogin()">
                <input type="hidden" name="action" value="login">
                <div class="form-group"><label>Email Address</label><input type="email" name="email" id="logEmail" class="form-control" required placeholder="name@cu.edu.in"></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" id="logPass" class="form-control" required placeholder="••••••••"></div>
                <button type="submit" class="btn btn-primary" style="width:100%;">Sign In</button>
                <div style="margin-top:1rem; font-size:0.8rem; background:#f1f5f9; padding:0.6rem; border-radius:6px;">
                    <strong>Demo Accounts:</strong><br>
                    <a href="javascript:void(0)" onclick="fill('admin@cu.edu.in','admin123')">Fill Admin</a> | 
                    <a href="javascript:void(0)" onclick="fill('arpit@cu.edu.in','student123')">Fill Student</a>
                </div>
            </form>

            <!-- Registration Form -->
            <form id="formReg" action="${pageContext.request.contextPath}/portal" method="POST" style="display:none;" onsubmit="return validateReg()">
                <input type="hidden" name="action" value="register">
                <div class="form-group"><label>Full Name</label><input type="text" name="name" id="regName" class="form-control" required></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" id="regEmail" class="form-control" required></div>
                <div class="form-group"><label>Roll Number</label><input type="text" name="roll_no" id="regRoll" class="form-control" placeholder="23MCA1001" required></div>
                <div class="form-group"><label>Department</label><input type="text" name="department" class="form-control" placeholder="MCA Data Science" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" id="regPass" class="form-control" required></div>
                <button type="submit" class="btn btn-primary" style="width:100%;">Create Account</button>
            </form>
        </div>
    </div>

    <script>
        function showForm(type) {
            document.getElementById('formLogin').style.display = type === 'login' ? 'block' : 'none';
            document.getElementById('formReg').style.display = type === 'reg' ? 'block' : 'none';
        }
        function fill(e, p) {
            document.getElementById('logEmail').value = e;
            document.getElementById('logPass').value = p;
        }
        function validateLogin() {
            return document.getElementById('logEmail').value.trim() !== "" && document.getElementById('logPass').value.trim() !== "";
        }
        function validateReg() {
            if (document.getElementById('regPass').value.length < 6) {
                alert("Password must be at least 6 characters!");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
