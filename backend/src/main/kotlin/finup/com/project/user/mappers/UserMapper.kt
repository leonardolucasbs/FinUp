package finup.com.project.user.mappers

import finup.com.project.user.dto.UserCreateDTO
import finup.com.project.user.models.User
import org.springframework.stereotype.Component

@Component
class UserMapper {
    fun toEntity(dto: UserCreateDTO): User {
        return User(
            fullName = dto.fullName,
            username = dto.username,
            password = dto.password
        )
    }
}