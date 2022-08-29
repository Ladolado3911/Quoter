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

enum Weekday: Int, CaseIterable {
    case sun = 1
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
}

struct RepeatingNotificationModel {
    let weekday: Weekday
    let hour: Int
    let minute: Int
    let message: String
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
    
    func scheduleRepeatingNotification(notificationModel: RepeatingNotificationModel) {
        let content = UNMutableNotificationContent()
        //let soundName = UNNotificationSoundName(rawValue: "new")
        //let sound = UNNotificationSound(named: soundName)
        content.title = "Did you know?"
        content.body = notificationModel.message
        content.categoryIdentifier = "OrganizerPlusCategory"
        //content.sound = sound
        
//        #error("when i return, before setting local notification timings, use user location and timing and research your market's best timing to show notification")
//
//        #error("or save the time user used the app and show local notifications for that time")
//
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        

        dateComponents.weekday = notificationModel.weekday.rawValue
        dateComponents.hour = notificationModel.hour    // 14:00 hours
        dateComponents.minute = notificationModel.minute
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
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
    
    func requestAndSetNotificationsIfAccepted() {
        requestAuthorization { [weak self] authorized in
            if authorized {
                let morningHour = 8
                let morningMinute = 0
                let eveningHour = 23
                let eveningMinute = 10

                for weekDay in Weekday.allCases {
                    var morningMessage: String = ""
                    var eveningMessage: String = ""
                    switch weekDay {
                    case .sun:
                        morningMessage =
                        eveningMessage =
                    case .mon:
                        morningMessage = "Your mind is the most effective in the morning. Learn from the richest!"
                        eveningMessage = "Your brain absorbs information like a sponge before sleep. It's time to get inspired!"
                    case .tue:
                        morningMessage =
                        eveningMessage = "Sleep helps you remember "
                    case .wed:
                        morningMessage = ""
                        eveningMessage = "Anything you learn grows you differently. Grow like the rich!"
                    case .thu:
                        morningMessage = "You learn the best when teaching others. Share valuable quotes!"
                        eveningMessage = "Learning that is spread out over time increases knowledge retention. Learn from the richest!"
                    case .fri:
                        morningMessage =
                        eveningMessage = "You retain 65% more information when an image is added to the learning process!"
                    case .sat:
                        morningMessage =
                        eveningMessage = "Your brain prefers images over text. Learn from quotes from the richest people with images in the background!"
                    }
                    let morningModel = RepeatingNotificationModel(weekday: weekDay,
                                                                  hour: morningHour,
                                                                  minute: morningMinute,
                                                                  message: morningMessage)
                    let eveningModel = RepeatingNotificationModel(weekday: weekDay,
                                                                  hour: morningHour,
                                                                  minute: morningMinute,
                                                                  message: eveningMessage)
                    
                    self?.scheduleRepeatingNotification(notificationModel: morningModel)
                    self?.scheduleRepeatingNotification(notificationModel: eveningModel)
                }
            }
        }
    }
}
