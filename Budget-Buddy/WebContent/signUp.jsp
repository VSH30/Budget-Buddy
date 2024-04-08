<!-- Include the header -->
<%@ include file="header.html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<section class="login-form">
    <h2>Sign Up</h2>
<form id="signup-form" action="UserControllerServlet" method="post">
    <input type="hidden" name="command" value="SIGNUP"/>
    Name: <input type="text" name="name" placeholder="Name" required>
    <br>
    Mobile: <input type="text" name="mobile" placeholder="Mobile No" required>
    <br>
    Password: <input type="password" name="password" placeholder="Password" required>
    <br>
    Confirm Password: <input type="password" name="c_password" placeholder="Confirm Password" required>
    <br>
    <button type="submit" id="signup-button">Create Account</button>
</form>
</section>

<!-- Include the footer -->
<%@ include file="footer.html" %>


<script>
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("signup-form");

    form.addEventListener("submit", function(event) {
        const name = form.querySelector("input[name='name']").value.trim();
        const mobile = form.querySelector("input[name='mobile']").value.trim();
        const password = form.querySelector("input[name='password']").value.trim();
        const confirmPassword = form.querySelector("input[name='c_password']").value.trim();

            // Validate name
            if (name === "") {
                alert("Please enter your name.");
                event.preventDefault();
                return false;
            }

            // Validate mobile number
            if (mobile === "") {
                alert("Please enter your mobile number.");
                event.preventDefault();
                return false;
            }
            if (!/^\d{10}$/.test(mobile)) {
                alert("Please enter a valid 10-digit mobile number.");
                event.preventDefault();
                return false;
            }

            // Validate password
            if (password === "") {
                alert("Please enter a password.");
                event.preventDefault();
                return false;
            }
            if (password.length < 6) {
                alert("Password must be at least 6 characters long.");
                event.preventDefault();
                return false;
            }

            // Validate confirm password
            if (confirmPassword === "") {
                alert("Please confirm your password.");
                event.preventDefault();
                return false;
            }
            if (password !== confirmPassword) {
                alert("Passwords do not match.");
                event.preventDefault();
                return false;
            }

            // Form submission is valid
            return true;
        });
    });
</script>
