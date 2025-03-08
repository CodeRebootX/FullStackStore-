package com.example.demo.api;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<?> createPedido(@RequestBody PedidoCreationRequest pedidoCreationRequest) {
        try {
            System.out.println("Recibiendo peido: " + pedidoCreationRequest);
            Pedido pedido = pedidoService.createPedido(pedidoCreationRequest);
            return ResponseEntity.ok(pedido);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error en el servidor: " + e.getMessage());
        }
        
    }

    /*@PostMapping
    public Pedido createPedido(@RequestBody PedidoCreationRequest pedidoCreationRequest) {
        
        return pedidoService.createPedido(pedidoCreationRequest);
    }*/

    @GetMapping("/{id}")
    public Pedido getPedido(@PathVariable Long id) {
        return pedidoService.getPedido(id).orElse(null);
    }

    @GetMapping("/usuario/{usuarioId}")
    public List<Pedido> getPedidosPorUsario(@PathVariable Long usuarioId) {
        return pedidoService.getPedidosPorUsuario(usuarioId);
    }

    @GetMapping("/getall")
    public List<Pedido> getAllPedidos() {
        return pedidoService.getAllPedidos();
    }

    @DeleteMapping("/{id}")
    public void removePedido (@PathVariable Long id) {
        pedidoService.removePedido(id);
    }
}
