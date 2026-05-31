package finup.com.project.user.repositories

import finup.com.project.user.models.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface UserRepository : JpaRepository<User, Int> {
    fun findUserByUsername(username: String): Optional<User>
    fun findUserById(id: Int): Optional<User>
}