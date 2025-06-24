package com.centroinformacion.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.entity.UsuarioHasRolPK;

public interface UsuarioHasRolRepository extends JpaRepository<UsuarioHasRol, UsuarioHasRolPK>{
	// Esta consulta devuelve una lista de usuarios que tienen un rol específico
    @Query("SELECT uhr FROM UsuarioHasRol uhr WHERE uhr.rol.idRol = :idRol")
    List<UsuarioHasRol> findUsuarioHasRolByRol(@Param("idRol") int idRol);
    List<UsuarioHasRol> findByUsuario(Usuario usuario);

}
