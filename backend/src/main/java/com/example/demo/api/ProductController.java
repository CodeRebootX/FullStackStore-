package com.example.demo.api;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.example.demo.models.Product;
import com.example.demo.models.request.ProductCreationRequest;
import com.example.demo.services.ProductService;

@RestController
@RequestMapping("/api/v1/products")
@CrossOrigin(origins = "*")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @PostMapping
    public Product createProduct(@RequestBody ProductCreationRequest productCreationRequest) {
        return productService.createProduct(productCreationRequest);
    }

    @PutMapping("/{id}")
    public Product updateProduct(@PathVariable Long id, @RequestBody ProductCreationRequest productCreationRequest) {
        return productService.updateProduct(id, productCreationRequest);
    }


    @GetMapping("/{id}")
    public Product getProduct(@PathVariable Long id) {
        return productService.getProduct(id).orElse(null);
    }
    

    @GetMapping("/getall")
    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }

    @DeleteMapping
    public void removeProduct (@PathVariable Long id) {
        productService.removeProduct(id);
    }
}
