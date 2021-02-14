//
//  JPUtility.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 18/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


class JPUtility: NSObject {
    
    static let shared = JPUtility()
   
    func performOperation(_ delay: Double, block: @escaping ()->()) {
        let delayInSeconds = delay;
        let delay = delayInSeconds * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            block()
        }
    }
    
    func agoStringFromTime(_ date: Date) -> String {
        var timeScale = [String : Int64]()
        timeScale["sec"] = 1
        timeScale["min"] = 60
        timeScale["hour"] = 3600
        timeScale["day"] = 86400
        timeScale["week"] = 605800
        timeScale["month"] = 2629743
        timeScale["year"] = 31556926
        var scale : String!
        let timeAgo = -1 * date.timeIntervalSinceNow
        if timeAgo < 60 {
            scale = "sec"
            return "Just now"
        } else if timeAgo < 3600 {
            scale = "min"
        } else if timeAgo < 86400 {
            scale = "hour"
        } else if timeAgo < 605800 {
            scale = "day"
        } else if timeAgo < 2629743 {
            scale = "week"
        } else if timeAgo < 31556926 {
            scale = "month"
        } else {
            scale = "year"
        }
        
        let ago = Int64(timeAgo) / timeScale[scale]!
        var s = ""
        if ago > 1 {
            s = "s"
        }
        
        return "\(ago) \(scale)\(s) ago"
    }
  
    func sjCount(_ cnt: Double) -> String {
        var float : Double = 0.0
        var integer : Double = 0.0
        var count = "\(Int(cnt))"
        if cnt > 999 && cnt < 999999 {
            float = cnt/1000.0
            let fr = Int(modf(float, &integer) * 100)
            if fr > 0 {
                count = String(format: "%.02f", float)
            } else {
                count = "\(Int(integer))"
            }
            count  += "K"
        } else if cnt > 999999  && cnt<999999999{
            float = cnt/1000000.0
            let fr = Int(modf(float, &integer) * 100)
            if fr > 0 {
                count = String(format: "%.02f", float)
            } else {
                count = "\(Int(integer))"
            }
            count  += "M"
        } else if cnt > 999999999  {
            float = cnt/1000000000.0
            let fr = Int(modf(float, &integer) * 100)
            if fr > 0 {
                count = String(format: "%.02f", float)
            } else {
                count = "\(Int(integer))"
            }
            count  += "B"
            
        }
        
        return count
    }
    
    func expireStringFromTime(_ date:Date) -> String {
        
        let dayHourMinuteSecond: NSCalendar.Unit = [.year, .month, .weekOfYear, .day, .hour, .minute, .second]
        let difference = (Calendar.current as NSCalendar).components(dayHourMinuteSecond, from: Date(), to: date, options: [])
        let s = "s"
       
        var seconds = "\(difference.second) " +  "sec"
     
        if difference.second! > 1{
              seconds +=  s
        }
        
        var minutes = "\(difference.minute) " + "min"
        if difference.minute! > 1{
            minutes +=  s
        }
        var hours   = "\(difference.hour) " + "hour"
        
        if difference.hour! > 1{
            hours +=  s
        }
        
        var days    = "\(difference.day) " + "day"
        
        if difference.day! > 1{
            days +=  s
        }
        
        var week    = "\(difference.weekOfYear) " + "week"
        
        if difference.weekOfYear! > 1{
            week +=  s
        }
        
        var month    = "\(difference.month) " + "month"
        
        if difference.month! > 1{
            month +=  s
        }
        
        var year    = "\(difference.year) " + "year"
        
        if difference.year! > 1{
            year +=  s
        }
        
        // For Years
        year += ", " + month
        
        // For Months
        month += ", " + week
        
        // For Weeks
        week += ", " + days
        
        // For Days
        days += ", " + hours
        
        // For Hours
        hours += ", " + minutes
        
        // For Minutes
        minutes += ", " + seconds

        if difference.year!          > 0 { return year }
        if difference.month!         > 0 { return month }
        if difference.weekOfYear!    > 0 { return week }
        if difference.day!           > 0 { return days }
        if difference.hour!          > 0 { return hours }
        if difference.minute!        > 0 { return minutes }
        if difference.second!        > 0 { return seconds }
        return ""
    }
}





