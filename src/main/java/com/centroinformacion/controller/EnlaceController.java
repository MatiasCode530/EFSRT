package com.centroinformacion.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class EnlaceController {

	//Login
	@GetMapping("/")
	public String verLogin() {	return "intranetLogin";  }
	
	@GetMapping("/verIntranetHome")
	public String verIntranetHome() {	return "intranetHome";  }

	@GetMapping("/verRegistroVehiculo")
	public String verRegistroVehiculo() {
	    return "intranetRegistroVehiculo";  // Para alumnos y proveedores
	}

	@GetMapping("/verRegistroSolicitud")
	public String verRegistroSolicitud() {
	    return "intranetRegistroSolicitud";  // Para alumnos y proveedores
	}

	// Opciones para los alumnos (tipo = 2)
	@GetMapping("/verRegistroVehiculoAlumnos")
	public String verRegistroVehiculoAlumnos() {
	    return "intranetRegistroVehiculo";  // Para alumnos
	}

	@GetMapping("/verRegistroSolicitudAlumnos")
	public String verRegistroSolicitudAlumnos() {
	    return "intranetRegistroSolicitud";  // Para alumnos
	}

	// Opciones para los miembros de seguridad (tipo = 3)
	@GetMapping("/verReporteIncidencia")
	public String verReporteIncidencia() {
	    return "intranetReporteIncidencia";  // Para miembros de seguridad
	}

	@GetMapping("/verReporteIngresoSalida")
	public String verReporteIngresoSalida() {
	    return "intranetReporteIngresoSalida";  // Para miembros de seguridad
	}

	@GetMapping("/verValidacionSolicitudEspecial")
	public String verValidacionSolicitudEspecial() {
	    return "intranetValidacionSolicitudEspecial";  // Para miembros de seguridad
	}

	@GetMapping("/verRegistroEntradaSalida")
	public String verRegistroEntradaSalida() {
	    return "intranetRegistroEntradaSalida";  // Para miembros de seguridad
	}

	// Opciones para los proveedores (tipo = 4)
	@GetMapping("/verRegistroVehiculoProveedor")
	public String verRegistroVehiculoProveedor() {
	    return "intranetRegistroVehiculo";  // Para proveedores
	}

	
	@GetMapping("/verRegistroSolicitudEspecial")
	public String verRegistroSolicitudEspecial() {
	    return "intranetRegistroSolicitudEspecial";  // Para proveedores
	}
	@GetMapping("/verRegistroProveedores")
	public String verRegistroProveedores() {
	    return "intranetRegistroProveedores";  // Para proveedores
	}
	
	
	
	//Transaccion
	@GetMapping("/VerAsignacionRol")
	public String VerAsignacionRol() {	return "intranetTransaccionAsignacionRol";	}

	@GetMapping("/VerAsignacionOpcion")
	public String VerAsignacionOpcion() {	return "intranetTransaccionAsignacionOpcion";	}


	 // Nueva ruta para la página de recuperación de contraseña
    @GetMapping("/recuperarContrasena")
    public String verRecuperarContrasena() {
        return "intranetRecuperarContrasena";  // Página de recuperación de contraseña
    }
	 // Nueva ruta para la página de actualizar de contraseña
    @GetMapping("/actualizarContrasena")
    public String verActualizarContrasena() {
        return "intranetActualizarContrasena";  // Página de actualizacion de contraseña
    }
	 // Nueva ruta para la página de actualizar de contraseña
    @GetMapping("/verificarCodigo")
    public String verVerificarCodigo() {
        return "intranetVerificarCodigo";  // Página de actualizacion de contraseña
    }
}
