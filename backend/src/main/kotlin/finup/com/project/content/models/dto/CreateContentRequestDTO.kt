package finup.com.project.content.models.dto

import finup.com.project.content.models.enums.ContentType
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import org.springframework.web.multipart.MultipartFile

data class CreateContentRequestDto(
    @field:NotBlank(message = "Title is required")
    val title: String = "",

    @field:NotBlank(message = "Description is required")
    val description: String = "",

    @field:NotNull(message = "User id is required")
    var userId: Int? = null,

    val type: ContentType? = null,
    val image: MultipartFile? = null,
)
