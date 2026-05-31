package finup.com.project.exception

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.validation.FieldError
import org.springframework.web.bind.MethodArgumentNotValidException
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

    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleApiException(exception: MethodArgumentNotValidException): ResponseEntity<Any> {
        val errors: MutableMap<String?, String?> = HashMap()

        exception.bindingResult.allErrors.forEach { error ->
            val fieldName = (error as FieldError).field
            val errorMessage = error.defaultMessage
            errors[fieldName] = errorMessage
        }

        return ResponseEntity
            .status(HttpStatus.BAD_REQUEST.value())
            .body(
                mapOf("message" to errors)
            )

    }
}