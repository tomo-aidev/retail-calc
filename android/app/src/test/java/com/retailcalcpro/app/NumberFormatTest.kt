package com.retailcalcpro.app

import com.retailcalcpro.app.util.NumberFormatUtil
import org.junit.Assert.*
import org.junit.Test

/**
 * 数値フォーマットテスト
 */
class NumberFormatTest {

    @Test
    fun `円フォーマット_1000`() {
        assertEquals("¥1,000", NumberFormatUtil.yenFormatted(1000))
    }

    @Test
    fun `円フォーマット_0`() {
        assertEquals("¥0", NumberFormatUtil.yenFormatted(0))
    }

    @Test
    fun `円フォーマット_999999`() {
        assertEquals("¥999,999", NumberFormatUtil.yenFormatted(999999))
    }

    @Test
    fun `カンマフォーマット_1234567`() {
        assertEquals("1,234,567", NumberFormatUtil.commaFormatted(1234567))
    }

    @Test
    fun `円フォーマット_1`() {
        assertEquals("¥1", NumberFormatUtil.yenFormatted(1))
    }
}
