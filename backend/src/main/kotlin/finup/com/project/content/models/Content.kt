package finup.com.project.content.models

import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.LocalDateTime
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated


enum class ContentType {
    notes,
    news,
    articles,
    others
}

@Entity
@Table(name = "content")
data class Content(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
    var title: String,
    var likes: Int = 0,
    @Enumerated(EnumType.STRING)  
    var type: ContentType = ContentType.others, 
    var description: String,
    var imageUrl: String? = null,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    var updatedAt: LocalDateTime = LocalDateTime.now()
)
