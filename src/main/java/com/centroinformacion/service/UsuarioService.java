package com.centroinformacion.service;

import java.util.List;
import java.util.Optional;

import com.centroinformacion.entity.Incidencia;
import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasIncidencia;
import com.centroinformacion.entity.UsuarioHasIncidenciaPK;
import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.entity.UsuarioHasRolPK;

public interface UsuarioService {
	public abstract Usuario save(Usuario usuario);  // Guardar el usuario en la base de datos

	public abstract Usuario login(Usuario bean);
	public abstract List<Opcion> traerEnlacesDeUsuario(int idUsuario);
	public abstract List<Rol> traerRolesDeUsuario(int idUsuario);
	public abstract Usuario buscaPorLogin(String login);
	public abstract List<Usuario> listaUsuario();

	public abstract UsuarioHasRol insertaRol(UsuarioHasRol obj);
	public abstract void eliminaRol(UsuarioHasRol obj);
	public abstract Optional<UsuarioHasRol> buscaRol(UsuarioHasRolPK obj);
	
	
	  // Métodos para manejar incidencias
    public abstract UsuarioHasIncidencia insertaIncidencia(UsuarioHasIncidencia obj);
    public abstract void eliminaIncidencia(UsuarioHasIncidencia obj);
    public abstract Optional<UsuarioHasIncidencia> buscaIncidencia(UsuarioHasIncidenciaPK obj);

    
    void encriptarContraseñas(); // Método para migrar contraseñas
    
    
    // Método para asignar una incidencia a un usuario
    UsuarioHasIncidencia asignarIncidencia(UsuarioHasIncidencia usuarioHasIncidencia);
    
    // Método para eliminar la relación usuario-incidencia
    void eliminarIncidencia(UsuarioHasIncidencia usuarioHasIncidencia);
    
    // Obtener todas las incidencias de un usuario
    List<UsuarioHasIncidencia> traerIncidenciasDeUsuario(int idUsuario);
    Usuario buscarUsuarioPorId(int idUsuario);

    public abstract UsuarioHasRol asignarRolAUsuario(Usuario usuario, int idRol);

    Usuario findByLogin(String login);  // Buscar usuario por login}
    
    Optional<Usuario> findByCorreo(String correo);  // Buscar usuario por correo
    
    Optional<Usuario> BuscarPorCorreo(String correo); 
    Optional<Usuario> BuscarPorLogin(String login); 

    


}
