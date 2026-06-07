package finup.com.project.course.mapper

import finup.com.project.course.models.Course
import finup.com.project.course.models.dto.CourseDTO
import finup.com.project.course.models.dto.CreateCourseRequestDto
import org.springframework.stereotype.Component

@Component
class CourseMapper {

    fun toEntity(dto: CreateCourseRequestDto): Course {
        return Course(
            title = dto.title,
            description = dto.description,
            teacher = dto.teacher,
            imageUrl = dto.imageUrl,
        )
    }

    fun toDTO(entity: Course): CourseDTO {
        return CourseDTO(
            id = entity.id!!,
            title = entity.title,
            description = entity.description,
            imageUrl = entity.imageUrl,
            teacher = entity.teacher,
            createdAt = entity.createdAt,
            updatedAt = entity.updatedAt
        )
    }
}
