package com.campusevent;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Main Controller Servlet for Campus Event Portal.
 * Compatible with Apache Tomcat 11 (Jakarta EE).
 */
@WebServlet(name = "PortalServlet", urlPatterns = {"/portal"})
public class PortalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";

        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect("login.jsp?msg=Logged out successfully");
        } else if ("delete_event".equals(action)) {
            handleDeleteEvent(req, resp);
        } else {
            resp.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "login":
                handleLogin(req, resp);
                break;
            case "register":
                handleRegister(req, resp);
                break;
            case "add_event":
                handleAddEvent(req, resp);
                break;
            case "register_event":
                handleEventBooking(req, resp);
                break;
            case "cancel_registration":
                handleCancelRegistration(req, resp);
                break;
            default:
                resp.sendRedirect("index.jsp");
                break;
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String pass = req.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, pass);
            rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userRole", rs.getString("role"));
                session.setAttribute("rollNo", rs.getString("roll_no"));
                session.setAttribute("dept", rs.getString("department"));

                if ("ADMIN".equalsIgnoreCase(rs.getString("role"))) {
                    resp.sendRedirect("admin.jsp");
                } else {
                    resp.sendRedirect("dashboard.jsp");
                }
            } else {
                resp.sendRedirect("login.jsp?error=Invalid email or password");
            }
        } catch (SQLException e) {
            resp.sendRedirect("login.jsp?error=Database error: " + e.getMessage());
        } finally {
            DBUtil.close(rs, ps, conn);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String roll = req.getParameter("roll_no");
        String dept = req.getParameter("department");

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("INSERT INTO users (name, email, password, role, roll_no, department) VALUES (?, ?, ?, 'STUDENT', ?, ?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, pass);
            ps.setString(4, roll);
            ps.setString(5, dept);
            ps.executeUpdate();
            resp.sendRedirect("login.jsp?msg=Registration successful! Please login.");
        } catch (SQLException e) {
            resp.sendRedirect("login.jsp?error=Email or Roll No already registered!");
        } finally {
            DBUtil.close(ps, conn);
        }
    }

    private void handleAddEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect("login.jsp?error=Unauthorized access");
            return;
        }

        String title = req.getParameter("title");
        String cat = req.getParameter("category");
        String venue = req.getParameter("venue");
        String date = req.getParameter("event_date");
        String time = req.getParameter("event_time");
        int cap = Integer.parseInt(req.getParameter("capacity"));

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("INSERT INTO events (title, category, venue, event_date, event_time, capacity, registered_count) VALUES (?, ?, ?, ?, ?, ?, 0)");
            ps.setString(1, title);
            ps.setString(2, cat);
            ps.setString(3, venue);
            ps.setString(4, date);
            ps.setString(5, time);
            ps.setInt(6, cap);
            ps.executeUpdate();
            resp.sendRedirect("admin.jsp?msg=Event added successfully!");
        } catch (SQLException e) {
            resp.sendRedirect("admin.jsp?error=" + e.getMessage());
        } finally {
            DBUtil.close(ps, conn);
        }
    }

    private void handleDeleteEvent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.sendRedirect("login.jsp?error=Unauthorized access");
            return;
        }
        int eventId = Integer.parseInt(req.getParameter("id"));
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM events WHERE id=?");
            ps.setInt(1, eventId);
            ps.executeUpdate();
            resp.sendRedirect("admin.jsp?msg=Event deleted successfully!");
        } catch (SQLException e) {
            resp.sendRedirect("admin.jsp?error=" + e.getMessage());
        } finally {
            DBUtil.close(ps, conn);
        }
    }

    private void handleEventBooking(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp?error=Please login to register for events");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        int eventId = Integer.parseInt(req.getParameter("eventId"));

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            // Check capacity
            ps = conn.prepareStatement("SELECT capacity, registered_count FROM events WHERE id=?");
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt("registered_count") >= rs.getInt("capacity")) {
                resp.sendRedirect("dashboard.jsp?error=Event is full!");
                return;
            }
            ps.close();

            // Insert Registration
            ps = conn.prepareStatement("INSERT INTO registrations (user_id, event_id) VALUES (?, ?)");
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ps.executeUpdate();
            ps.close();

            // Increment count
            ps = conn.prepareStatement("UPDATE events SET registered_count = registered_count + 1 WHERE id=?");
            ps.setInt(1, eventId);
            ps.executeUpdate();

            resp.sendRedirect("dashboard.jsp?msg=Successfully registered for event!");
        } catch (SQLException e) {
            resp.sendRedirect("dashboard.jsp?error=Already registered for this event!");
        } finally {
            DBUtil.close(ps, conn);
        }
    }

    private void handleCancelRegistration(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        int eventId = Integer.parseInt(req.getParameter("eventId"));

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM registrations WHERE user_id=? AND event_id=?");
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            int rows = ps.executeUpdate();
            ps.close();

            if (rows > 0) {
                ps = conn.prepareStatement("UPDATE events SET registered_count = GREATEST(0, registered_count - 1) WHERE id=?");
                ps.setInt(1, eventId);
                ps.executeUpdate();
                resp.sendRedirect("dashboard.jsp?msg=Registration cancelled.");
            } else {
                resp.sendRedirect("dashboard.jsp?error=Registration not found.");
            }
        } catch (SQLException e) {
            resp.sendRedirect("dashboard.jsp?error=" + e.getMessage());
        } finally {
            DBUtil.close(ps, conn);
        }
    }
}
