package com.project.controller;

import com.project.otp.EmailService;
import com.project.otp.OtpInfo;
import com.project.otp.OtpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final String SESSION_ADMIN_PENDING = "ADMIN_PENDING";
    private static final String SESSION_ADMIN_OTP_ATTEMPTS = "ADMIN_OTP_ATTEMPTS";
    private static final String SESSION_ADMIN_AUTH = "adminAuthenticated";

    // static credentials
    private static final String ADMIN_USER = "Admin123!"; // or whatever you use in your app
    private static final String ADMIN_PASS = "Admin123!"; // your static password (case-sensitive)
    private static final String SYSTEM_ADMIN_EMAIL = "skustateethclinic@gmail.com";

    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;

    @GetMapping("/login")
    public String showAdminLogin() {
        return "/WEB-INF/jsp/admin-login.jsp"; // adapt if your admin page path differs
    }

    @PostMapping("/login")
    public String doAdminLogin(@RequestParam String username,
                               @RequestParam String password,
                               HttpSession session,
                               Model model) {
        if (!ADMIN_USER.equals(username) || !ADMIN_PASS.equals(password)) {
            model.addAttribute("error", "Invalid admin credentials.");
            return "/WEB-INF/jsp/admin-login.jsp";
        }

        // valid creds — create OTP, send to the system email
        session.setAttribute(SESSION_ADMIN_PENDING, true);
        session.setAttribute(SESSION_ADMIN_OTP_ATTEMPTS, 0);

        OtpInfo otp = otpService.createAndStoreOtp(session, null, null, "ADMIN_LOGIN");
        emailService.sendOtpEmail(SYSTEM_ADMIN_EMAIL, "Admin login OTP", "Admin login OTP: " + otp.getCode());

        model.addAttribute("msg", "OTP sent to system email. Please enter the code.");
        return "/WEB-INF/jsp/admin-confirm-otp.jsp";
    }

    @PostMapping("/confirm-otp")
    public String confirmAdminOtp(@RequestParam String code,
                                  HttpSession session,
                                  Model model) {
        Boolean pending = (Boolean) session.getAttribute(SESSION_ADMIN_PENDING);
        Integer attempts = (Integer) session.getAttribute(SESSION_ADMIN_OTP_ATTEMPTS);
        if (attempts == null) attempts = 0;
        if (pending == null || !pending) {
            model.addAttribute("error", "No admin login pending. Please login first.");
            return "/WEB-INF/jsp/admin-login.jsp";
        }

        OtpInfo info = otpService.getOtpFromSession(session, null, null, "ADMIN_LOGIN");
        if (info == null || otpService.isExpired(info) || !info.getCode().equals(code)) {
            attempts++;
            session.setAttribute(SESSION_ADMIN_OTP_ATTEMPTS, attempts);
            if (attempts >= 3) {
                // wipe admin pending
                session.removeAttribute(SESSION_ADMIN_PENDING);
                session.removeAttribute(SESSION_ADMIN_OTP_ATTEMPTS);
                otpService.removeOtpFromSession(session, null, null, "ADMIN_LOGIN");
                model.addAttribute("error", "Admin OTP verification failed 3 times. Please login again.");
                return "/WEB-INF/jsp/admin-login.jsp";
            }
            model.addAttribute("error", "Invalid or expired OTP. Attempts left: " + (3 - attempts));
            return "/WEB-INF/jsp/admin-confirm-otp.jsp";
        }

        // success
        session.removeAttribute(SESSION_ADMIN_PENDING);
        session.removeAttribute(SESSION_ADMIN_OTP_ATTEMPTS);
        otpService.removeOtpFromSession(session, null, null, "ADMIN_LOGIN");

        // mark admin authenticated
        session.setAttribute(SESSION_ADMIN_AUTH, true);
        // You may want to set a role or redirect to admin dashboard
        return "redirect:/admin/dashboard"; // adapt to your admin dashboard URL
    }

    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session) {
        Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
        if (auth == null || !auth) return "redirect:/admin/login";
        return "/WEB-INF/jsp/admin-dashboard.jsp"; // adapt as necessary
    }

    @GetMapping("/logout")
    public String logoutAdmin(HttpSession session) {
        session.removeAttribute(SESSION_ADMIN_AUTH);
        return "redirect:/admin/login";
    }
}
