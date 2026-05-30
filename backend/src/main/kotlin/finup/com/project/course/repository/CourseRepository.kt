package finup.com.project.course.repository

import finup.com.project.course.models.Course
import org.springframework.data.jpa.repository.JpaRepository

interface CourseRepository : JpaRepository<Course, Long>
