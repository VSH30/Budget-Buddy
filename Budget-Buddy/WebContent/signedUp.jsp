<!-- Include the header -->
<%@ include file="header.html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<section class="login-form">
    <h2>Sign Up Successful</h2>
	<h3>Your user ID = "${uid}"</h3>
	(Please note your user ID)
	<button onclick="window.location.href = 'Login.jsp'">Proceed to Login</button>
</section>

<!-- Include the footer -->
<%@ include file="footer.html" %>
