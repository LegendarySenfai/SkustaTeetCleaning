package com.project.controller;

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
    @Autowired
    private UserRepository userRepo;

    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;

    @GetMapping("/register")
    public String showRegister() { return "/WEB-INF/jsp/register.jsp"; }

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
        if (username == null || username.isBlank() || password.isBlank()) {
            model.addAttribute("error", "Username and password required.");
            return "/WEB-INF/jsp/register.jsp";
        }
        if (age == null || age < 0 || age > 200) {
            model.addAttribute("error", "Age should be between 0 and 200.");
            return "/WEB-INF/jsp/register.jsp";
        }
        if (userRepo.findByUsername(username).isPresent()) {
            model.addAttribute("error", "Username already exists.");
            return "/WEB-INF/jsp/register.jsp";
        }

        User u = new User();
        u.setUsername(username);
        u.setPassword(password);
        u.setFirstName(firstName);
        u.setLastName(lastName);
        u.setGender(gender);
        u.setAge(age);
        u.setEmail(email);
        u.setRole("ROLE_PATIENT");
        u.setEmailVerified(false);
        userRepo.save(u);

        // create OTP and send to provided email
        OtpInfo otp = otpService.createAndStoreOtp(session, u.getId(), null, "REGISTRATION");
        emailService.sendOtpEmail(email, "Your registration OTP", "Your OTP code is: " + otp.getCode());

        model.addAttribute("pendingUserId", u.getId());
        model.addAttribute("msg", "OTP sent to " + email + ". Please enter the code to verify your account.");
        return "/WEB-INF/jsp/register-confirm.jsp";
    }

    @GetMapping("/register/confirm")
    public String showRegisterConfirm() { return "/WEB-INF/jsp/register-confirm.jsp"; }

    @PostMapping("/register/confirm")
    public String confirmRegistration(@RequestParam Long pendingUserId,
                                      @RequestParam String code,
                                      HttpSession session,
                                      Model model) {
        OtpInfo info = otpService.getOtpFromSession(session, null, pendingUserId, "REGISTRATION");
        if (info == null || otpService.isExpired(info) || !info.getCode().equals(code)) {
            model.addAttribute("error", "Invalid or expired OTP.");
            model.addAttribute("pendingUserId", pendingUserId);
            return "/WEB-INF/jsp/register-confirm.jsp";
        }

        Optional<User> userOpt = userRepo.findById(pendingUserId);
        if (userOpt.isEmpty()) {
            model.addAttribute("error", "User not found.");
            return "/WEB-INF/jsp/register.jsp";
        }
        User user = userOpt.get();
        user.setEmailVerified(true);
        userRepo.save(user);
        otpService.removeOtpFromSession(session, null, pendingUserId, "REGISTRATION");

        model.addAttribute("msg", "Email verified — you can now login.");
        return "/WEB-INF/jsp/login.jsp";
    }

    @GetMapping("/login")
    public String showLogin() { return "/WEB-INF/jsp/login.jsp"; }

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
