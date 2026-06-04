package finup.com.project.savedcontent.mapper

import finup.com.project.content.models.Content
import finup.com.project.savedcontent.models.SavedContent
import finup.com.project.savedcontent.models.dto.CreateSavedContentRequestDTO
import finup.com.project.savedcontent.models.dto.SavedContentDTO
import finup.com.project.user.models.User
import org.springframework.stereotype.Component

@Component
class SavedContentMapper {

    fun toEntity(dto: CreateSavedContentRequestDTO, user: User, content: Content): SavedContent {
        return SavedContent(
            user = user,
            content = content,
        )
    }

    fun toDTO(entity: SavedContent): SavedContentDTO {
        return SavedContentDTO(
            id = entity.id!!,
            userId = entity.user.id!!,
            contentId = entity.content.id!!,
            createdAt = entity.createdAt,
        )
    }
}
