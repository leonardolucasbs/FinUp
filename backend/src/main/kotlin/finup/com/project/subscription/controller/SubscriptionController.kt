package finup.com.project.subscription.controller

import finup.com.project.subscription.models.dto.CreateSubscriptionRequestDTO
import finup.com.project.subscription.models.dto.SubscriptionDTO
import finup.com.project.subscription.models.dto.UpdateSubscriptionRequestDTO
import finup.com.project.subscription.service.SubscriptionService
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/subscriptions")
class SubscriptionController(private val subscriptionService: SubscriptionService) {

    @PostMapping
    fun create(@Valid @RequestBody dto: CreateSubscriptionRequestDTO): ResponseEntity<SubscriptionDTO> {
        val subscription = subscriptionService.create(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(subscription)
    }

    @GetMapping
    fun findAll(): ResponseEntity<List<SubscriptionDTO>> {
        val subscriptions = subscriptionService.findAll()
        return ResponseEntity.ok(subscriptions)
    }

    @GetMapping("/{id}")
    fun findById(@PathVariable id: Long): ResponseEntity<SubscriptionDTO> {
        val subscription = subscriptionService.findById(id)
        return ResponseEntity.ok(subscription)
    }

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: Long,
        @Valid @RequestBody dto: UpdateSubscriptionRequestDTO,
    ): ResponseEntity<SubscriptionDTO> {
        val updatedSubscription = subscriptionService.update(id, dto)
        return ResponseEntity.ok(updatedSubscription)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: Long): ResponseEntity<Void> {
        subscriptionService.delete(id)
        return ResponseEntity.noContent().build()
    }
}
