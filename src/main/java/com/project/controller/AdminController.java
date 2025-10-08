package com.project.controller;

import com.project.model.Appointment;
import com.project.model.Dentist;
import com.project.model.User;
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

    private static final String ADMIN_USER = "Admin123!";
    private static final String ADMIN_PASS = "Admin123!";

    @Autowired private AppointmentRepository apptRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private DentistRepository dentistRepo;

    @GetMapping("/login")
    public String showLogin() { return "/WEB-INF/jsp/admin-login.jsp"; }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        if (ADMIN_USER.equals(username) && ADMIN_PASS.equals(password)) {
            session.setAttribute("admin", true);
            return "redirect:/admin/dashboard";
        } else {
            model.addAttribute("error", "Invalid admin credentials.");
            return "/WEB-INF/jsp/admin-login.jsp";
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("admin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";

        List<Appointment> appts = apptRepo.findAll();
        List<User> users = userRepo.findAll();
        List<Dentist> dentists = dentistRepo.findAll();
        model.addAttribute("appts", appts);
        model.addAttribute("users", users);
        model.addAttribute("dentists", dentists);
        return "/WEB-INF/jsp/admin-dashboard.jsp";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) { session.removeAttribute("admin"); return "redirect:/admin/login"; }

    @PostMapping("/appointments/{id}/delete")
    public String deleteAppointment(@PathVariable Long id, HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("admin");
        if (isAdmin == null || !isAdmin) return "redirect:/admin/login";
        apptRepo.deleteById(id);
        return "redirect:/admin/dashboard";
    }
}
