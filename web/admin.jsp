<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.campusevent.DBUtil"%>
<%
    String userRole = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(userRole)) {
        response.sendRedirect("login.jsp?error=Admin access required");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Console | UniVentPortal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <div class="nav-brand">UniVent<span>Admin</span></div>
        <nav class="nav-links">
            <a href="index.jsp">Public View</a>
            <a href="admin.jsp">Admin Panel</a>
            <a href="<%= ctx %>/portal?action=logout" class="btn btn-outline btn-sm">Logout</a>
        </nav>
    </header>

    <div class="container">
        <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
        <% if (request.getParameter("error") != null) { %><div class="alert alert-danger"><%= request.getParameter("error") %></div><% } %>

        <h2>Campus Event Administration</h2>
        <p style="color:#64748b; margin-bottom:1.5rem;">Create, delete events and monitor student registrations in real-time.</p>

        <!-- Add Event Form -->
        <div class="card" style="margin-bottom:2rem;">
            <h3 style="margin-bottom:1rem;">Add New Campus Event</h3>
            <form action="<%= ctx %>/portal" method="POST">
                <input type="hidden" name="action" value="add_event">
                <div style="display:grid; grid-template-columns: 2fr 1fr 1fr; gap:1rem; margin-bottom:1rem;">
                    <div><label style="font-size:0.8rem; font-weight:600;">Event Title</label><input type="text" name="title" class="form-control" placeholder="Hackathon 2026" required></div>
                    <div><label style="font-size:0.8rem; font-weight:600;">Category</label>
                        <select name="category" class="form-control" required>
                            <option>Technical</option><option>Cultural</option><option>Workshop</option><option>Sports</option>
                        </select>
                    </div>
                    <div><label style="font-size:0.8rem; font-weight:600;">Max Capacity</label><input type="number" name="capacity" class="form-control" value="50" min="1" required></div>
                </div>
                <div style="display:grid; grid-template-columns: 2fr 1fr 1fr; gap:1rem; margin-bottom:1rem;">
                    <div><label style="font-size:0.8rem; font-weight:600;">Venue Location</label><input type="text" name="venue" class="form-control" placeholder="Seminar Hall 3" required></div>
                    <div><label style="font-size:0.8rem; font-weight:600;">Date</label><input type="date" name="event_date" class="form-control" required></div>
                    <div><label style="font-size:0.8rem; font-weight:600;">Time</label><input type="text" name="event_time" class="form-control" placeholder="10:00 AM" required></div>
                </div>
                <button type="submit" class="btn btn-primary btn-sm">+ Publish Event</button>
            </form>
        </div>

        <!-- Manage Events Table -->
        <h3 style="margin-bottom:1rem;">Manage Active Events</h3>
        <div class="table-card">
            <table>
                <thead>
                    <tr><th>Title</th><th>Category</th><th>Date & Time</th><th>Venue</th><th>Enrolled</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        Statement st = null;
                        ResultSet rs = null;
                        try {
                            conn = DBUtil.getConnection();
                            st = conn.createStatement();
                            rs = st.executeQuery("SELECT * FROM events ORDER BY event_date ASC");
                            while (rs.next()) {
                    %>
                        <tr>
                            <td><strong><%= rs.getString("title") %></strong></td>
                            <td><span class="badge"><%= rs.getString("category") %></span></td>
                            <td><%= rs.getString("event_date") %> (<%= rs.getString("event_time") %>)</td>
                            <td><%= rs.getString("venue") %></td>
                            <td><%= rs.getInt("registered_count") %> / <%= rs.getInt("capacity") %></td>
                            <td>
                                <a href="<%= ctx %>/portal?action=delete_event&id=<%= rs.getInt("id") %>" 
                                   class="btn btn-danger btn-sm" 
                                   onclick="return confirm('Delete event: <%= rs.getString("title") %>?');">Delete</a>
                            </td>
                        </tr>
                    <%      }
                        } catch(Exception e) { out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>"); }
                        finally { DBUtil.close(rs, st, conn); }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Student Registrations Master Roster -->
        <h3 style="margin-bottom:1rem;">Registered Students Roster</h3>
        <div class="table-card">
            <table>
                <thead>
                    <tr><th>Student Name</th><th>Roll No</th><th>Department</th><th>Event Title</th><th>Registration Date</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            conn = DBUtil.getConnection();
                            st = conn.createStatement();
                            rs = st.executeQuery("SELECT u.name, u.roll_no, u.department, e.title, r.reg_date FROM registrations r JOIN users u ON r.user_id=u.id JOIN events e ON r.event_id=e.id ORDER BY r.reg_date DESC");
                            while (rs.next()) {
                    %>
                        <tr>
                            <td><strong><%= rs.getString("name") %></strong></td>
                            <td><code><%= rs.getString("roll_no") %></code></td>
                            <td><%= rs.getString("department") %></td>
                            <td><%= rs.getString("title") %></td>
                            <td><%= rs.getTimestamp("reg_date") %></td>
                        </tr>
                    <%      }
                        } catch(Exception e) { out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>"); }
                        finally { DBUtil.close(rs, st, conn); }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
