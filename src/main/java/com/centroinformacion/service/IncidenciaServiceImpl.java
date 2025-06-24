package com.centroinformacion.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.centroinformacion.entity.Incidencia;
import com.centroinformacion.repository.IncidenciaRepository;
@Service

public class IncidenciaServiceImpl implements IncidenciaService {
	@Autowired
	    private IncidenciaRepository repository;
	@Override
	public Incidencia insertaActualizaIncidencia(Incidencia obj) {
		// TODO Auto-generated method stub
		return repository.save(obj);
	}
	@Override
    public List<Incidencia> listaIncidencias() {
        return repository.findAll();
    }
	 @Override
	    public Incidencia buscarIncidenciaPorId(int idIncidencia) {
	        return repository.findById(idIncidencia).orElse(null);  // Devuelve null si no se encuentra
	    }
	 
	  @Override
	    public Incidencia guardarIncidencia(Incidencia incidencia) {
	        return repository.save(incidencia);
	    }
}
