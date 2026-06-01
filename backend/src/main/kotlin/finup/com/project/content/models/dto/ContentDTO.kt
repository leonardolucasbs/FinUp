package finup.com.project.content.models.dto

import java.time.LocalDateTime
import finup.com.project.content.models.enums.ContentType

data class ContentDTO(
    val id: Long,
    val title: String,
    val likes: Int,
    val type: ContentType,
    val description: String,
    val imageUrl: String?,
    val userId: Int,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
)
