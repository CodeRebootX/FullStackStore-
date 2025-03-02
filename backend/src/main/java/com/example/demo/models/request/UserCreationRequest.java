package com.example.demo.models.request;

public record UserCreationRequest (String nombre, String contrasena, int edad, boolean administrador) {
    
}
