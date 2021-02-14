//
//  ScheduleClassTime.swift
//  HobbyCourses
//
//  Created by Nitin on 04/08/19.
//  Copyright © 2019 Code Atena. All rights reserved.
//

import Foundation
import UIKit

class ScheduleClassVC : UIViewController{


    @IBOutlet var subviewDatePicker: UIView!

    @IBOutlet weak var viewInnerDatePicker: StylishUIView!

    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var calenderView: FSCalendar!

    @IBOutlet weak var tfCustomerNAme: StylishUITextField!

    @IBOutlet weak var tfDate: StylishUITextField!

    @IBOutlet weak var tfStartTime: StylishUITextField!

    @IBOutlet weak var tfEndTime: StylishUITextField!

    @IBOutlet weak var lblCurrentMonth: UILabel!

    @IBOutlet weak var tfSubject: StylishUITextField!

    @IBOutlet weak var tvMessage: KMPlaceholderTextView!

    var unit: FSCalendarUnit!
    var pickertag = 0

     lazy var formatter :DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
    lazy var formatter1 :DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        calenderView.delegate = self
        calenderView.dataSource = self
        tfEndTime.delegate = self
        tfStartTime.delegate = self
        tfStartTime.tag = 101
        tfEndTime.tag = 201
        calenderView.headerHeight = 0
    }


    @IBAction func btnSaveChanges(_ sender: Any) {
        if self.tfCustomerNAme.text!.count == 0{
            return
        }
        if self.tfDate.text!.count == 0{
            return
        }
        if self.tfSubject.text!.count == 0{
            return
        }
        if self.tvMessage.text!.count == 0{
            return
        }
        if self.tfStartTime.text!.count == 0{
            return
        }
        if self.tfEndTime.text!.count == 0{
            return
        }
        self.book_schdule_customer()
    }

    @IBAction func btnBooking(_ sender: Any) {

    }

    @IBAction func btnNextMonth(_ sender: Any) {
        print("NEXT tapped!")
        unit = (calenderView.scope == FSCalendarScope.month) ? FSCalendarUnit.month : FSCalendarUnit.weekOfYear
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calenderView.currentPage)

        calenderView.setCurrentPage(nextMonth!, animated: true)
    }


    @IBAction func btnPreviousMonth(_ sender: Any) {
        if calenderView.currentPage.compare(Date()) == .orderedAscending{
            return
        }
        unit = (calenderView.scope == FSCalendarScope.month) ? FSCalendarUnit.month : FSCalendarUnit.weekOfYear
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calenderView.currentPage)
        calenderView.setCurrentPage(previousMonth!, animated: true)
    }




    @IBAction func btnCancelOnPicker(_ sender: Any) {
        showPickerView(isShow: false)
    }

    @IBAction func btnDoneOnPicker(_ sender: Any) {
        showPickerView(isShow: false)
        let strDate = formatter.string(from: datePickerView.date)
        if pickertag == 101 {
            self.tfStartTime.text = strDate
        }else{
            self.tfEndTime.text = strDate
        }
    }


    func showPickerView(isShow:Bool){
        if isShow{
            self.subviewDatePicker.frame = self.view.bounds
            self.view.addSubview(subviewDatePicker)
            self.subviewDatePicker.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        }else{
            self.subviewDatePicker.removeFromSuperview()
        }
    }

}



extension ScheduleClassVC : FSCalendarDelegate,FSCalendarDataSource{
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let component = Calendar.current.dateComponents([.year,.month], from: calendar.currentPage)
        let monthName = formatter.monthSymbols[component.month!-1]
        self.lblCurrentMonth.text = "\(monthName) \(component.year ?? 2017)"
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        self.tfDate.text = formatter1.string(from: date)
    }

}


extension ScheduleClassVC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showPickerView(isShow: true)
        self.pickertag = textField.tag
        return false
    }
}


extension ScheduleClassVC {
    func book_schdule_customer(){
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
                dictParam["customer"] = self.tfCustomerNAme.text!.trim
                dictParam["class_date"] = self.tfDate.text!.trim
                dictParam["start_hour"] = self.tfStartTime.text!.trim
                dictParam["end_hour"] = self.tfEndTime.text!.trim
                dictParam["subject"] = self.tfSubject.text!.trim
                dictParam["comment"] = tvMessage.text!.trim
            }
            let book_schdule_customer = "http://myhobbycourses.com/myhobbycourses_endpoint/book_schdule/book_schdule_customer"

            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(book_schdule_customer)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\(dictParam)
                ==============================
                """)
            ApiManagerURLSession.CreateAndGetRes(url: book_schdule_customer, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                guard let status = statusCode else{return}
                if status == 1 {
                   print(">>>>>>>>>>>>>>",res)
                }else{

                }
            }
        }
    }
}
