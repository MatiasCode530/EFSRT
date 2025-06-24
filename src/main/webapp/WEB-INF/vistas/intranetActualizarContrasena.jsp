<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="js/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/bootstrapValidator.js"></script>
    <script type="text/javascript" src="js/global.js"></script>

    <link rel="stylesheet" href="css/bootstrap.css" />
    <link rel="stylesheet" href="css/dataTables.bootstrap.min.css" />
    <link rel="stylesheet" href="css/bootstrapValidator.css" />
    <title>Actualizar Contrase&ntilde;a</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #003953;
            position: relative;
            overflow: hidden;
            
        }

        .dots-bg {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            overflow: hidden;
            opacity: 0.5;
            pointer-events: none;
        }

        .dot {
            position: absolute;
            width: 20px;
            height: 20px;
            border-radius: 50%;
        }

        .dot:nth-child(3n) {
            background: #3498db;
        }

        .dot:nth-child(3n+1) {
            background: #2ecc71;
        }

        .dot:nth-child(3n+2) {
            background: #00b8d4;
        }

        .login-container {
            background: white;
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            margin: 1rem;
            position: relative;
            z-index: 1;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        h1 {
            color: #003953;
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .subtitle {
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            color: #003953;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #003953;
            box-shadow: 0 0 0 4px rgba(0, 57, 83, 0.1);
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 0.8rem 1rem;
            color: white;
            font-weight: bold;
            width: 100%;
            border-radius: 5px;
            transition: background-color 0.3s;
            font-size: 1rem;
            text-transform: uppercase;
        }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .alert {
            text-align: center;
            margin-bottom: 20px;
        }

        .logo {
            width: 80px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
    <div class="dots-bg">
        <!-- Puntos de fondo animados (opcional) -->
        <div class="dot" style="top: 10%; left: 20%;"></div>
        <div class="dot" style="top: 40%; left: 50%;"></div>
        <div class="dot" style="top: 60%; left: 80%;"></div>
        <div class="dot" style="top: 80%; left: 30%;"></div>
    </div>

    <div class="login-container">
        <div class="login-header">
            <h1>Actualizar Contrase&ntilde;a</h1>
            <p class="subtitle">Por favor ingresa tu nueva contrase&ntilde;a</p>
        </div>
        <form id="id_form" method="post">
            <!-- Hidden input for correo -->
            <input type="hidden" id="correo" name="correo" value="${correo}">
            <div class="form-group">
                <label for="nuevaContrasena">Nueva Contrase&ntilde;a:</label>
                <input type="password" id="nuevaContrasena" name="nuevaContrasena" class="form-control" required>
            </div>
            <div class="form-group text-center">
                <button id="actualizarButton" type="button" class="btn btn-primary">Verificar</button>
            </div>
        </form>
    </div>

    <script>
        $(document).ready(function () {
            $("#actualizarButton").click(function () {
                var correo = $("#correo").val();  // Obtener el correo desde el formulario
                var nuevaContrasena = $("#nuevaContrasena").val();  // Obtener la nueva contrase&ntilde;a desde el formulario

                if (correo !== "" && nuevaContrasena !== "") {
                    $.ajax({
                        type: "POST",
                        url: "actualizarContrasenas",  // URL para procesar la actualización
                        data: {
                            correo: correo,
                            nuevaContrasena: nuevaContrasena
                        },
                        success: function (data) {
                            

                            // Mostrar mensaje de éxito o error
                            if (data && data.MENSAJE) {
                                mostrarMensaje(data.MENSAJE);
                                 // Verifica si la clave REDIRECCIONAR está presente
                        if (data.REDIRECCIONAR) {
                            console.log("Redirigiendo a:", data.REDIRECCIONAR);  // Verifica la URL de redirección
                            // Aquí, agregamos el correo a la URL de redirección
                            window.location.href = data.REDIRECCIONAR;  // Redirige a la página especificada con el correo
                        }
                            } else {
                                mostrarMensaje("Ocurri" + String.fromCharCode(243) + " un error inesperado.");
                            }
                        },
                        error: function () {
                            mostrarMensaje("Ocurri" + String.fromCharCode(243) + " un error al procesar la solicitud.");
                        },
                        complete: function () {
                            $("#id_form").prop('disabled', false);
                        }
                    });
                } else {
                    mostrarMensaje("El correo electr" + String.fromCharCode(243) + "nico y la nueva contrase&ntilde;a son obligatorios.");
                }
            });
        });

        // Función para mostrar el mensaje de respuesta en el frontend
        function mostrarMensaje(mensaje) {
            $('#mensaje').text(mensaje);  // Mostrar mensaje en el contenedor con id 'mensaje'
        }
    </script>
</body>

</html>
