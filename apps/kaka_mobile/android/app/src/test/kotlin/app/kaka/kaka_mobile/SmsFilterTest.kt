package app.kaka.kaka_mobile

import org.json.JSONObject
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.File

class SmsFilterTest {
    private val fixtures = JSONObject(File("../../../../packages/kaka_sms/test/fixtures/sms_filter.json").readText())

    @Test
    fun realBankSmsAreStored() {
        val a = fixtures.getJSONArray("transactions")
        for (i in 0 until a.length()) assertTrue(a.getString(i), SmsFilter.shouldStore(a.getString(i), knownSender = false))
    }

    @Test
    fun otpAdsAndPersonalAreIgnored() {
        val a = fixtures.getJSONArray("not_transactions")
        for (i in 0 until a.length()) assertFalse(a.getString(i), SmsFilter.shouldStore(a.getString(i), knownSender = true))
    }

    @Test
    fun persianDigitsAndSenderForms() {
        assertTrue(SmsFilter.shouldStore("بانک ملی\nبرداشت:۲۵۰,۰۰۰-\nمانده:۱,۰۰۰,۰۰۰", knownSender = false))
        assertTrue(SmsFilter.sender("+98 700-717") == SmsFilter.sender("98700717"))
    }
}
