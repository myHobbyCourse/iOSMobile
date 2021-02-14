//
//  BookingDetailViewController.swift
//  HobbyCourse
//
//  Created by Nitin on 21/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class BookingDetailViewController: UIViewController {

    //MARK:- Outlets

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var tblBooking: UITableView!
    @IBOutlet weak var hgtConsTblBooking: NSLayoutConstraint!
    //MARK:- View Life cycle
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tblBooking.delegate = self
        tblBooking.dataSource = self
        hour_schedule()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblBooking.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        tblBooking.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tblBooking.removeObserver(self, forKeyPath: "contentSize")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblBooking && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblBooking.constant = size.height
                }}}

    }
}


extension BookingDetailViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex != indexPath.row{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCellCollapse", for: indexPath) as! BookingCellCollapse

        return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCellExpand", for: indexPath) as! BookingCellExpand

            return cell
        }
    }
}

extension BookingDetailViewController {
    func hour_schedule() {
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
                dictHeader["Content-Type"] = ContentType.Application_Json.rawValue
                dictParam["data"] = "subject"

            }
            let hour_schedule = "https://myhobbycourses.com/hour-schedule"

            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(hour_schedule)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\(dictParam)
                ==============================
                """)
            ApiManagerURLSession.CreateAndGetRes(url: hour_schedule, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                guard let status = statusCode else{return}
                if status == 1 {
                    print(">>>>>>>>>>>>>>",res)
                }else{

                }
            }
        }
    }
}


class BookingCellCollapse : UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeekDay: UILabel!

    @IBOutlet weak var lblSubjects: UILabel!
    @IBOutlet weak var lblHours: UILabel!



}
class BookingCellExpand : UITableViewCell ,UITableViewDataSource,UITableViewDelegate{


    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeekDay: UILabel!

    @IBOutlet weak var lblSubjects: UILabel!
    @IBOutlet weak var lblHours: UILabel!

    @IBOutlet weak var tblBooking: UITableView!

    @IBOutlet weak var hgtConsTblBooking: NSLayoutConstraint!

    override func awakeFromNib() {
        tblBooking.delegate = self
        tblBooking.dataSource = self
        self.tblBooking.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblBooking && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblBooking.constant = size.height
                }}}
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingInfo", for: indexPath ) as! BookingInfo
        return cell
    }

}

class BookingInfo:UITableViewCell{
    @IBOutlet weak var lblFromTime: UILabel!
    @IBOutlet weak var lblToTime: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblComment: UILabel!
}

