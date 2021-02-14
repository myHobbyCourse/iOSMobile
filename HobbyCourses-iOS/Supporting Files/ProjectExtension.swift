//
//  ProjectExtension.swift
//  
//
//  Created by Nitin on 13/01/19.
//  Copyright © 2019 GSTech. All rights reserved.
//
import UIKit
import Foundation
import AVKit

extension UIViewController{
    
   
    
    func setAttributedString(str1:String,color1:UIColor,str2:String,color2:UIColor,font1:UIFont,font2:UIFont)->NSMutableAttributedString{
        let attrs1 = [NSFontAttributeName: font1, NSForegroundColorAttributeName : color1]
        let attrs2 = [NSFontAttributeName : font2, NSForegroundColorAttributeName : color2]
        let attributedString1 = NSMutableAttributedString(string:str1, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:str2, attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }




    func addAndRemovePopup(subview:UIView,innerView:UIView,isShow:Bool){
        if isShow {
            subview.frame = self.view.bounds
            subview.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
            self.view.addSubview(subview)
            innerView.frame.origin.y = self.view.bounds.height
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.6) {
                innerView.frame.size.height = self.view.bounds.height - 250
                self.view.layoutIfNeeded()
            }
        }else{
            subview.removeFromSuperview()
        }


    }


    
}
extension UIImagePickerController{
    func openGallary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.sourceType = .photoLibrary
            self.allowsEditing = true
        }
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.sourceType = .camera
            self.allowsEditing = true
        }else{
            openGallary()
        }
    }


}


extension String{
     func time() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
         guard let fromDate = formatter.date(from: self) else { return "invalid date" }
        guard fromDate < Date() else { return "Back to the future" }

        let allComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components:DateComponents = Calendar.current.dateComponents(allComponents, from: fromDate, to: Date())

        for (period, timeAgo) in [
            ("year", components.year ?? 0),
            ("month", components.month ?? 0),
            ("week", components.weekOfYear ?? 0),
            ("day", components.day ?? 0),
            ("hour", components.hour ?? 0),
            ("minute", components.minute ?? 0),
            ("second", components.second ?? 0),
            ] {
                if timeAgo > 0 {
                    return "\(timeAgo.of(period))"
                }
        }

        return "Just now"
    }
    func getElapsedInterval() -> String {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dtFormatter.timeZone = TimeZone.current
        guard let fromDate  = dtFormatter.date(from: self) else {return ""}
        let interval = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: fromDate, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute ago" :
                "\(minute)" + " " + "minutes ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second ago" :
                "\(second)" + " " + "seconds ago"
        } else {
            return "a moment ago"
        }

    }
    func strikethrought(color:UIColor)->NSMutableAttributedString{
        let attr1 = NSMutableAttributedString(string: self, attributes: [NSStrikethroughColorAttributeName:color])
        attr1.addAttribute(NSStrikethroughColorAttributeName, value: 2, range: NSRange.init(location: 0, length: attr1.length))
        return attr1
    }
    
    var trim : String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func calcAge(dateFormat:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat
        guard let birthdayDate = dateFormater.date(from: self)else{ return "" }
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let calcAge = calendar.dateComponents([.year], from: birthdayDate, to: now)
        guard let age = calcAge.year else { return "" }
        return "\(age)"
    }
    
    func getCurrentDate(newFormate:String,oldFormat:String)-> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = oldFormat
        dateFormater.timeZone = TimeZone.current
        guard let date = dateFormater.date(from: self) else{return ""}
        let dateFormater1 = DateFormatter()
        dateFormater1.dateFormat = newFormate
        return dateFormater1.string(from: date)
    }
    
    func isValidPassword() -> Bool {
        guard self != "" else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
         // at least one special char
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    // validate an email for the right format
    func isValidEmail() -> Bool {
        guard self != "" else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
    
    var twoDigit : Double{
        if let doubleValue = Double(self) {
          let strTwoDigit = String(format: "%.2f", doubleValue)
            if let value = Double(strTwoDigit){
                return value
            }
        }
        return 0.0
    }
    
}



extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }

    //Convert video to mp4
    func encodeVideo(at videoURL: URL, completionHandler: ((URL?, Error?) -> Void)?)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)

        let startDate = Date()

        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(nil, nil)
            return
        }

        //Creating temp path to save the converted video
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = documentsDirectory.appendingPathComponent("rendered-Video.mp4")

        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                completionHandler?(nil, error)
            }
        }

        exportSession.outputURL = filePath
      //  exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession.timeRange = range

        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(nil, exportSession.error)
            case .cancelled:
                print("Export canceled")
                completionHandler?(nil, nil)
            case .completed:
                //Video conversion finished
                let endDate = Date()

                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print(exportSession.outputURL ?? "NO OUTPUT URL")
                completionHandler?(exportSession.outputURL, nil)

            default: break
            }

        })
    }
    func data()->Data {
        if let data = try? Data.init(contentsOf: self) {
           return data
        }
         return Data()
    }
}

extension UIImage {
    func data()->Data {
        if let imageData = UIImageJPEGRepresentation(self, 0) {
            return imageData
        }else{
            return Data()
        }
    }
}



extension UIFont {
    class func regular(fontSize:CGFloat)->UIFont{
        return UIFont.init(name: "PROXIMA-NOVA_REGULAR", size: fontSize)!
    }
   
    class func bold(fontSize:CGFloat)->UIFont{
        return UIFont.init(name: "PROXIMA-NOVA-BOLD", size: fontSize)!
    }
    
}


extension UITextField {
    func setPlaceHolderColor(){
        if let placeholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName:UIColor.darkGray])
        }
       
    }
}
extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
    
    func setImageColor(color:UIColor){
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageV.tintColor = color
    }
    func setPlaceholderColor(color:UIColor){
        let font = UIFont.init(name: "MarkoOne-Regular", size: 15.0)
        let attributes = [NSFontAttributeName: font!,NSForegroundColorAttributeName: color,
        ]
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Search Here...", attributes: attributes)
        let textFieldPlaceHolder = self.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = attributedPlaceholder
    }
}


extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.textColor = UIColor.blue
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor,constant: -100).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
    }
}


extension Date {
    static func time(since fromDate: Date) -> String {
        guard fromDate < Date() else { return "Back to the future" }

        let allComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components:DateComponents = Calendar.current.dateComponents(allComponents, from: fromDate, to: Date())

        for (period, timeAgo) in [
            ("year", components.year ?? 0),
            ("month", components.month ?? 0),
            ("week", components.weekOfYear ?? 0),
            ("day", components.day ?? 0),
            ("hour", components.hour ?? 0),
            ("minute", components.minute ?? 0),
            ("second", components.second ?? 0),
            ] {
                if timeAgo > 0 {
                    return "\(timeAgo.of(period))"
                }
        }

        return "Just now"
    }
}
extension Int {
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}
