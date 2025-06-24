package com.centroinformacion.controller;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.entity.UsuarioHasRolPK;
import com.centroinformacion.service.RolService;
import com.centroinformacion.service.UsuarioService;

@Controller
public class RolTransaccionController {

	@Autowired 
	private UsuarioService usuarioService;
	
	@Autowired 
	private RolService rolService;
	
	@ResponseBody()
	@GetMapping("/listaRoles")
	public List<Rol> lista(){
		return rolService.listaRol(); 
	}
	
	@ResponseBody()
	@GetMapping("/listaUsuario")
	public List<Usuario> listaUsuario(){
		return usuarioService.listaUsuario(); 
	}
	
	@ResponseBody()
	@GetMapping("/listaRolPorUsuario")
	public List<Rol> listaRolUsuario(int idUsuario){
		return usuarioService.traerRolesDeUsuario(idUsuario);
	}
	
	@ResponseBody()
	@PostMapping("/registraRol")
	public HashMap<String, Object> registro(int idUsuario, int idRol){
		HashMap<String, Object> maps = new HashMap<>();
		
		UsuarioHasRolPK pk = new UsuarioHasRolPK();
		pk.setIdRol(idRol);
		pk.setIdUsuario(idUsuario);
		
		UsuarioHasRol usp = new UsuarioHasRol();
		usp.setUsuarioHasRolPk(pk);
		
		if (usuarioService.buscaRol(pk).isPresent()) {
			maps.put("mensaje", "El rol ya existe");
		}else {
			UsuarioHasRol objUsp = usuarioService.insertaRol(usp);
			if (objUsp == null) {
				maps.put("mensaje", "Error en el registro");
			}else {
				maps.put("mensaje", "Registro existoso");
			}
		}
		
		List<Rol> lstSalida = usuarioService.traerRolesDeUsuario(idUsuario);
		maps.put("lista", lstSalida);
		maps.put("usuario", idUsuario);
		return maps;
	}
	
	@ResponseBody()
	@PostMapping("/eliminaRol")
	public HashMap<String, Object> elimina(int idUsuario, int idRol){
		HashMap<String, Object> maps = new HashMap<>();
		
		UsuarioHasRolPK pk = new UsuarioHasRolPK();
		pk.setIdRol(idRol);
		pk.setIdUsuario(idUsuario);
		
		UsuarioHasRol usp = new UsuarioHasRol();
		usp.setUsuarioHasRolPk(pk);
		
		if (usuarioService.buscaRol(pk).isPresent()) {
			usuarioService.eliminaRol(usp);
			maps.put("mensaje", "Se elimin&oacute;el rol");
		}else {
			maps.put("mensaje", "No existe rol");
		}
		
		List<Rol> lstSalida = usuarioService.traerRolesDeUsuario(idUsuario);
		maps.put("lista", lstSalida);
		maps.put("usuario", idUsuario);
		return maps;
	}
}
