package com.centroinformacion.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.centroinformacion.entity.Incidencia;
import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasIncidencia;
import com.centroinformacion.entity.UsuarioHasIncidenciaPK;
import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.entity.UsuarioHasRolPK;
import com.centroinformacion.repository.RolRepository;
import com.centroinformacion.repository.UsuarioHasIncidenciaRepository;
import com.centroinformacion.repository.UsuarioHasRolRepository;
import com.centroinformacion.repository.UsuarioRepository;
import com.centroinformacion.util.PasswordUtil;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UsuarioServiceImpl implements UsuarioService{

	@Autowired
	private UsuarioRepository repository;
	@Autowired
	private RolRepository rolRepository;
	@Autowired 
	private UsuarioHasIncidenciaRepository usuarioHasIncidenciaRepository;
	@Autowired
	private UsuarioHasRolRepository usuarioHasRolRepository;
	  @Autowired
	    private PasswordEncoder passwordEncoder;
	 @Override
	    public Usuario login(Usuario bean) {
	        // Buscar el usuario por su login
	        Usuario usuario = repository.findByLogin(bean.getLogin());
	        
	        if (usuario != null && passwordEncoder.matches(bean.getPassword(), usuario.getPassword())) {
	            // Si la contraseña coincide con la de la base de datos, devolver el usuario
	            return usuario;
	        } else {
	            // Si las contraseñas no coinciden
	            return null;
	        }
	    }

	@Override
	public List<Opcion> traerEnlacesDeUsuario(int idUsuario) {
		return repository.traerEnlacesDeUsuario(idUsuario);
	}

	@Override
	public List<Rol> traerRolesDeUsuario(int idUsuario) {
		return repository.traerRolesDeUsuario(idUsuario);
	}

	@Override
	public Usuario buscaPorLogin(String login) {
		return repository.findByLogin(login);
	}

	@Override
	public List<Usuario> listaUsuario() {
		return repository.findAll();
	}

	@Override
	public UsuarioHasRol insertaRol(UsuarioHasRol obj) {
		return usuarioHasRolRepository.save(obj);
	}

	@Override
	public void eliminaRol(UsuarioHasRol obj) {
		usuarioHasRolRepository.delete(obj);
	}

	@Override
	public Optional<UsuarioHasRol> buscaRol(UsuarioHasRolPK obj) {
		return usuarioHasRolRepository.findById(obj);
	}
	@Override
	public void encriptarContraseñas() {
	    List<Usuario> usuarios = repository.findAll();
	    System.out.println("Cantidad de usuarios a revisar: " + usuarios.size());

	    for (Usuario usuario : usuarios) {
	        String contraseñaActual = usuario.getPassword();
	        System.out.println("Contraseña original de usuario " + usuario.getLogin() + ": " + contraseñaActual);

	        // Encriptar solo contraseñas no encriptadas
	        if (!contraseñaActual.startsWith("$2a$")) { // Verifica si ya es BCrypt
	            String contraseñaEncriptada = PasswordUtil.encode(contraseñaActual);
	            usuario.setPassword(contraseñaEncriptada);
	            repository.save(usuario); // Actualiza el usuario en la BD
	            System.out.println("Contraseña encriptada para usuario " + usuario.getLogin() + ": " + contraseñaEncriptada);
	        }
	    }
	}

	@Override
	public UsuarioHasIncidencia insertaIncidencia(UsuarioHasIncidencia obj) {
		// TODO Auto-generated method stub
		return usuarioHasIncidenciaRepository.save(obj);
	}

	@Override
	public void eliminaIncidencia(UsuarioHasIncidencia obj) {
		usuarioHasIncidenciaRepository.delete(obj);
	}

	@Override
	public Optional<UsuarioHasIncidencia> buscaIncidencia(UsuarioHasIncidenciaPK obj) {
		// TODO Auto-generated method stub
		return usuarioHasIncidenciaRepository.findById(obj);
	}

	@Override
    public UsuarioHasIncidencia asignarIncidencia(UsuarioHasIncidencia usuarioHasIncidencia) {
        return usuarioHasIncidenciaRepository.save(usuarioHasIncidencia);
    }

    @Override
    public void eliminarIncidencia(UsuarioHasIncidencia usuarioHasIncidencia) {
        usuarioHasIncidenciaRepository.delete(usuarioHasIncidencia);
    }

    @Override
    public List<UsuarioHasIncidencia> traerIncidenciasDeUsuario(int idUsuario) {
        return usuarioHasIncidenciaRepository.findIncidenciasByUsuario(idUsuario);
    }
    @Override
    public Usuario buscarUsuarioPorId(int idUsuario) {
        return repository.findById(idUsuario).orElse(null);  // Devuelve null si no se encuentra
    }

 // En UsuarioServiceImpl (implementación del servicio)
    @Override
    public UsuarioHasRol asignarRolAUsuario(Usuario usuario, int idRol) {
        // Buscar el rol por id
        Rol rol = rolRepository.findById(idRol).orElseThrow(() -> new RuntimeException("Rol no encontrado"));

        // Crear la relación UsuarioHasRol
        UsuarioHasRol usuarioHasRol = new UsuarioHasRol();
        UsuarioHasRolPK usuarioHasRolPK = new UsuarioHasRolPK();
        usuarioHasRolPK.setIdUsuario(usuario.getIdUsuario());
        usuarioHasRolPK.setIdRol(rol.getIdRol());

        usuarioHasRol.setUsuario(usuario);
        usuarioHasRol.setRol(rol);
        usuarioHasRol.setUsuarioHasRolPk(usuarioHasRolPK);

        // Guardar la relación
        return usuarioHasRolRepository.save(usuarioHasRol);
    }

	@Override
	public Usuario save(Usuario usuario) {
		// TODO Auto-generated method stub
        return repository.save(usuario);
	}

	@Override
	public Usuario findByLogin(String login) {
		// TODO Auto-generated method stub
        return repository.findByLogin(login);
	}

	@Override
	public Optional<Usuario> findByCorreo(String correo) {
		// TODO Auto-generated method stub
        return repository.findByCorreo(correo);
	}

	@Override
	public Optional<Usuario> BuscarPorLogin(String login) {
		// TODO Auto-generated method stub
		return repository.BuscarPorLogin(login);
	}

	@Override
	public Optional<Usuario> BuscarPorCorreo(String correo) {
		// TODO Auto-generated method stub
		return repository.BuscarPorCorreo(correo);
	}


}
