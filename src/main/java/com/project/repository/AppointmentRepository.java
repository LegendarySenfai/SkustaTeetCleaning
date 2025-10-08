package com.project.repository;

import com.project.model.Appointment;
import com.project.model.Dentist;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    boolean existsByDentistAndAppointmentDateAndAppointmentStart(Dentist dentist, LocalDate date, LocalTime start);
    List<Appointment> findByPatientId(Long patientId);
    List<Appointment> findByDentistIdAndAppointmentDate(Long dentistId, LocalDate date);
    List<Appointment> findByDentistId(Long dentistId);
}
