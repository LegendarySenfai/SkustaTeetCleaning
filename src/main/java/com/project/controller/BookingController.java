package com.project.controller;

import com.project.model.*;
import com.project.otp.EmailService;
import com.project.otp.OtpInfo;
import com.project.otp.OtpService;
import com.project.repository.*;
import com.project.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

@Controller
public class BookingController {

    @Autowired private ServiceRepository serviceRepo;
    @Autowired private DentistRepository dentistRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private AppointmentRepository appointmentRepo;
    @Autowired private AppointmentService appointmentService;
    @Autowired private OtpService otpService;
    @Autowired private EmailService emailService;

    @GetMapping("/")
    public String home() { return "redirect:/book"; }

    @GetMapping("/DentalClinic")
    public String Landingpage() {
        return "/WEB-INF/jsp/landingpage.jsp";
    }

    @GetMapping("/book")
    public String showBookPage(@RequestParam(required=false) String date, Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        model.addAttribute("services", serviceRepo.findAll());
        model.addAttribute("dentists", dentistRepo.findAll());
        model.addAttribute("selectedDate", date);
        return "/WEB-INF/jsp/book.jsp";
    }

    @GetMapping("/api/available")
    @ResponseBody
    public List<String> availableTimes(@RequestParam(required = false) Long dentistId,
                                       @RequestParam String date) {
        LocalDate d = LocalDate.parse(date);
        List<LocalTime> slots = generateSlots();
        Set<LocalTime> occupied = new HashSet<>();
        if (dentistId != null && !dentistId.toString().isBlank()) {
            List<Appointment> booked = appointmentRepo.findByDentistIdAndAppointmentDate(dentistId, d);
            for (Appointment a : booked) occupied.add(a.getAppointmentStart());
        } else {
            List<Appointment> bookedAll = appointmentRepo.findAll();
            for (Appointment a : bookedAll) if (d.equals(a.getAppointmentDate())) occupied.add(a.getAppointmentStart());
        }
        List<String> out = new ArrayList<>();
        for (LocalTime t : slots) out.add(t.toString() + (occupied.contains(t) ? "|false" : "|true"));
        return out;
    }

    private List<LocalTime> generateSlots() {
        List<LocalTime> list = new ArrayList<>();
        LocalTime start = LocalTime.of(9,0);
        LocalTime end = LocalTime.of(16,30);
        LocalTime t = start;
        while (!t.isAfter(end)) {
            list.add(t);
            t = t.plusMinutes(30);
        }
        return list;
    }

