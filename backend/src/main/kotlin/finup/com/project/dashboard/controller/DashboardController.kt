package finup.com.project.dashboard.controller

import finup.com.project.dashboard.models.dto.AddExpenseRequestDTO
import finup.com.project.dashboard.models.dto.AddFixedValueRequestDTO
import finup.com.project.dashboard.models.dto.AddMoneyRequestDTO
import finup.com.project.dashboard.models.dto.CategoryDTO
import finup.com.project.dashboard.models.dto.CreateCategoryRequestDTO
import finup.com.project.dashboard.models.dto.CreateDashboardRequestDTO
import finup.com.project.dashboard.models.dto.DashboardDTO
import finup.com.project.dashboard.models.dto.ExpenseDTO
import finup.com.project.dashboard.service.DashboardService
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
@RequestMapping("/dashboard")
class DashboardController(private val dashboardService: DashboardService) {

    @PostMapping
    fun createDashboard(@Valid @RequestBody dto: CreateDashboardRequestDTO): ResponseEntity<DashboardDTO> {
        val dashboard = dashboardService.createDashboard(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(dashboard)
    }

    @GetMapping("/{id}")
    fun findById(@PathVariable id: Long): ResponseEntity<DashboardDTO> {
        return ResponseEntity.ok(dashboardService.findById(id))
    }

    @DeleteMapping("/{id}")
    fun deleteDashboard(@PathVariable id: Long): ResponseEntity<Void> {
        dashboardService.deleteDashboard(id)
        return ResponseEntity.noContent().build()
    }

    @GetMapping("/users/{userId}")
    fun findByUser(@PathVariable userId: Int): ResponseEntity<List<DashboardDTO>> {
        return ResponseEntity.ok(dashboardService.findByUser(userId))
    }

    @GetMapping("/getall/{userId}")
    fun findAllByUser(@PathVariable userId: Int): ResponseEntity<List<DashboardDTO>> {
        return ResponseEntity.ok(dashboardService.findByUser(userId))
    }

    @PostMapping("/categories")
    fun createCategory(@Valid @RequestBody dto: CreateCategoryRequestDTO): ResponseEntity<CategoryDTO> {
        val category = dashboardService.createCategory(dto)
        return ResponseEntity.status(HttpStatus.CREATED).body(category)
    }

    @GetMapping("/categories")
    fun findAllCategories(): ResponseEntity<List<CategoryDTO>> {
        return ResponseEntity.ok(dashboardService.findAllCategories())
    }

    @GetMapping("/categories/{userId}")
    fun findCategoriesByUser(@PathVariable userId: Int): ResponseEntity<List<CategoryDTO>> {
        return ResponseEntity.ok(dashboardService.findCategoriesByUser(userId))
    }

    @GetMapping("/{dashboardId}/expenses")
    fun findExpensesByDashboard(@PathVariable dashboardId: Long): ResponseEntity<List<ExpenseDTO>> {
        return ResponseEntity.ok(dashboardService.findExpensesByDashboard(dashboardId))
    }

    @PostMapping("/fixed-values")
    fun addFixedValue(@Valid @RequestBody dto: AddFixedValueRequestDTO): ResponseEntity<DashboardDTO> {
        return ResponseEntity.ok(dashboardService.addFixedValue(dto))
    }

    @PostMapping("/money")
    fun addMoney(@Valid @RequestBody dto: AddMoneyRequestDTO): ResponseEntity<DashboardDTO> {
        return ResponseEntity.ok(dashboardService.addMoney(dto))
    }

    @PostMapping("/expenses")
    fun addExpense(@Valid @RequestBody dto: AddExpenseRequestDTO): ResponseEntity<DashboardDTO> {
        return ResponseEntity.ok(dashboardService.addExpense(dto))
    }
}
