//
//  utils.swift
//  AMACalendar
//
//  Created by Ama on 08/12/2016.
//  Copyright © 2016 Ama. All rights reserved.
//
/***************************************************天干地支************************************************************
 
 //天干地支 天干：年的最末一位 地支： 年 % 12 如2016 天干：6，地支：2016 % 12 = 0 丙 申猴 年
 //0 1 2 3 4 5 6 7 8 9
 static let tianGan: [String] = ["庚", "辛", "壬", "癸", "甲", "乙", "丙", "丁", "戊", "己"]
 
 //0 1 2 3 4 5 6 7 8 9 10 11 申猴、酉鸡、戌狗、亥猪、子鼠、丑牛、寅虎、卯兔、辰龙、巳蛇、午马、未羊
 static let diZhi: [String] = ["申猴", "酉鸡", "戌狗", "亥猪", "子鼠", "丑牛", "寅虎", "卯兔", "辰龙", "巳蛇", "午马", "未羊"]
 
 ***************************************************天干地支************************************************************/

import UIKit

class utils: NSObject {

    // 阳历 singleton
    static fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    // 阴历 singleton
    static fileprivate let chinese: Calendar = Calendar(identifier: .chinese)
    
    // 星期
    static fileprivate let weeks: [String] = ["Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"]
    
    // 中国日历 日
    static fileprivate let chineseDays: [String] =
        ["初一", "初二", "初三", "初四", "初五", "初六",
         "初七", "初八", "初九", "初十", "十一", "十二",
         "十三", "十四", "十五", "十六", "十七", "十八",
         "十九", "廿十", "廿一", "廿二", "廿三", "廿四",
         "廿五", "廿六", "廿七", "廿八", "廿九", "三十",]
    
    // 中国日历 月
    static fileprivate let chineseMonths: [String] =
        ["正月", "二月", "三月", "四月", "五月", "六月",
         "七月", "八月", "九月", "十月", "冬月", "腊月"]
    
    static fileprivate let tGdZ: [Int: String] =
        [1: "甲子鼠年", 11: "甲戌狗年", 21: "甲申猴年", 31: "甲午马年", 41: "甲辰龙年", 51: "甲寅虎年",
         2: "乙丑牛年", 12: "乙亥猪年", 22: "乙酉鸡年", 32: "乙未羊年", 42: "乙巳蛇年", 52: "乙卯兔年",
         3: "丙寅虎年", 13: "丙子鼠年", 23: "丙戌狗年", 33: "丙申猴年", 43: "丙午马年", 53: "丙辰龙年",
         4: "丁卯兔年", 14: "丁丑牛年", 24: "丁亥猪年", 34: "丁酉鸡年", 44: "丁未羊年", 54: "丁巳蛇年",
         5: "戊辰龙年", 15: "戊寅虎年", 25: "戊子鼠年", 35: "戊戌狗年", 45: "戊申猴年", 55: "戊午马年",
         6: "己巳蛇年", 16: "己卯兔年", 26: "己丑牛年", 36: "己亥猪年", 46: "己酉鸡年", 56: "己未羊年",
         7: "庚午牛年", 17: "庚辰龙年", 27: "庚寅虎年", 37: "庚子鼠年", 47: "庚戌狗年", 57: "庚申猴年",
         8: "辛未羊年", 18: "辛巳蛇年", 28: "辛卯兔年", 38: "辛丑牛年", 48: "辛亥猪年", 58: "辛酉鸡年",
         9: "壬申猴年", 19: "壬午马年", 29: "壬辰龙年", 39: "壬寅虎年", 49: "壬子鼠年", 59: "壬戌狗年",
        10: "癸酉鸡年", 20: "癸未羊年", 30: "癸巳蛇年", 40: "癸卯兔年", 50: "癸丑牛年", 60: "癸亥猪年",]
    
    // 获取 年月
    class func date(month: Int, year: Int) -> Date? {
        return date(month: month, day: 1, year: year)
    }
    
    // 获取 年月日
    class func date(month: Int, day: Int, year: Int) -> Date? {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        
        return date(components: comps)
    }
    
    // 通过 component 获取 Date
    class func date(components: DateComponents) -> Date? {
        return gregorian.date(from: components)
    }
    
    // 通过 chinese component 获取 Date
    class func date(forChineseComps comps: DateComponents) -> String {
        let cComps = date(convertToCComps: comps.month!, day: comps.day!, year: comps.year!)
        
        return "\(date(convertToCYearStr: cComps.year!))\(date(convertToCMonthStr: cComps.month!))\(date(convertToCDayStr: cComps.day!))"
    }
    
    // 获取 月的天数
    class func day(inMonth: Int, inYear: Int) -> Int? {
        
        guard let date = date(month: inMonth, year: inYear) else {
            return nil
        }
        
        return gregorian.range(of: .day, in: .month, for: date)?.count
    }
    
    // 获取 月所属的周
    class func firstWeekday(inMonth: Int, inYear: Int) -> Int? {
        
        guard let date = date(month: inMonth, year: inYear) else {
            return nil
        }
        
        return gregorian.component(.weekday, from: date)
    }
    
    // 获取 礼拜
    class func stringOfWeekday(weekday: Int) -> String? {
        assert(weekday >= 1 && weekday <= 7, "Invalid weekday: \(weekday)")
        return calendarBundle.localizedStr(fotKey: weeks[weekday - 1])
    }
    
    // 通过Date 获取 component
    class func date(fromDate date: Date) -> DateComponents {
        let comps: Set<Calendar.Component> = [.year, .month, .day]
        return gregorian.dateComponents( comps, from: date)
    }
    
    // change Chinese date
    class func date(convertToCComps month: Int, day: Int, year: Int) -> DateComponents {
        let comps: Set<Calendar.Component> = [.year, .month, .day]
        let date = self.date(month: month, day: day, year: year)!
        
        return chinese.dateComponents( comps, from: date)
    }
    
    // 获取 Chinese year
    class func date(convertToCYearStr year: Int) -> String {
        guard let cYear = tGdZ[year] else {
            fatalError("invalid year \(year)")
        }
        return cYear
    }
    
    // 获取 Chinese month
    class func date(convertToCMonthStr month: Int) -> String {
        return chineseMonths[month - 1]
    }
    
    // 获取 Chinese day
    class func date(convertToCDayStr day: Int) -> String {
        return chineseDays[day - 1]
    }
    
    // Date 是否是今天
    class func isDateToday(components: DateComponents) -> Bool {
        let todayComps = date(fromDate: Date(timeIntervalSinceNow: 0))
        
        return (todayComps.year == components.year) &&
                (todayComps.month == components.month) &&
                (todayComps.day == components.day)
    }
}
