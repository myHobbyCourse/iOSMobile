//
//  OrderDetailViewController_iPad.swift
//  HobbyCourse
//
//  Created by Nitin on 28/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class OrderDetailViewController_iPad: UIViewController {


    //MARK:- outlet

    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var lblUserName: UILabel!

    @IBOutlet weak var lblOcceupation: UILabel!
    @IBOutlet weak var btnFilter2: UIButton!
    @IBOutlet weak var btnFilter1: UIButton!
    @IBOutlet weak var tfSearch: StylishUITextField!

    @IBOutlet weak var lblFullName: UILabel!

    @IBOutlet weak var lblClientFullName: UILabel!

    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var cvSessionTime: UICollectionView!

    @IBOutlet weak var tblOrder: UITableView!

    @IBOutlet weak var lblOrderTime: UILabel!

    @IBOutlet weak var lblMail: UILabel!

    @IBOutlet weak var lblAddress: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tblOrder.delegate = self
        tblOrder.dataSource = self
        cvSessionTime.delegate = self
        cvSessionTime.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAll(_ sender: Any) {
    }
    @IBAction func btnFilter(_ sender: Any) {
    }
    @IBAction func btnFilter2(_ sender: Any) {
    }
    @IBAction func btnOrderID(_ sender: Any) {
    }
    @IBAction func btnSessionTime(_ sender: Any) {
    }
    @IBAction func btnSubject(_ sender: Any) {
    }
    @IBAction func btnStatus(_ sender: Any) {
    }
    @IBAction func btnPrice(_ sender: Any) {
    }
    

    @IBAction func btnBell(_ sender: Any) {
    }

    @IBAction func btnShowProfileInfo(_ sender: Any) {
    }
}


extension OrderDetailViewController_iPad : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailInfoCell", for: indexPath) as! OrderDetailInfoCell
        return cell
    }


}

extension OrderDetailViewController_iPad : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionTimeCell", for: indexPath) as! SessionTimeCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 320, height: collectionView.frame.height)
    }

    }




class OrderDetailInfoCell : UITableViewCell{
    @IBOutlet weak var lblOrderId: UILabel!
     @IBOutlet weak var lblSession: UILabel!
     @IBOutlet weak var lblSubject: UILabel!
     @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}


class SessionTimeCell:UICollectionViewCell{

    @IBOutlet weak var lblDate: UILabel!

    @IBOutlet weak var lblYear: UILabel!

    @IBOutlet weak var lblFromTime: UILabel!

    @IBOutlet weak var lblToTime: UILabel!

    @IBOutlet weak var lblFromAMPM: UILabel!

    @IBOutlet weak var lblToAMPM: UILabel!

    @IBOutlet weak var lblSubjectComment: UILabel!

    @IBOutlet weak var lblOrderStatus: UILabel!

    @IBOutlet weak var lblTotalDuration: UILabel!
}
