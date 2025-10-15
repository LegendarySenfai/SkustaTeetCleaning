package com.project.controller;

import com.project.otp.EmailService;
import com.project.otp.OtpInfo;
import com.project.otp.OtpService;
import com.project.model.Appointment;
import com.project.model.User;
import com.project.model.Dentist;
import com.project.repository.AppointmentRepository;
import com.project.repository.DentistRepository;
import com.project.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final String SESSION_ADMIN_PENDING = "ADMIN_PENDING";
    private static final String SESSION_ADMIN_OTP_ATTEMPTS = "ADMIN_OTP_ATTEMPTS";
    private static final String SESSION_ADMIN_AUTH = "adminAuthenticated";

    // static credentials (you already use Admin123! in your code)
    private static final String ADMIN_USER = "Admin123!";
    private static final String ADMIN_PASS = "Admin123!";
    private static final String SYSTEM_ADMIN_EMAIL = "skustateethclinic@gmail.com";

    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;

    // <-- REPOSITORIES we need to populate the model for the JSP
    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DentistRepository dentistRepository;

    @GetMapping("/login")
    public String showAdminLogin() {
        return "/WEB-INF/jsp/admin-login.jsp";
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
        return "redirect:/admin/dashboard";
    }

    // ---------------------------
    // DASHBOARD: populate model
    // ---------------------------
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
        if (auth == null || !auth) return "redirect:/admin/login";

        // fetch lists from repositories
        List<Appointment> appts = appointmentRepository.findAll();
        // Touch nested associations so JSP doesn't hit lazy-loading blanks (simple defensive step)
        for (Appointment a : appts) {
            if (a.getPatient() != null) {
                // force load patient fields
                a.getPatient().getFirstName();
                a.getPatient().getLastName();
            }
            if (a.getDentist() != null) {
                a.getDentist().getName();
            }
            if (a.getServices() != null) {
                a.getServices().size();
            }
        }

        model.addAttribute("appts", appts);
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("dentists", dentistRepository.findAll());

        return "/WEB-INF/jsp/admin-dashboard.jsp";
    }

    @GetMapping("/logout")
    public String logoutAdmin(HttpSession session) {
        session.removeAttribute(SESSION_ADMIN_AUTH);
        return "redirect:/admin/login";
    }

    // ---------------------------
    // Debug endpoint (temporary)
    // ---------------------------
    @GetMapping("/debug-counts")
    @ResponseBody
    public String debugCounts() {
        return "users=" + userRepository.count()
                + ", appointments=" + appointmentRepository.count()
                + ", dentists=" + dentistRepository.count();
    }
 // ---------------------------
 // DELETE ENDPOINTS
 // ---------------------------

 @PostMapping("/deleteAppointment")
 public String deleteAppointment(@RequestParam Long id, HttpSession session) {
     Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
     if (auth == null || !auth) return "redirect:/admin/login";

     appointmentRepository.deleteById(id);
     return "redirect:/admin/dashboard";
 }

 @PostMapping("/deleteUser")
 public String deleteUser(@RequestParam Long id, HttpSession session) {
     Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
     if (auth == null || !auth) return "redirect:/admin/login";

     userRepository.deleteById(id);
     return "redirect:/admin/dashboard";
 }

 @PostMapping("/deleteDentist")
 public String deleteDentist(@RequestParam Long id, HttpSession session) {
     Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
     if (auth == null || !auth) return "redirect:/admin/login";

     dentistRepository.deleteById(id);
     return "redirect:/admin/dashboard";
 }

 // ---------------------------
 // UPDATE ENDPOINTS (example skeletons)
 // ---------------------------

 @PostMapping("/updateAppointment")
 public String updateAppointment(@ModelAttribute Appointment appointment, HttpSession session) {
     Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
     if (auth == null || !auth) return "redirect:/admin/login";

     appointmentRepository.save(appointment);
     return "redirect:/admin/dashboard";
 }

 @PostMapping("/updateUser")
 public String updateUser(@ModelAttribute User user, HttpSession session) {
     Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
     if (auth == null || !auth) return "redirect:/admin/login";

     userRepository.save(user);
     return "redirect:/admin/dashboard";
 }

 @PostMapping("/updateDentist")
 public String updateDentist(@ModelAttribute Dentist dentist, HttpSession session) {
     Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
     if (auth == null || !auth) return "redirect:/admin/login";

     dentistRepository.save(dentist);
     return "redirect:/admin/dashboard";
 }
}
