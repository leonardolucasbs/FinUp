package finup.com.project.course.models.dto

import java.time.LocalDateTime

data class CourseDTO(
    val id: Long,
    val title: String,
    val description: String,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)
