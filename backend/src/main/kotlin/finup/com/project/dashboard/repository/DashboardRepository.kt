package finup.com.project.dashboard.repository

import finup.com.project.dashboard.models.Dashboard
import org.springframework.data.jpa.repository.JpaRepository
import java.util.Optional

interface DashboardRepository : JpaRepository<Dashboard, Long> {
    fun findAllByUserId(userId: Int): List<Dashboard>
    fun findByIdAndUserId(id: Long, userId: Int): Optional<Dashboard>
}
