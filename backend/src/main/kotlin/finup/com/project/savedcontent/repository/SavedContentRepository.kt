package finup.com.project.savedcontent.repository

import finup.com.project.savedcontent.models.SavedContent
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query

interface SavedContentRepository : JpaRepository<SavedContent, Long> {
    @Query("SELECT COUNT(p) from SavedContent p where p.content.id = :contentId")
    fun numberOfSaved(contentId: Long): Int
    @Query("SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM SavedContent p WHERE p.user.id = :userId AND p.content.id = :contentId")
    fun findIfUserSavedContent(userId: Int, contentId: Long): Boolean
}
