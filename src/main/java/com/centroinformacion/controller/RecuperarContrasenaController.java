package com.centroinformacion.controller;

import java.util.Calendar;
import java.util.Date;
import java.util.Optional;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.centroinformacion.entity.Usuario;
import com.centroinformacion.repository.UsuarioRepository;
import com.centroinformacion.service.CorreoService;
import com.centroinformacion.config.CodigoUtil;

@Controller
public class RecuperarContrasenaController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private CorreoService correoService;
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();


    // Método para enviar el código de recuperación
    @PostMapping("/recuperar")
    @ResponseBody
    public Map<String, String> enviarCodigo(@RequestParam String correo, RedirectAttributes redirectAttributes) {
        Optional<Usuario> usuario = usuarioRepository.findByCorreo(correo);

        Map<String, String> map = new HashMap<>();

        if (usuario.isEmpty()) {
            map.put("ERROR", "El correo no está registrado en la base de datos.");
            return map;  // Retorna el map directamente con el mensaje
        }

        String codigo = CodigoUtil.generarCodigo(6);  // Genera el código de 6 dígitos
        Usuario usuarioEncontrado = usuario.get();

        // Asignar el código de verificación y la expiración
        usuarioEncontrado.setCodigoVerificacion(codigo);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.MINUTE, 10);  // Expira en 10 minutos
        usuarioEncontrado.setExpiracionCodigo(calendar.getTime());
        String nombreUsuario = usuarioEncontrado.getNombreCompleto();
        usuarioRepository.save(usuarioEncontrado);

     // Enviar el correo al usuario con el código de recuperación
        correoService.enviarCorreo(
                correo,
                "Código de recuperación de contraseña - Sistema de Gestión Vehicular",
                "Estimado/a " + nombreUsuario + ":\n\n" +
                "La contraseña para tu cuenta en el Sistema de Gestión Vehicular ha sido cambiada recientemente.\n\n" +
                "Tu código de recuperación es: " + codigo + "\n" +
                "Este código expira en 10 minutos.\n\n" +
                "Asegúrate de ingresar el código de recuperación en el formulario correspondiente.\n" +
                "Si tienes algún inconveniente con el acceso luego de estos pasos, no dudes en comunicarte con nuestro soporte técnico al teléfono (anexo 7777).\n\n" +
                "Atentamente,\n" +
                "Servicios de TI - Sistema de Gestión Vehicular"
        );


     // Si el código se envió exitosamente, agregar el mensaje y la URL de redirección al map
        map.put("MENSAJE", "Código enviado exitosamente al correo.");

        // Aquí, verificamos si el mensaje es el esperado y añadimos la redirección
        if ("Código enviado exitosamente al correo.".equals(map.get("MENSAJE"))) {
            map.put("REDIRECCIONAR", "verificarCodigos");  // URL de redirección al éxito
        }  
        redirectAttributes.addAttribute("correo", correo);  // Añadir el correo como parámetro
        return map;  // Retorna el map con el mensaje
    }

    // Método para verificar el código ingresado por el usuario
    @PostMapping("/validarCodigo")
    @ResponseBody
    public Map<String, String> validarCodigo(@RequestParam String correo, @RequestParam String codigoIngresado) {
        Optional<Usuario> usuario = usuarioRepository.findByCorreo(correo);

        Map<String, String> map = new HashMap<>();

        if (usuario.isEmpty()) {
            map.put("ERROR", "El correo no está registrado.");
            return map;  // Devolver el map directamente en vez de redirigir
        }

        Usuario usuarioEncontrado = usuario.get();
        Date fechaExpiracion = usuarioEncontrado.getExpiracionCodigo();
        Date fechaActual = new Date();

        // Verificar si el código ha expirado
        if (fechaExpiracion.before(fechaActual)) {
            map.put("TIEMPO", "El código ha expirado.");
            return map;  // Retornar el map con el mensaje de expiración
        }
        // Verificar que el código ingresado coincida con el guardado
        if (!usuarioEncontrado.getCodigoVerificacion().equals(codigoIngresado)) {
            map.put("ERROR", "El código ingresado es incorrecto.");
            return map;  // Retornar el map con el mensaje de error
        }
        // Si el código se envió exitosamente, agregar el mensaje y la URL de redirección al map
        map.put("MENSAJE", "Código válido. Puedes proceder a cambiar tu contraseña.");
        // Si el código es válido, devolver mensaje de éxito
        if ("Código válido. Puedes proceder a cambiar tu contraseña.".equals(map.get("MENSAJE"))) {
            map.put("REDIRECCIONAR", "actualizarContrasenaVista");  // URL de redirección al éxito
        }  
        return map;  // Retornar el map con el mensaje de éxito
    }

    // Método para mostrar la página de verificación de código
    @GetMapping("/verificarCodigos")
    public String verificarCodigo(@RequestParam String correo, Model model) {
        // Agregar el correo al modelo para poder usarlo en la vista
        model.addAttribute("correo", correo);

        // Retornar la vista para verificar el código
        return "intranetVerificarCodigo";  // Nombre de la vista de verificación de código
    }
 // Método para mostrar la página de actualización de contraseña
    @GetMapping("/actualizarContrasenaVista")
    public String mostrarActualizarContrasena(@RequestParam String correo, Model model) {
        // Añadir el correo al modelo para que se utilice en la vista
        model.addAttribute("correo", correo);
        return "intranetActualizarContrasena";  // Nombre de la vista para actualizar contraseña
    }

    // Método para procesar la actualización de contraseña
    @PostMapping("/actualizarContrasenas")
    @ResponseBody
    public Map<String, String> actualizarContrasena(
            @RequestParam String correo,
            @RequestParam String nuevaContrasena) {

        Map<String, String> map = new HashMap<>();
        Optional<Usuario> usuario = usuarioRepository.findByCorreo(correo);

        if (usuario.isEmpty()) {
            map.put("MENSAJE", "El correo no está registrado.");
            return map;
        }

        Usuario usuarioEncontrado = usuario.get();
        String encryptedPassword = passwordEncoder.encode(nuevaContrasena);

        usuarioEncontrado.setPassword(encryptedPassword);  // Actualizar la contraseña
        usuarioEncontrado.setCodigoVerificacion(null);    // Eliminar el código de verificación
        usuarioEncontrado.setExpiracionCodigo(null);      // Limpiar la fecha de expiración del código
        usuarioRepository.save(usuarioEncontrado);        // Guardar los cambios

        map.put("MENSAJE", "Contraseña actualizada exitosamente.");
        // Si el código es válido, devolver mensaje de éxito
        if ("Contraseña actualizada exitosamente.".equals(map.get("MENSAJE"))) {
            map.put("REDIRECCIONAR", "/");  // URL de redirección al éxito
        }  

        return map;  // Retornar el mensaje de éxito
    }
}
