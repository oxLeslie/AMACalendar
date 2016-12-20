//
//  calendar+Bundle.swift
//  AMACDemo
//
//  Created by Ama.Qiu on 20/12/2016.
//  Copyright © 2016 Ama.Qiu. All rights reserved.
//

import UIKit

class calendarBundle: Bundle {
    static fileprivate let bundel = Bundle(path: Bundle(for: calendarView.self).path(forResource: "AMACalendar", ofType: "bundle")!)
    
    class func previousImage() -> UIImage {
        return UIImage(contentsOfFile: bundel!.path(forResource: "prev", ofType: "png")!)!.withRenderingMode(.alwaysTemplate)
    }
    
    class func nextImage() -> UIImage {
        return UIImage(contentsOfFile: bundel!.path(forResource: "next", ofType: "png")!)!.withRenderingMode(.alwaysTemplate)
    }
    
    class func localizedStr(fotKey key: String) -> String {
        return localizedString(forKey: key, value: nil)
    }
    
    class func localizedString(forKey key: String, value: String?) -> String {
        var value = value
        var language = NSLocale.preferredLanguages.first
        
        if language!.hasPrefix("zh") && language!.contains("Hans") {
            language = "zh-Hans"
        } else {
            language = "en"
        }
        
        let tmpBundle = Bundle(path: bundel!.path(forResource: language, ofType: "lproj")!)
        value = tmpBundle?.localizedString(forKey: key, value: value, table: nil)
        
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
