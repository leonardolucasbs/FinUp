package finup.com.project.content.exception

import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(HttpStatus.NOT_FOUND)
class ContentNotFoundException(message: String) : RuntimeException(message)
