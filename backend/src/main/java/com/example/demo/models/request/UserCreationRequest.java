package com.example.demo.models.request;

public record UserCreationRequest (
    String trato,
    String nombre,
    String contrasena,
    int edad,
    String imagen,
    String lugarNacimiento,
    boolean administrador,
    boolean bloqueado
    ) {
    
}
