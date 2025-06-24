package com.centroinformacion.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.RolHasOpcion;
import com.centroinformacion.entity.RolHasOpcionPK;
import com.centroinformacion.repository.RolHasOpcionRepository;
import com.centroinformacion.repository.RolRepository;

@Service
public class RolServiceImpl implements RolService{

	@Autowired
	private RolRepository rolRepository;
	
	@Autowired
	private RolHasOpcionRepository rolHasOpcionRepository;
	
	@Override
	public List<Rol> listaRol() {
		return rolRepository.findAll();
	}

	@Override
	public List<Opcion> traerOpcionDeRol(int idRol) {
		return rolRepository.traerOpcionDeRol(idRol);
	}

	@Override
	public RolHasOpcion insertaOpcion(RolHasOpcion obj) {
		return rolHasOpcionRepository.save(obj);
	}

	@Override
	public void eliminaOpcion(RolHasOpcion obj) {
		rolHasOpcionRepository.delete(obj);	
	}

	@Override
	public Optional<RolHasOpcion> buscaOpcion(RolHasOpcionPK obj) {
		return rolHasOpcionRepository.findById(obj);
	}
}
