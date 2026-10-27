<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.campusevent.DBUtil"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String rollNo = (String) session.getAttribute("rollNo");
    String dept = (String) session.getAttribute("dept");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard | UniVentPortal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <div class="nav-brand">UniVent<span>Portal</span></div>
        <nav class="nav-links">
            <a href="index.jsp">Browse Events</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="<%= ctx %>/portal?action=logout" class="btn btn-outline btn-sm">Logout</a>
        </nav>
    </header>

    <div class="container">
        <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
        <% if (request.getParameter("error") != null) { %><div class="alert alert-danger"><%= request.getParameter("error") %></div><% } %>

        <div class="hero" style="text-align:left; padding:2rem;">
            <h2>Welcome, <%= userName %>!</h2>
            <p>Roll No: <strong><%= rollNo %></strong> &bull; Department: <%= dept %></p>
        </div>

        <h3 style="margin-bottom:1rem;">My Registered Activities</h3>
        <div class="table-card">
            <table>
                <thead>
                    <tr><th>Event Title</th><th>Category</th><th>Date & Time</th><th>Venue</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        boolean hasReg = false;
                        try {
                            conn = DBUtil.getConnection();
                            String sql = "SELECT e.* FROM registrations r JOIN events e ON r.event_id=e.id WHERE r.user_id=? ORDER BY e.event_date ASC";
                            ps = conn.prepareStatement(sql);
                            ps.setInt(1, userId);
                            rs = ps.executeQuery();
                            while (rs.next()) {
                                hasReg = true;
                    %>
                        <tr>
                            <td><strong><%= rs.getString("title") %></strong></td>
                            <td><span class="badge"><%= rs.getString("category") %></span></td>
                            <td><%= rs.getString("event_date") %> (<%= rs.getString("event_time") %>)</td>
                            <td><%= rs.getString("venue") %></td>
                            <td>
                                <form action="<%= ctx %>/portal" method="POST" onsubmit="return confirm('Cancel this registration?');" style="margin:0;">
                                    <input type="hidden" name="action" value="cancel_registration">
                                    <input type="hidden" name="eventId" value="<%= rs.getInt("id") %>">
                                    <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                                </form>
                            </td>
                        </tr>
                    <%      }
                            if (!hasReg) {
                                out.println("<tr><td colspan='5' style='text-align:center;'>You have not registered for any events yet. <a href='index.jsp'>Browse Events</a></td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' style='color:red;'>Error loading registrations</td></tr>");
                        } finally {
                            DBUtil.close(rs, ps, conn);
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
