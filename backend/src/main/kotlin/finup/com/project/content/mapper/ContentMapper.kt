package finup.com.project.content.mapper

import finup.com.project.content.models.Content
import finup.com.project.content.models.dto.ContentDTO
import finup.com.project.content.models.dto.CreateContentRequestDto
import finup.com.project.content.models.enums.ContentType
import finup.com.project.user.models.User
import org.springframework.stereotype.Component
import java.util.Base64

@Component
class ContentMapper {

    fun toEntity(dto: CreateContentRequestDto, user: User): Content {
        val image = dto.image?.takeIf { !it.isEmpty }
        return Content(
            title = dto.title,
            description = dto.description,
            type = dto.type ?: ContentType.OTHERS,
            imageData = image?.bytes,
            imageContentType = image?.contentType,
            user = user,
        )
    }

    fun toDTO(entity: Content): ContentDTO {
        return ContentDTO(
            id = entity.id!!,
            title = entity.title,
            type = entity.type,
            description = entity.description,
            imageData = entity.imageData,
            imageContentType = entity.imageContentType,
            userId = entity.user.id!!,
            createdAt = entity.createdAt,
            updatedAt = entity.updatedAt
        )
    }
}
