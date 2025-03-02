package com.example.demo.api;

import java.util.List;
import org.springframework.web.bind.annotation.*;

import com.example.demo.models.Pedido;
import com.example.demo.models.request.PedidoCreationRequest;
import com.example.demo.services.PedidoService;

@RestController
@RequestMapping("/api/v1/pedidos")
@CrossOrigin(origins = "*")
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    @PostMapping
    public Pedido createPedido(@RequestBody PedidoCreationRequest pedidoCreationRequest) {
        return pedidoService.createPedido(pedidoCreationRequest);
    }

    @GetMapping("/{id}")
    public Pedido getPedido(@PathVariable Long id) {
        return pedidoService.getPedido(id).orElse(null);
    }

    @GetMapping("/getall")
    public List<Pedido> getAllPedidos() {
        return pedidoService.getAllPedidos();
    }

    @DeleteMapping
    public void removePedido (@PathVariable Long id) {
        pedidoService.removePedido(id);
    }



    

}
