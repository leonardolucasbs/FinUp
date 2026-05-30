package finup.com.project.exception

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice

@RestControllerAdvice
class GlobalExceptionHandler {

    @ExceptionHandler(ApiException::class)
    fun handleApiException(exception: ApiException): ResponseEntity<Map<String, String?>> {

        return ResponseEntity
            .status(exception.error.statusCode)
            .body(
                mapOf("message" to exception.error.message)
            )

    }
}