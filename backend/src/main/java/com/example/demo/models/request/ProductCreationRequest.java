package com.example.demo.models.request;

public record ProductCreationRequest (
    String nombre,
    String descripcion,
    String imagenPath,
    int stock,
    double precio
    ){

}
