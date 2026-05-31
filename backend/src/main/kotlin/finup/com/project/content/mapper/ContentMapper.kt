package finup.com.project.content.mapper

import finup.com.project.content.models.Content
import finup.com.project.content.models.ContentType
import finup.com.project.content.models.dto.ContentDTO
import finup.com.project.content.models.dto.CreateContentRequestDto
import org.springframework.stereotype.Component

@Component
class ContentMapper {

    fun toEntity(dto: CreateContentRequestDto): Content {
        return Content(
            title = dto.title,
            description = dto.description,
            type = dto.type ?: ContentType.others,
            imageUrl = dto.imageUrl,
        )
    }

    fun toDTO(entity: Content): ContentDTO {
        return ContentDTO(
            id = entity.id!!,
            title = entity.title,
            likes = entity.likes,
            type = entity.type,
            description = entity.description,
            imageUrl = entity.imageUrl,
            createdAt = entity.createdAt,
            updatedAt = entity.updatedAt
        )
    }
}
