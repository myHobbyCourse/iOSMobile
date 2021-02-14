//
//  AttendenceViewController.swift
//  HobbyCourse
//
//  Created by Vinod Jat on 04/08/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class AttendenceViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var tblAttendence: UITableView!
    @IBOutlet weak var hgtConsTblAttendence: NSLayoutConstraint!
    //MARK:- View Life cycle
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAttendence.delegate = self
        tblAttendence.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tblAttendence.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tblAttendence.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tblAttendence.removeObserver(self, forKeyPath: "contentSize")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblAttendence && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblAttendence.constant = size.height
                }}}
        
    }
}
extension AttendenceViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedIndex != indexPath.row{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendenceCellCollapse", for: indexPath) as! AttendenceCellCollapse
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendenceCellExpand", for: indexPath) as! AttendenceCellExpand
            return cell
        }
    }
    
    
}
class AttendenceCellCollapse : UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeekDay: UILabel!
    
    @IBOutlet weak var lblSubjects: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    
}
class AttendenceCellExpand : UITableViewCell ,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblWeekDay: UILabel!
    
    @IBOutlet weak var lblSubjects: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    
    @IBOutlet weak var tblattendence: UITableView!
    
    @IBOutlet weak var hgtConsTblBooking: NSLayoutConstraint!
    
    override func awakeFromNib() {
        tblattendence.delegate = self
        tblattendence.dataSource = self
        self.tblattendence.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblattendence && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblBooking.constant = size.height
                }}}
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendenceInfo", for: indexPath ) as! AttendenceInfo
        return cell
    }
    
}
class AttendenceInfo:UITableViewCell{
    @IBOutlet weak var lblFromTime: UILabel!
    
}
