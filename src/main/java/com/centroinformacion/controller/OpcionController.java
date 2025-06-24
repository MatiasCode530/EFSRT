package com.centroinformacion.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.centroinformacion.entity.Opcion;
import com.centroinformacion.entity.Rol;
import com.centroinformacion.entity.RolHasOpcion;
import com.centroinformacion.entity.RolHasOpcionPK;
import com.centroinformacion.service.OpcionService;
import com.centroinformacion.service.RolService;

@Controller
public class OpcionController {
	@Autowired
	private RolService rolService;
	
	@Autowired
	private OpcionService opcionService;
	
	@ResponseBody
	@GetMapping("/listaRol")
	public List<Rol> listaRol(){
		return rolService.listaRol();
	}
	
	@ResponseBody
	@GetMapping("/listaOpcion")
	public List<Opcion> listaPasatiempo(){
		return  opcionService.listaOpcion();
	}
	
	
	@ResponseBody
	@GetMapping("/listaOpcionPorRol")
	public List<Opcion> listaOpcionPorRol(int idRol){
		return  rolService.traerOpcionDeRol(idRol);
	}
	
	@ResponseBody
	@PostMapping("/registraOpcion")
	public HashMap<String, Object> registro(int idRol, int idOpcion){
		HashMap<String, Object> maps = new HashMap<String, Object>();
		RolHasOpcionPK pk = new RolHasOpcionPK();
		pk.setIdOpcion(idOpcion);
		pk.setIdRol(idRol);

		RolHasOpcion obj = new RolHasOpcion();
		obj.setRolHasOpcionPK(pk);
		
		Optional<RolHasOpcion> existentOpcion = rolService.buscaOpcion(pk);
        if (existentOpcion.isEmpty()) {
        	RolHasOpcion objSalida = rolService.insertaOpcion(obj);
        	if (objSalida == null) {
        		maps.put("mensaje", "Error en el registro");		
        	}else {
        		maps.put("mensaje", "Registro exitoso");
        	}
        }else {
        	maps.put("mensaje", "Registro Exitoso");
        }
        List<Opcion> lstOpcion =  rolService.traerOpcionDeRol(idRol);
        maps.put("lista", lstOpcion);
        maps.put("rol", idRol);
		return maps;
	}
	
	@ResponseBody
	@PostMapping("/eliminaOpcion")
	public HashMap<String, Object> elimina(int idRol, int idOpcion){
		HashMap<String, Object> maps = new HashMap<String, Object>();
		
		RolHasOpcionPK pk = new RolHasOpcionPK();
		pk.setIdOpcion(idOpcion);
		pk.setIdRol(idRol);

		RolHasOpcion obj = new RolHasOpcion();
		obj.setRolHasOpcionPK(pk);
		
		rolService.eliminaOpcion(obj);
		maps.put("mensaje", "Eliminaci&oacute;n exitosa");
		
		List<Opcion> lstOpcion =  rolService.traerOpcionDeRol(idRol);
        maps.put("lista", lstOpcion);
        maps.put("rol", idRol);
		
		return maps;
	}
}
