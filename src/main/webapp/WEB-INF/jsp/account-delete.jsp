<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Delete Account</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <div class="delete-container">
    <h2>Confirm Account Deletion</h2>

    <p>Please enter your password to permanently delete your account.</p>

    <c:if test="${not empty error}">
      <p style="color: red;">${error}</p>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/account-delete">
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required>
      <br><br>
      <button type="submit">Confirm Delete</button>
      <a href="${pageContext.request.contextPath}/SkustaTeeth" style="margin-left: 10px;">Cancel</a>
    </form>
  </div>

  <style>
    body {
      font-family: 'Lato', sans-serif;
      background-color: #f9f9f9;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    .delete-container {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      text-align: center;
      width: 400px;
    }

    input[type=password] {
      width: 80%;
      padding: 8px;
      margin-top: 8px;
      border: 1px solid #ccc;
      border-radius: 6px;
    }

    button {
      background-color: #e53935;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 8px;
      cursor: pointer;
    }

    button:hover {
      background-color: #c62828;
    }

    a {
      color: #555;
      text-decoration: none;
    }
  </style>
</body>
</html>
