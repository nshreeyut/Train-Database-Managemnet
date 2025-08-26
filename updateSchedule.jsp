<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%
    String schedule_idParam = request.getParameter("schedule_id"); // From form
    if (schedule_idParam == null || schedule_idParam.isEmpty()) {
        throw new IllegalArgumentException("Schedule ID is missing or invalid.");
    }
    int schedule_id = Integer.parseInt(schedule_idParam);

    String arrival_time = request.getParameter("arrival_time");
    String fare = request.getParameter("fare");

    if (arrival_time == null || arrival_time.isEmpty() || fare == null || fare.isEmpty()) {
        throw new IllegalArgumentException("Arrival time or fare is missing or invalid.");
    }

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = (Connection) session.getAttribute("dbConnection");
        if (conn == null || conn.isClosed()) {
            throw new SQLException("Database connection is not available.");
        }

        String updateQuery = "UPDATE schedule SET arrival_time = ?, fare = ? WHERE schedule_id = ?";
        ps = conn.prepareStatement(updateQuery);
        ps.setString(1, "2024-12-10 " + arrival_time + ":00");
        ps.setBigDecimal(2, new BigDecimal(fare));
        ps.setInt(3, schedule_id);
        ps.executeUpdate();

        response.sendRedirect("modTrains.jsp");
    } catch (SQLException e) {
        out.println("Error updating schedule: " + e.getMessage());
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        // Do not close `conn` because it is shared in the session.
    }
%>
