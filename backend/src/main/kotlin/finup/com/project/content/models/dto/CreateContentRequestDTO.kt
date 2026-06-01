package finup.com.project.content.models.dto

import finup.com.project.content.models.enums.ContentType
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull

data class CreateContentRequestDto(
    @field:NotBlank(message = "Title is required")
    val title: String,

    @field:NotBlank(message = "Description is required")
    val description: String,

    @field:NotNull(message = "User id is required")
    val userId: Int,

    val type: ContentType? = null, 
    val imageUrl: String? = null,     

)
