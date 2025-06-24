package com.centroinformacion.repository;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.centroinformacion.entity.Solicitud;
import com.centroinformacion.entity.Usuario;


@Repository
public interface SolicitudIngresoRepository extends JpaRepository<Solicitud, Integer> {

	@Query("SELECT s FROM Solicitud s WHERE "
	         + "(?1 = -1 OR s.espacio.idEspacio = ?1) AND "
	         + "(?2 = -1 OR s.vehiculo.tipoVehiculo = ?2) AND "
	         + "(?3 = '' OR s.vehiculo.placa = ?3) AND "
	         + "(?4 = -1 OR s.usuarioRegistro.idUsuario = ?4) AND "  // Filtro por idUsuario
	         + "(s.fechaReserva >= ?5) AND "
	         + "(s.fechaReserva <= ?6)"
	         + "ORDER BY s.estado DESC") // Ordenar por idSolicitud de forma descendente
	List<Solicitud> listaConsultaSolicitudAvanzado(int idEspacio, int tipoVehiculo, String placa, int idUsuario, Date fecDesde, Date fecHasta);

	
	Optional<Solicitud> findById(Integer idSolicitud);
    
    boolean existsByUsuarioRegistroAndEstado(Usuario usuarioRegistro, int estado);
    // Método personalizado para obtener solicitudes de usuarios con rol 4
    @Query("SELECT s FROM Solicitud s " +
           "JOIN s.usuarioRegistro ur " +  // Asumiendo que tienes la relación con Usuario
           "JOIN ur.usuarioHasRol uhr " +  // Si tienes la relación con roles del usuario
           "WHERE uhr.rol.idRol = :idRol") // Filtramos por el idRol del rol
    List<Solicitud> findSolicitudesPorRol(@Param("idRol") int idRol);
    @Query("SELECT s FROM Solicitud s WHERE s.entrada = 1 AND s.salida = 0")
    List<Solicitud> findSolicitudesActivas();
}
