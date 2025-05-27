<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String campaignId = request.getParameter("campaignId");
    if (campaignId == null) {
        response.sendRedirect("errorPage.jsp?error=Invalid campaign.");
        return;
    }
%>
<html>
<head>
    <title>Donation Form</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f3f4ff;
            padding: 40px;
            color: #333;
        }

        h2 {
            text-align: center;
            color: #5a4fcf;
            margin-bottom: 30px;
        }

        form {
            max-width: 500px;
            margin: auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(90, 79, 207, 0.1);
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #bfb6ff;
            border-radius: 8px;
            background-color: #f7f6ff;
            transition: border-color 0.3s ease;
        }

        input:focus, select:focus {
            border-color: #5a4fcf;
            background-color: #ffffff;
            outline: none;
        }

        button {
            width: 100%;
            background-color: #5a4fcf;
            color: #ffffff;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background-color: #483db0;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: -15px;
            margin-bottom: 10px;
        }
    </style>

    <script>
        function togglePaymentField() {
            const method = document.getElementById("method").value;
            const upiDiv = document.getElementById("upiField");
            const cardDiv = document.getElementById("cardField");

            upiDiv.style.display = method === "UPI" ? "block" : "none";
            cardDiv.style.display = method === "Card" ? "block" : "none";
        }

        function validateForm() {
            const amount = document.getElementById("amount").value.trim();
            const method = document.getElementById("method").value;
            const upiId = document.getElementById("upi_id").value.trim();
            const cardNo = document.getElementById("card_no").value.trim();

            if (amount === "" || isNaN(amount) || Number(amount) <= 0) {
                alert("Please enter a valid donation amount.");
                return false;
            }

            if (method === "") {
                alert("Please select a payment method.");
                return false;
            }

            if (method === "UPI" && upiId === "") {
                alert("Please enter your UPI ID.");
                return false;
            }

            if (method === "Card") {
                if (cardNo === "" || !/^\d{16}$/.test(cardNo)) {
                    alert("Please enter a valid 16-digit card number.");
                    return false;
                }
            }

            return true;
        }
    </script>
</head>
<body>
    <h2>Donate to Campaign</h2>
    <form action="DonateServlet" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="campaignId" value="<%= campaignId %>">

        <label for="amount">Enter Donation Amount:</label>
        <input type="text" id="amount" name="amount" required>

        <label for="method">Select Payment Method:</label>
        <select name="method" id="method" onchange="togglePaymentField()" required>
            <option value="">-- Select --</option>
            <option value="UPI">UPI</option>
            <option value="Card">Card</option>
        </select>

        <div id="upiField" style="display:none;">
            <label for="upi_id">UPI ID:</label>
            <input type="text" id="upi_id" name="upi_id" placeholder="e.g. yourname@upi">
        </div>

        <div id="cardField" style="display:none;">
            <label for="card_no">Card Number:</label>
            <input type="text" id="card_no" name="card_no" placeholder="16-digit card number">
        </div>

        <button type="submit">Donate</button>
    </form>
</body>
</html>
