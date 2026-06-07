package finup.com.project.content.repository

import finup.com.project.content.models.Content
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface ContentRepository : JpaRepository<Content, Long>
