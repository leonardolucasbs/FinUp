package finup.com.project.subscription.models.dto

import jakarta.validation.constraints.NotNull

data class CreateSubscriptionRequestDTO(
    @field:NotNull(message = "User id is required")
    val userId: Int,

    @field:NotNull(message = "Course id is required")
    val courseId: Long,
)
