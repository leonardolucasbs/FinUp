package finup.com.project.content.models.dto
import finup.com.project.content.models.ContentType
import jakarta.validation.constraints.NotBlank

data class CreateContentRequestDto(
    @field:NotBlank(message = "Title is required")
    val title: String,

    @field:NotBlank(message = "Description is required")
    val description: String,

    val type: ContentType? = null, 
    val imageUrl: String? = null,     

)
