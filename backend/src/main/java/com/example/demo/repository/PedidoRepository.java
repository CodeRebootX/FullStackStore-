package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.models.Pedido;

public interface PedidoRepository extends JpaRepository<Pedido, Long> {

}
