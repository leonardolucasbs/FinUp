package finup.com.project.subscription.models.dto

import finup.com.project.subscription.models.enums.SubscriptionStatus
import jakarta.validation.constraints.NotNull

data class UpdateSubscriptionRequestDTO(
    @field:NotNull(message = "Status is required")
    val status: SubscriptionStatus,
)
