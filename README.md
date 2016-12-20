# AMACalendar
## This is a Chinese Calendar.
_The project `AMACalendar` is customized for `Bmemo` and it borrows [daysquare](https://github.com/unixzii/Daysquare). Because `Bmemo` reason, i added the support of the lunar calendar._

## Usage

```
let calendar = calendarView(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width - 20, height: 280))
        calendar.addTarget(self, action: #selector(calendarChange), for: .valueChanged)
        view.addSubview(calendar)
```
```
@objc fileprivate func calendarChange(view: calendarView) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        print(formatter.string(from: (view.selectedDate?.0)!), view.selectedDate!.1)
    }
```
# Installation
## Cocoapods

```
pod 'AMACalendar', ~> 0.0.1
```
