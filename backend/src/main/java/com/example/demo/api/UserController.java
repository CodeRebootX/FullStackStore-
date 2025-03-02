package com.example.demo.api;

import java.util.List;

import org.springframework.web.bind.annotation.*;

import com.example.demo.models.User;
import com.example.demo.models.request.UserCreationRequest;
import com.example.demo.services.UserService;

//capaz de recibir peticiones

@RestController
@RequestMapping("/api/v1/users")
@CrossOrigin(origins = "*")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping
    public User createUser(@RequestBody UserCreationRequest userCreationRequest) {
        return userService.createUser(userCreationRequest);
    }

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.getUser(id).orElse(null);
    }

    @GetMapping("/getall")
    public List<User> getAllUsers(){
        return userService.getAllUsers();
    }

    @DeleteMapping
    public void removeUser (@PathVariable Long id) {
        userService.removeUser(id);
    }

}
