package finup.com.project.subscription.service

import finup.com.project.course.exception.CourseNotFoundException
import finup.com.project.course.repository.CourseRepository
import finup.com.project.exception.ApiException
import finup.com.project.subscription.exception.SubscriptionNotFoundException
import finup.com.project.subscription.mapper.SubscriptionMapper
import finup.com.project.subscription.models.dto.CreateSubscriptionRequestDTO
import finup.com.project.subscription.models.dto.SubscriptionDTO
import finup.com.project.subscription.models.dto.UpdateSubscriptionRequestDTO
import finup.com.project.subscription.repository.SubscriptionRepository
import finup.com.project.user.repositories.UserRepository
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class SubscriptionService(
    private val subscriptionRepository: SubscriptionRepository,
    private val subscriptionMapper: SubscriptionMapper,
    private val userRepository: UserRepository,
    private val courseRepository: CourseRepository,
) {

    fun create(dto: CreateSubscriptionRequestDTO): SubscriptionDTO {
        val user = userRepository.findUserById(dto.userId)
            .orElseThrow { ApiException(ApiException.Error.USER_NOT_FOUND) }
        val course = courseRepository.findById(dto.courseId)
            .orElseThrow { CourseNotFoundException("Course with id ${dto.courseId} not found") }

        val subscription = subscriptionMapper.toEntity(dto, user, course)
        val saved = subscriptionRepository.save(subscription)
        return subscriptionMapper.toDTO(saved)
    }

    fun findAll(): List<SubscriptionDTO> {
        return subscriptionRepository.findAll().map { subscriptionMapper.toDTO(it) }
    }

    fun findById(id: Long): SubscriptionDTO {
        val subscription = subscriptionRepository.findById(id)
            .orElseThrow { SubscriptionNotFoundException("Subscription with id $id not found") }
        return subscriptionMapper.toDTO(subscription)
    }

    fun update(id: Long, dto: UpdateSubscriptionRequestDTO): SubscriptionDTO {
        val subscription = subscriptionRepository.findById(id)
            .orElseThrow { SubscriptionNotFoundException("Subscription with id $id not found") }

        if (dto.status != null) {
            subscription.status = dto.status
        }
        subscription.updatedAt = LocalDateTime.now()

        val updated = subscriptionRepository.save(subscription)
        return subscriptionMapper.toDTO(updated)
    }

    fun delete(id: Long) {
        if (!subscriptionRepository.existsById(id)) {
            throw SubscriptionNotFoundException("Subscription with id $id not found")
        }
        subscriptionRepository.deleteById(id)
    }
}
