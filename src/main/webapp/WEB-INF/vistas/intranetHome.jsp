<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<jsp:include page="intranetValida.jsp" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Expires" content="-1" />
    <meta http-equiv="Cache-Control" content="private" />
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />

    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="js/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/bootstrapValidator.js"></script>
    <script type="text/javascript" src="js/global.js"></script>

    <link rel="stylesheet" href="css/bootstrap.css" />
    <link rel="stylesheet" href="css/dataTables.bootstrap.min.css" />
    <link rel="stylesheet" href="css/bootstrapValidator.css" />

    <title>Intranet</title>

    <style>
        body {
            padding-top: 90px; /* Espacio para la navbar */
            background-color: #f4f7fa;
            font-family: Arial, sans-serif;
        }

        .navbar-fixed-top {
            height: 100px; /* Ajustar la altura de la navbar */
        }

        h3 {
            color: #007bff;
            font-weight: bold;
        }

        h4 {
            font-weight: normal;
        }

        .profile-info {
            display: flex; /* Usar flexbox para alinear elementos */
            align-items: center; /* Centrar verticalmente */
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        .profile-info .text {
            flex: 1; /* Dejar que el texto ocupe el espacio restante */
            margin-right: 20px; /* Separar la imagen del texto */
        }

        .profile-info img {
            border-radius: 50%; /* Foto circular */
            border: 3px solid #007bff;
            max-width: 150px;  /* Limitar el tamaño máximo de la imagen */
            max-height: 150px; /* Limitar el tamaño máximo de la imagen */
            object-fit: cover; /* Ajustar la imagen dentro del contorno circular */
        }

        .roles li {
            display: inline-block;
            margin-right: 10px;
            background-color: #28a745;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
        }

        /* Evitar que los efectos de la imagen afecten al menú */
        .navbar, .navbar-collapse, .navbar-nav {
            z-index: 10; /* Asegurarse de que el menú esté por encima de otros elementos */
        }
    </style>
</head>
<body>
    <!-- Incluir la cabecera -->
    <jsp:include page="intranetCabecera.jsp" />

    <!-- Contenido principal -->
    <div class="container">
        <div class="profile-info">
            <div class="text">
                <h3>Sistema Gesti&oacute;n de Ingreso y Salida Vehicular</h3>
                <p>Bienvenido, <strong>${sessionScope.objUsuario.nombreCompleto}</strong></p>
                <p><strong>DNI:</strong> ${sessionScope.objUsuario.dni}</p>
                <h4>Roles:</h4>
                <ul class="roles">
                    <c:forEach var="x" items="${sessionScope.objRoles}">
                        <li>${x.nombre}</li>
                    </c:forEach>
                </ul>
            </div>
            <div class="imagen">
                <img src="/usuarios/${sessionScope.objUsuario.fotoPerfil}" 
                     alt="Foto de perfil de ${sessionScope.objUsuario.nombreCompleto}" 
                     class="img-thumbnail">
            </div>
        </div>
    </div>
</body>
</html>