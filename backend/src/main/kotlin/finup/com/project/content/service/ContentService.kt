package finup.com.project.content.service

import finup.com.project.content.exception.ContentNotFoundException
import finup.com.project.content.mapper.ContentMapper
import finup.com.project.content.models.dto.ContentDTO
import finup.com.project.content.models.dto.CreateContentRequestDto
import finup.com.project.content.models.dto.UpdateContentRequestDTO
import finup.com.project.content.repository.ContentRepository
import finup.com.project.content.models.Content
import finup.com.project.content.models.ContentType
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class ContentService(
    private val contentRepository: ContentRepository,
    private val contentMapper: ContentMapper
) {

    fun create(dto: CreateContentRequestDto): ContentDTO {
        val content = contentMapper.toEntity(dto)
        val savedContent = contentRepository.save(content)
        return contentMapper.toDTO(savedContent)
    }

    fun findAll(): List<ContentDTO> {
        return contentRepository.findAll().map { contentMapper.toDTO(it) }
    }

    fun findById(id: Long): ContentDTO {
        val content = contentRepository.findById(id)
            .orElseThrow { ContentNotFoundException("Content with id $id not found") }
        return contentMapper.toDTO(content)
    }

    fun update(id: Long, dto: UpdateContentRequestDTO): ContentDTO {
        val content = contentRepository.findById(id)
            .orElseThrow { ContentNotFoundException("Content with id $id not found") }

        content.title = dto.title
        content.description = dto.description
        if (dto.type != null) {
            content.type = dto.type
        }
        content.updatedAt = LocalDateTime.now()

        if (dto.imageUrl != null) {
            content.imageUrl = dto.imageUrl
        }

        val updatedContent = contentRepository.save(content)
        return contentMapper.toDTO(updatedContent)
    }

    fun delete(id: Long) {
        if (!contentRepository.existsById(id)) {
            throw ContentNotFoundException("Content with id $id not found")
        }
        contentRepository.deleteById(id)
    }
}
