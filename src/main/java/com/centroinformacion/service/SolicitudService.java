package com.centroinformacion.service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

import com.centroinformacion.entity.Solicitud; // Aseg&uacute;rate de que la entidad Solicitud est&eacute; importada
import com.centroinformacion.entity.Usuario;

public interface SolicitudService {
    public abstract Solicitud insertaActualizaSolicitud(Solicitud obj); // Cambiado a Solicitud
    public abstract List<Solicitud> listaConsultaEspacio(int idEspacio,int tipoVehiculo,String placa,int idUsuario, Date fecDesde, Date fecHasta);
	public abstract Optional<Solicitud> buscaSolicitud(int idSolicitud);
    boolean existeSolicitudActiva(Usuario usuarioRegistro); // Cambia a Usuario

}
