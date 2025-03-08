package com.example.demo.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.repository.PedidoRepository;
import com.example.demo.repository.ProductRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.models.request.PedidoCreationRequest;
import com.example.demo.models.DetallePedido;
import com.example.demo.models.Pedido;
import com.example.demo.models.Product;
import com.example.demo.models.User;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@Service
public class PedidoService {
    private final PedidoRepository pedidoRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public PedidoService(PedidoRepository pedidoRepository, UserRepository userRepository, ProductRepository productRepository) {
        this.pedidoRepository = pedidoRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
    }

    @Transactional
    public Pedido createPedido(PedidoCreationRequest pedidoCreationRequest) {
        System.out.println("Recibiendo pedido: " + pedidoCreationRequest);
        if (pedidoCreationRequest.usuarioId() == null) {
            throw new IllegalArgumentException("El userId no puede ser nulo");
        }

        if (pedidoCreationRequest.productos() == null || pedidoCreationRequest.productos().isEmpty()) {
            throw new IllegalArgumentException("La lista productos no puede ser nula o vacía");
        }
        User usuario = userRepository.findById(pedidoCreationRequest.usuarioId())
            .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));
        
        Pedido pedido = new Pedido ();
        pedido.setTotal(pedidoCreationRequest.total());
        pedido.setEstado(pedidoCreationRequest.estado());
        pedido.setUsuario(usuario);

        List<DetallePedido> detalles = new ArrayList<>();
    
        for (Map.Entry<Long, Integer> entry : pedidoCreationRequest.productos().entrySet()) {
            Product producto = productRepository.findById(entry.getKey())
                    .orElseThrow(() -> new RuntimeException("Producto con ID " + entry.getKey() + " no encontrado"));
            DetallePedido detalle = new DetallePedido();
            detalle.setPedido(pedido);
            detalle.setProducto(producto);
            detalle.setCantidad(entry.getValue());
            detalle.setPrecio(producto.getPrecio());
            detalles.add(detalle);
        }

        pedido.setDetalles(detalles);

        System.out.println("Guardando el pedido en la base de datos " + pedido);

        Pedido savedPedido = pedidoRepository.save(pedido);
        if (savedPedido.getId() == null) {
            throw new RuntimeException("Error: El pedido no se ha guardado correctamente.");
        }

        System.out.println("Pedido guardado correctamente con ID: " + savedPedido.getId());


        return savedPedido;
    }

    public Pedido mapToPedido (PedidoCreationRequest pedidoCreationRequest) {
        Pedido pedido = new Pedido();
        //pedido.setDescripcion(pedidoCreationRequest.descripcion());
        pedido.setTotal(pedidoCreationRequest.total());
        pedido.setEstado(pedidoCreationRequest.estado());

        return pedido;
    }

    public void removePedido(Long id) {
        pedidoRepository.deleteById(id);
    }

    public Optional<Pedido> getPedido (final long id) {
        return pedidoRepository.findById(id);
    }

    public List<Pedido> getAllPedidos () {
        return pedidoRepository.findAll();
    }

    public List<Pedido> getPedidosPorUsuario(Long usuarioId) {
        List<Pedido> response = pedidoRepository.findByUsuario_Id(usuarioId);
        return response;
    }
}
