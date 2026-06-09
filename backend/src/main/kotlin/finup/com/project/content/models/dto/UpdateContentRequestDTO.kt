package finup.com.project.content.models.dto

import jakarta.validation.constraints.NotBlank
import finup.com.project.content.models.enums.ContentType
import org.springframework.web.multipart.MultipartFile

data class UpdateContentRequestDTO(
    @field:NotBlank(message = "Title is required")
    val title: String = "",

    @field:NotBlank(message = "Description is required")
    val description: String = "",

    val type: ContentType? = null,
    val image: MultipartFile? = null,
)
