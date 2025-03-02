package com.example.demo.services;

import org.springframework.stereotype.Service;

import com.example.demo.models.request.ProductCreationRequest;
import com.example.demo.models.Product;
import com.example.demo.repository.ProductRepository;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Service
public class ProductService {

    private final ProductRepository productRepository;

    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);

    public ProductService(ProductRepository productRepository) {
        this.productRepository=productRepository;
    }

    public Product createProduct(ProductCreationRequest productCreationRequest) {
        return productRepository.save(mapToProduct(productCreationRequest)); 
    }

    public Product mapToProduct (ProductCreationRequest productCreationRequest) {
        Product product = new Product();
        product.setNombre(productCreationRequest.nombre());
        product.setDescripcion(productCreationRequest.descripcion());
        product.setImagenPath(productCreationRequest.imagenPath());
        product.setStock(productCreationRequest.stock());
        product.setPrecio(productCreationRequest.precio());

        return product;
    }

    public void removeProduct(Long id) {
        productRepository.deleteById(id);
    }

    public Optional<Product> getProduct (final long id) {
        try {
            return productRepository.findById(id);
        } catch (Exception e) {
            logger.error("Error recuperando el producto con id {}, Exeption {}", id, e);
            return null;
        }
        
    }



    public List<Product> getAllProducts () {
        
        return productRepository.findAll();
    }
}
