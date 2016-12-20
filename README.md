##### AMACalendar

###### This is a Chinese Calendar.

###### The project `AMACalendar` is for `Bmemo` to write and it refer to the [Daysquare](https://github.com/unixzii/Daysquare). So, the need of `Bmemo`, the support of the lunar calendar.

============
[![CocoaPods](https://img.shields.io/cocoapods/v/AMACalendar.svg)](https://github.com/Ama4Q/AMACalendar)
[![Swift Package Manager](https://rawgit.com/jlyonsmith/artwork/master/SwiftPackageManager/swiftpackagemanager-compatible.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/cocoapods/l/AMACalendar.svg?style=flat)](http://cocoapods.org/pods/AMACalendar)
[![Platform](https://img.shields.io/cocoapods/p/AMACalendar.svg?style=flat)](http://cocoapods.org/pods/AMACalendar)

Requirements

- Xcode 8+
- swift 3.0+
- iOS 9.0+

Usage

```swift
let calendar = calendarView(frame: CGRect(x: 10,
                                          y: 50, 
                                      width: UIScreen.main.bounds.width - 20, 
                                     height: 280))
                                     
calendar.addTarget(self, action: #selector(calendarChange), for: .valueChanged)
view.addSubview(calendar)
```
```swift
@objc fileprivate func calendarChange(view: calendarView) {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    print(formatter.string(from: (view.selectedDate?.0)!), view.selectedDate!.1)
}
```
Installation

- Cocoapods

```ruby
pod 'AMACalendar', ~> 0.0.1
```
