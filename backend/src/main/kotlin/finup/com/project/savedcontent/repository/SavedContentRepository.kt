package finup.com.project.savedcontent.repository

import finup.com.project.savedcontent.models.SavedContent
import org.springframework.data.jpa.repository.JpaRepository

interface SavedContentRepository : JpaRepository<SavedContent, Long>
