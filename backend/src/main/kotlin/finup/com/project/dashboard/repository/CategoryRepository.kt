package finup.com.project.dashboard.repository

import finup.com.project.dashboard.models.Category
import org.springframework.data.jpa.repository.JpaRepository
import java.util.Optional

interface CategoryRepository : JpaRepository<Category, Long> {
    fun findByIdAndUserId(id: Long, userId: Int): Optional<Category>
    fun findAllByUserId(userId: Int): List<Category>
    fun existsByUserIdAndNameIgnoreCase(userId: Int, name: String): Boolean
}
