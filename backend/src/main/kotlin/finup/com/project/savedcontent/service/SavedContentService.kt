package finup.com.project.savedcontent.service

import finup.com.project.content.exception.ContentNotFoundException
import finup.com.project.content.repository.ContentRepository
import finup.com.project.exception.ApiException
import finup.com.project.savedcontent.exception.SavedContentNotFoundException
import finup.com.project.savedcontent.mapper.SavedContentMapper
import finup.com.project.savedcontent.models.dto.CreateSavedContentRequestDTO
import finup.com.project.savedcontent.models.dto.SavedContentDTO
import finup.com.project.savedcontent.repository.SavedContentRepository
import finup.com.project.user.repositories.UserRepository
import org.springframework.stereotype.Service

@Service
class SavedContentService(
    private val savedContentRepository: SavedContentRepository,
    private val savedContentMapper: SavedContentMapper,
    private val userRepository: UserRepository,
    private val contentRepository: ContentRepository,
) {

    fun create(dto: CreateSavedContentRequestDTO): SavedContentDTO {
        val user = userRepository.findUserById(dto.userId)
            .orElseThrow { ApiException(ApiException.Error.USER_NOT_FOUND) }
        val content = contentRepository.findById(dto.contentId)
            .orElseThrow { ContentNotFoundException("Content with id ${dto.contentId} not found") }

        val savedContent = savedContentMapper.toEntity(dto, user, content)
        val saved = savedContentRepository.save(savedContent)
        return savedContentMapper.toDTO(saved)
    }

    fun findAll(): List<SavedContentDTO> {
        return savedContentRepository.findAll().map { savedContentMapper.toDTO(it) }
    }

    fun findById(id: Long): SavedContentDTO {
        val savedContent = savedContentRepository.findById(id)
            .orElseThrow { SavedContentNotFoundException("Saved content with id $id not found") }
        return savedContentMapper.toDTO(savedContent)
    }

    fun delete(id: Long) {
        if (!savedContentRepository.existsById(id)) {
            throw SavedContentNotFoundException("Saved content with id $id not found")
        }
        savedContentRepository.deleteById(id)
    }
}
