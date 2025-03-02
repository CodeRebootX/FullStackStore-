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


    public User mapToUser (UserCreationRequest userCreationRequest){
        User user = new User();
        user.setNombre(userCreationRequest.nombre());
        user.setContrasena(userCreationRequest.contrasena());
        user.setEdad(userCreationRequest.edad());
        user.setAdministrador(userCreationRequest.administrador());

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
