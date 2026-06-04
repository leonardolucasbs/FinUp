package finup.com.project.savedcontent.models.dto

import java.time.LocalDateTime

data class SavedContentDTO(
    val id: Long,
    val userId: Int,
    val contentId: Long,
    val createdAt: LocalDateTime,
)
