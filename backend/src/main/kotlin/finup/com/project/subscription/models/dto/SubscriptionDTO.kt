package finup.com.project.subscription.models.dto

import finup.com.project.subscription.models.enums.SubscriptionStatus
import java.time.LocalDateTime

data class SubscriptionDTO(
    val id: Long,
    val userId: Int,
    val courseId: Long,
    val status: SubscriptionStatus,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime,
)
