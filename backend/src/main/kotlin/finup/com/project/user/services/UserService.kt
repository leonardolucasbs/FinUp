package finup.com.project.user.services

import finup.com.project.user.dto.UserCreateDTO
import finup.com.project.user.dto.UserLoginDTO
import finup.com.project.user.dto.UserResponseDTO
import finup.com.project.user.dto.UserUpdateDTO
import finup.com.project.exception.ApiException
import finup.com.project.user.mappers.UserMapper
import finup.com.project.user.models.User
import finup.com.project.user.repositories.UserRepository
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import java.time.LocalDateTime
import java.util.Optional

@Service
class UserService (
    private val userRepository: UserRepository,
    private val userMapper: UserMapper
) {

    fun getUserById(userId: Int): Optional<User> {
        return userRepository.findUserById(userId)
    }

    fun createUser(user: UserCreateDTO): ResponseEntity<Any> {
        val findUser = userRepository.findUserByUsername(user.username)

        if (findUser.isPresent) {
            throw ApiException(ApiException.Error.EMAIL_ALREADY_EXISTS);
        }

        val user: User = userMapper.toEntity(user);
        userRepository.save(user);

        return ResponseEntity.status(HttpStatus.CREATED)
            .body(
                mapOf(
                    "response" to "Usuário criado com sucesso"
                )
            )
    }

    fun loginUser(user: UserLoginDTO): ResponseEntity<Any> {
        val findUser = userRepository.findUserByUsername(user.username)

        if (findUser.isEmpty || findUser.get().password != user.password) {
            throw ApiException(ApiException.Error.INVALID_CREDENTIALS)
        }

        val userResponseDto = UserResponseDTO(findUser.get().id!!, findUser.get().fullName, findUser.get().username)

        return ResponseEntity.ok(
            mapOf(
                "data" to userResponseDto
            )
        )
    }

    fun getUser(userId: Int): ResponseEntity<Any> {
        val findUser = getUserById(userId)

        if (findUser.isEmpty) {
            throw ApiException(ApiException.Error.USER_NOT_FOUND)
        }

        val userResponseDto = UserResponseDTO(findUser.get().id!!, findUser.get().fullName, findUser.get().username)

        return ResponseEntity.ok(
            mapOf(
                "data" to userResponseDto
            )
        )
    }

    fun updateUser(userId: Int, userUpdate: UserUpdateDTO): ResponseEntity<Any> {

        val findUser = getUserById(userId);

        if (findUser.isEmpty) {
            throw ApiException(ApiException.Error.USER_NOT_FOUND)
        }

        val user: User = findUser.get()

        user.fullName = userUpdate.fullName
        user.password = userUpdate.password
        user.updateAt = LocalDateTime.now()

        userRepository.save(user);

        return ResponseEntity.ok(
            mapOf(
                "data" to "Usuário atualizado com sucesso."
            )
        )
    }

    fun deletedUser(userId: Int): ResponseEntity<Any> {

        val findUser = getUserById(userId);

        if (findUser.isEmpty) {
            throw ApiException(ApiException.Error.USER_NOT_FOUND)
        }

        userRepository.deleteById(userId)

        return ResponseEntity.ok(
            mapOf(
                "data" to "Usuário deletado com sucesso."
            )
        )
    }

}
