package finup.com.project.dashboard.models.dto

import jakarta.validation.constraints.Positive

data class AddMoneyRequestDTO(
    val dashboardId: Long,

    @field:Positive(message = "Amount must be greater than zero")
    val amount: Double
)
