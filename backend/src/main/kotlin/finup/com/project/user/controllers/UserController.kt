package finup.com.project.user.controllers

import org.springframework.http.ResponseEntity
import finup.com.project.user.dto.UserCreateDTO
import finup.com.project.user.dto.UserUpdateDTO
import finup.com.project.user.services.UserService
import jakarta.validation.Valid
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/users")
class UserController(private val userService: UserService) {

    @GetMapping("/{id}")
    fun getUser(@PathVariable id: Int): ResponseEntity<Any> {
        return userService.getUser(id)
    }

    @PostMapping
    fun createUser(@RequestBody @Valid user: UserCreateDTO): ResponseEntity<Any> {
        return userService.createUser(user)
    }

    @PutMapping("/{id}")
    fun updateUser(@RequestBody @Valid user: UserUpdateDTO, @PathVariable id: Int): ResponseEntity<Any> {
        return userService.updateUser(id, user)
    }

    @DeleteMapping("/{id}")
    fun deleteUser(@PathVariable id: Int): ResponseEntity<Any> {
        return userService.deletedUser(id)
    }

}