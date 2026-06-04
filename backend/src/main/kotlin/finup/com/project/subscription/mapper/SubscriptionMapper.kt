package finup.com.project.subscription.mapper

import finup.com.project.course.models.Course
import finup.com.project.subscription.models.Subscription
import finup.com.project.subscription.models.dto.CreateSubscriptionRequestDTO
import finup.com.project.subscription.models.dto.SubscriptionDTO
import finup.com.project.user.models.User
import org.springframework.stereotype.Component

@Component
class SubscriptionMapper {

    fun toEntity(dto: CreateSubscriptionRequestDTO, user: User, course: Course): Subscription {
        return Subscription(
            user = user,
            course = course,
        )
    }

    fun toDTO(entity: Subscription): SubscriptionDTO {
        return SubscriptionDTO(
            id = entity.id!!,
            userId = entity.user.id!!,
            courseId = entity.course.id!!,
            status = entity.status,
            createdAt = entity.createdAt,
            updatedAt = entity.updatedAt,
        )
    }
}
