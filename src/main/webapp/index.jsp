<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>GreenGuardians - Home</title>
    <style>
        @charset "UTF-8";

     body {
    margin: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #eaf7f0; /* Soft mint background */
    color: #333;
    overflow-x: hidden;
}

.centre {
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    background: linear-gradient(135deg, #a8edea, #fed6e3); /* Soft blue-pink gradient */
    padding: 0 20px;
}

.centre h1 {
    font-size: 48px;
    margin-bottom: 20px;
    font-weight: 700;
    color: #3d5a80; /* Calm deep blue */
}

.centre p {
    font-size: 22px;
    margin-bottom: 30px;
    color: #5c677d; /* Softer gray-blue */
}

.centre button {
    background-color: #7fb77e; /* Soft green button */
    color: #fff;
    padding: 15px 30px;
    font-size: 18px;
    border: none;
    border-radius: 25px;
    cursor: pointer;
    transition: background 0.3s ease;
}

.centre button:hover {
    background-color: #5c946e; /* Deeper green on hover */
}

.info {
    display: flex;
    justify-content: space-around;
    align-items: center;
    padding: 50px 20px;
    background: #c7ecee; /* Light cool blue background */
    text-align: center;
}

.info1 {
    width: 40%;
    margin: 0 20px;
    padding: 30px;
    background: #ffffff;
    border-radius: 10px;
    transition: 0.3s;
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
}

.info1:hover {
    background: #d6f5e3; /* Light pastel green on hover */
    transform: translateY(-5px);
}

footer {
    background-color: #3d5a80; /* Soft deep blue footer */
    color: #fff;
    text-align: center;
    padding: 20px 0;
}

footer a {
    color: #f4a261; /* Soft orange accent */
}

footer a:hover {
    text-decoration: underline;
}

    </style>
    <script>
        function toggleDropdown() {
            document.getElementById("loginDropdown").classList.toggle("show");
        }
        window.onclick = function(event) {
            if (!event.target.matches('.dropbtn')) {
                var dropdowns = document.getElementsByClassName("dropdown-content");
                for (var i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }
    </script>
</head>
<body>
    <%@include file="header.jsp" %>
    <section class="centre">
        <div class="content">
            <h1>Protect Nature, Protect Our Future</h1>
            <p>Join us in our mission to preserve our planet's natural beauty.</p>
          
        </div>
    </section>

    <section class="info">
        <div class="info1">
            <h2>Our Mission</h2>
            <p>At GreenGuardians, our mission is to protect and restore the natural beauty of our planet. 
            We are dedicated to conserving vital ecosystems, planting trees, and promoting sustainable practices 
            that safeguard the environment for future generations. Through education, collaboration, and community engagement,
             we empower individuals and organizations to make a meaningful impact on the environment. Together, we can create a 
             greener, 
             healthier world for all.

</p>
        </div>
        <div class="info1">
            <h2>How You Can Help</h2>
              <p>  *Volunteer: Join our tree planting events, awareness campaigns,  </p>
               
              <p>  *Donate: Your financial contributions support our programs.</P>
               
              <p>  *Spread Awareness: Share our mission with others! Every conversation, 
                    social media post, or word of encouragement helps build a larger movement 
                    for the environment.</p>
        </div>
    </section>

    <%@include file="footer.jsp" %>
</body>
</html>
