package com.centroinformacion.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.centroinformacion.entity.Solicitud;
import com.centroinformacion.entity.Espacio;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.entity.UsuarioHasRol;
import com.centroinformacion.repository.UsuarioHasIncidenciaRepository;
import com.centroinformacion.repository.UsuarioHasRolRepository;
import com.centroinformacion.service.EspacioService;
import com.centroinformacion.service.SolicitudService; // Servicio para manejar solicitudes
import com.centroinformacion.util.AppSettings;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.util.JRLoader;
import lombok.extern.apachecommons.CommonsLog;
@CommonsLog
@Controller
public class SolicitudRegistroController {

    @Autowired
    private SolicitudService solicitudService; // Cambia el nombre del servicio para gestionar solicitudes
    @Autowired
    private EspacioService espacioService;
    @Autowired
    private UsuarioHasRolRepository usuarioHasRolRepository;
    @Autowired
    private UsuarioHasIncidenciaRepository usuarioHasIncidenciaRepository;
    @PostMapping("/registraSolicitud")
    @ResponseBody
    public Map<String, Object> registraSolicitud(Solicitud obj, HttpSession session) {
        Map<String, Object> map = new HashMap<>();
        
        // Obtener el usuario de la sesión
        Usuario objUsuario = (Usuario) session.getAttribute("objUsuario");
        if (objUsuario == null) {
            map.put("MENSAJE", "Usuario no autenticado");
            return map;
        }
        // Verificar si el usuario tiene 3 o más reportes
        int cantidadReportes = usuarioHasIncidenciaRepository.contarIncidenciasPorUsuario(objUsuario.getIdUsuario());
        if (cantidadReportes >= 3) {
            map.put("MENSAJE", "No se puede registrar la solicitud. El usuario tiene 3 o más reportes.");
            return map;
        }

        // Verificar si existe una solicitud activa para el usuario actual
        boolean existeSolicitudActiva = solicitudService.existeSolicitudActiva(objUsuario);
        if (existeSolicitudActiva) {
            map.put("MENSAJE", "No se puede crear una nueva solicitud, ya existe una activa.");
            return map;
        }

        // Obtener el espacio por ID
        Espacio espacio = espacioService.obtenerEspacioPorId(obj.getEspacio().getIdEspacio());
        if (espacio == null) {
            map.put("MENSAJE", "Espacio no encontrado");
            return map;
        }

        // Cambiar estado_reserva a 1
        espacio.setEstado_reserva(1);
        espacioService.actualizarEspacio(espacio);

        // Verificar si el usuario tiene el rol con ID 4
        List<UsuarioHasRol> rolesDelUsuario = usuarioHasRolRepository.findByUsuario(objUsuario);
        boolean tieneRol4 = rolesDelUsuario.stream().anyMatch(rol -> rol.getRol().getIdRol() == 4);

        // Ajustar estado y estadoEspecial en función del rol
        if (rolesDelUsuario.size() == 1 && tieneRol4) {
            System.out.println("Usuario: " + objUsuario.getIdUsuario() + " tiene rol 4. Estableciendo estado en 0 y estadoEspecial en 1.");
            obj.setEstado(0);
            obj.setEstadoEspecial(1);
        } else {
            System.out.println("Usuario: " + objUsuario.getIdUsuario() + " no tiene rol 4. Estableciendo estado en 1 y estadoEspecial en 0.");
            obj.setEstado(1);
            obj.setEstadoEspecial(0);
        }

        // Configurar otros campos de la solicitud
        obj.setUsuarioRegistro(objUsuario); // Usa el usuario de la sesión
        obj.setUsuarioActualiza(objUsuario); // Usa el usuario de la sesión
        obj.setFechaRegistro(new Date());
        obj.setFechaActualizacion(new Date());
        obj.setEntrada(0);
        obj.setSalida(0);

        // Asignar el espacio a la solicitud
        obj.setEspacio(espacio); // Establecer el espacio en la solicitud

        // Registrar la solicitud
        Solicitud objSalida = solicitudService.insertaActualizaSolicitud(obj);
        if (objSalida == null) {
            map.put("MENSAJE", "Error en el registro de la solicitud");
            return map;
        }

        map.put("MENSAJE", "Registro de solicitud exitoso");
        return map;
    }