    @PostMapping("/book")
    public String doBook(@RequestParam(required = false) Long dentistId,
                         @RequestParam(value = "serviceIds", required = false) List<Long> serviceIds,
                         @RequestParam String date,
                         @RequestParam String time,
                         HttpSession session,
                         Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        // Prevent multiple active appointments per user
        // --- CHANGED: only PENDING (or null) counts as an active appointment that blocks booking.
        List<Appointment> existing = appointmentRepo.findByPatientId(userId);
        boolean hasActive = existing.stream().anyMatch(a -> {
            String s = a.getStatus();
            // treat null as pending (legacy rows), and only "PENDING" blocks booking.
            return s == null || s.equalsIgnoreCase("PENDING");
        });
        if (hasActive) {
            model.addAttribute("errors", List.of("You already have an active appointment. Cancel or complete it before booking a new one."));
            model.addAttribute("services", serviceRepo.findAll());
            model.addAttribute("dentists", dentistRepo.findAll());
            model.addAttribute("selectedDate", date);
            return "/WEB-INF/jsp/book.jsp";
        }

        List<String> errors = new ArrayList<>();
        if (serviceIds == null || serviceIds.isEmpty()) errors.add("Select at least one service.");
        if (date == null || date.isBlank()) errors.add("Select a date.");
        if (time == null || time.isBlank()) errors.add("Select a time.");
        if (dentistId == null) errors.add("Select a dentist."); // will now be handled here instead of throwing 400

        LocalDate d = null;
        LocalTime t = null;
        try {
            d = LocalDate.parse(date);
            if (d.isBefore(LocalDate.now())) errors.add("Date cannot be in the past.");
        } catch (Exception ex) { errors.add("Invalid date format."); }
        try { t = LocalTime.parse(time); } catch (Exception ex) { errors.add("Invalid time format."); }

        Dentist dentist = null;
        if (dentistId != null) {
            dentist = dentistRepo.findById(dentistId).orElse(null);
            if (dentist == null) errors.add("Selected dentist not found.");
        }

        if (!errors.isEmpty()) {
            model.addAttribute("errors", errors);
            model.addAttribute("services", serviceRepo.findAll());
            model.addAttribute("dentists", dentistRepo.findAll());
            model.addAttribute("selectedDate", date);
            return "/WEB-INF/jsp/book.jsp";
        }

        // At this point dentist is non-null and valid
        if (appointmentRepo.existsByDentistAndAppointmentDateAndAppointmentStart(dentist, d, t)) {
            model.addAttribute("errors", List.of("Selected slot is already booked."));
            model.addAttribute("services", serviceRepo.findAll());
            model.addAttribute("dentists", dentistRepo.findAll());
            return "/WEB-INF/jsp/book.jsp";
        }

        User patient = userRepo.findById(userId).orElseThrow();
        Appointment appt = new Appointment();
        appt.setPatient(patient);
        appt.setDentist(dentist);

        // make sure serviceIds isn't null (we already validated above)
        Set<ServiceEntity> servs = new HashSet<>(serviceRepo.findAllById(serviceIds == null ? Collections.emptyList() : serviceIds));
        appt.setServices(servs);
        appt.setAppointmentDate(d);
        appt.setAppointmentStart(t);
        int maxDur = servs.stream().map(s -> s.getDurationMinutes() == null ? 30 : s.getDurationMinutes()).max(Integer::compareTo).orElse(30);
        appt.setAppointmentEnd(t.plusMinutes(maxDur));
        appt.setStatus("PENDING");
        appointmentRepo.save(appt);

        model.addAttribute("appt", appt);
        return "/WEB-INF/jsp/confirm.jsp";
    }

    @GetMapping("/myappointments")
    public String myAppointments(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        model.addAttribute("appointments", appointmentService.getByPatient(userId));
        return "/WEB-INF/jsp/appointments.jsp";
    }

    @GetMapping("/appointments/{id}/edit")
    public String editAppointment(@PathVariable Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Optional<Appointment> o = appointmentRepo.findById(id);
        if (o.isEmpty()) return "redirect:/myappointments";
        Appointment appt = o.get();
        if (!appt.getPatient().getId().equals(userId)) return "redirect:/myappointments";

        model.addAttribute("appt", appt);
        model.addAttribute("services", serviceRepo.findAll());
        model.addAttribute("dentists", dentistRepo.findAll());
        return "/WEB-INF/jsp/edit.jsp";
    }

