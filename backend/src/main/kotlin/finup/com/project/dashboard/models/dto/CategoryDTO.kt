package finup.com.project.dashboard.models.dto

import java.time.LocalDateTime

data class CategoryDTO(
    val id: Long,
    val name: String,
    val userId: Int,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)
