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
    private static final String SESSION_PWD_EMAIL = "PWD_EMAIL";
    private static final String SESSION_PWD_OTP_ATTEMPTS = "PWD_OTP_ATTEMPTS";
    private static final String SESSION_PWD_OTP_VERIFIED = "PWD_OTP_VERIFIED";

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
        // register uniqueness
        if (userRepo.findByEmail(email).isPresent()) {
            model.addAttribute("error", "An account with this email already exists.");
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
    
    // --- Show email input page ---
    @GetMapping("/forgot-password")
    public String showForgotPassword() {
        return "/WEB-INF/jsp/forgot-password.jsp";
    }

    // --- Handle email submit: create OTP if email exists ---
    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam String email, Model model, HttpSession session) {
        if (email == null || email.isBlank()) {
            model.addAttribute("error", "Please enter your email.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }

        var userOpt = userRepo.findByEmail(email);
        if (userOpt.isEmpty()) {
            model.addAttribute("error", "This email is not registered to any account.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }

        // Save email in session and reset attempts and verified flag
        session.setAttribute(SESSION_PWD_EMAIL, email);
        session.setAttribute(SESSION_PWD_OTP_ATTEMPTS, 0);
        session.setAttribute(SESSION_PWD_OTP_VERIFIED, false);

        // Create OTP & send email (include userId)
        Long userId = userOpt.get().getId();
        OtpInfo otp = otpService.createAndStoreOtp(session, userId, null, "RESET_PASSWORD");
        try {
            emailService.sendOtpEmail(email, "Password reset OTP", "Your password reset OTP is: " + otp.getCode());
        } catch (Exception ex) {
            // If sending fails, clear session and show error
            session.removeAttribute(SESSION_PWD_EMAIL);
            session.removeAttribute(SESSION_PWD_OTP_ATTEMPTS);
            session.removeAttribute(SESSION_PWD_OTP_VERIFIED);
            otpService.removeOtpFromSession(session, null, userId, "RESET_PASSWORD");
            model.addAttribute("error", "Failed to send OTP. Please try again later.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }

        model.addAttribute("msg", "OTP sent to " + email + ". Enter the code to continue.");
        model.addAttribute("email", email);
        return "/WEB-INF/jsp/forgot-password-confirm.jsp";
    }

    // GET - show confirm OTP page (OTP-only)
    @GetMapping("/forgot-password/confirm")
    public String showForgotConfirm(HttpSession session, Model model) {
        String email = (String) session.getAttribute(SESSION_PWD_EMAIL);
        if (email != null) model.addAttribute("email", email);
        return "/WEB-INF/jsp/forgot-password-confirm.jsp";
    }

    // POST - verify OTP only (no password change here)
    @PostMapping("/forgot-password/confirm")
    public String confirmForgotPasswordOtp(@RequestParam String code,
                                           HttpSession session,
                                           Model model) {
        String email = (String) session.getAttribute(SESSION_PWD_EMAIL);
        if (email == null) {
            model.addAttribute("error", "No password reset request found. Please start again.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }

        var userOpt = userRepo.findByEmail(email);
        if (userOpt.isEmpty()) {
            session.removeAttribute(SESSION_PWD_EMAIL);
            model.addAttribute("error", "Account not found. Please try again.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }
        Long userId = userOpt.get().getId();

        // CORRECT parameter order for your OtpService implementation:
        OtpInfo info = otpService.getOtpFromSession(session, null, userId, "RESET_PASSWORD");
        Integer attempts = (Integer) session.getAttribute(SESSION_PWD_OTP_ATTEMPTS);
        if (attempts == null) attempts = 0;

        if (info == null || otpService.isExpired(info) || !info.getCode().equals(code)) {
            attempts++;
            session.setAttribute(SESSION_PWD_OTP_ATTEMPTS, attempts);
            if (attempts >= 3) {
                // cancel flow
                session.removeAttribute(SESSION_PWD_EMAIL);
                session.removeAttribute(SESSION_PWD_OTP_ATTEMPTS);
                session.removeAttribute(SESSION_PWD_OTP_VERIFIED);
                otpService.removeOtpFromSession(session, null, userId, "RESET_PASSWORD");
                model.addAttribute("error", "OTP verification failed 3 times. Please try again.");
                return "/WEB-INF/jsp/forgot-password.jsp";
            }
            model.addAttribute("error", "Invalid or expired OTP. Attempts left: " + (3 - attempts));
            model.addAttribute("email", email);
            return "/WEB-INF/jsp/forgot-password-confirm.jsp";
        }

        // success - mark verified and remove OTP
        session.setAttribute(SESSION_PWD_OTP_VERIFIED, true);
        otpService.removeOtpFromSession(session, null, userId, "RESET_PASSWORD");

        // redirect to new-password page
        return "redirect:/forgot-password/new-password";
    }

    // GET show new password page (only after OTP verified)
    @GetMapping("/forgot-password/new-password")
    public String showNewPasswordForm(HttpSession session, Model model) {
        Boolean verified = (Boolean) session.getAttribute(SESSION_PWD_OTP_VERIFIED);
        String email = (String) session.getAttribute(SESSION_PWD_EMAIL);
        if (verified == null || !verified || email == null) {
            model.addAttribute("error", "You must verify OTP first.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }
        model.addAttribute("email", email);
        return "/WEB-INF/jsp/forgot-password-new.jsp";
    }

    // POST to actually update password
    @PostMapping("/forgot-password/new-password")
    public String handleNewPassword(@RequestParam String newPassword,
                                    @RequestParam(required = false) String confirmPassword,
                                    HttpSession session,
                                    Model model) {
        Boolean verified = (Boolean) session.getAttribute(SESSION_PWD_OTP_VERIFIED);
        String email = (String) session.getAttribute(SESSION_PWD_EMAIL);
        if (verified == null || !verified || email == null) {
            model.addAttribute("error", "You must verify OTP first.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }

        if (newPassword == null || newPassword.isBlank()) {
            model.addAttribute("error", "Please enter a new password.");
            model.addAttribute("email", email);
            return "/WEB-INF/jsp/forgot-password-new.jsp";
        }
        if (newPassword.length()<8 || newPassword.isBlank()) {
            model.addAttribute("error", "Please enter a new password.");
            model.addAttribute("email", email);
            return "/WEB-INF/jsp/forgot-password-new.jsp";
        }
        if (confirmPassword != null && !newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "Password and confirmation do not match.");
            model.addAttribute("email", email);
            return "/WEB-INF/jsp/forgot-password-new.jsp";
        }

        var userOpt = userRepo.findByEmail(email);
        if (userOpt.isEmpty()) {
            session.removeAttribute(SESSION_PWD_EMAIL);
            session.removeAttribute(SESSION_PWD_OTP_ATTEMPTS);
            session.removeAttribute(SESSION_PWD_OTP_VERIFIED);
            model.addAttribute("error", "Account not found. Please try again.");
            return "/WEB-INF/jsp/forgot-password.jsp";
        }

        var user = userOpt.get();
        user.setPassword(newPassword); // demo only — plaintext; hash in production
        userRepo.save(user);

        // cleanup
        session.removeAttribute(SESSION_PWD_EMAIL);
        session.removeAttribute(SESSION_PWD_OTP_ATTEMPTS);
        session.removeAttribute(SESSION_PWD_OTP_VERIFIED);

        model.addAttribute("msg", "Password updated. You can now login with your new password.");
        return "/WEB-INF/jsp/login.jsp";
    }
 // === ACCOUNT DELETE ===

    @GetMapping("/account-delete")
    public String showDeleteAccountPage(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        return "/WEB-INF/jsp/account-delete.jsp";
    }

    @PostMapping("/account-delete")
    public String handleDeleteAccount(@RequestParam String password, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        Optional<User> userOpt = userRepo.findById(userId);
        if (userOpt.isEmpty()) {
            session.invalidate();
            return "redirect:/login";
        }

        User user = userOpt.get();
        if (!user.getPassword().equals(password)) {
            model.addAttribute("error", "Incorrect password. Please try again.");
            return "/WEB-INF/jsp/account-delete.jsp";
        }

        // Delete account
        userRepo.deleteById(userId);
        session.invalidate(); // logout user

        model.addAttribute("msg", "Your account has been deleted successfully.");
        
        
        return "redirect:/login?status=deleted";
    }

}
