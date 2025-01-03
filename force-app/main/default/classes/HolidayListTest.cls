@isTest
private class HolidayListTest {
    // テストケース
    // 繰り返しではない休日
    @isTest
    static void testNotRecurrence() {
        List<Holiday> l = new List<Holiday>();
        Holiday holiday = new Holiday(
            Name = '2024年4月29日',
            IsAllDay = true,
            IsRecurrence = false,
            ActivityDate = Date.newInstance(2024, 4, 29)
        );
        l.add(holiday);
        HolidayList holidayList = new HolidayList(l);
        
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 4, 29)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 30)));
    }
    
    // テストケース
    // 頻度：毎日
    // 毎日 X日ごと
    @isTest
    static void testRecursDaily() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 毎日3日ごと',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursDaily',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = Date.newInstance(2024, 7, 31),
                RecurrenceInterval = 3
            )
                };
                    HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 28))); // 休日だが有効範囲外
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 1)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 3)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 4)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 5)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 7, 30))); // 最後の休日
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 8, 2))); // 休日だが有効範囲外
    }
    
    // テストケース
    // 頻度：毎日
    // 毎日 平日
    @isTest
    static void testRecursEveryWeekday() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 平日',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursEveryWeekday',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = null,
                RecurrenceDayOfWeekMask = 62
            )
                };
                    HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 4, 28))); // 休日だが有効範囲外
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 1)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 3)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 4))); // 土曜なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 5))); // 日曜なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 6)));
    }
    
    // テストケース
    // 頻度：毎週
    // 毎週　X週ごと　X曜日(複数可)
    @isTest
    static void testRecursWeekly() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 隔週土日',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursWeekly',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = null,
                RecurrenceDayOfWeekMask = 65,
                RecurrenceInterval = 2
            )
                };
                    HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
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
    // 頻度：毎月
    // 毎月　Xヶ月ごと　Y日
    @isTest
    static void testRecursMonthly() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 2ヶ月毎 12日',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursMonthly',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = null,
                RecurrenceDayOfMonth = 12,
                RecurrenceInterval = 2
            )
                };
                    HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 3, 12))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 11)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 5, 12))); // 初回なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 5, 13)));
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 6, 12))); // 1ヶ月後なので
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 7, 12))); // 2ヶ月後なので
    }
    
    // テストケース
    // 頻度：毎月
    // 毎月　Xヶ月ごと　第Y週　Z曜日
    @isTest
    static void testRecursMonthlyNth() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 毎月第１週月曜',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursMonthlyNth',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = null,
                RecurrenceDayOfWeekMask = 2,
                RecurrenceInstance = 'First',
                RecurrenceInterval = 1
            ),
                new Holiday(
                    Name = '2024年5月1日 毎月最終週木曜',
                    IsAllDay = true,
                    IsRecurrence = true,
                    RecurrenceType = 'RecursMonthlyNth',
                    ActivityDate = Date.newInstance(2024, 5, 1),
                    RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                    RecurrenceEndDateOnly = null,
                    RecurrenceDayOfWeekMask = 16,
                    RecurrenceInstance = 'Last',
                    RecurrenceInterval = 1
                )
                };
                    HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
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
    // 頻度：毎年
    // 毎年　X月Y日
    @isTest
    static void testRecursYearly() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 毎年7月13日',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursYearly',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = null,
                RecurrenceDayOfMonth = 13,
                RecurrenceMonthOfYear = 'July'
            )};
                HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2023, 7, 13))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 7, 12)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 7, 13))); // 初回なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 7, 14)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2025, 7, 13))); // 1年後なので
    }
    
    // テストケース
    // 頻度：毎年
    // 毎年　X月　第Y週　Z曜日
    @isTest
    static void testRecursYearlyNth() {
        List<Holiday> l = new List<Holiday>{
            new Holiday(
                Name = '2024年5月1日 毎年10月第２月曜日',
                IsAllDay = true,
                IsRecurrence = true,
                RecurrenceType = 'RecursYearlyNth',
                ActivityDate = Date.newInstance(2024, 5, 1),
                RecurrenceStartDate = Date.newInstance(2024, 5, 1),
                RecurrenceEndDateOnly = null,
                RecurrenceDayOfWeekMask = 2,
                RecurrenceInstance = 'Second',
                RecurrenceMonthOfYear = 'October'
            )
                };
                    
                    HolidayList holidayList = new HolidayList(l);
        System.debug(holidayList);
        
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2023, 10, 9))); // 休日だが有効範囲外
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 10, 13)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2024, 10, 14))); // 初回なので
        Assert.isFalse(holidayList.isHoliday(Date.newInstance(2024, 10, 15)));
        Assert.isTrue(holidayList.isHoliday(Date.newInstance(2025, 10, 13))); // 1年後なので
    }
}