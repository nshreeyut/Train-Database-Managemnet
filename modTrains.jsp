<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Train Schedule System</title>
        <style>
            body {
                background-color: lightblue;
                font-family: Arial, sans-serif;
                text-align: center;
                margin: 0;
                padding: 0;
            }
            h1 {
                color: black;
            }
            .center {
                margin: 0 auto;
                width: 90%;
                background-color: lightgray;
                border: 2px solid black;
                border-radius: 15px;
                padding: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
            }
            table th, table td {
                border: 1px solid black;
                padding: 10px;
                text-align: center;
            }
            table th {
                background-color: #f2f2f2;
            }
            .button {
                padding: 5px 10px;
                margin: 5px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <h1>Train Schedule System</h1>
        <div class="center">
            <h2>Available Train Schedules</h2>
            <table>
                <thead>
                    <tr>
                        <th>Train Number</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure Time</th>
                        <th>Arrival Time</th>
                        <th>Fare</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = (Connection) session.getAttribute("dbConnection");
                            if (conn == null || conn.isClosed()) {
                                throw new SQLException("Database connection is not available.");
                            }

                            String query = "SELECT * FROM schedule";
                            ps = conn.prepareStatement(query);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                int schedule_id = rs.getInt("schedule_id");
                                String trainID = rs.getString("train_id");
                                String origin = rs.getString("origin");
                                String destination = rs.getString("destination");
                                String departure_time = rs.getString("departure_time");
                                String arrival_time = rs.getString("arrival_time");
                                String fare = rs.getString("fare");
                    %>
                    <tr>
                        <td><%= trainID %></td>
                        <td><%= origin %></td>
                        <td><%= destination %></td>
                        <td><%= departure_time %></td>
                        <td><%= arrival_time %></td>
                        <td><%= fare %></td>
                        <td>
                            <form action="updateSchedule.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="schedule_id" value="<%= schedule_id %>">
                                <button type="submit" class="button">Update</button>
                            </form>
                            <form action="deleteSchedule.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="schedule_id" value="<%= schedule_id %>">
                                <button type="submit" class="button" style="background-color: red;">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (SQLException e) {
                            out.println("<tr><td colspan='7'>Error retrieving data: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>
        </div>

<div class="center">
    <h2>Add New Schedule</h2>
    <form action="addSchedule.jsp" method="post">
        <label for="train_id">Train ID:</label>
        <select name="train_id" id="train_id" required>
            <%-- Populate Train IDs dynamically --%>
            <% 
                try {
                    String trainQuery = "SELECT TrainID FROM trains";
                    ps = conn.prepareStatement(trainQuery);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        String trainID = rs.getString("TrainID");
            %>
            <option value="<%= trainID %>"><%= trainID %></option>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<option disabled>Error loading trains</option>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </select><br>

        <label for="origin">Origin:</label>
        <select name="origin" id="origin" required>
            <%-- Populate Stations for Origin dynamically --%>
            <% 
                try {
                    String stationQuery = "SELECT stationID, stationName FROM stations";
                    ps = conn.prepareStatement(stationQuery);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        String stationID = rs.getString("stationID");
                        String stationName = rs.getString("stationName");
            %>
            <option value="<%= stationName %>"><%= stationName %> (<%= stationID %>)</option>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<option disabled>Error loading stations</option>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </select><br>

        <label for="destination">Destination:</label>
        <select name="destination" id="destination" required>
            <%-- Populate Stations for Destination dynamically --%>
            <% 
                try {
                    String stationQuery = "SELECT stationID, stationName FROM stations";
                    ps = conn.prepareStatement(stationQuery);
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        String stationID = rs.getString("stationID");
                        String stationName = rs.getString("stationName");
            %>
            <option value="<%= stationName %>"><%= stationName %> (<%= stationID %>)</option>
            <%
                    }
                } catch (SQLException e) {
                    out.println("<option disabled>Error loading stations</option>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </select><br>

        <label for="departure_time">Departure Time:</label>
        <input type="datetime-local" id="departure_time" name="departure_time" required><br>

        <label for="arrival_time">Arrival Time:</label>
        <input type="datetime-local" id="arrival_time" name="arrival_time" required><br>

        <label for="fare">Fare:</label>
        <input type="number" id="fare" name="fare" step="0.01" required><br>

        <button type="submit" class="button">Add Schedule</button>
    </form>
    <form action="repDashboard.jsp" method="get" style="margin-top: 20px;">
        <button type="submit" class="button" style="background-color: gray;">Back</button>
    </form>
</div>

    </body>
</html>