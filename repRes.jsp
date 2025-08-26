<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Representative Reservations</title>
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
    <h1>Representative - View Customers with Reservations</h1>
    <div class="container">
        <h2>Filter by Transit Line and Date</h2>
        <form method="post">
            <div class="form-group">
                <label for="transit-line">Transit Line:</label>
                <select id="transit-line" name="transitLine">
                    <option value="">Select Transit Line</option>
                    <option value="Northeast Corridor Line">Northeast Corridor Line</option>
                    <option value="North Jersey Coast Line">North Jersey Coast Line</option>
                    <option value="Raritan Valley Line">Raritan Valley Line</option>
                </select>
            </div>
            <div class="form-group">
                <label for="reservation-date">Date:</label>
                <input type="date" id="reservation-date" name="reservationDate" required>
            </div>
            <button type="submit" name="action" value="filter">Filter</button>
        </form>

        <h2>Customers with Reservations</h2>
        <table>
            <thead>
                <tr>
                    <th>Customer Name</th>
                    <th>Email</th>
                    <th>Transit Line</th>
                    <th>Reservation Date</th>
                    <th>Trip Type</th>
                    <th>Discount</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    String transitLine = request.getParameter("transitLine");
                    String reservationDate = request.getParameter("reservationDate");

                    try {
                        conn = (Connection) session.getAttribute("dbConnection");
                        if (conn == null || conn.isClosed()) {
                            throw new Exception("Database connection is not available. Please log in again.");
                        }

                        String query = "SELECT CONCAT(c.fname, ' ', c.lname) AS customer_name, " +
                                       "c.username AS email, t.TransitLineName, r.date, " +
                                       "r.trip_type, r.discount_type " +
                                       "FROM reservations r " +
                                       "JOIN customers c ON r.passenger_id = c.username " +
                                       "JOIN trains t ON t.TrainID IN (SELECT train_id FROM schedule WHERE schedule.schedule_id = r.reservation_id) " +
                                       "WHERE 1=1 ";

                        if (transitLine != null && !transitLine.isEmpty()) {
                            query += "AND t.TransitLineName = ? ";
                        }
                        if (reservationDate != null && !reservationDate.isEmpty()) {
                            query += "AND DATE(r.date) = ? ";
                        }

                        ps = conn.prepareStatement(query);
                        int paramIndex = 1;
                        if (transitLine != null && !transitLine.isEmpty()) {
                            ps.setString(paramIndex++, transitLine);
                        }
                        if (reservationDate != null && !reservationDate.isEmpty()) {
                            ps.setString(paramIndex++, reservationDate);
                        }

                        rs = ps.executeQuery();

                        while (rs.next()) {
                            String customerName = rs.getString("customer_name");
                            String email = rs.getString("email");
                            String lineName = rs.getString("TransitLineName");
                            String date = rs.getString("date");
                            String tripType = rs.getString("trip_type");
                            String discount = rs.getString("discount_type");
                %>
                <tr>
                    <td><%= customerName %></td>
                    <td><%= email %></td>
                    <td><%= lineName %></td>
                    <td><%= date %></td>
                    <td><%= tripType %></td>
                    <td><%= discount %></td>
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
        <form action="repDashboard.jsp" method="get" style="margin-top: 20px;">
    <button type="submit" class="button" style="background-color: gray;">Back</button>
</form>

    </div>
</body>
</html>
