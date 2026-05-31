package finup.com.project.content.controller

import finup.com.project.content.models.dto.ContentDTO
import finup.com.project.content.models.dto.CreateContentRequestDto
import finup.com.project.content.models.dto.UpdateContentRequestDTO
import finup.com.project.content.service.ContentService
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/contents")
class ContentController(private val contentService: ContentService) {

    @PostMapping
    fun create(@Valid @RequestBody dto: CreateContentRequestDto): ResponseEntity<ContentDTO> {
        val content = contentService.create(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(content)
    }

    @GetMapping
    fun findAll(): ResponseEntity<List<ContentDTO>> {
        val contents = contentService.findAll()
        return ResponseEntity.ok(contents)
    }

    @GetMapping("/{id}")
    fun findById(@PathVariable id: Long): ResponseEntity<ContentDTO> {
        val content = contentService.findById(id)
        return ResponseEntity.ok(content)
    }
    
    @PutMapping("/{id}")
    fun update(@PathVariable id: Long, @Valid @RequestBody dto: UpdateContentRequestDTO): ResponseEntity<ContentDTO> {
        val updatedContent = contentService.update(id, dto)
        return ResponseEntity.ok(updatedContent)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: Long): ResponseEntity<Void> {
        contentService.delete(id)
        return ResponseEntity.noContent().build()
    }
}