package com.centroinformacion.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.centroinformacion.entity.Incidencia;
import com.centroinformacion.entity.UsuarioHasIncidencia;
import com.centroinformacion.entity.UsuarioHasIncidenciaPK;

public interface UsuarioHasIncidenciaRepository extends JpaRepository<UsuarioHasIncidencia, UsuarioHasIncidenciaPK> {

    // Consulta para encontrar todas las incidencias asociadas a un usuario
    @Query("SELECT uhi FROM UsuarioHasIncidencia uhi WHERE uhi.usuario.idUsuario = :idUsuario")
    List<UsuarioHasIncidencia> findIncidenciasByUsuario(@Param("idUsuario") int idUsuario);

    // Consulta para encontrar todas las incidencias asociadas a una incidencia
    @Query("SELECT uhi FROM UsuarioHasIncidencia uhi WHERE uhi.incidencia.idIncidencia = :idIncidencia")
    List<UsuarioHasIncidencia> findUsuariosByIncidencia(@Param("idIncidencia") int idIncidencia);
    @Query("SELECT COUNT(uhi) FROM UsuarioHasIncidencia uhi WHERE uhi.usuario.idUsuario = :idUsuario")
    int contarIncidenciasPorUsuario(@Param("idUsuario") int idUsuario);


}
