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
                            <a href="${pageContext.request.contextPath}/account-delete" id="deleteAccountLink">Delete Account</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
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
                <!-- keep markup same; JS will find inputs via form element -->
                <form id="contactForm">
                    <input type="text" name="name" placeholder="Name" required>
                    <input type="email" name="email" placeholder="Email" required>
                    <textarea name="message" placeholder="Type your message here" required></textarea>
                    <button type="submit" class="btn" id="contactSendBtn">SEND</button>
                </form>
                <!-- container for validation/success messages -->
                <div id="contactFeedback" aria-live="polite" style="margin-top:10px;"></div>
            </div>
        </div>
    </section>

    <footer>
        <p>© 2025 Dental Clinic | Designed with ❤️</p>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // === Delete Account Confirmation ===
            const deleteLink = document.getElementById('deleteAccountLink');
            if (deleteLink) {
                deleteLink.addEventListener('click', function (e) {
                    e.preventDefault();
                    if (confirm("Are you sure you want to delete your account?")) {
                        window.location.href = "${pageContext.request.contextPath}/account-delete";
                    }
                });
            }

            const homeLink = document.querySelector('.header-nav a[href="#home"]');
            if (homeLink) {
                homeLink.addEventListener('click', function (e) {
                    e.preventDefault();
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                });
            }

            const navLinks = document.querySelectorAll('.header-nav a');
            const sections = document.querySelectorAll('section[id]');

            navLinks.forEach(link => {
                const href = link.getAttribute('href');
                if (href && href.startsWith('#')) {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();

                        navLinks.forEach(a => a.classList.remove('active'));
   
                        this.classList.add('active');

                        const target = document.querySelector(href);
                        if (target) {
                            window.scrollTo({
                                top: target.offsetTop - 70, 
                                behavior: 'smooth'
                            });
                        }
                    });
                }
            });

            window.addEventListener('scroll', function () {
                let currentSection = '';

                sections.forEach(section => {
                    const sectionTop = section.offsetTop - 100;
                    const sectionHeight = section.offsetHeight;
                    if (window.scrollY >= sectionTop && window.scrollY < sectionTop + sectionHeight) {
                        currentSection = '#' + section.id;
                    }
                });

                navLinks.forEach(link => {
                    const href = link.getAttribute('href');
                    if (href && href.startsWith('#')) {
                        link.classList.toggle('active', href === currentSection);
                    }
                });
            });

            // ============================
            // Contact form handling logic
            // ============================
            (function() {
                const form = document.getElementById('contactForm');
                const feedback = document.getElementById('contactFeedback');
                const sendBtn = document.getElementById('contactSendBtn');

                if (!form) return;

                function showFeedback(msg, type) {
                    // type: 'error' | 'success' | 'info'
                    feedback.textContent = msg;
                    feedback.style.color = (type === 'success') ? 'green' : (type === 'error' ? 'crimson' : '#333');
                }

                function clearFeedback() {
                    feedback.textContent = '';
                }

                function isValidEmail(email) {
                    // simple regex check
                    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
                }

                form.addEventListener('submit', async function(e) {
                    e.preventDefault();
                    clearFeedback();

                    const name = (form.querySelector('input[name="name"]') || {}).value || '';
                    const email = (form.querySelector('input[name="email"]') || {}).value || '';
                    const message = (form.querySelector('textarea[name="message"]') || {}).value || '';

                    if (name.trim().length < 8) {
                        showFeedback('Name must be at least 8 characters long.', 'error');
                        return;
                    }
                    if (!isValidEmail(email)) {
                        showFeedback('Please enter a valid email address.', 'error');
                        return;
                    }
                    if (message.trim().length < 8) {
                        showFeedback('Message must be at least 8 characters long.', 'error');
                        return;
                    }

                    // disable send button while sending
                    sendBtn.disabled = true;
                    const originalText = sendBtn.textContent;
                    sendBtn.textContent = 'Sending...';

                    try {
                        const resp = await fetch('/contact/send', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'Accept': 'application/json'
                            },
                            body: JSON.stringify({ name: name.trim(), email: email.trim(), message: message.trim() })
                        });

                        if (resp.ok) {
                            // optionally parse JSON returned by server
                            let data = null;
                            try { data = await resp.json(); } catch(_) { /* ignore parse errors */ }

                            const serverMsg = data && data.message ? data.message : 'Your message has been sent. Thank you!';
                            showFeedback(serverMsg, 'success');
                            form.reset();
                        } else {
                            // server responded with error status
                            let errText = 'Failed to send message. Please try again later.';
                            try {
                                const errData = await resp.json();
                                if (errData && errData.message) errText = errData.message;
                            } catch (_) {}
                            showFeedback(errText, 'error');
                        }
                    } catch (networkErr) {
                        console.error('Contact send error', networkErr);
                        showFeedback('Could not send message. Check your connection and try again.', 'error');
                    } finally {
                        sendBtn.disabled = false;
                        sendBtn.textContent = originalText;
                    }
                });
            })();

        });
    </script>
</body>
</html>
