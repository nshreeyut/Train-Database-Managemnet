<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
    String train_id = request.getParameter("train_id");
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String departure_time = request.getParameter("departure_time");
    String arrival_time = request.getParameter("arrival_time");
    String fare = request.getParameter("fare");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = (Connection) session.getAttribute("dbConnection");
        if (conn == null || conn.isClosed()) {
            throw new SQLException("Database connection is not available.");
        }

        String insertQuery = "INSERT INTO schedule (train_id, origin, destination, departure_time, arrival_time, fare) VALUES (?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(insertQuery);
        ps.setString(1, train_id);
        ps.setString(2, origin);
        ps.setString(3, destination);
        ps.setString(4, departure_time);
        ps.setString(5, arrival_time);
        ps.setBigDecimal(6, new BigDecimal(fare));
        ps.executeUpdate();

        response.sendRedirect("modTrains.jsp");
    } catch (SQLException e) {
        out.println("Error adding schedule: " + e.getMessage());
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
