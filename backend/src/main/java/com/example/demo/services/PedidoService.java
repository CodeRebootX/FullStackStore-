package com.example.demo.services;

import org.springframework.stereotype.Service;
import com.example.demo.repository.PedidoRepository;
import com.example.demo.models.request.PedidoCreationRequest;
import com.example.demo.models.Pedido;
import java.util.List;
import java.util.Optional;

@Service
public class PedidoService {
    private final PedidoRepository pedidoRepository;

    public PedidoService(PedidoRepository pedidoRepository) {
        this.pedidoRepository = pedidoRepository;
    }

    public Pedido createPedido(PedidoCreationRequest pedidoCreationRequest) {
        return pedidoRepository.save(mapToPedido(pedidoCreationRequest));
    }

    public Pedido mapToPedido (PedidoCreationRequest pedidoCreationRequest) {
        Pedido pedido = new Pedido();
        //pedido.setDescripcion(pedidoCreationRequest.descripcion());
        pedido.setTotal(pedidoCreationRequest.total());
        pedido.setEstado(pedidoCreationRequest.estado());
        pedido.setComprador(pedidoCreationRequest.comprador());

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
}
