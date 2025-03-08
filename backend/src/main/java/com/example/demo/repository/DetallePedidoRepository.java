package com.example.demo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.models.DetallePedido;

public interface DetallePedidoRepository extends JpaRepository<DetallePedido, Long>{
    
}
