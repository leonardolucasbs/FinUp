package finup.com.project.course.controller

import finup.com.project.course.models.dto.CourseDTO
import finup.com.project.course.models.dto.CreateCourseRequestDto
import finup.com.project.course.models.dto.UpdateCourseRequestDto
import finup.com.project.course.service.CourseService
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/courses")
class CourseController(private val courseService: CourseService) {

    @PostMapping
    fun create(@Valid @RequestBody dto: CreateCourseRequestDto): ResponseEntity<CourseDTO> {
        val course = courseService.create(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(course)
    }

    @GetMapping
    fun findAll(): ResponseEntity<List<CourseDTO>> {
        val courses = courseService.findAll()
        return ResponseEntity.ok(courses)
    }

    @GetMapping("/{id}")
    fun findById(@PathVariable id: Long): ResponseEntity<CourseDTO> {
        val course = courseService.findById(id)
        return ResponseEntity.ok(course)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: Long, @Valid @RequestBody dto: UpdateCourseRequestDto): ResponseEntity<CourseDTO> {
        val updatedCourse = courseService.update(id, dto)
        return ResponseEntity.ok(updatedCourse)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: Long): ResponseEntity<Void> {
        courseService.delete(id)
        return ResponseEntity.noContent().build()
    }
}
