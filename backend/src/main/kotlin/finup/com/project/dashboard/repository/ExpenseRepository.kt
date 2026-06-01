package finup.com.project.dashboard.repository

import finup.com.project.dashboard.models.Expense
import org.springframework.data.jpa.repository.JpaRepository

interface ExpenseRepository : JpaRepository<Expense, Long> {
    fun findAllByDashboardId(dashboardId: Long): List<Expense>
}
