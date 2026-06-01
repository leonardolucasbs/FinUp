package finup.com.project.dashboard.models.dto

import java.time.LocalDate
import java.time.LocalDateTime

data class DashboardDTO(
    val id: Long,
    val title: String,
    val userId: Int,
    val balance: Double,
    val fixedBalance: Double,
    val expenses: Double,
    val date: LocalDate,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)
