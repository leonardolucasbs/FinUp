package finup.com.project.dashboard.models.dto

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull

data class CreateDashboardRequestDTO(
    @field:NotNull(message = "User id is required")
    val userId: Int,

    @field:NotBlank(message = "Title is required")
    val title: String
)
