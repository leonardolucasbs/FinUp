package finup.com.project.user.dto

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class UserCreateDTO(
    @NotBlank(message = "Nome não pode ser vazio.")
    val fullName: String,
    @NotBlank(message = "Email não pode ser vazio.")
    @Email(message = "Email inválido.")
    val username: String,
    @NotBlank(message = "Senha não pode ser vazio.")
    @Size(min = 8, message = "Senha deve ter no mínimo 8 caracteres.")
    val password: String,
)
