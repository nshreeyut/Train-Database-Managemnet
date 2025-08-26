<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Reservations</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
        }
        .container {
            width: 80%;
            margin: auto;
            background-color: lightgray;
            padding: 20px;
            border-radius: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        select, input, button {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid black;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table th, table td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        table th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Admin - View Reservations</h1>
    <div class="container">
        <h2>Filter Reservations</h2>
        <form method="post">
            <div class="form-group">
                <label for="transit-line">Transit Line:</label>
                <select id="transit-line" name="transitLine">
                    <option value="">All</option>
                    <option value="Northeast Corridor">Northeast Corridor</option>
                    <option value="Coast Line">Coast Line</option>
                    <option value="Hudson Line">Hudson Line</option>
                </select>
            </div>
            <div class="form-group">
                <label for="customer-name">Customer Name:</label>
                <input type="text" id="customer-name" name="customerName" placeholder="Enter customer name">
            </div>
            <button type="submit" name="action" value="filter">Filter</button>
        </form>

        <h2>Reservations</h2>
        <table>
            <thead>
                <tr>
                    <th>Reservation ID</th>
                    <th>Transit Line</th>
                    <th>Customer Name</th>
                    <th>Date</th>
                    <th>Total Fare</th>
                    <th>Trip Type</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    String transitLine = request.getParameter("transitLine");
                    String customerName = request.getParameter("customerName");

                    try {
                        conn = (Connection) session.getAttribute("dbConnection");
                        if (conn == null || conn.isClosed()) {
                            throw new Exception("Database connection is not available. Please log in again.");
                        }

                        String query = "SELECT r.reservation_id, t.TransitLineName, CONCAT(c.fname, ' ', c.lname) AS customer_name, r.date, r.total_fare, r.trip_type " +
                                       "FROM reservations r " +
                                       "JOIN customers c ON r.passenger_id = c.username " +
                                       "JOIN schedule s ON r.schedule_id = s.schedule_id " +
                                       "JOIN trains t ON s.train_id = t.TrainID WHERE 1=1 ";

                        if (transitLine != null && !transitLine.isEmpty()) {
                            query += "AND t.TransitLineName = ? ";
                        }
                        if (customerName != null && !customerName.isEmpty()) {
                            query += "AND CONCAT(c.fname, ' ', c.lname) LIKE ? ";
                        }

                        ps = conn.prepareStatement(query);
                        int paramIndex = 1;
                        if (transitLine != null && !transitLine.isEmpty()) {
                            ps.setString(paramIndex++, transitLine);
                        }
                        if (customerName != null && !customerName.isEmpty()) {
                            ps.setString(paramIndex++, "%" + customerName + "%");
                        }

                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int reservationId = rs.getInt("reservation_id");
                            String lineName = rs.getString("TransitLineName");
                            String name = rs.getString("customer_name");
                            String date = rs.getString("date");
                            double totalFare = rs.getDouble("total_fare");
                            String tripType = rs.getString("trip_type");
                %>
                <tr>
                    <td><%= reservationId %></td>
                    <td><%= lineName %></td>
                    <td><%= name %></td>
                    <td><%= date %></td>
                    <td>$<%= totalFare %></td>
                    <td><%= tripType %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>