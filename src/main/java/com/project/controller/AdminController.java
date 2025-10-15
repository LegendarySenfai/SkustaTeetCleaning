package com.project.controller;

import com.project.model.Appointment;
import com.project.model.User;
import com.project.model.Dentist;
import com.project.model.ServiceEntity;
import com.project.otp.EmailService;
import com.project.otp.OtpInfo;
import com.project.otp.OtpService;
import com.project.repository.AppointmentRepository;
import com.project.repository.DentistRepository;
import com.project.repository.UserRepository;
import com.project.repository.ServiceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final String SESSION_ADMIN_PENDING = "ADMIN_PENDING";
    private static final String SESSION_ADMIN_OTP_ATTEMPTS = "ADMIN_OTP_ATTEMPTS";
    private static final String SESSION_ADMIN_AUTH = "adminAuthenticated";

    // static credentials
    private static final String ADMIN_USER = "Admin123!";
    private static final String ADMIN_PASS = "Admin123!";
    private static final String SYSTEM_ADMIN_EMAIL = "skustateethclinic@gmail.com";

    @Autowired
    private OtpService otpService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DentistRepository dentistRepository;

    @Autowired
    private ServiceRepository serviceRepository;

    // --- admin login / OTP (unchanged behavior) ---
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
                session.removeAttribute(SESSION_ADMIN_PENDING);
                session.removeAttribute(SESSION_ADMIN_OTP_ATTEMPTS);
                otpService.removeOtpFromSession(session, null, null, "ADMIN_LOGIN");
                model.addAttribute("error", "Admin OTP verification failed 3 times. Please login again.");
                return "/WEB-INF/jsp/admin-login.jsp";
            }
            model.addAttribute("error", "Invalid or expired OTP. Attempts left: " + (3 - attempts));
            return "/WEB-INF/jsp/admin-confirm-otp.jsp";
        }

        session.removeAttribute(SESSION_ADMIN_PENDING);
        session.removeAttribute(SESSION_ADMIN_OTP_ATTEMPTS);
        otpService.removeOtpFromSession(session, null, null, "ADMIN_LOGIN");

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

        List<Appointment> appts = appointmentRepository.findAll();
        // touch lazy associations to avoid JSP lazy-loading problems
        for (Appointment a : appts) {
            if (a.getPatient() != null) { a.getPatient().getFirstName(); a.getPatient().getLastName(); }
            if (a.getDentist() != null) a.getDentist().getName();
            if (a.getServices() != null) a.getServices().size();
        }

        model.addAttribute("appts", appts);
        model.addAttribute("users", userRepository.findAll());
        model.addAttribute("dentists", dentistRepository.findAll());
        model.addAttribute("services", serviceRepository.findAll());
        return "/WEB-INF/jsp/admin-dashboard.jsp";
    }

    @GetMapping("/logout")
    public String logoutAdmin(HttpSession session) {
        session.removeAttribute(SESSION_ADMIN_AUTH);
        return "redirect:/admin/login";
    }

    // ---------------------------
    // DELETE endpoints
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
    // ADMIN EDIT / UPDATE Appointment
    // ---------------------------

    // Show the admin edit form for a specific appointment
    @GetMapping("/appointments/{id}/edit")
    public String showAdminEditAppointment(@PathVariable Long id, HttpSession session, Model model) {
        Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
        if (auth == null || !auth) return "redirect:/admin/login";

        Optional<Appointment> opt = appointmentRepository.findById(id);
        if (opt.isEmpty()) return "redirect:/admin/dashboard";
        Appointment appt = opt.get();

        // defensive touches for lazy loaded fields
        if (appt.getPatient() != null) {
            appt.getPatient().getFirstName();
            appt.getPatient().getLastName();
        }
        if (appt.getDentist() != null) appt.getDentist().getName();
        if (appt.getServices() != null) appt.getServices().size();

        model.addAttribute("appt", appt);
        model.addAttribute("services", serviceRepository.findAll());
        model.addAttribute("dentists", dentistRepository.findAll());
        model.addAttribute("users", userRepository.findAll());
        return "/WEB-INF/jsp/admin-edit-appointment.jsp";
    }

    // Handle update submitted by admin
    @PostMapping("/updateAppointment")
    public String updateAppointment(@RequestParam Long id,
                                    @RequestParam Long dentistId,
                                    @RequestParam(value = "serviceIds", required = false) List<Long> serviceIds,
                                    @RequestParam String date,
                                    @RequestParam String time,
                                    @RequestParam(required = false) String status,
                                    HttpSession session,
                                    Model model) {
        Boolean auth = (Boolean) session.getAttribute(SESSION_ADMIN_AUTH);
        if (auth == null || !auth) return "redirect:/admin/login";

        Optional<Appointment> opt = appointmentRepository.findById(id);
        if (opt.isEmpty()) return "redirect:/admin/dashboard";
        Appointment appt = opt.get();

        List<String> errors = new ArrayList<>();
        if (date == null || date.isBlank()) errors.add("Date required.");
        if (time == null || time.isBlank()) errors.add("Time required.");
        if (dentistId == null) errors.add("Select a dentist.");
        if (!errors.isEmpty()) {
            model.addAttribute("errors", errors);
            model.addAttribute("appt", appt);
            model.addAttribute("services", serviceRepository.findAll());
            model.addAttribute("dentists", dentistRepository.findAll());
            return "/WEB-INF/jsp/admin-edit-appointment.jsp";
        }

        LocalDate d = LocalDate.parse(date);
        LocalTime t = LocalTime.parse(time);

        Dentist dentist = dentistRepository.findById(dentistId).orElse(null);
        appt.setDentist(dentist);
        appt.setAppointmentDate(d);
        appt.setAppointmentStart(t);

        List<Long> ids = (serviceIds == null) ? List.of() : serviceIds;
        Set<ServiceEntity> servs = new HashSet<>(serviceRepository.findAllById(ids));
        appt.setServices(servs);

        int maxDur = appt.getServices().stream()
                .map(s -> s.getDurationMinutes() == null ? 30 : s.getDurationMinutes())
                .max(Integer::compareTo).orElse(30);
        appt.setAppointmentEnd(t.plusMinutes(maxDur));

        if (status != null) appt.setStatus(status);

        appointmentRepository.save(appt);
        return "redirect:/admin/dashboard";
    }

    // ---------------------------
    // UPDATE other entities (unchanged)
    // ---------------------------
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
