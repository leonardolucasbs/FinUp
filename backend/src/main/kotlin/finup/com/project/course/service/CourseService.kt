package finup.com.project.course.service

import finup.com.project.course.exception.CourseNotFoundException
import finup.com.project.course.mapper.CourseMapper
import finup.com.project.course.models.dto.CourseDTO
import finup.com.project.course.models.dto.CreateCourseRequestDto
import finup.com.project.course.models.dto.UpdateCourseRequestDto
import finup.com.project.course.repository.CourseRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class CourseService(
    private val courseRepository: CourseRepository,
    private val courseMapper: CourseMapper
) {

    fun create(dto: CreateCourseRequestDto): CourseDTO {
        val course = courseMapper.toEntity(dto)
        val savedCourse = courseRepository.save(course)
        return courseMapper.toDTO(savedCourse)
    }

    fun findAll(): List<CourseDTO> {
        return courseRepository.findAll().map { courseMapper.toDTO(it) }
    }

    fun findById(id: Long): CourseDTO {
        val course = courseRepository.findById(id)
            .orElseThrow { CourseNotFoundException("Course with id $id not found") }
        return courseMapper.toDTO(course)
    }

    fun update(id: Long, dto: UpdateCourseRequestDto): CourseDTO {
        val course = courseRepository.findById(id)
            .orElseThrow { CourseNotFoundException("Course with id $id not found") }

        course.title = dto.title
        course.description = dto.description
        course.updatedAt = LocalDateTime.now()

        val updatedCourse = courseRepository.save(course)
        return courseMapper.toDTO(updatedCourse)
    }

    fun delete(id: Long) {
        if (!courseRepository.existsById(id)) {
            throw CourseNotFoundException("Course with id $id not found")
        }
        courseRepository.deleteById(id)
    }
}
