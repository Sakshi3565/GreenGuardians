<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
body{
    margin-top:0;
    padding: 0;
    font-family: Arial,sans-serif;background: url('image/home.jpg') no-repeat center center fixed; 
    background-size: cover;
}
form{
    max-width: 500px;
    padding: 20px;
    margin: 100px auto;
    border: 1px solid #ccc; 
    backdrop-filter: blur(10px);
    background: rgba(255, 255, 255, 0); /* Fully transparent background */
}
input,textarea,select{
   display: block; 
   margin: 10px 0; 
   padding: 8px;
   width: 400px; height:40px ;
    resize: none;
}
button {
    width: 100%;
    padding: 12px;
    background: #E74C3C;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 18px;
    cursor: pointer;
    transition: 0.3s;
}

button:hover {
    background: #C0392B;
}
.error {
    color: red;
    font-size: 14px;
    display: block;
}
    </style>
    
    <script>
    function validateForm() {
        let name = document.forms["regForm"]["name"].value;
        let email = document.forms["regForm"]["email"].value;
        let password = document.forms["regForm"]["password"].value;
        let phone = document.forms["regForm"]["phone"].value;
        let address = document.forms["regForm"]["address"].value;
        let gender = document.forms["regForm"]["gender"].value;

        let namePattern = /^[A-Za-z\s]{3,}$/; // Only letters, min 3 chars
        let emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        let passwordPattern = /^(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$/;
        let phonePattern = /^[0-9]{10}$/;

        let valid = true;

        document.getElementById("nameError").innerText = namePattern.test(name) ? "" : "Name must have at least 3 letters.";
        document.getElementById("emailError").innerText = emailPattern.test(email) ? "" : "Invalid email format.";
        document.getElementById("passwordError").innerText = passwordPattern.test(password) ? "" : "Password must be at least 6 characters and contain a number & special character.";
        document.getElementById("phoneError").innerText = phonePattern.test(phone) ? "" : "Phone number must be 10 digits.";
        document.getElementById("addressError").innerText = address.length >= 5 ? "" : "Address must be at least 5 characters.";
        document.getElementById("genderError").innerText = gender ? "" : "Please select a gender.";

        if (!namePattern.test(name) || !emailPattern.test(email) || !passwordPattern.test(password) || 
            !phonePattern.test(phone) || address.length < 5 || !gender) {
            valid = false;
        }

        return valid;
    }
    </script>
</head>
<body>

    <%@ include file="header.jsp" %> <!-- Header at top -->

    <div class="container">
       
        <form name="regForm" action="RegisterServlet" method="post" onsubmit="return validateForm()">
            <h2>User Registration</h2>
            <label><b>Name:</b></label>
            <input type="text" name="name" placeholder="Enter Name">
            <span id="nameError" class="error"></span>

            <label><b>Email:</b></label>
            <input type="email" name="email" placeholder="Enter Email">
            <span id="emailError" class="error"></span>

            <label><b>Password:</b></label>
            <input type="password" name="password" placeholder="Enter Password">
            <span id="passwordError" class="error"></span>

            <label><b>Phone No:</b></label>
            <input type="text" name="phone" placeholder="Enter Phone">
            <span id="phoneError" class="error"></span>

            <label><b>Address:</b></label>
            <textarea name="address" placeholder="Enter Address"></textarea>
            <span id="addressError" class="error"></span>

            <label><b>Gender:</b></label>
            <select name="gender">
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>
            <span id="genderError" class="error"></span>

            <button type="submit">Register</button>
           <p>already registerd? <a href="User_Login.jsp">login here</a></p>
        </form>
    </div>

    <%@ include file="footer.jsp" %> <!-- Footer at bottom -->

</body>
</html>