    @PostMapping("/appointments/{id}/edit")
    public String updateAppointment(@PathVariable Long id,
                                    @RequestParam Long dentistId,
                                    @RequestParam(value = "serviceIds", required = false) List<Long> serviceIds,
                                    @RequestParam String date,
                                    @RequestParam String time,
                                    HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Optional<Appointment> o = appointmentRepo.findById(id);
        if (o.isEmpty()) return "redirect:/myappointments";
        Appointment appt = o.get();
        if (!appt.getPatient().getId().equals(userId)) return "redirect:/myappointments";

        List<String> errors = new ArrayList<>();
        if (serviceIds == null || serviceIds.isEmpty()) errors.add("Select at least one service.");
        LocalDate d = null; LocalTime newTime = null;
        try { d = LocalDate.parse(date); if (d.isBefore(LocalDate.now())) errors.add("Date cannot be in the past."); } catch (Exception ex) { errors.add("Invalid date format."); }
        try { newTime = LocalTime.parse(time); } catch (Exception ex) { errors.add("Invalid time format."); }
        Dentist dentist = dentistRepo.findById(dentistId).orElse(null);
        if (dentist == null) errors.add("Selected dentist not found.");
        if (!errors.isEmpty()) {
            model.addAttribute("errors", errors);
            model.addAttribute("appt", appt);
            model.addAttribute("services", serviceRepo.findAll());
            model.addAttribute("dentists", dentistRepo.findAll());
            return "/WEB-INF/jsp/edit.jsp";
        }

        final Long apptIdForCheck = appt.getId();
        final LocalDate dateForCheck = d;
        final LocalTime timeForCheck = newTime;
        final Long dentistIdForCheck = dentist.getId();

        boolean conflict = appointmentRepo.findByDentistIdAndAppointmentDate(dentistIdForCheck, dateForCheck).stream()
                .anyMatch(a -> !a.getId().equals(apptIdForCheck) && a.getAppointmentStart().equals(timeForCheck));
        if (conflict) {
            model.addAttribute("errors", List.of("Selected slot is already booked."));
            model.addAttribute("appt", appt);
            model.addAttribute("services", serviceRepo.findAll());
            model.addAttribute("dentists", dentistRepo.findAll());
            return "/WEB-INF/jsp/edit.jsp";
        }

        appt.setDentist(dentist);
        Set<ServiceEntity> servs = new HashSet<>(serviceRepo.findAllById(serviceIds));
        appt.setServices(servs);
        appt.setAppointmentDate(d);
        appt.setAppointmentStart(newTime);
        int maxDur = servs.stream().map(s -> s.getDurationMinutes() == null ? 30 : s.getDurationMinutes()).max(Integer::compareTo).orElse(30);
        appt.setAppointmentEnd(newTime.plusMinutes(maxDur));
        appointmentRepo.save(appt);

        model.addAttribute("appt", appt);
        return "/WEB-INF/jsp/confirm.jsp";
    }

    //
    // Cancellation with OTP endpoints
    //

    @GetMapping("/appointments/{id}/cancel-request")
    public String cancelRequest(@PathVariable Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Optional<Appointment> opt = appointmentRepo.findById(id);
        if (opt.isEmpty()) return "redirect:/myappointments";
        Appointment appt = opt.get();
        if (!appt.getPatient().getId().equals(userId)) return "redirect:/myappointments";

        User patient = appt.getPatient();
        if (patient.getEmail() == null || patient.getEmail().isBlank()) {
            model.addAttribute("error", "No email on file. Please update profile with email.");
            model.addAttribute("appointments", appointmentService.getByPatient(userId));
            return "/WEB-INF/jsp/appointments.jsp";
        }
        OtpInfo otp = otpService.createAndStoreOtp(session, userId, id, "CANCEL_APPOINTMENT");
        emailService.sendOtpEmail(patient.getEmail(), "Appointment cancel OTP", "Your cancellation OTP is: " + otp.getCode());

        model.addAttribute("appointmentId", id);
        model.addAttribute("msg", "OTP sent to " + patient.getEmail());
        return "/WEB-INF/jsp/cancel-otp.jsp";
    }

    @GetMapping("/appointments/{id}/cancel-otp")
    public String showCancelOtp(@PathVariable Long id, Model model, HttpSession session) {
        model.addAttribute("appointmentId", id);
        return "/WEB-INF/jsp/cancel-otp.jsp";
    }

    @PostMapping("/appointments/{id}/cancel-confirm")
    public String confirmCancel(@PathVariable Long id,
                                @RequestParam String code,
                                HttpSession session,
                                Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        OtpInfo info = otpService.getOtpFromSession(session, id, userId, "CANCEL_APPOINTMENT");
        if (info == null || otpService.isExpired(info) || !info.getCode().equals(code)) {
            model.addAttribute("error", "Invalid or expired OTP.");
            model.addAttribute("appointmentId", id);
            return "/WEB-INF/jsp/cancel-otp.jsp";
        }
        Optional<Appointment> o = appointmentRepo.findById(id);
        if (o.isEmpty()) return "redirect:/myappointments";
        Appointment appt = o.get();
        if (!appt.getPatient().getId().equals(userId)) return "redirect:/myappointments";

        appt.setStatus("CANCELLED");
        appointmentRepo.save(appt);
        otpService.removeOtpFromSession(session, id, userId, "CANCEL_APPOINTMENT");

        return "redirect:/myappointments";
    }
}
