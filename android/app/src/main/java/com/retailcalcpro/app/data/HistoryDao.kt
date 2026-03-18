package com.retailcalcpro.app.data

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface HistoryDao {
    @Query("SELECT * FROM calculation_history ORDER BY createdAt DESC")
    fun getAllHistory(): Flow<List<CalculationHistory>>

    @Insert
    suspend fun insert(history: CalculationHistory)

    @Delete
    suspend fun delete(history: CalculationHistory)

    @Query("DELETE FROM calculation_history")
    suspend fun deleteAll()
}
