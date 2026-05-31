package finup.com.project.user.models

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.LocalDateTime
import java.time.OffsetDateTime

@Entity
@Table
class User (

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id : Int? = null,

    @Column
    var fullName : String,

    @Column
    var username: String,

    @Column
    var password : String,

    @Column(columnDefinition = "timestamp default current_timestamp")
    var createdAt : LocalDateTime = LocalDateTime.now(),

    @Column(columnDefinition = "timestamp default current_timestamp")
    var updateAt : LocalDateTime = LocalDateTime.now()

)