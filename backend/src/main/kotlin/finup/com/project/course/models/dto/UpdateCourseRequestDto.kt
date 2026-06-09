package finup.com.project.course.models.dto

import finup.com.project.course.models.enums.CourseLevel
import finup.com.project.course.models.enums.CourseType
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.Positive
import java.time.LocalDate

data class UpdateCourseRequestDto(
    @field:NotBlank(message = "Title is required")
    val title: String,

    @field:NotBlank(message = "Description is required")
    val description: String,

    @field:NotBlank(message = "Teacher is required")
    val teacher: String,

    @field:NotNull(message = "Course type is required")
    val courseType: CourseType,

    @field:NotBlank(message = "Location is required")
    val location: String,

    @field:NotNull(message = "Course hours is required")
    @field:Positive(message = "Course hours must be greater than zero")
    val courseHours: Int,

    @field:NotNull(message = "Start date is required")
    val startDate: LocalDate,

    @field:NotNull(message = "Level is required")
    val level: CourseLevel,

    val imageUrl: String? = null,
)
