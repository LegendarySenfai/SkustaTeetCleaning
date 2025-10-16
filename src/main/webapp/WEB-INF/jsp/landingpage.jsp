<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/landingpage.css"> 
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,300;0,400;0,700;1,300;1,400;1,700&display=swap" rel="stylesheet">
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Crimson+Pro:ital,wght@0,400;0,600;0,700;1,400;1,600&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body>

    <!-- ======= NAVBAR ======= -->
	<header>
	  <div class="header-logo">
	    <img src="${pageContext.request.contextPath}/images/SkustaTeethLogo.png" alt="Dental Clinic Logo">
	  </div>
	  <nav class="header-nav">
	    <a href="#home" class="active">Home</a>
	    <a href="#services">Services</a>
	    <a href="/book">Book an Appointment</a>
	    <a href="#about">About Us</a>
	    <a href="#contact">Contact Us</a>
	  </nav>
	  <div class="user-info">
  <c:choose>
    <c:when test="${not empty sessionScope.username}">
      <div class="dropdown">
        <button class="dropbtn">Hi, ${sessionScope.username} <i class="fa fa-caret-down"></i></button>
        <div class="dropdown-content">
          <a href="${pageContext.request.contextPath}/logout">Logout</a>
          <a href="${pageContext.request.contextPath}/account-delete" id="deleteAccountLink"
   onclick="return confirm('Are you sure you want to delete your account?')">Delete Account</a>
          

          
          
        </div>
      </div>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/login">Login</a>
    </c:otherwise>
  </c:choose>
</div>

<script>
  // Delete Account confirmation
  document.addEventListener('DOMContentLoaded', function() {
    const deleteLink = document.getElementById('deleteAccountLink');
    if (deleteLink) {
      deleteLink.addEventListener('click', function(e) {
        e.preventDefault();
        if (confirm("Are you sure you want to delete your account?")) {
          window.location.href = "${pageContext.request.contextPath}/account-delete";
        }
      });
    }
  });
</script>

<style>
/* Simple dropdown styling */
.dropdown {
  position: relative;
  display: inline-block;
}

.dropbtn {
  background-color: transparent;
  color: #333;
  font-weight: bold;
  border: none;
  cursor: pointer;
  font-family: 'Lato', sans-serif;
}

.dropbtn i {
  margin-left: 5px;
}

.dropdown-content {
  display: none;
  position: absolute;
  right: 0;
  background-color: white;
  min-width: 160px;
  box-shadow: 0px 8px 16px rgba(0,0,0,0.2);
  z-index: 1000;
  border-radius: 8px;
}

.dropdown-content a {
  color: #333;
  padding: 10px 16px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {
  background-color: #f1f1f1;
}

.dropdown:hover .dropdown-content {
  display: block;
}
</style>
	  
	</header>

    <!-- ======= HERO SECTION ======= -->
    <section class="hero" id="home">
        <div class="hero-content">
            <h1>The <span class="highlight">best</span> dental <br>
				clinic to keep your<br>
				<span class="highlight">smile</span> healthy.</h1>
            <p>We believe going to the dentist shouldn't feel stressful - it should feel like visiting a friend who's here to keep you and your smile at your best.</p>
            <a href="/book" class="btn">Book an Appointment</a>
        </div>
        <div class="hero-img">
            <img src="${pageContext.request.contextPath}/images/smilecouple.png" alt="Happy Smiling Couple">
        </div>
    </section>

    <!-- ======= SERVICES ======= -->
    <section class="services" id="services">
        <h2>Our Services</h2>
        <div class="service-cards">
            <div class="card">
                <img src="${pageContext.request.contextPath}/images/Dentalcheck.png" alt="Dental Check-ups">
                <p>Dental Check-ups & Cleaning</p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/images/Extraction.png" alt="Tooth Extraction">
                <p>Tooth Extraction</p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/images/Fillings.png" alt="Tooth Fillings">
                <p>Tooth Fillings</p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/images/Braces.png" alt="Braces & Orthodontics">
                <p>Braces & Orthodontics</p>
            </div>
            <div class="card">
                <img src="${pageContext.request.contextPath}/images/Whitening.png" alt="Teeth Whitening">
                <p>Teeth Whitening</p>
            </div>
        </div>
        <a href="/book" class="btn">Book an Appointment</a>
    </section>

    <!-- ======= ABOUT SECTION ======= -->
    <section class="about" id="about">
        <div class="about-text">
            <h3>About us</h3>
            <h2><span class="highlight">10 years</span> of expertise in dental care</h2>
            <p>
				Our team of experienced dentists and caring staff believe that great dental care goes beyond treatment - it's about building trust, comfort, and confidence with every visit.
            </p> <br>
            <p>
				From routine check-ups to advanced treatments, we use modern tools and gentle techniques to make sure every patient feels at ease. Whether it's your first visit or your tenth, we're here to listen, guide, and provide the care you deserve.
            </p> <br>
            <p>
                Because for us, it's <span class="highlight">not just about teeth </span> - it's about keeping you smiling, inside and out.
            </p>
        </div>
        <div class="about-img">
            <img src="${pageContext.request.contextPath}/images/NewTeam.jpg" alt="Dental Team">
        </div>
    </section>

    <!-- ======= CONTACT SECTION ======= -->
    <section class="contact" id="contact">
        <div class="contact-container">
            <div class="contact-info">
                <h3>Contact Us</h3>
				<p><i class="fas fa-location-dot"></i>1234 Sampaguita Lane, Makati City, Metro Manila 1200</p>
				<p><i class="fas fa-envelope"></i>skustateethclinic@gmail.com</p>
				<p><i class="fas fa-phone"></i>+63 907 456 2463</p>
            </div>
            <div class="contact-form">
                <h3>Get in Touch</h3>
                <p>Feel free to drop us a line below!</p>
                <form>
                    <input type="text" placeholder="Name" required>
                    <input type="email" placeholder="Email" required>
                    <textarea placeholder="Type your message here" required></textarea>
                    <button type="submit" class="btn">SEND</button>
                </form>
            </div>
        </div>
    </section>

    <footer>
        <p>© 2025 Dental Clinic | Designed with ❤️</p>
    </footer>

    <script>
        // Smooth scroll to top when Home clicked
        document.querySelector('.nav-links a[href="#home"]').addEventListener('click', function(e) {
            e.preventDefault();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    </script>
</body>
</html>
