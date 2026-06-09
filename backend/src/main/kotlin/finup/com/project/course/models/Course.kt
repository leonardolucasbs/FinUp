package finup.com.project.course.models

import finup.com.project.course.models.enums.CourseLevel
import finup.com.project.course.models.enums.CourseType
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.LocalDate
import java.time.LocalDateTime

@Entity
@Table(name = "course")
data class Course(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
    var title: String,
    var description: String,
    var teacher: String,
    @Enumerated(EnumType.STRING)
    var courseType: CourseType? = null,
    var location: String? = null,
    var courseHours: Int? = null,
    var startDate: LocalDate? = null,
    @Enumerated(EnumType.STRING)
    var level: CourseLevel? = null,
    var imageUrl: String? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    var updatedAt: LocalDateTime = LocalDateTime.now()
)
