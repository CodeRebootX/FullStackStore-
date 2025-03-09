package com.example.demo.models.request;
import java.util.List;

import com.example.demo.models.User;
import com.fasterxml.jackson.annotation.JsonProperty;

public record PedidoCreationRequest (
    double total,
    String estado,
    @JsonProperty("usuario")
    User usuario,
    @JsonProperty("productos")
    List<DetallePedidoRequest> productos ){

}
