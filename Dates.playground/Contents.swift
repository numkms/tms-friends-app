import UIKit

let date = Date.now
let hourInterval: TimeInterval = 60 * 60
let dayInterval: TimeInterval = hourInterval * 24
let afterHour = Date.now.addingTimeInterval(hourInterval)
let beforeHour = Date.now.addingTimeInterval(-hourInterval)
let weekBefore = Date.now.addingTimeInterval(-dayInterval * 7)
let twoWeekBefore = weekBefore.addingTimeInterval(-dayInterval * 7)
let twoWeekBeforeButOneMinute = twoWeekBefore.addingTimeInterval(60)
let customDate = Date(timeIntervalSince1970: 0)
if date < afterHour {
    print("Меньше")
} else {
    print("Больше")
}

var dateComponents = DateComponents()
dateComponents.day = 1
dateComponents.month = 1
dateComponents.minute = 10
let modifiedDate = Calendar.current.date(byAdding: dateComponents, to: customDate)

let formatter = DateFormatter()
formatter.dateFormat = "dd/MMM/yyyy HH:mm"
formatter.string(from: weekBefore)

let stringDate = "21/Sep/2020 23:06"
let stringDate2 = "22/Aug/2024 20:06"
let somestring = "22/Aud/2024 20:00"

let date1 = formatter.date(from: stringDate)
let date2 = formatter.date(from: stringDate2)
let date3 = formatter.date(from: somestring)

if let date1, let date2, date1 < date2 {
    print("\(date1) меньше чем \(date2)")
} else if let date1, let date2 {
    print("\(date1) больше чем \(date2)")
}
formatter.locale = .init(identifier: "ru-RU")

formatter.dateFormat = "dd/MMM/yyyy HH:mm"
print(formatter.string(from: weekBefore))
formatter.dateFormat = "dd-MMM-yyyy HH"
print(formatter.string(from: weekBefore))
formatter.dateFormat = "MMM-yyyy HH"
print(formatter.string(from: weekBefore))
formatter.dateFormat = "EEEE, MMMM d, h:mm a"
print(formatter.string(from: weekBefore))
formatter.dateFormat = "EEE, MMM d, h:mm a"
print(formatter.string(from: weekBefore))
formatter.dateFormat = "EEEE, MMM d, h:mm a"
print(formatter.string(from: weekBefore))
formatter.dateFormat = "dd MMMM, yyyy"
print(formatter.string(from: weekBefore))

formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
print(formatter.string(from: weekBefore))
let newFormatter = DateFormatter()
newFormatter.dateStyle = .long
print(newFormatter.string(from: weekBefore))
newFormatter.dateStyle = .short
print(newFormatter.string(from: weekBefore))
newFormatter.dateStyle = .full
print(newFormatter.string(from: weekBefore))
newFormatter.dateStyle = .medium
print(newFormatter.string(from: weekBefore))

