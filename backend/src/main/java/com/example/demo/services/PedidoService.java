package com.example.demo.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.repository.PedidoRepository;
import com.example.demo.repository.ProductRepository;
import com.example.demo.repository.UserRepository;
import com.example.demo.models.request.DetallePedidoRequest;
import com.example.demo.models.request.PedidoCreationRequest;
import com.example.demo.models.DetallePedido;
import com.example.demo.models.Pedido;
import com.example.demo.models.Product;
import com.example.demo.models.User;

import java.util.ArrayList;
import java.util.List;
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
        
        if (pedidoCreationRequest.usuario() == null || pedidoCreationRequest.usuario().getId() == null) {
            throw new IllegalArgumentException("El usuario no puede ser nulo y debe contener un ID");
        }

        if (pedidoCreationRequest.productos() == null || pedidoCreationRequest.productos().isEmpty()) {
            throw new IllegalArgumentException("La lista de productos no puede ser nula o vacía");
        }

        User usuario = userRepository.findById(pedidoCreationRequest.usuario().getId())
            .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));

        System.out.println("Usuario encontrado: " + usuario.getId() + " - " + usuario.getNombre());

        Pedido pedido = new Pedido();
        pedido.setTotal(pedidoCreationRequest.total());
        pedido.setEstado(pedidoCreationRequest.estado());
        pedido.setUsuario(usuario);

        List<DetallePedido> detalles = new ArrayList<>();

        for (DetallePedidoRequest detalleReq : pedidoCreationRequest.productos()) {
            if (detalleReq.producto() == null) {
                throw new IllegalArgumentException("Error: el producto no puede ser null");
            }
    
            Product producto = productRepository.findById(detalleReq.producto().getId())
                .orElseThrow(() -> new RuntimeException("Producto con ID "+detalleReq.producto().getId()+" no encontrado"));
            DetallePedido detalle = new DetallePedido();
            detalle.setPedido(pedido);
            detalle.setProducto(producto);
            detalle.setCantidad(detalleReq.cantidad());
            detalle.setPrecio(detalleReq.precio());
            detalles.add(detalle);
        }

        pedido.setDetalles(detalles);
        Pedido savedPedido = pedidoRepository.save(pedido);
        if (savedPedido.getId() == null) {
            throw new RuntimeException("Error: El pedido no se ha guardado correctamente.");
        }

        System.out.println("Pedido guardado correctamente con ID: " + savedPedido.getId());

        return savedPedido;
    }

    public Pedido mapToPedido (PedidoCreationRequest pedidoCreationRequest) {
        Pedido pedido = new Pedido();
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

    @Transactional
    public Pedido updateEstadoPedido(Long pedidoId, String nuevoEstado) {
        return pedidoRepository.findById(pedidoId)
            .map(pedido -> {
                pedido.setEstado(nuevoEstado);
                return pedidoRepository.save(pedido);
            })
            .orElseThrow(() -> new RuntimeException("Pedido no encontrado con ID " + pedidoId));
    }

}
