package com.example.demo.models.request;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonProperty;

public record PedidoCreationRequest (
    double total,
    String estado,
    @JsonProperty("usuarioId")
    Long usuarioId,
    @JsonProperty("productos")
    Map<Long, Integer> productos ){

}
