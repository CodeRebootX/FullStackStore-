package com.example.demo.services;

import org.springframework.stereotype.Service;
import com.example.demo.models.request.UserCreationRequest;
import com.example.demo.models.User;
import com.example.demo.repository.UserRepository;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

//aqui iria la logica de negocio

//controller conecta con serice (una API) (de aqui a una capa de negocio) --> Repository (JPA)--> mySQL
@Service
public class UserService {


    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository=userRepository;
    }

    public User createUser(UserCreationRequest userCreationRequest) {
        return userRepository.save(mapToUser(userCreationRequest));
    }

    /*public User updateUser(UserCreationRequest userCreationRequest) {
        return userRepository.save(mapToUser(userCreationRequest));
    }*/

    public User updateUser(Long userId, UserCreationRequest userCreationRequest) {
        return userRepository.findById(userId)
            .map(existingUser -> {
                existingUser.setTrato(userCreationRequest.trato());
                existingUser.setNombre(userCreationRequest.nombre());
                existingUser.setContrasena(userCreationRequest.contrasena());
                existingUser.setEdad(userCreationRequest.edad());
                existingUser.setImagenPath(userCreationRequest.imagen());
                existingUser.setLugarNacimiento(userCreationRequest.lugarNacimiento());
                existingUser.setAdministrador(userCreationRequest.administrador());
                existingUser.setBloqueado(userCreationRequest.bloqueado());
    
                return userRepository.save(existingUser);
            })
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado con ID: " + userId));
    }


    public User mapToUser (UserCreationRequest userCreationRequest){
        User user = new User();
        user.setTrato(userCreationRequest.trato());
        user.setNombre(userCreationRequest.nombre());
        user.setContrasena(userCreationRequest.contrasena());
        user.setEdad(userCreationRequest.edad());
        user.setImagenPath(userCreationRequest.imagen());
        user.setLugarNacimiento(userCreationRequest.lugarNacimiento());
        user.setAdministrador(userCreationRequest.administrador());
        user.setBloqueado(userCreationRequest.bloqueado());

        return user;
    }

    public void removeUser(Long id) {
        userRepository.deleteById(id);
    }

    public Optional<User> getUser(final long id) {
        try {
            return userRepository.findById(id);
        } catch (Exception e) {
            logger.error("Error recuperando el usuario con id {}, Exeption {}", id, e);
            return null;
        }
        
    }

    public List<User> getAllUsers (){
        logger.info("Listado de usuarios");

        try {
            return userRepository.findAll();
        } catch (Exception e) {
            logger.error("Error en listado de usuario", e);
            return null;
        }
        
    }
}
