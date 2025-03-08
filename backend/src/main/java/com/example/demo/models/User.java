package com.example.demo.models;
import java.util.ArrayList;
import java.util.List;

//import java.util.Objects;
import jakarta.persistence.*;

@Entity
@Table(name="User")
public class User {
    @Id
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="trato")
    private String trato;

    @Column(name="nombre")
    private String nombre;

    @Column(name="contrasena")
    private String contrasena;

    @Column(name="edad")
    private int edad;

    @Column(name="imagenPath")
    private String imagenPath;

    @Column(name="lugarNacimiento")
    private String lugarNacimiento;

    @Column(name="administrador")
    private boolean administrador;

    @Column(name="bloqueado")
    private boolean bloqueado;

    @OneToMany(mappedBy = "usuario", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Pedido> pedidos = new ArrayList<>();

    public User() {
    }

    

    public void setEdad(int edad) {
        this.edad = edad;
    }



    public void setAdministrador(boolean administrador) {
        this.administrador = administrador;
    }



    public int getEdad() {
        return edad;
    }



    public boolean isAdministrador() {
        return administrador;
    }



    public Long getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }


    public String getTrato() {
        return trato;
    }



    public void setTrato(String trato) {
        this.trato = trato;
    }



    public String getImagenPath() {
        return imagenPath;
    }



    public void setImagenPath(String imagenPath) {
        this.imagenPath = imagenPath;
    }



    public String getLugarNacimiento() {
        return lugarNacimiento;
    }



    public void setLugarNacimiento(String lugarNacimiento) {
        this.lugarNacimiento = lugarNacimiento;
    }



    public boolean isBloqueado() {
        return bloqueado;
    }



    public void setBloqueado(boolean bloqueado) {
        this.bloqueado = bloqueado;
    }


    

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + ((trato == null) ? 0 : trato.hashCode());
        result = prime * result + ((nombre == null) ? 0 : nombre.hashCode());
        result = prime * result + ((contrasena == null) ? 0 : contrasena.hashCode());
        result = prime * result + edad;
        result = prime * result + ((imagenPath == null) ? 0 : imagenPath.hashCode());
        result = prime * result + ((lugarNacimiento == null) ? 0 : lugarNacimiento.hashCode());
        result = prime * result + (administrador ? 1231 : 1237);
        result = prime * result + (bloqueado ? 1231 : 1237);
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
        User other = (User) obj;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        if (trato == null) {
            if (other.trato != null)
                return false;
        } else if (!trato.equals(other.trato))
            return false;
        if (nombre == null) {
            if (other.nombre != null)
                return false;
        } else if (!nombre.equals(other.nombre))
            return false;
        if (contrasena == null) {
            if (other.contrasena != null)
                return false;
        } else if (!contrasena.equals(other.contrasena))
            return false;
        if (edad != other.edad)
            return false;
        if (imagenPath == null) {
            if (other.imagenPath != null)
                return false;
        } else if (!imagenPath.equals(other.imagenPath))
            return false;
        if (lugarNacimiento == null) {
            if (other.lugarNacimiento != null)
                return false;
        } else if (!lugarNacimiento.equals(other.lugarNacimiento))
            return false;
        if (administrador != other.administrador)
            return false;
        if (bloqueado != other.bloqueado)
            return false;
        return true;
    }

}
