/**
 * HolidayList のテストクラス
 */
@isTest
private class HolidayListTest {

    @testSetup 
    static void setup() {
        // 既存のレコードは削除しておく
        // 営業時間が紐づいていると紐付けの情報も設定から削除する必要がある。(プログラムで削除できない)
        List<Holiday> oldHolidayList = [SELECT Id, Name, Description, ActivityDate FROM Holiday];
//        for(Holiday h : oldHolidayList) {
//            System.debug(h);
//        }
		delete oldHolidayList;
        
        List<Holiday> holidayList = new List<Holiday>();

        holidayList.add(new Holiday(
            Name = '2024年4月29日',
            IsAllDay = true, IsRecurrence = false,
            ActivityDate = Date.newInstance(2024, 4, 29)
        ));

        holidayList.add(new Holiday(
            Name = '2024年5月1日 平日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursEveryWeekday',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 62
        ));

        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎日3日ごと',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursDaily',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = Date.newInstance(2024, 7, 31),
            RecurrenceInterval = 3
        ));

        holidayList.add(new Holiday(
            Name = '2024年5月1日 隔週土日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursWeekly',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 65,
            RecurrenceInterval = 2
        ));

        holidayList.add(new Holiday(
            Name = '2024年5月1日 2ヶ月毎 12日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursMonthly',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 12,
            RecurrenceInterval = 2
        ));

        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎月第１週月曜',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursMonthlyNth',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'First',
            RecurrenceInterval = 1
        ));
        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎月最終週木曜',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursMonthlyNth',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 16,
            RecurrenceInstance = 'Last',
            RecurrenceInterval = 1
        ));

        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎年1月13日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearly',
            ActivityDate = Date.newInstance(2024, 1, 13),
            RecurrenceStartDate = Date.newInstance(2024, 1, 13),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 13,
            RecurrenceMonthOfYear = 'January'
        ));
        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎年3月13日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearly',
            ActivityDate = Date.newInstance(2024, 3, 1),
            RecurrenceStartDate = Date.newInstance(2024, 3, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 13,
            RecurrenceMonthOfYear = 'March'
        ));
        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎年5月13日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearly',
            ActivityDate = Date.newInstance(2024, 5, 1),
            RecurrenceStartDate = Date.newInstance(2024, 5, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 13,
            RecurrenceMonthOfYear = 'May'
        ));
        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎年7月13日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearly',
            ActivityDate = Date.newInstance(2024, 7, 1),
            RecurrenceStartDate = Date.newInstance(2024, 7, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 13,
            RecurrenceMonthOfYear = 'July'
        ));
        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎年9月13日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearly',
            ActivityDate = Date.newInstance(2024, 9, 1),
            RecurrenceStartDate = Date.newInstance(2024, 9, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 13,
            RecurrenceMonthOfYear = 'September'
        ));
        holidayList.add(new Holiday(
            Name = '2024年5月1日 毎年11月13日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearly',
            ActivityDate = Date.newInstance(2024, 11, 1),
            RecurrenceStartDate = Date.newInstance(2024, 11, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfMonth = 13,
            RecurrenceMonthOfYear = 'November'
        ));

        holidayList.add(new Holiday(
            Name = '2024年2月1日 毎年2月第1月曜日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearlyNth',
            ActivityDate = Date.newInstance(2024, 2, 1),
            RecurrenceStartDate = Date.newInstance(2024, 2, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'First',
            RecurrenceMonthOfYear = 'February'
        ));
        holidayList.add(new Holiday(
            Name = '2024年4月1日 毎年4月第2月曜日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearlyNth',
            ActivityDate = Date.newInstance(2024, 4, 1),
            RecurrenceStartDate = Date.newInstance(2024, 4, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'Second',
            RecurrenceMonthOfYear = 'April'
        ));
        holidayList.add(new Holiday(
            Name = '2024年6月1日 毎年6月第3月曜日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearlyNth',
            ActivityDate = Date.newInstance(2024, 6, 1),
            RecurrenceStartDate = Date.newInstance(2024, 6, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'Third',
            RecurrenceMonthOfYear = 'June'
        ));
        holidayList.add(new Holiday(
            Name = '2024年8月1日 毎年8月第4月曜日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearlyNth',
            ActivityDate = Date.newInstance(2024, 8, 1),
            RecurrenceStartDate = Date.newInstance(2024, 8, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'Fourth',
            RecurrenceMonthOfYear = 'August'
        ));
        holidayList.add(new Holiday(
            Name = '2024年10月1日 毎年10月第2月曜日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearlyNth',
            ActivityDate = Date.newInstance(2024, 10, 1),
            RecurrenceStartDate = Date.newInstance(2024, 10, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'Second',
            RecurrenceMonthOfYear = 'October'
        ));
        holidayList.add(new Holiday(
            Name = '2024年12月1日 毎年12月最終月曜日',
            IsAllDay = true, IsRecurrence = true,
            RecurrenceType = 'RecursYearlyNth',
            ActivityDate = Date.newInstance(2024, 12, 1),
            RecurrenceStartDate = Date.newInstance(2024, 12, 1),
            RecurrenceEndDateOnly = null,
            RecurrenceDayOfWeekMask = 2,
            RecurrenceInstance = 'Last',
            RecurrenceMonthOfYear = 'December'
        ));
        insert holidayList;        
    }

    // テストケース
    // 引数に null
    @isTest
    static void testNull() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
        ];
        HolidayList holidayList = new HolidayList(l);
        
        try {
            holidayList.isHoliday(null);
            Assert.fail('No expected HolidayException.');
        } catch(NullPointerException ex) {
            Assert.areEqual('judgeDate is null.', ex.getMessage());
        }
    }

    // テストケース
    // 繰り返しではない休日
    @isTest
    static void testNotRecurrence() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE IsRecurrence = false
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 4, 29)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 30)));
    }
    
    // テストケース
    // 頻度：毎日 - 平日
    @isTest
    static void testRecursEveryWeekday() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursEveryWeekday'
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 28))); // 休日だが有効範囲外
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 1)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 3)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 4))); // 土曜なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 5))); // 日曜なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 6)));
    }
    
    // テストケース
    // 頻度：毎日 - X日ごと
    @isTest
    static void testRecursDaily() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursDaily'
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 28))); // 休日だが有効範囲外
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 1)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 3)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 4)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 5)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 7, 30))); // 最後の休日
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 8, 2))); // 休日だが有効範囲外
    }

    // テストケース
    // 頻度：毎週 - X週ごと - X曜日(複数可)
    @isTest
    static void testRecursWeekly() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursWeekly'
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 28))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 1)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 3)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 4))); // 初回の土曜なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 5))); // 初回の日曜なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 6)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 11))); // 1週後の土曜なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 12))); // 1週後の日曜なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 18))); // 2週後の土曜なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 19))); // 2週後の日曜なので
    }
    
    // テストケース
    // 頻度：毎月 - Xか月ごと - Y日
    @isTest
    static void testRecursMonthly() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursMonthly'
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 3, 12))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 11)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 12))); // 初回なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 13)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 6, 12))); // 1ヶ月後なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 7, 12))); // 2ヶ月後なので
    }
    
    // テストケース
    // 頻度：毎月 - Xか月ごと - 第Y週 - Z曜日
    @isTest
    static void testRecursMonthlyNth() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursMonthlyNth'
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 1))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 25))); // 休日だが有効範囲外
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 6))); // 初回なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 30))); // 初回なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 2)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 27)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 6, 3))); // 1ヶ月後なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 6, 27))); // 2ヶ月後なので
    }
    
    // テストケース
    // 頻度：毎年 - X月 - Y日
    @isTest
    static void testRecursYearly() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursYearly'
        ];
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2023, 7, 13))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 7, 12)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 7, 13)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 7, 14)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 1, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 3, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 9, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 11, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2025, 7, 13))); // 1年後なので
    }
    
    // テストケース
    // 頻度：毎年 - X月 - 第Y週 - Z曜日(単一のみ)
    @isTest
    static void testRecursYearlyNth() {
        List<Holiday> l = [
            SELECT Id, Name, Description, ActivityDate, IsRecurrence, RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, 
                   RecurrenceDayOfMonth, RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
              FROM Holiday
             WHERE RecurrenceType = 'RecursYearlyNth'
        ];
        HolidayList holidayList = new HolidayList(l);

        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2023, 10, 9))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 10, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 10, 14))); // 初回なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 10, 15)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 2, 5)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 4, 8)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 6, 17)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 8, 26)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 12, 30)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2025, 10, 13))); // 1年後なので
    }
}