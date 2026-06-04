package finup.com.project.subscription.repository

import finup.com.project.subscription.models.Subscription
import org.springframework.data.jpa.repository.JpaRepository

interface SubscriptionRepository : JpaRepository<Subscription, Long>