    @PostMapping("/actualizaSolicitud")
    @ResponseBody
    public Map<?, ?> actualiza(Solicitud obj, HttpSession session) {
        Usuario objUsuario = (Usuario) session.getAttribute("objUsuario");

        HashMap<String, Object> map = new HashMap<>();
        Optional<Solicitud> optSolicitud = solicitudService.buscaSolicitud(obj.getIdSolicitud());
        System.out.println("ID de Solicitud: " + obj.getIdSolicitud());

        if (!optSolicitud.isPresent()) {
            map.put("MENSAJE", "Solicitud no encontrada");
            return map;
        }

        // Obtener la solicitud existente
        Solicitud solicitudExistente = optSolicitud.get();

        // Obtener el espacio antiguo por ID
        Espacio espacioAntiguo = solicitudExistente.getEspacio();

        // Obtener el nuevo espacio por ID
        Espacio espacioNuevo = espacioService.obtenerEspacioPorId(obj.getEspacio().getIdEspacio());
        if (espacioNuevo == null) {
            map.put("MENSAJE", "Espacio nuevo no encontrado");
            return map;
        }

        // Cambiar estado_reserva del espacio antiguo a 0
        if (espacioAntiguo != null) {
            espacioAntiguo.setEstado_reserva(0);
            espacioService.actualizarEspacio(espacioAntiguo);
        }

        // Cambiar estado_reserva del nuevo espacio a 1
        espacioNuevo.setEstado_reserva(1);
        espacioService.actualizarEspacio(espacioNuevo);

        // Mantener los valores de entrada y salida actuales, para no sobrescribirlos accidentalmente
        obj.setEntrada(solicitudExistente.getEntrada());  // Conservar valor de entrada
        obj.setSalida(solicitudExistente.getSalida());    // Conservar valor de salida

        // Configurar la solicitud con los valores restantes
        obj.setFechaRegistro(solicitudExistente.getFechaRegistro());
        obj.setFechaActualizacion(new Date());
        obj.setEstado(solicitudExistente.getEstado());  // Mantener el estado actual si no se modifica
        obj.setUsuarioRegistro(solicitudExistente.getUsuarioRegistro());
        obj.setUsuarioActualiza(objUsuario);

        // Asignar el nuevo espacio a la solicitud
        obj.setEspacio(espacioNuevo);

        // Registrar la solicitud
        Solicitud objSalida = solicitudService.insertaActualizaSolicitud(obj);
        if (objSalida == null) {
            map.put("MENSAJE", "Error en la actualización de la solicitud");
            return map;
        }

        map.put("MENSAJE", "Actualización de solicitud exitosa");
        return map;
    }
    @ResponseBody
    @PostMapping("/registrarEntradaSalida")
    public Map<String, Object> registrarEntradaSalida(int idSolicitud, String accion) {
        HashMap<String, Object> map = new HashMap<>();

        // Buscar la solicitud por ID
        Solicitud objSolicitud = solicitudService.buscaSolicitud(idSolicitud).orElse(null);
        if (objSolicitud == null) {
            map.put("MENSAJE", "Solicitud no encontrada");
            return map;
        }

        // Obtener el espacio asociado a la solicitud
        Espacio espacio = objSolicitud.getEspacio();
        if (espacio == null) {
            map.put("MENSAJE", "Espacio no asociado a la solicitud");
            return map;
        }

        // Registrar la entrada o salida según la acción
        if ("entrada".equalsIgnoreCase(accion)) {
        	 objSolicitud.setFechaHoraEntrada(new Date()); // Registrar la fecha y hora de entrada
             objSolicitud.setEntrada(1); // Cambiar el atributo entrada a 1
             map.put("MENSAJE", "Entrada registrada exitosamente");
        } else if ("salida".equalsIgnoreCase(accion)) {
            objSolicitud.setFechaHoraSalida(new Date());
            objSolicitud.setSalida(1);
            objSolicitud.setEstado(0);
         // Cambiar el estado del espacio a 0 (disponible)
            espacio.setEstado_reserva(0);
            espacioService.actualizarEspacio(espacio);
            // Cambiar el atributo salida a 1
            // Registrar la fecha y hora de salida
            // Puedes actualizar otros campos si es necesario
            map.put("MENSAJE", "Salida registrada exitosamente");
        } else {
            map.put("MENSAJE", "Acción no válida");
        }

        // Guardar los cambios en la solicitud
        solicitudService.insertaActualizaSolicitud(objSolicitud);

        return map;
    }
   

