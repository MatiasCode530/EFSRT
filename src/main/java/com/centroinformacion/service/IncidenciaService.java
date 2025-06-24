package com.centroinformacion.service;

import java.util.List;

import com.centroinformacion.entity.Incidencia;

public interface IncidenciaService {
    public abstract Incidencia insertaActualizaIncidencia(Incidencia obj); // Cambiado a Solicitud
    List<Incidencia> listaIncidencias();
    Incidencia buscarIncidenciaPorId(int idIncidencia);
    Incidencia guardarIncidencia(Incidencia incidencia);

}
