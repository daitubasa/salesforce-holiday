# salesforce-holiday
salesforce の休日オブジェクト(Holiday)を利用して休日判定する。

## 使い方

``` 
// 組織から休日情報を取得して、HolidayListクラスのインスタンスを作成します。
// salesforce の設定画面から休日情報を任意に登録できます。
// developer edition の場合、毎週土曜日、日曜日がデフォルトで休日登録されています。
List<Holiday> l = [
    SELECT Id, Name, Description, ActivityDate, IsRecurrence, 
    	   RecurrenceType, RecurrenceStartDate, RecurrenceEndDateOnly, RecurrenceDayOfMonth, 
     	   RecurrenceDayOfWeekMask, RecurrenceInstance, RecurrenceInterval, RecurrenceMonthOfYear 
      FROM Holiday];
HolidayList holidayList = new HolidayList(l);

// 専用のメソッドを呼び出して判定する
System.debug(holidayList.isHoliday(Date.newInstance(2025, 1, 4)));  //土曜日なので
Assert.isTrue(holidayList.isHoliday(Date.newInstance(2025, 1, 5)));  //日曜日なので
Assert.isFalse(holidayList.isHoliday(Date.newInstance(2025, 1, 6))); //月曜日なので
```

## 制限事項

* 終日のチェックが入っていることが前提で、時間のチェックはしていません。(本当はしたいが・・・)
* テストコードも用意されていますが不完全です。  
カバレッジ率：87% 171/195
