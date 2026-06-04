package finup.com.project.dashboard.service

import finup.com.project.dashboard.models.Category
import finup.com.project.dashboard.models.Dashboard
import finup.com.project.dashboard.models.Expense
import finup.com.project.dashboard.models.dto.AddExpenseRequestDTO
import finup.com.project.dashboard.models.dto.AddFixedValueRequestDTO
import finup.com.project.dashboard.models.dto.AddMoneyRequestDTO
import finup.com.project.dashboard.models.dto.CategoryDTO
import finup.com.project.dashboard.models.dto.CreateCategoryRequestDTO
import finup.com.project.dashboard.models.dto.CreateDashboardRequestDTO
import finup.com.project.dashboard.models.dto.DashboardDTO
import finup.com.project.dashboard.models.dto.ExpenseDTO
import finup.com.project.dashboard.repository.CategoryRepository
import finup.com.project.dashboard.repository.DashboardRepository
import finup.com.project.dashboard.repository.ExpenseRepository
import finup.com.project.exception.ApiException
import finup.com.project.user.models.User
import finup.com.project.user.repositories.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime

@Service
class DashboardService(
    private val dashboardRepository: DashboardRepository,
    private val categoryRepository: CategoryRepository,
    private val expenseRepository: ExpenseRepository,
    private val userRepository: UserRepository
) {

    fun createDashboard(dto: CreateDashboardRequestDTO): DashboardDTO {
        val user = getUser(dto.userId)
        ensureDefaultCategories(user)
        val dashboard = dashboardRepository.save(
            Dashboard(
                title = dto.title,
                user = user
            )
        )
        return toDTO(dashboard)
    }

    fun findById(id: Long): DashboardDTO {
        return toDTO(getDashboard(id))
    }

    fun findByUser(userId: Int): List<DashboardDTO> {
        getUser(userId)
        return dashboardRepository.findAllByUserId(userId).map { toDTO(it) }
    }

    @Transactional
    fun deleteDashboard(id: Long) {
        val dashboard = getDashboard(id)
        val expenses = expenseRepository.findAllByDashboardId(id)
        expenseRepository.deleteAll(expenses)
        dashboardRepository.delete(dashboard)
    }

    fun createCategory(dto: CreateCategoryRequestDTO): CategoryDTO {
        val user = getUser(dto.userId)
        val category = categoryRepository.save(
            Category(
                name = dto.name,
                user = user
            )
        )
        return toDTO(category)
    }

    fun findAllCategories(): List<CategoryDTO> {
        return categoryRepository.findAll().map { toDTO(it) }
    }

    fun findCategoriesByUser(userId: Int): List<CategoryDTO> {
        val user = getUser(userId)
        ensureDefaultCategories(user)
        return categoryRepository.findAllByUserId(userId).map { toDTO(it) }
    }

    fun findExpensesByDashboard(dashboardId: Long): List<ExpenseDTO> {
        getDashboard(dashboardId)
        return expenseRepository.findAllByDashboardId(dashboardId).map { toDTO(it) }
    }

    fun addFixedValue(dto: AddFixedValueRequestDTO): DashboardDTO {
        val dashboard = getDashboard(dto.dashboardId)
        dashboard.fixedBalance += dto.amount
        dashboard.balance += dto.amount
        dashboard.updatedAt = LocalDateTime.now()
        return toDTO(dashboardRepository.save(dashboard))
    }

    fun addMoney(dto: AddMoneyRequestDTO): DashboardDTO {
        val dashboard = getDashboard(dto.dashboardId)
        dashboard.balance += dto.amount
        dashboard.updatedAt = LocalDateTime.now()
        return toDTO(dashboardRepository.save(dashboard))
    }

    fun addExpense(dto: AddExpenseRequestDTO): DashboardDTO {
        val dashboard = getDashboard(dto.dashboardId)
        val category = categoryRepository.findByIdAndUserId(dto.categoryId, dashboard.user.id!!)
            .orElseThrow { ApiException(ApiException.Error.CATEGORY_NOT_FOUND) }

        dashboard.balance -= dto.amount
        dashboard.expenses += dto.amount
        dashboard.updatedAt = LocalDateTime.now()
        expenseRepository.save(
            Expense(
                amount = dto.amount,
                dashboard = dashboard,
                category = category
            )
        )

        return toDTO(dashboardRepository.save(dashboard))
    }

    private fun getDashboard(id: Long): Dashboard {
        return dashboardRepository.findById(id)
            .orElseThrow { ApiException(ApiException.Error.DASHBOARD_NOT_FOUND) }
    }

    private fun getUser(userId: Int): User {
        return userRepository.findUserById(userId)
            .orElseThrow { ApiException(ApiException.Error.USER_NOT_FOUND) }
    }

    private fun ensureDefaultCategories(user: User) {
        DEFAULT_CATEGORIES
            .filterNot { categoryRepository.existsByUserIdAndNameIgnoreCase(user.id!!, it) }
            .map { name -> Category(name = name, user = user) }
            .takeIf { it.isNotEmpty() }
            ?.let { categoryRepository.saveAll(it) }
    }

    private fun toDTO(dashboard: Dashboard): DashboardDTO {
        return DashboardDTO(
            id = dashboard.id!!,
            title = dashboard.title,
            userId = dashboard.user.id!!,
            balance = dashboard.balance,
            fixedBalance = dashboard.fixedBalance,
            expenses = dashboard.expenses,
            date = dashboard.date,
            createdAt = dashboard.createdAt,
            updatedAt = dashboard.updatedAt
        )
    }

    private fun toDTO(category: Category): CategoryDTO {
        return CategoryDTO(
            id = category.id!!,
            name = category.name,
            userId = category.user.id!!,
            createdAt = category.createdAt,
            updatedAt = category.updatedAt
        )
    }

    private fun toDTO(expense: Expense): ExpenseDTO {
        return ExpenseDTO(
            id = expense.id!!,
            dashboardId = expense.dashboard.id!!,
            amount = expense.amount,
            category = toDTO(expense.category),
            createdAt = expense.createdAt,
            updatedAt = expense.updatedAt
        )
    }

    private companion object {
        val DEFAULT_CATEGORIES = listOf(
            "Alimentacao",
            "Moradia",
            "Transporte",
            "Saude",
            "Lazer"
        )
    }
}
