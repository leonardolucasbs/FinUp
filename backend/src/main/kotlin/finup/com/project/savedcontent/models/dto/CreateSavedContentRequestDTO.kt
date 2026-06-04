package finup.com.project.savedcontent.models.dto

import jakarta.validation.constraints.NotNull

data class CreateSavedContentRequestDTO(
    @field:NotNull(message = "User id is required")
    val userId: Int,

    @field:NotNull(message = "Content id is required")
    val contentId: Long,
)
