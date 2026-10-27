<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.campusevent.DBUtil"%>
<%
    String userRole = (String) session.getAttribute("userRole");
    String userName = (String) session.getAttribute("userName");
    String cat = request.getParameter("cat");
    if (cat == null) cat = "All";
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Campus Event Portal | Chandigarh University</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <div class="nav-brand">UniVent<span>Portal</span></div>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <% if (userName == null) { %>
                <a href="login.jsp" class="btn btn-primary btn-sm">Sign In</a>
            <% } else if ("ADMIN".equals(userRole)) { %>
                <a href="admin.jsp">Admin Panel</a>
                <a href="<%= ctx %>/portal?action=logout" class="btn btn-outline btn-sm">Logout</a>
            <% } else { %>
                <a href="dashboard.jsp">My Dashboard</a>
                <a href="<%= ctx %>/portal?action=logout" class="btn btn-outline btn-sm">Logout (<%= userName.split(" ")[0] %>)</a>
            <% } %>
        </nav>
    </header>

    <div class="container">
        <% if (request.getParameter("msg") != null) { %><div class="alert alert-success"><%= request.getParameter("msg") %></div><% } %>
        <% if (request.getParameter("error") != null) { %><div class="alert alert-danger"><%= request.getParameter("error") %></div><% } %>

        <div class="hero">
            <h1>Chandigarh University Events</h1>
            <p>Discover hackathons, cultural festivals, workshops, and sports tournaments</p>
        </div>

        <div class="filters">
            <% String[] cats = {"All", "Technical", "Cultural", "Workshop", "Sports"};
               for (String c : cats) { %>
                <a href="index.jsp?cat=<%= c %>" class="pill <%= cat.equals(c) ? "active" : "" %>"><%= c %></a>
            <% } %>
        </div>

        <div class="grid">
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBUtil.getConnection();
                    String sql = "SELECT * FROM events " + (!"All".equals(cat) ? "WHERE category=? " : "") + "ORDER BY event_date ASC";
                    ps = conn.prepareStatement(sql);
                    if (!"All".equals(cat)) ps.setString(1, cat);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        int seatsLeft = rs.getInt("capacity") - rs.getInt("registered_count");
            %>
                <div class="card">
                    <div>
                        <span class="badge"><%= rs.getString("category") %></span>
                        <h3><%= rs.getString("title") %></h3>
                        <div class="meta">
                            <div>📅 <%= rs.getString("event_date") %> at <%= rs.getString("event_time") %></div>
                            <div>📍 <%= rs.getString("venue") %></div>
                            <div>👥 <%= rs.getInt("registered_count") %> / <%= rs.getInt("capacity") %> Enrolled (<%= seatsLeft %> seats left)</div>
                        </div>
                    </div>
                    <div>
                        <% if (seatsLeft <= 0) { %>
                            <button class="btn btn-outline btn-sm" disabled>Full</button>
                        <% } else if (userName == null) { %>
                            <a href="login.jsp" class="btn btn-primary btn-sm">Login to Register</a>
                        <% } else if ("STUDENT".equals(userRole)) { %>
                            <form action="<%= ctx %>/portal" method="POST" style="margin:0;">
                                <input type="hidden" name="action" value="register_event">
                                <input type="hidden" name="eventId" value="<%= rs.getInt("id") %>">
                                <button type="submit" class="btn btn-primary btn-sm">Register</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Database Connection Error. Check XAMPP MySQL!</p>");
                } finally {
                    DBUtil.close(rs, ps, conn);
                }
            %>
        </div>
    </div>
</body>
</html>
