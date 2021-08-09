//  notificationCenter.swift
//  pray timer
//  Created by admin on 2021/8/7.

import Foundation
import UserNotifications

class notificationCenter {
    static let intance = notificationCenter()
    
    func requestAutherization() ->Bool {
        let options:UNAuthorizationOptions = [.alert,.sound,.badge]
        var autherized = false
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Faild to get authorization for pushing notifications")
                print("\(error.localizedDescription)")
                autherized = false
            }else {
               print("Succeeded to get authorization for pushing notifications")
                autherized = true
                print("auterized \(autherized)")
            }
        }
        return autherized
    }
    
    func scheduleNotifications(){
        var data = [String]()
        Api().getDataCurrentPlace { (d) in
            data = d
        }
        for i in 0..<data.count {
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm for \(getPrayName(index: i))"
        content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "newAthan.caf"))
        content.badge = 1
        
        // setUp the trigger using calendar
        
        var dateComponent = DateComponents()
        dateComponent.hour = getHourAndMinFromStr(data[i]).hour
        dateComponent.minute = getHourAndMinFromStr(data[i]).min
            
            
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
            print("notification added successfully")
            
        }
    }
}

func getPrayName(index:Int)->String{
    switch index {
    case 0:
        return "Fajr"
    case 1:
        return "Sunrise"
    case 2:
        return "Dhuhr"
    case 3:
        return "Asr"
    case 4:
        return "Maghrib"
    case 5 :
        return "Isha"
    default:
        return "For allah"
    }
}
