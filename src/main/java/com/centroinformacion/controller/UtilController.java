package com.centroinformacion.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;


import com.centroinformacion.entity.Vehiculo; // Aseg&uacute;rate de que esta entidad exista
import com.centroinformacion.repository.SolicitudIngresoRepository;
import com.centroinformacion.repository.VehiculoRepository;
import com.centroinformacion.entity.Espacio; // Aseg&uacute;rate de que esta entidad exista
import com.centroinformacion.entity.Solicitud;
import com.centroinformacion.service.VehiculoService; // Aseg&uacute;rate de que este servicio exista
import com.centroinformacion.service.EspacioService; // Aseg&uacute;rate de que este servicio exista


@Controller
public class UtilController {

    @Autowired
    private VehiculoService vehiculoService; // Aseg&uacute;rate de que el servicio est&aacute; inyectado

    @Autowired
    private EspacioService espacioService; // Aseg&uacute;rate de que el servicio est&aacute; inyectado

    @GetMapping("/listaVehiculo")
    @ResponseBody
    public ResponseEntity<List<Vehiculo>> listaVehiculo() {
        try {
            List<Vehiculo> vehiculos = vehiculoService.listaTodos();
            if (vehiculos.isEmpty()) {
                return ResponseEntity.noContent().build(); // Retorna 204 si no hay vehículos
            }
            return ResponseEntity.ok(vehiculos); // Retorna 200 con la lista
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null); // 500 en caso de error interno
        }
    }


    @GetMapping("/listaEspacio")
    @ResponseBody
    public ResponseEntity<List<Espacio>> listaEspacio() {
        try {
            List<Espacio> espacios = espacioService.listaEspacioDisponibles();
            if (espacios.isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(espacios);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

   
    @GetMapping("/listaEspacios")
    @ResponseBody
    public ResponseEntity<List<Espacio>> listaEspacios() {
        try {
            List<Espacio> espacios = espacioService.listaTodos();

            // Ordenar por pabellón, número y piso
            List<String> ordenPabellones = Arrays.asList("Pabellón A", "Pabellón E");
            espacios.sort((a, b) -> {
                int pabellonCompare = Integer.compare(
                    ordenPabellones.indexOf(a.getPabellon()), 
                    ordenPabellones.indexOf(b.getPabellon())
                );

                if (pabellonCompare == 0) {
                    try {
                        int numeroA = Integer.parseInt(a.getNumero());
                        int numeroB = Integer.parseInt(b.getNumero());
                        if (numeroA == numeroB) {
                            return a.getPiso().compareTo(b.getPiso());
                        }
                        return Integer.compare(numeroA, numeroB);
                    } catch (NumberFormatException e) {
                        return a.getNumero().compareTo(b.getNumero()); // Ordenar alfabéticamente si no es numérico
                    }
                }
                return pabellonCompare;
            });

            if (espacios.isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(espacios);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }


    @GetMapping("/listaVehiculosUsuario/{idUsuarioRegistro}")
    public ResponseEntity<List<Vehiculo>> listaVehiculosUsuario(@PathVariable Integer idUsuarioRegistro) {
        if (idUsuarioRegistro == null || idUsuarioRegistro <= 0) {
            return ResponseEntity.badRequest().build(); // 400 si el ID es inválido
        }
        try {
            List<Vehiculo> vehiculos = vehiculoService.findByUsuarioRegistroId(idUsuarioRegistro);
            if (vehiculos.isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(vehiculos);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    
}
