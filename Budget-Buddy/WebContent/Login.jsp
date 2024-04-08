<!-- Include the header -->
<%@ include file="header.html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Login Form -->
<section class="login-form">
    <h2>Login</h2>
    <form action="UserControllerServlet" method="post">
    	<input type="hidden" name="command" value="LOGIN"/>
        User ID: <input type="text" name="userid" placeholder="User ID" required>
        <br>
        Password: <input type="password" name="password" placeholder="Password" required>
        <br>
        <c:if test='<%= null != session.getAttribute("Error") %>'>
        	<b>Error: Invalid UserID or Password</b>
        </c:if>
        <br>
        <button type="submit">Login</button>
        <button onclick="window.location.href = 'signUp.jsp'">SignUp</button>
    </form>
</section>

<!-- Include the footer -->
<%@ include file="footer.html" %>
