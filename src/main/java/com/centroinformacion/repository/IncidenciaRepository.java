package com.centroinformacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.centroinformacion.entity.Incidencia;

@Repository

public interface IncidenciaRepository extends JpaRepository<Incidencia, Integer>{

}
