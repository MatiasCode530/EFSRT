package com.centroinformacion.service;

import java.util.List;
import java.util.Optional;

import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.RolHasOpcion;
import com.centroinformacion.entity.RolHasOpcionPK;

public interface RolService {

	public abstract List<Rol> listaRol();
	public abstract List<Opcion> traerOpcionDeRol(int idRol);
	
	public abstract RolHasOpcion insertaOpcion(RolHasOpcion obj);
	public abstract void eliminaOpcion(RolHasOpcion obj);
	public abstract Optional<RolHasOpcion> buscaOpcion(RolHasOpcionPK obj);

}