    @ResponseBody
    @PostMapping("/validarSolicitudEspecial")
    public Map<String, Object> validarSolicitudEspecial(int idSolicitud, String accion,HttpSession session) {
        HashMap<String, Object> map = new HashMap<>();

        // Buscar la solicitud por ID
        Solicitud objSolicitud = solicitudService.buscaSolicitud(idSolicitud).orElse(null);
        if (objSolicitud == null) {
            map.put("MENSAJE", "Solicitud no encontrada");
            return map;
        }

        // Obtener el espacio asociado a la solicitud
        Espacio espacio = objSolicitud.getEspacio();
        if (espacio == null) {
            map.put("MENSAJE", "Espacio no asociado a la solicitud");
            return map;
        }
        // Obtener el usuario de la sesión
        Usuario objUsuario = (Usuario) session.getAttribute("objUsuario");
        if (objUsuario == null) {
            map.put("MENSAJE", "Usuario no autenticado");
            return map;
        }

        // Registrar la entrada o salida según la acción
        if ("aceptar".equalsIgnoreCase(accion)) {
        	 objSolicitud.setFechaHoraEntrada(new Date()); // Registrar la fecha y hora de entrada
             objSolicitud.setAceptar(1); // Cambiar el atributo entrada a 1
             objSolicitud.setEstadoEspecial(0);
             objSolicitud.setEstado(AppSettings.ACTIVO);
             espacio.setEstado_reserva(1);

             map.put("MENSAJE", "Se acepto la solicitud exitosamente");
        } else if ("rechazar".equalsIgnoreCase(accion)) {
            objSolicitud.setFechaHoraSalida(new Date());
            objSolicitud.setRechazar(1);
            objSolicitud.setEstadoEspecial(1);
         // Cambiar el estado del espacio a 0 (disponible)
            espacio.setEstado_reserva(0);
            espacioService.actualizarEspacio(espacio);
            // Cambiar el atributo salida a 1
            // Registrar la fecha y hora de salida
            // Puedes actualizar otros campos si es necesario
            map.put("MENSAJE", "Se rechazo la solicitud exitosamente");
        } else {
            map.put("MENSAJE", "Acción no válida");
        }

        // Guardar los cambios en la solicitud
        solicitudService.insertaActualizaSolicitud(objSolicitud);

        return map;
    }
    
    
    @GetMapping("/consultaSolicitud")
	@ResponseBody
	public List<Solicitud> consulta(
	        int idEspacio,
	        int tipoVehiculo,
	        String placa,
	        int idUsuario,
	        @DateTimeFormat(pattern = "yyyy-MM-dd") Date fecDesde,
	        @DateTimeFormat(pattern = "yyyy-MM-dd") Date fecHasta) {
	    
	    List<Solicitud> lstSalida = solicitudService.listaConsultaEspacio(idEspacio,tipoVehiculo,placa,idUsuario,fecDesde, fecHasta);    
	    return lstSalida;
	}
	@GetMapping("/reporteSolicitudPdf")
	public void reportes(HttpServletRequest request, 
			             HttpServletResponse response,
	                     int paramEspacio,
	                     int paramtipoVehiculo,
	                     String paramPlaca,
	                     int paramIdUsuario,
	                     @DateTimeFormat(pattern = "yyyy-MM-dd") Date paramFechaDesde,
	                     @DateTimeFormat(pattern = "yyyy-MM-dd") Date paramFechaHasta) {
	    try {
	        // PASO 1: OBTENER EL DATASOURCE QUE VA A GENERAR EL REPORTE 
	        List<Solicitud> lstSalida = solicitudService.listaConsultaEspacio(paramEspacio, paramtipoVehiculo,paramPlaca,paramIdUsuario,paramFechaDesde, paramFechaHasta);
	        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(lstSalida);

	        // PASO 2: OBTENER EL ARCHIVO QUE CONTIENE EL DISE&ntilde;O DEL REPORTE 
	        String fileDirectory = request.getServletContext().getRealPath("/WEB-INF/reportes/reportesSolicitud.jasper");
	        log.info(">>> File Reporte >> " + fileDirectory);
	        FileInputStream stream = new FileInputStream(new File(fileDirectory));
	    	
	        // PASO 4: ENVIAMOS DATASOURCE, DISE&ntilde;O Y PAR&aacute;METROS PARA GENERAR EL PDF 
	        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(stream);
	        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, null, dataSource);

	        // PASO 5: ENVIAR EL PDF GENERADO 
	        response.setContentType("application/x-pdf");
	        response.addHeader("Content-disposition", "attachment; filename=reporteSolicitud.pdf");

	        OutputStream outStream = response.getOutputStream();
	        JasperExportManager.exportReportToPdfStream(jasperPrint, outStream);
	    } catch (Exception e) {
                    e.printStackTrace();	        // Aqu&iacute; puedes manejar la excepci&oacute;n seg&uacute;n sea necesario
	    }
	}

  
}
