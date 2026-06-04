package finup.com.project.savedcontent.controller

import finup.com.project.savedcontent.models.dto.CreateSavedContentRequestDTO
import finup.com.project.savedcontent.models.dto.SavedContentDTO
import finup.com.project.savedcontent.service.SavedContentService
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/saved-contents")
class SavedContentController(private val savedContentService: SavedContentService) {

    @PostMapping
    fun create(@Valid @RequestBody dto: CreateSavedContentRequestDTO): ResponseEntity<SavedContentDTO> {
        val savedContent = savedContentService.create(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(savedContent)
    }

    @GetMapping
    fun findAll(): ResponseEntity<List<SavedContentDTO>> {
        val savedContents = savedContentService.findAll()
        return ResponseEntity.ok(savedContents)
    }

    @GetMapping("/{id}")
    fun findById(@PathVariable id: Long): ResponseEntity<SavedContentDTO> {
        val savedContent = savedContentService.findById(id)
        return ResponseEntity.ok(savedContent)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: Long): ResponseEntity<Void> {
        savedContentService.delete(id)
        return ResponseEntity.noContent().build()
    }
}
