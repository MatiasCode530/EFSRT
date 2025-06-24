package com.centroinformacion.config;

import java.util.Random;

public class CodigoUtil {
	public static String generarCodigo(int longitud) {
        String caracteres = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder codigo = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < longitud; i++) {
            codigo.append(caracteres.charAt(random.nextInt(caracteres.length())));
        }
        return codigo.toString();
    }
}
