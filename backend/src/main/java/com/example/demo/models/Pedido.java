package com.example.demo.models;
import jakarta.persistence.*;

@Entity
@Table(name="Pedido")
public class Pedido {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;

    /*@Column(name="descripcion")
    private String descripcion;*/

    @Column(name="total")
    private double total;

    @Column(name="estado")
    private String estado;

    @Column(name="comprador")
    private String comprador;

    public Pedido() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    /*public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }*/

    public double getTotal() {
        return total;
    }

    public void setTotal(double precio) {
        this.total = precio;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getComprador() {
        return comprador;
    }

    public void setComprador(String comprador) {
        this.comprador = comprador;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        //result = prime * result + ((descripcion == null) ? 0 : descripcion.hashCode());
        long temp;
        temp = Double.doubleToLongBits(total);
        result = prime * result + (int) (temp ^ (temp >>> 32));
        result = prime * result + ((estado == null) ? 0 : estado.hashCode());
        result = prime * result + ((comprador == null) ? 0 : comprador.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Pedido other = (Pedido) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        /*if (descripcion == null) {
            if (other.descripcion != null)
                return false;
        } else if (!descripcion.equals(other.descripcion))
            return false;*/
        if (Double.doubleToLongBits(total) != Double.doubleToLongBits(other.total))
            return false;
        if (estado == null) {
            if (other.estado != null)
                return false;
        } else if (!estado.equals(other.estado))
            return false;
        if (comprador == null) {
            if (other.comprador != null)
                return false;
        } else if (!comprador.equals(other.comprador))
            return false;
        return true;
    }

    
}
