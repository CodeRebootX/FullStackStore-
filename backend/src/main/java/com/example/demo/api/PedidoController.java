package com.example.demo.api;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.demo.models.Pedido;
import com.example.demo.models.request.DetallePedidoRequest;
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
        for (DetallePedidoRequest detalle : pedidoCreationRequest.productos()) {
        if (detalle.producto() == null) {
            return ResponseEntity.badRequest().body("Error: producto no puede ser null");
        }
    }
    
    Pedido nuevoPedido = pedidoService.createPedido(pedidoCreationRequest);
    return ResponseEntity.ok(nuevoPedido);  
    }

    @GetMapping("/{id}")
    public Pedido getPedido(@PathVariable Long id) {
        return pedidoService.getPedido(id).orElse(null);
    }

    @GetMapping("/usuario/{usuarioId}")
    public List<Pedido> getPedidosPorUsuario(@PathVariable Long usuarioId) {
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

    @PutMapping("/{id}")
    public ResponseEntity<Pedido> updateEstadoPedido(@PathVariable Long id, @RequestBody Map<String, String> request) {
        String nuevoEstado = request.get("estado");
        if (nuevoEstado == null || nuevoEstado.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        Pedido pedidoActualizado = pedidoService.updateEstadoPedido(id, nuevoEstado);
        return ResponseEntity.ok(pedidoActualizado);
    }
}
