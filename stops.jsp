<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Train Schedule System - Train Stops</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            color: black;
        }
        .content {
            background-color: lightgray;
            border-radius: 25px;
            border: 2px solid black;
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table th, table td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        table th {
            background-color: #f2f2f2;
        }
        .button {
            margin-top: 20px;
        }
        .button a {
            text-decoration: none;
            background-color: #4285F4;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
        }
        .button a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <h1>Train Stops</h1>
    <div class="content">
        <%
            String trainID = request.getParameter("trainNumber");
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            if (trainID == null || trainID.trim().isEmpty()) {
                out.println("<p>Invalid train number. <a href='trainView.jsp'>Go Back</a></p>");
            } else {
                try {
                    conn = (Connection) session.getAttribute("dbConnection");
                    if (conn == null || conn.isClosed()) {
                        throw new Exception("Database connection is not available. Please log in again.");
                    }

                    // Query to fetch all stops, including origin and destination
                    String query = "SELECT st.stationID, st.stationName, st.city, st.state, g.schedule_id " +
                                   "FROM goes g " +
                                   "JOIN stations st ON g.station_id = st.stationID " +
                                   "WHERE g.train_id = ? " +
                                   "ORDER BY st.stopNumber";
                    ps = conn.prepareStatement(query);
                    ps.setString(1, trainID);
                    rs = ps.executeQuery();

                    // Display stops in a table
                    out.println("<table>");
                    out.println("<thead><tr><th>Stop Number</th><th>Station Name</th><th>City</th><th>State</th></tr></thead>");
                    out.println("<tbody>");

                    boolean hasStops = false;
                    while (rs.next()) {
                        hasStops = true;
                        int stopNumber = rs.getInt("schedule_id");
                        String stationName = rs.getString("stationName");
                        String city = rs.getString("city");
                        String state = rs.getString("state");

                        out.println("<tr>");
                        out.println("<td>" + stopNumber + "</td>");
                        out.println("<td>" + stationName + "</td>");
                        out.println("<td>" + city + "</td>");
                        out.println("<td>" + state + "</td>");
                        out.println("</tr>");
                    }

                    if (!hasStops) {
                        out.println("<tr><td colspan='4'>No stops available for this train.</td></tr>");
                    }

                    out.println("</tbody>");
                    out.println("</table>");
                } catch (Exception e) {
                    out.println("<p>Error fetching stops: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
        <div class="button">
            <a href="trainView.jsp">Back to Train View</a>
        </div>
    </div>
</body>
</html>
