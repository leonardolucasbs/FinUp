package finup.com.project.exception

import lombok.Getter
import org.springframework.http.HttpStatus

@Getter
class ApiException(val error: Error) : RuntimeException(error.message) {

    enum class Error(val statusCode: Int, val message: String) {
        EMAIL_ALREADY_EXISTS(HttpStatus.BAD_REQUEST.value(), "Email ja existe."),
        INVALID_CREDENTIALS(HttpStatus.BAD_REQUEST.value(), "E-mail ou senha invalida."),
        USER_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "Usuario nao encontrado."),
        CATEGORY_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "Categoria nao encontrada."),
        DASHBOARD_NOT_FOUND(HttpStatus.NOT_FOUND.value(), "Dashboard nao encontrado.")
    }

}
