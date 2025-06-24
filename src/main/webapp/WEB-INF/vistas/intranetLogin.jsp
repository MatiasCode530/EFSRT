<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CIBERTEC</title>
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

        /* Dots decoration */
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
            position: absolute;
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
            position: relative;
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
		/* Forgot password link styling */
		       .forgot-password {
		           text-align: center;
		           margin-top: 10px;
		       }

		       .forgot-password a {
		           color: #007bff;
		           text-decoration: none;
		       }

		       .forgot-password a:hover {
		           text-decoration: underline;
		       }
    </style>
</head>
<body>
    <div class="dots-bg">
        <div class="dot" style="top: 20%; left: 15%; background-color: #3498db;"></div>
        <div class="dot" style="top: 30%; right: 10%; background-color: #ffffff;"></div>
        <div class="dot" style="bottom: 25%; left: 35%; background-color: #2ecc71;"></div>
        <div class="dot" style="bottom: 20%; right: 40%; background-color: #3498db;"></div>
        <div class="dot" style="top: 10%; left: 50%; background-color: #ffffff;"></div>
        <div class="dot" style="bottom: 15%; right: 15%; background-color: #2ecc71;"></div>
        <div class="dot" style="top: 40%; left: 70%; background-color: #3498db;"></div>
        <div class="dot" style="bottom: 10%; right: 30%; background-color: #ffffff;"></div>
        <div class="dot" style="top: 60%; left: 10%; background-color: #2ecc71;"></div>
        <div class="dot" style="bottom: 5%; right: 5%; background-color: #3498db;"></div>
        <!-- A&ntilde;adiendo más puntos -->
        <div class="dot" style="top: 25%; left: 20%; background-color: #ffffff;"></div>
        <div class="dot" style="top: 50%; left: 80%; background-color: #2ecc71;"></div>
        <div class="dot" style="bottom: 30%; left: 60%; background-color: #3498db;"></div>
        <div class="dot" style="top: 70%; right: 20%; background-color: #ffffff;"></div>
        <div class="dot" style="bottom: 20%; left: 10%; background-color: #2ecc71;"></div>
        <div class="dot" style="top: 35%; right: 30%; background-color: #3498db;"></div>
    </div>
    
    

    <div class="login-container">
        <div class="login-header">
            <img src="https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png" alt="Logo" class="logo">
            <h1>LOGIN</h1>
            <p class="subtitle">Bienvenido a la intranet de Cibertec</p>
        </div>

        <c:if test="${requestScope.mensaje != null}">
            <div class="alert alert-danger" id="success-alert">
                <strong>${requestScope.mensaje}</strong>
            </div>
        </c:if>
        
        <form id="id_form" action="login" method="post" class="login-form">
            <div class="form-group">
                <input type="text" name="login" placeholder="Ingresa el usuario" class="form-control" id="form-username" maxlength="20">
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Ingresa la contrase&ntilde;a" class="form-control" id="form-password" maxlength="20">
            </div>
            <button type="submit" class="btn btn-primary">Ingresar</button>
        </form>
		<div class="forgot-password">
            <a href="recuperarContrasena">&iquest;Olvidaste tu contrase&ntilde;a&quest;</a>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#success-alert").fadeTo(1000, 500).slideUp(500, function () {
                $("#success-alert").slideUp(500);
            });

            $('#id_form').bootstrapValidator({
                message: 'Este valor no es v&aacute;lido',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                },
                fields: {
                    login: {
                        validators: {
                            notEmpty: {
                                message: 'El usuario es obligatorio',
                                callback: function (value, validator, $field) {
                                    $('#errorLogin').text('El usuario es obligatorio');
                                }
                            },
                            stringLength: {
                                message: 'El usuario debe tener entre 3 y 20 caracteres',
                                min: 3,
                                max: 20
                            },
                            regexp: {
                                message: 'El usuario no puede contener espacios ni caracteres especiales. Solo se permiten letras y números.',
                                regexp: /^[a-zA-Z0-9]+$/
                            }
                        }
                    },
                    password: {
                        validators: {
                            notEmpty: {
                                message: 'La contrase&ntilde;a es obligatoria',
                                callback: function (value, validator, $field) {
                                    $('#errorPassword').text('La contrase&ntilde;a es obligatoria');
                                }
                            },
                            stringLength: {
                                message: 'La contrase&ntilde;a debe tener entre 3 y 20 caracteres',
                                min: 3,
                                max: 20
                            },
                            regexp: {
                                message: 'La contrase&ntilde;a no puede contener espacios ni caracteres especiales. Solo se permiten letras y números.',
                                regexp: /^[a-zA-Z0-9]+$/
                            }
                        }
                    }
                },
                excluded: [':disabled'], // Ignorar campos deshabilitados
                submitButtons: 'button[type="submit"]',
                feedbackIcons: {
                    valid: 'glyphicon glyphicon-ok',
                    invalid: 'glyphicon glyphicon-remove',
                    validating: 'glyphicon glyphicon-refresh'
                }
            }).on('success.form.bv', function (e) {
                // Limpiar mensajes de error
                $('#errorLogin').text('');
                $('#errorPassword').text('');
            }).on('error.field.bv', function (e, data) {
                // Mostrar el mensaje de error en el campo correspondiente
                if (data.field === 'login') {
                    $('#errorLogin').text(data.message);
                }
                if (data.field === 'password') {
                    $('#errorPassword').text(data.message);
                }
            });

            $('#validateBtn').click(function () {
                $('#id_form').bootstrapValidator('validate');
            });
        });
    
   
   </script>
</body>
</html>
