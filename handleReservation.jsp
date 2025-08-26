<%@ page import="java.sql.*" %>
<%
    // HttpSession session = request.getSession();
    Connection conn = (Connection) session.getAttribute("dbConnection");
    String query = "SELECT username FROM customers WHERE username = ? AND password = ?";
    PreparedStatement ps = conn.prepareStatement(query);
    ps.setString(1, request.getParameter("username"));
    ps.setString(2, request.getParameter("password"));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        String username = rs.getString("username");
        session.setAttribute("username", username);
        response.sendRedirect("dashboard.jsp");
    } else {
        out.println("<p>Invalid credentials. Please try again.</p>");
    }

    String passengerId = (String) session.getAttribute("username");

    out.println("<p>Debug: dbConnection = " + conn + "</p>");
    out.println("<p>Debug: username = " + passengerId + "</p>");

    String trainRoute = request.getParameter("trainRoute");
    String tripType = request.getParameter("tripType");
    String reservationDate = request.getParameter("reservationDate");

    PreparedStatement psInsert = null;
    try {
        String insertQuery = "INSERT INTO reservations (schedule_id, passenger_id, date, trip_type, total_fare) " +
                             "VALUES (?, ?, ?, ?, ?)";
        psInsert = conn.prepareStatement(insertQuery);

        int scheduleId = 1; // Example value
        double totalFare = 20.0; // Example value

        psInsert.setInt(1, scheduleId);
        psInsert.setString(2, passengerId);
        psInsert.setString(3, reservationDate);
        psInsert.setString(4, tripType);
        psInsert.setDouble(5, totalFare);

        int rowsAffected = psInsert.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<p>Reservation successfully created!</p>");
        } else {
            out.println("<p>Failed to create reservation. Please try again.</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (psInsert != null) psInsert.close();
    }
%>
