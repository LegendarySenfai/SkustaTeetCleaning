package com.project.controller;

import com.project.dto.PendingUser;
import com.project.model.User;
import com.project.otp.EmailService;
import com.project.otp.OtpInfo;
import com.project.otp.OtpService;
import com.project.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Optional;

@Controller
public class AuthController {

    private static final String SESSION_PENDING_REG = "PENDING_REG";
    private static final String SESSION_REG_OTP_ATTEMPTS = "REG_OTP_ATTEMPTS";

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;
    
    @GetMapping("/SkustaTeeth")
    public String showLandingpage() {
        return "/WEB-INF/jsp/landingpage.jsp"; 
    }

    @GetMapping("/register")
    public String showRegister() {
        return "/WEB-INF/jsp/register.jsp";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String firstName,
                           @RequestParam String lastName,
                           @RequestParam String gender,
                           @RequestParam Integer age,
                           @RequestParam String email,
                           Model model,
                           HttpSession session) {

        // Basic validation
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            model.addAttribute("error", "Username and password required.");
            return "/WEB-INF/jsp/register.jsp";
        }
        if (age == null || age < 0 || age > 200) {
            model.addAttribute("error", "Age should be between 0 and 200.");
            return "/WEB-INF/jsp/register.jsp";
        }
        // Username uniqueness check against DB
        if (userRepo.findByUsername(username).isPresent()) {
            model.addAttribute("error", "Username already exists.");
            return "/WEB-INF/jsp/register.jsp";
        }

        // Create PendingUser object and store in session (do NOT save to DB yet)
        PendingUser pending = new PendingUser(username, password, firstName, lastName, gender, age, email, "ROLE_PATIENT");
        session.setAttribute(SESSION_PENDING_REG, pending);
        session.setAttribute(SESSION_REG_OTP_ATTEMPTS, 0);

        // Create OTP and send to provided email
        OtpInfo otp = otpService.createAndStoreOtp(session, null, null, "REGISTRATION");
        emailService.sendOtpEmail(email, "Registration OTP", "Your registration OTP code is: " + otp.getCode());

        model.addAttribute("pendingUserEmail", email);
        model.addAttribute("msg", "OTP sent to " + email + ". Please enter the code to verify your account.");
        return "/WEB-INF/jsp/register-confirm.jsp";
    }

    @GetMapping("/register/confirm")
    public String showRegisterConfirm() {
        return "/WEB-INF/jsp/register-confirm.jsp";
    }

    @PostMapping("/register/confirm")
    public String confirmRegistration(@RequestParam String code,
                                      HttpSession session,
                                      Model model) {

        PendingUser pending = (PendingUser) session.getAttribute(SESSION_PENDING_REG);
        Integer attempts = (Integer) session.getAttribute(SESSION_REG_OTP_ATTEMPTS);
        if (attempts == null) attempts = 0;

        if (pending == null) {
            model.addAttribute("error", "No pending registration found. Please register again.");
            return "/WEB-INF/jsp/register.jsp";
        }

        OtpInfo info = otpService.getOtpFromSession(session, null, null, "REGISTRATION");
        if (info == null || otpService.isExpired(info) || !info.getCode().equals(code)) {
            attempts++;
            session.setAttribute(SESSION_REG_OTP_ATTEMPTS, attempts);
            if (attempts >= 3) {
                // Remove pending data and OTP from session and redirect to register with error
                session.removeAttribute(SESSION_PENDING_REG);
                otpService.removeOtpFromSession(session, null, null, "REGISTRATION");
                session.removeAttribute(SESSION_REG_OTP_ATTEMPTS);
                model.addAttribute("error", "OTP verification failed 3 times. Registration canceled.");
                return "/WEB-INF/jsp/register.jsp";
            }
            model.addAttribute("error", "Invalid or expired OTP. Attempts left: " + (3 - attempts));
            model.addAttribute("pendingUserEmail", pending.getEmail());
            return "/WEB-INF/jsp/register-confirm.jsp";
        }

        // OTP is valid: persist user to DB now
        User u = new User();
        u.setUsername(pending.getUsername());
        u.setPassword(pending.getPassword()); // demo only: plaintext. Use hashing in production.
        u.setFirstName(pending.getFirstName());
        u.setLastName(pending.getLastName());
        u.setGender(pending.getGender());
        u.setAge(pending.getAge());
        u.setEmail(pending.getEmail());
        u.setRole(pending.getRole());
        u.setEmailVerified(true);
        userRepo.save(u);

        // cleanup session
        session.removeAttribute(SESSION_PENDING_REG);
        otpService.removeOtpFromSession(session, null, null, "REGISTRATION");
        session.removeAttribute(SESSION_REG_OTP_ATTEMPTS);

        model.addAttribute("msg", "Email verified — you can now login.");
        return "/WEB-INF/jsp/login.jsp";
    }

    @GetMapping("/login")
    public String showLogin() {
        return "/WEB-INF/jsp/login.jsp";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        Model model) {
        Optional<User> o = userRepo.findByUsername(username);
        if (o.isEmpty() || !o.get().getPassword().equals(password)) {
            model.addAttribute("error", "Invalid credentials.");
            return "/WEB-INF/jsp/login.jsp";
        }
        if (o.get().getEmailVerified() == null || !o.get().getEmailVerified()) {
            model.addAttribute("error", "Email not verified. Please register again or verify your email.");
            return "/WEB-INF/jsp/login.jsp";
        }
        session.setAttribute("userId", o.get().getId());
        session.setAttribute("username", o.get().getUsername());
        session.setAttribute("role", o.get().getRole());
        return "redirect:/book";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}
