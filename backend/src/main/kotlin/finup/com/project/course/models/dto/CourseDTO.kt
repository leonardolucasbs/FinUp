package finup.com.project.course.models.dto

import finup.com.project.course.models.enums.CourseLevel
import finup.com.project.course.models.enums.CourseType
import java.time.LocalDate
import java.time.LocalDateTime

data class CourseDTO(
    val id: Long,
    val title: String,
    val description: String,
    val teacher: String,
    val courseType: CourseType?,
    val location: String?,
    val courseHours: Int?,
    val startDate: LocalDate?,
    val level: CourseLevel?,
    val imageUrl: String?,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)
