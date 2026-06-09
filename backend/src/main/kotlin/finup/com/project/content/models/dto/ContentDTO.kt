package finup.com.project.content.models.dto

import java.time.LocalDateTime
import finup.com.project.content.models.enums.ContentType
import jakarta.persistence.Lob

data class ContentDTO(
    val id: Long,
    val title: String,
    val type: ContentType,
    val description: String,
    @Lob
    var imageData: ByteArray? = null,
    var imageContentType: String? = null,
    val userId: Int,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ContentDTO

        if (id != other.id) return false
        if (userId != other.userId) return false
        if (title != other.title) return false
        if (type != other.type) return false
        if (description != other.description) return false
        if (!imageData.contentEquals(other.imageData)) return false
        if (imageContentType != other.imageContentType) return false
        if (createdAt != other.createdAt) return false
        if (updatedAt != other.updatedAt) return false

        return true
    }

    override fun hashCode(): Int {
        var result = id.hashCode()
        result = 31 * result + userId
        result = 31 * result + title.hashCode()
        result = 31 * result + type.hashCode()
        result = 31 * result + description.hashCode()
        result = 31 * result + (imageData?.contentHashCode() ?: 0)
        result = 31 * result + (imageContentType?.hashCode() ?: 0)
        result = 31 * result + createdAt.hashCode()
        result = 31 * result + updatedAt.hashCode()
        return result
    }
}
