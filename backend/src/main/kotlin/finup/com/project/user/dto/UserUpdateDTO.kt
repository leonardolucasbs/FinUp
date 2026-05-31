package finup.com.project.user.dto

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class UserUpdateDTO (
    @NotBlank(message = "Nome não pode ser vazio.")
    val fullName: String,
    @NotBlank(message = "Senha não pode ser vazio.")
    @Size(min = 8, message = "Senha deve ter no mínimo 8 caracteres.")
    val password: String
){}