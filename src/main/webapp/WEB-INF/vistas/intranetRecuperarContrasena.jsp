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
        <title>Recuperaci&oacute;n de Contrase&ntilde;a</title>

        <!-- Estilos personalizados -->
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

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script> <!-- SweetAlert para mensajes -->
    </head>

    <body>
        <div class="login-container">
            <!-- Fondo de puntos -->
            <div class="dots-bg">
                <div class="dot" style="top: 20%; left: 30%;"></div>
                <div class="dot" style="top: 60%; left: 60%;"></div>
                <div class="dot" style="top: 10%; left: 80%;"></div>
                <!-- Añadir más puntos según sea necesario -->
            </div>

            <div class="login-header">
                <h1>Recuperar Contrase&ntilde;a</h1>
                <p class="subtitle">Ingresa tu correo electr&oacute;nico para recibir el c&oacute;digo de
                    recuperaci&oacute;n</p>
            </div>

            <!-- Formulario de recuperación de contraseña -->
            <form id="recuperar-form" method="post">
                <div class="form-group">
                    <label for="correo">Correo Electr&oacute;nico:</label>
                    <input type="email" class="form-control" id="correo" name="correo"
                        placeholder="Ingrese tu correo electr&oacute;nico" required>
                </div>

                <div class="form-group text-center">
                    <button id="enviar-codigo" type="button" class="btn btn-primary">Enviar C&oacute;digo</button>
                </div>

                <p id="mensaje" class="alert"></p>
            </form>
        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                $("#enviar-codigo").click(function () {
                    var correo = $("#correo").val();  // Obtener el correo desde el formulario
                    if (correo !== "") {
                        // Mostrar SweetAlert con loader
                        Swal.fire({
                            title: 'Procesando...',
                            text: 'Enviando el c' + String.fromCharCode(243) + 'digo de recuperaci' + String.fromCharCode(243) + 'n.',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading(); // Mostrar el spinner
                            }
                        });

                        // Enviar solicitud al servidor
                        $.ajax({
                            type: "POST",
                            url: "recuperar",  // URL del controlador para procesar la recuperación
                            data: { correo: correo },
                            success: function (data) {
                                // Ocultar el loader de SweetAlert
                                Swal.close();

                                // Mostrar el mensaje de éxito
                                if (data && data.MENSAJE) {
                                    Swal.fire({
                                        title: String.fromCharCode(201) + 'xito',
                                        text: data.MENSAJE,
                                        icon: 'success'
                                    });

                                    // Verifica si la clave REDIRECCIONAR está presente
                                    if (data.REDIRECCIONAR) {
                                        window.location.href = data.REDIRECCIONAR + "?correo=" + correo;  // Redirige a la página especificada con el correo
                                    }
                                } else if (data && data.ERROR) {
                                    // Mostrar el mensaje de error
                                    Swal.fire({
                                        title: 'Error',
                                        text: data.ERROR,  // Muestra el mensaje de error enviado por el controlador
                                        icon: 'error'
                                    });
                                } else {
                                    // Si no hay MENSAJE ni ERROR, muestra un error genérico
                                    Swal.fire({
                                        title: 'Error',
                                        text: 'Ocurri' + String.fromCharCode(243) + ' un error inesperado.',
                                        icon: 'error'
                                    });
                                }
                            },

                            error: function () {
                                // Ocultar el loader y mostrar un mensaje de error
                                Swal.fire({
                                    title: 'Error',
                                    text: 'Ocurri' + String.fromCharCode(243) + ' un error al procesar la solicitud.',
                                    icon: 'error'
                                });
                            }
                        });
                    } else {
                        Swal.fire({
                            title: 'Advertencia',
                            text: 'El correo electr' + String.fromCharCode(243) + 'nico es obligatorio.',
                            icon: 'warning'
                        });
                    }
                });
            });


        </script>
    </body>

    </html>