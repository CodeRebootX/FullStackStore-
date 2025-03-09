package com.example.demo.models.request;
import com.example.demo.models.Product;
import com.fasterxml.jackson.annotation.JsonProperty;;;

public record DetallePedidoRequest (
    @JsonProperty("producto")
    Product producto,

    @JsonProperty("cantidad")
    int cantidad,

    @JsonProperty("precio")
    double precio
) {
    
}