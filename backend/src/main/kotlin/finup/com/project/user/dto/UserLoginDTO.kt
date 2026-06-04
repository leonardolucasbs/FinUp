package finup.com.project.user.dto

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank

data class UserLoginDTO(
    @NotBlank(message = "Email nao pode ser vazio.")
    @Email(message = "Email invalido.")
    val username: String,
    @NotBlank(message = "Senha nao pode ser vazio.")
    val password: String,
)
