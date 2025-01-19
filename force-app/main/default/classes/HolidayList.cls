/**
 * 休日(Holiday) のファーストクラスコレクション
 * 
 * Holiday | Object Reference for the Salesforce Platform | Salesforce Developers
 * https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_holiday.htm
 */
public class HolidayList {

    /** 日数の算出の基準は 1970年1月1日(木)とする */
    private static final Date START_DATE = Date.newInstance(1970, 1, 1);
    /** salesforce に設定されている想定の休日リスト */
    private List<Holiday> holidayList;
    
    /** 指定した休日リストを保持したインスタンスを返す */
    public HolidayList(List<Holiday> holidayList) {
        this.holidayList = holidayList;
    }
    
    /**
     * 指定した日付が休日かどうかを判定します。クラス内部の休日コレクションに1つでも条件を満たしていれば休日とする。
     * @param judgeDate 判定する日付
     * @return 休日であれば true を返します。そうでないなら false を返します。
     */
    public Boolean isHoliday(Date judgeDate) {
        if (judgeDate == null) {
            NullPointerException ex = new NullPointerException();
            ex.setMessage('judgeDate is null.');
            throw ex;
        }

        for (Holiday holiday : this.holidayList) {
            if (holiday.IsRecurrence) {
                if (isHolidayRecurrence(holiday, judgeDate)) {
                    return true;
                }
            } else {
                if (holiday.ActivityDate == judgeDate) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    /**
     * 判定する日付が繰り返し前提の休日レコードの条件を満たす(休日である)かどうかを返します。
     * 判定する日付が休日レコードの日付の範囲外の場合は、休日ではないとします。
     * @param holiday 休日レコード(IsRecurrence が trueであることが前提)
     * @param judgeDate 判定する日付
     * @return 判定する日付が休日レコードの条件を満たす（休日である）ならば true を返します。そうでないなら false を返します。
     */
    private Boolean isHolidayRecurrence(Holiday holiday, Date judgeDate) {
        if (!isBetween(judgeDate, holiday.RecurrenceStartDate, holiday.RecurrenceEndDateOnly)) {
            return false;
        }
        
        switch on holiday.RecurrenceType {
            // 頻度：毎日 - 平日(月曜から金曜までのエイリアス設定が画面に存在する)
            when 'RecursEveryWeekday' {
                return isHolidayEveryWeekday(holiday, judgeDate);
            }
            // 頻度：毎日 - X日ごと
            when 'RecursDaily' {
                return isHolidayDaily(holiday, judgeDate);
            }
            // 頻度：毎週 - X週ごと - X曜日(複数可)
            when 'RecursWeekly' {
                return isHolidayWeekly(holiday, judgeDate);
            }
            // 頻度：毎月 - Xか月ごと - Y日
            when 'RecursMonthly' {
                return isHolidayMonthly(holiday, judgeDate);
            }
            // 頻度：毎月 - Xか月ごと - 第Y週 - Z曜日
            when 'RecursMonthlyNth' {
                return isHolidayMonthlyNth(holiday, judgeDate);
            }
            // 頻度：毎年 - X月 - Y日
            when 'RecursYearly' {
                return isHolidayYearly(holiday, judgeDate);
            }
            // 頻度：毎年 - X月 - 第Y週 - Z曜日(単一のみ)
            when 'RecursYearlyNth' {
                return isHolidayYearlyNth(holiday, judgeDate);
            }
            when else {
                throw new IllegalArgumentException('変数:RecurrenceType が想定していない値です。値:' + holiday.RecurrenceType);
            }
        }
    }

    // 頻度：毎日 - 平日 の場合
    private Boolean isHolidayEveryWeekday(Holiday holiday, Date judgeDate) {
        DayOfWeek dayOfWeek = getDayOfWeek(judgeDate);
        Set<DayOfWeek> weekdayDayOfWeekSet = getDayOfWeekSet(holiday.RecurrenceDayOfWeekMask);
        
        return weekdayDayOfWeekSet.contains(dayOfWeek);
    }
    
    // 頻度：毎日 - X日ごと の場合
    private Boolean isHolidayDaily(Holiday holiday, Date judgeDate) {
        Date workDate = holiday.RecurrenceStartDate;
        Date endDate = endDate(holiday, judgeDate);

        while (workDate <= endDate) {
            if (judgeDate == workDate) {
                return true;
            }
            workDate = workDate.addDays(holiday.RecurrenceInterval);
        }
        return false;
    }
    
    // 頻度：毎週 - X週ごと - X曜日(複数可) の場合
    private Boolean isHolidayWeekly(Holiday holiday, Date judgeDate) {
        DayOfWeek dayOfWeek = getDayOfWeek(judgeDate);
        Set<DayOfWeek> weekdayDayOfWeekSet = getDayOfWeekSet(holiday.RecurrenceDayOfWeekMask);

        if (!weekdayDayOfWeekSet.contains(dayOfWeek)) {
            return false; // 曜日が合致しない
        }
        
        // 走査の初期値は RecurrenceStartDate 以降で judgeDate と同じ曜日を持つ日付
        Date workDate = holiday.RecurrenceStartDate;
        while (getDayOfWeek(workDate) != dayOfWeek) {
            workDate = workDate.addDays(1);
        }
        Date endDate = endDate(holiday, judgeDate);
        while (workDate <= endDate) {
            if (judgeDate == workDate) {
                return true;
            }
            workDate = workDate.addDays(holiday.RecurrenceInterval * 7);
        }
        return false;
    }
    
    // 頻度：毎月 - Xか月ごと - Y日 の場合
    private Boolean isHolidayMonthly(Holiday holiday, Date judgeDate) {
        // 初期値は開始日から最初の休日
        Date workDate = holiday.RecurrenceStartDate;
        if (workDate.day() > holiday.RecurrenceDayOfMonth) {
            workDate = workDate.addMonths(1);
        }
        workDate = Date.newInstance(workDate.year(), workDate.month(), holiday.RecurrenceDayOfMonth);
        
        Date endDate = endDate(holiday, judgeDate);
        while (workDate <= endDate) {
            if (judgeDate == workDate) {
                return true;
            }
            workDate = workDate.addMonths(holiday.RecurrenceInterval);
        }
        return false;
    }
    
    // 頻度：毎月 - Xか月ごと - 第Y週 - Z曜日 の場合
    private Boolean isHolidayMonthlyNth(Holiday holiday, Date judgeDate) {
        DayOfWeek dayOfWeek = getDayOfWeek(judgeDate);
        Set<DayOfWeek> weekdayDayOfWeekSet = getDayOfWeekSet(holiday.RecurrenceDayOfWeekMask);

        // 曜日の条件を満たすかどうか
        if (!weekdayDayOfWeekSet.contains(dayOfWeek)) {
            return false;
        }
        // 何週目の条件を満たすかどうか
        if (!isWeekRecurrenceInstance(judgeDate, holiday.RecurrenceInstance)) {
            return false;
        }
        
        // 初期値は開始日から judgeDate と曜日が同じで、月からの週目も同じ。
        Date workDate = holiday.RecurrenceStartDate;
        while (getDayOfWeek(workDate) != dayOfWeek) {
            workDate = workDate.addDays(1);
        }
        while (!isWeekRecurrenceInstance(workDate, holiday.RecurrenceInstance)) {
            workDate = workDate.addDays(7);
        }
        
        // 曜日、何週目はチェック済みなので、残るは年月さえ合えば良い
        Date endDate = endDate(holiday, judgeDate);
        while (workDate <= endDate) {
            if (workDate.year() == judgeDate.year() && workDate.month() == judgeDate.month()) {
                return true;
            }
            workDate = Date.newInstance(workDate.year(), workDate.month(), 1); // 日にちは1 にすることで、年月のインターバルを確実に加算されるようにする
            workDate = workDate.addMonths(holiday.RecurrenceInterval);
        }
        return false;
    }
    
    // 頻度：毎年 - X月 - Y日 の場合
    // 毎週や毎月と異なり年のインターバルは1年固定なので、月の値と日の値が一致していれば良い
    private Boolean isHolidayYearly(Holiday holiday, Date judgeDate) {
        Integer recurrenceMonth = getMonth(holiday.RecurrenceMonthOfYear);
        return judgeDate.day() == holiday.RecurrenceDayOfMonth && judgeDate.month() == recurrenceMonth;
    }
    
    // 頻度：毎年 - X月 - 第Y週 - Z曜日(単一のみ) の場合
    // 毎週や毎月と異なり年のインターバルは1年固定なので、曜日と第何週と月の値が一致していれば良い
    private Boolean isHolidayYearlyNth(Holiday holiday, Date judgeDate) {
        Set<DayOfWeek> weekdayDayOfWeekSet = getDayOfWeekSet(holiday.RecurrenceDayOfWeekMask);
        DayOfWeek dayOfWeek = getDayOfWeek(judgeDate);

        // 曜日の条件を満たすかどうか
        if (!weekdayDayOfWeekSet.contains(dayOfWeek)) {
            return false;
        }
        // 何週目の条件を満たすかどうか
        if (!isWeekRecurrenceInstance(judgeDate, holiday.RecurrenceInstance)) {
            return false;
        }
        // 曜日、何週目はチェック済みなので、残るは月さえ合えば良い
        Integer recurrenceMonth = getMonth(holiday.RecurrenceMonthOfYear);
        return judgeDate.month() == recurrenceMonth;
    }
    
    // 指定した日付の曜日を返します。
    // 1970/1/1 以前は指定されない想定です。
    private DayOfWeek getDayOfWeek(Date workDate) {
        Integer days = getDays(workDate);
        switch on Math.mod(days, 7) {
            when 0 {
                return DayOfWeek.THURSDAY;
            }
            when 1 {
                return DayOfWeek.FRIDAY;
            }
            when 2 {
                return DayOfWeek.SATURDAY;
            }
            when 3 {
                return DayOfWeek.SUNDAY;
            }
            when 4 {
                return DayOfWeek.MONDAY;
            }
            when 5 {
                return DayOfWeek.TUESDAY;
            }
            when else {
                return DayOfWeek.WEDNESDAY;
            }
        }
    }
    
    // 基準日(START_DATE)からの日数を返します。
    private Integer getDays(Date workDate) {
        return START_DATE.daysBetween(workDate);
    }
    
    // Holidayオブジェクトの RecurrenceDayOfWeekMask の値から曜日情報を取り出します。
    // 独自クラス DayOfWeek に変換しています。
    private Set<DayOfWeek> getDayOfWeekSet(Integer recurrenceDayOfWeekMask) {
        Set<DayOfWeek> dayOfWeekSet = new Set<DayOfWeek>();
        
        List<Integer> bits = new List<Integer>{ 64, 32, 16, 8, 4, 2, 1 };
        for (Integer bit : bits) {
            if (recurrenceDayOfWeekMask >= bit) {
                dayOfWeekSet.add(getDayOfWeek(bit));
                recurrenceDayOfWeekMask = recurrenceDayOfWeekMask - bit;
            }
        }
        return dayOfWeekSet;
    }
    
    // Holidayオブジェクトの RecurrenceDayOfWeekMask の定義されているビットマスク値(1,2,4,8,16,32,64)から単一の曜日を取り出します。
    private DayOfWeek getDayOfWeek(Integer bitMask) {
        switch on bitMask {
            when 1 {
                return DayOfWeek.SUNDAY;
            }
            when 2 {
                return DayOfWeek.MONDAY;
            }
            when 4 {
                return DayOfWeek.TUESDAY;
            }
            when 8 {
                return DayOfWeek.WEDNESDAY;
            }
            when 16 {
                return DayOfWeek.THURSDAY;
            }
            when 32 {
                return DayOfWeek.FRIDAY;
            }
            when else { // 64しかないので
                return DayOfWeek.SATURDAY;
            }
        }
    }
    
    // 選択肢 : RecurrenceMonthOfYear の文字列表現から数値に変換する
    private Integer getMonth(String recurrenceMonthOfYear) {
        switch on recurrenceMonthOfYear {
            when 'January' {
                return 1;
            }
            when 'February' {
                return 2;
            }
            when 'March' {
                return 3;
            }
            when 'April' {
                return 4;
            }
            when 'May' {
                return 5;
            }
            when 'June' {
                return 6;
            }
            when 'July' {
                return 7;
            }
            when 'August' {
                return 8;
            }
            when 'September' {
                return 9;
            }
            when 'October' {
                return 10;
            }
            when 'November' {
                return 11;
            }
            when 'December' {
                return 12;
            }
            when else {
                throw new IllegalArgumentException('変数:recurrenceMonthOfYear が想定していない値です。値:' + recurrenceMonthOfYear);
            }
        }
    }
    
    // judgeDate が startDate から endDate の間に含まれているか？
    // startDate は salesforce の Holidayオブジェクトの仕様から null は想定していない。
    private Boolean isBetween(Date judgeDate, Date startDate, Date endDate) {
        if (judgeDate < startDate) {
            return false;
        }
        if (endDate != null && judgeDate > endDate) {
            return false;
        }
        return true;
    }

    // 休日レコードから繰り返しの終了日を返す。null の場合は defaultDate を返す。
    private Date endDate(Holiday holiday, Date defaultDate) {
        return holiday.RecurrenceEndDateOnly != null ? holiday.RecurrenceEndDateOnly : defaultDate;
    } 
    
    // 指定された日付の日が選択肢 : RecurrenceInstance の条件を満たすか？
    private Boolean isWeekRecurrenceInstance(Date judgeDate, String recurrenceInstance) {
        Integer day = judgeDate.day();
        switch on recurrenceInstance {
            when 'First' {
                return (1 <= day && day <= 7) ? true : false;
            }
            when 'Second' {
                return (8 <= day && day <= 14) ? true : false;
            }
            when 'Third' {
                return (15 <= day && day <= 21) ? true : false;
            }
            when 'Fourth' {
                return (22 <= day && day <= 28) ? true : false;
            }
            when 'Last' {
                // 月末日から7日以内であれば最終週と判定する
                Integer numberDays = Date.daysInMonth(judgeDate.year(), judgeDate.month());
                return (numberDays - day < 7) ? true : false;
            }
            when else {
                throw new IllegalArgumentException('変数:recurrenceInstance が想定していない値です。値:' + recurrenceInstance);
            }
        }
    }
}