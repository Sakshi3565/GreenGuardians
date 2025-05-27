<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Assign Staff to Campaign</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f9f9f9;
        }

        h2 {
            color: #333;
        }

        form {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            width: 400px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        label {
            font-weight: bold;
        }

        select, button {
            width: 100%;
            padding: 8px;
            margin: 10px 0 20px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #28a745;
            color: white;
            border: none;
        }

        .message {
            font-weight: bold;
            margin-bottom: 15px;
        }

        .message.success {
            color: green;
        }

        .message.error {
            color: red;
        }

        #assignedBox {
            margin-top: 30px;
            padding: 15px;
            background: #fff;
            border-radius: 10px;
            width: 400px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        ul#assignedList {
            padding-left: 20px;
        }

        ul#assignedList li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>

<h2>Assign Staff to Campaign</h2>

<c:if test="${not empty success}">
    <div class="message success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="message error">${error}</div>
</c:if>

<form action="${pageContext.request.contextPath}/assignStaff" method="post">
    <label>Select Staff:</label>
    <select name="staffId" required>
        <c:forEach var="staff" items="${staffList}">
            <option value="${staff.staffId}">${staff.name} (${staff.role})</option>
        </c:forEach>
    </select>

    <label>Select Campaign:</label>
    <select name="campaignId" id="campaignDropdown" required>
        <c:forEach var="campaign" items="${campaignList}">
            <option value="${campaign.campaignId}">${campaign.title}</option>
        </c:forEach>
    </select>

    <button type="submit">Assign</button>
</form>

<div id="assignedBox">
    <h3>Assigned Staff:</h3>
    <ul id="assignedList">
        <li>Select a campaign to see assigned staff.</li>
    </ul>
</div>

<script>
    document.getElementById("campaignDropdown").addEventListener("change", function () {
        const campaignId = this.value;
        const contextPath = "${pageContext.request.contextPath}";

        fetch(contextPath + "/getAssignedStaff?campaignId=" + campaignId)
            .then(response => response.json())
            .then(data => {
                const list = document.getElementById("assignedList");
                list.innerHTML = "";
                if (data.length === 0) {
                    list.innerHTML = "<li>No staff assigned yet.</li>";
                } else {
                    data.forEach(name => {
                        const li = document.createElement("li");
                        li.textContent = name;
                        list.appendChild(li);
                    });
                }
            })
            .catch(error => {
                console.error("Error fetching assigned staff:", error);
            });
    });
</script>

</body>
</html>
