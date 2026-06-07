package finup.com.project.course.models.dto

import jakarta.validation.constraints.NotBlank

data class CreateCourseRequestDto(
    @field:NotBlank(message = "Title is required")
    val title: String,

    @field:NotBlank(message = "Description is required")
    val description: String,

    @field:NotBlank(message = "Teacher is required")
    val teacher: String,

    val imageUrl: String? = null
    ,
)
