<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
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
            text-align: center;
        }
        .center {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        div {
            width: 80%;
            padding: 20px;
            margin: 20px auto;
            text-align: center;
            background-color: lightgray;
            border: 2px solid black;
            border-radius: 25px;
        }
        fieldset {
            border: none;
            margin: auto;
        }
        .spacing {
            line-height: 1.5;
        }
        .margin {
            margin-top: 5px;
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
        .footer {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 50px;
            background-color: lightgray;
            border: 2px solid black;
            border-radius: 35px;
            width: 80%;
            margin: 20px auto;
        }
        .footer button {
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            text-align: center;
            cursor: pointer;
            font-size: 14px;
        }
        .footer button:hover {
            background-color: #0056b3;
        }
    </style>
    <head>
        <title>Train Schedule System</title>
    </head>
    <body>
        <h1>Train Schedule System</h1>
        <div class="center">
            <!-- Search Form -->
            <fieldset class="spacing">
                <form action="trainView.jsp" method="get">
                    <label for="origin">Origin:</label>
                    <input type="text" id="origin" name="origin"><br>
                    <label for="destination">Destination:</label>
                    <input type="text" id="destination" name="destination"><br>
                    <label for="travelDate">Date of Travel:</label>
                    <input type="date" id="travelDate" name="travelDate"><br>
                    <input class="margin" type="submit" value="Search">
                </form>
            </fieldset>
            
            <!-- Sort Form -->
            <fieldset class="spacing">
                <form action="trainView.jsp" method="get">
                    <label for="sortBy">Sort By:</label>
                    <select id="sortBy" name="sortBy">
                        <option value="departure" <%= "departure".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Departure Time</option>
                        <option value="arrival" <%= "arrival".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Arrival Time</option>
                        <option value="fare" <%= "fare".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Fare</option>
                    </select>
                    <input class="margin" type="submit" value="Sort">
                </form>
            </fieldset>

            <!-- Show All Form -->
            <form action="trainView.jsp" method="get">
                <input type="hidden" name="showAll" value="true">
                <input class="margin" type="submit" value="Show All Trains">
            </form>

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
                        <th>Stops</th>
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
                                throw new Exception("Database connection is not available. Please log in again.");
                            }

                            String origin = request.getParameter("origin");
                            String destination = request.getParameter("destination");
                            String travelDate = request.getParameter("travelDate");
                            String sortBy = request.getParameter("sortBy");
                            String showAll = request.getParameter("showAll");

                            // Determine sorting column
                            String sortColumn = "s.departure_time"; // Default sort column
                            if ("arrival".equals(sortBy)) {
                                sortColumn = "s.arrival_time";
                            } else if ("fare".equals(sortBy)) {
                                sortColumn = "s.fare";
                            }

                            // Build query dynamically based on parameters
                            StringBuilder query = new StringBuilder(
                                "SELECT t.TrainID, s.origin, s.destination, s.departure_time, s.arrival_time, s.fare " +
                                "FROM schedule s JOIN trains t ON s.train_id = t.TrainID WHERE 1=1"
                            );

                            // Apply filters if not showing all trains
                            if (showAll == null || !"true".equals(showAll)) {
                                if (origin != null && !origin.trim().isEmpty()) {
                                    query.append(" AND s.origin LIKE ?");
                                }
                                if (destination != null && !destination.trim().isEmpty()) {
                                    query.append(" AND s.destination LIKE ?");
                                }
                                if (travelDate != null && !travelDate.trim().isEmpty()) {
                                    query.append(" AND DATE(s.departure_time) = ?");
                                }
                            }

                            // Add sorting
                            query.append(" ORDER BY ").append(sortColumn);

                            ps = conn.prepareStatement(query.toString());

                            int paramIndex = 1;
                            if (showAll == null || !"true".equals(showAll)) {
                                if (origin != null && !origin.trim().isEmpty()) {
                                    ps.setString(paramIndex++, "%" + origin + "%");
                                }
                                if (destination != null && !destination.trim().isEmpty()) {
                                    ps.setString(paramIndex++, "%" + destination + "%");
                                }
                                if (travelDate != null && !travelDate.trim().isEmpty()) {
                                    ps.setString(paramIndex++, travelDate);
                                }
                            }

                            rs = ps.executeQuery();

                            // Loop through results and dynamically generate table rows
                            while (rs.next()) {
                                String trainID = rs.getString("TrainID");
                                String originResult = rs.getString("origin");
                                String destinationResult = rs.getString("destination");
                                String departureTime = rs.getString("departure_time");
                                String arrivalTime = rs.getString("arrival_time");
                                String fare = rs.getString("fare");
                    %>
                    <tr>
                        <td><%= trainID %></td>
                        <td><%= originResult %></td>
                        <td><%= destinationResult %></td>
                        <td><%= departureTime %></td>
                        <td><%= arrivalTime %></td>
                        <td>$<%= fare %></td>
                        <td><a href="stops.jsp?trainNumber=<%= trainID %>">View Stops</a></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7'>Error retrieving data: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <!-- Footer Section -->
        <div class="footer">
            <form action="userDashboard.jsp" method="get">
                <button type="submit" class="main-menu">Main Menu</button>
            </form>
            <form action="reservation.jsp" method="get">
                <button type="submit" class="main-menu">Make Reservation</button>
            </form>
        </div>
    </body>
</html>
