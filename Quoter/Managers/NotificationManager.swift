//
//  NotificationsManager.swift
//  Quoter
//
//  Created by Lado Tsivtsivadze on 8/28/22.
//

import Foundation
import UserNotifications
import UIKit

//MARK: USA Working hours
// The traditional American business hours are 9:00 a.m. to 5:00 p.m., Monday to Friday, representing a workweek of five eight-hour days comprising 40 hours in total.

//MARK: UK Working hours
// A work day in the United Kingdom closely mirrors one in the US. In the UK, the day begins at 8:50 a.m. — 20 minutes after the US work day begins — and ends at 5 p.m., which is 30 minutes earlier than in the US.

//MARK: Canada Working hours
// The standard working hours in Canada are Monday to Friday, between 8:00 a.m. or 8:30 a.m. and 5 p.m., for a total of 37.5 – 40 hours per week (7.5 or 8 hours per day).

//MARK: Ireland Working hours
// Usually 8 hours a day, 39 hours a week. Typically those hours are stipulated, Monday to Friday from 9:00 am to 5:30 pm

enum PermissionStatus {
    case on
    case off
}

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func getPermissionStatus(completion: @escaping (PermissionStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    completion(.on)
                }
                else {
                    completion(.off)
                }
            }
        }
    }
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
            completion(granted)
        }
    }
    
    func getActiveNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            DispatchQueue.main.async {
                completion(notificationRequests)
            }
        }
    }
    
    func deleteActiveNotification(using id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        let soundName = UNNotificationSoundName(rawValue: "new")
        let sound = UNNotificationSound(named: soundName)
        content.title = "Quotie"
        content.body = "Body"
        content.categoryIdentifier = "OrganizerPlusCategory"
        content.sound = sound
        
        #error("when i return, before setting local notification timings, use user location and timing and research your market's best timing to show notification")
                
        #error("or save the time user used the app and show local notifications for that time")
            
        var trigger: UNNotificationTrigger?
        let secondsInterval = TimeInterval(CGFloat(hour * 60 + minute) * 60)
        guard let date2 = dryDay.date else { return }
        let targetDayDate = Calendar.current.date(byAdding: .day, value: -days, to: date2)!
        let finalDate2 = targetDayDate.addingTimeInterval(secondsInterval)
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: finalDate2)
        
        if Date() == dryDay.date {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
        }
        else {
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            content.userInfo["date"] = finalDate2.description(with: Locale(identifier: "en_US_POSIX"))
        }
        
        if let trigger = trigger {
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
}
