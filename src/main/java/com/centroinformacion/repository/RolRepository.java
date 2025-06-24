package com.centroinformacion.repository;


import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;

public interface RolRepository extends JpaRepository<Rol, Integer>{


	@Query("Select r.opcion from RolHasOpcion r where r.rol.idRol = ?1")
	public abstract List<Opcion> traerOpcionDeRol(int idRol);

}
