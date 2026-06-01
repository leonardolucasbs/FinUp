package finup.com.project.dashboard.models.dto

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull

data class CreateCategoryRequestDTO(
    @field:NotNull(message = "User id is required")
    val userId: Int,

    @field:NotBlank(message = "Name is required")
    val name: String
)
