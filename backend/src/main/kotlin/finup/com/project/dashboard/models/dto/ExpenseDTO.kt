package finup.com.project.dashboard.models.dto

import java.time.LocalDateTime

data class ExpenseDTO(
    val id: Long,
    val dashboardId: Long,
    val amount: Double,
    val category: CategoryDTO,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)
