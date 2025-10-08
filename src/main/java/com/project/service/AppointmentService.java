package com.project.service;

import com.project.model.Appointment;
import com.project.model.Dentist;
import com.project.repository.AppointmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Service
public class AppointmentService {
    @Autowired
    private AppointmentRepository repo;

    public Appointment book(Appointment appt) {
        Dentist d = appt.getDentist();
        if (d != null && repo.existsByDentistAndAppointmentDateAndAppointmentStart(d, appt.getAppointmentDate(), appt.getAppointmentStart())) {
            throw new IllegalStateException("Selected time slot is already booked for this dentist.");
        }
        appt.setStatus("PENDING");
        return repo.save(appt);
    }

    public List<Appointment> getByPatient(Long patientId) {
        return repo.findByPatientId(patientId);
    }

    public List<Appointment> getAll() { return repo.findAll(); }

    public List<Appointment> getByDentistAndDate(Long dentistId, LocalDate date) {
        return repo.findByDentistIdAndAppointmentDate(dentistId, date);
    }
}
