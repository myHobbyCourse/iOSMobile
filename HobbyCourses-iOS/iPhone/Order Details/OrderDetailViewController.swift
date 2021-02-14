//
//  OrderDetailViewController.swift
//  HobbyCourse
//
//  Created by Nitin on 20/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    //Mark:- Outlets

    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblViewOrderList: UITableView!

    @IBOutlet weak var btnOrderDetail: UIButton!

    @IBOutlet weak var hgtConsTblOrder: NSLayoutConstraint!

    //MARK:- Variables
    var selectedIndex = 0
    var arrOrdersInfo = [Any]()
    //MARK:-Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewOrderList.delegate = self
        tblViewOrderList.dataSource = self
        get_order_API()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tblViewOrderList.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tblViewOrderList.removeObserver(self, forKeyPath: "contentSize")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblViewOrderList && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblOrder.constant = size.height
                }}}
    }

}


//MARK:-Other
extension OrderDetailViewController {
    func get_order_API(){
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
            }
            let get_order_detail = "http://myhobbycourses.com/myhobbycourses_endpoint/vendor_sales/get_orders"

            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(get_order_detail)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\([:])
                ==============================
                """)
            ApiManagerURLSession.CreateAndGetRes(url: get_order_detail, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: [:]) { (reply, res, error, statusCode) in
                guard let status = statusCode else{return}
                if status == 200 {
                    self.arrOrdersInfo = res.getArrayValue(forkey: "data")
                    self.tblViewOrderList.reloadData()
                }else{

                }
            }
        }
    }
}


//MARK:-UITableViewDataSource
extension OrderDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrdersInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictOrder = arrOrdersInfo.getDictionaryValue(atIndex: indexPath.row)
        if selectedIndex == indexPath.row{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderExpandCell", for: indexPath) as! OrderExpandCell
            let font1 = UIFont.init(name: "OpenSansRegular", size: 14.0)
            let font2 = UIFont.init(name: "OpenSansRegular", size: 14.0)

            cell.lblUserName.attributedText = setAttributedString(str1: "Full name: ", color1: #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1), str2: dictOrder.getStringValue(forkey: "billing_name_line"), color2: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1), font1: font1!, font2: font2!)
            cell.lblOrderNumber.text = "Order ID: \(dictOrder.getStringValue(forkey: "order_id"))"
            cell.lblOrderName.text = ""

            cell.lblStatus.attributedText = setAttributedString(str1: "Status: ", color1: #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1), str2: dictOrder.getStringValue(forkey: "status"), color2: #colorLiteral(red: 0.231372549, green: 0.5058823529, blue: 0.1450980392, alpha: 1), font1: font1!, font2: font2!)
             cell.lblOrderTime.attributedText = setAttributedString(str1: "Order time: ", color1: #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1), str2: dictOrder.getStringValue(forkey: "status"), color2: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1), font1: font1!, font2: font2!)
            cell.lblName.attributedText = setAttributedString(str1: "Name: ", color1: #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1), str2: dictOrder.getStringValue(forkey: "billing_name_line"), color2: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1), font1: font1!, font2: font2!)
             cell.lblEmail.attributedText = setAttributedString(str1: "Mail: ", color1: #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1), str2: dictOrder.getStringValue(forkey: "billing_email"), color2: #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1), font1: font1!, font2: font2!)
            cell.lblBillingAddress.text = "\(dictOrder.getStringValue(forkey: "billing_administrative_area")) \n \(dictOrder.getStringValue(forkey: "billing_thoroughfare")) \n \(dictOrder.getStringValue(forkey: "billing_postal_code"))"
            cell.lblUnitPrice.text = dictOrder.getStringValue(forkey: "order_total")
             cell.lblTotalAmount.text = dictOrder.getStringValue(forkey: "order_total")
             cell.lblQTY.text = "1"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCollapseCell", for: indexPath) as! OrderCollapseCell
            cell.lblUserName.text = "Vendor name: \(dictOrder.getStringValue(forkey: "billing_name_line"))"
            cell.lblOrderNumber.text = "Order ID: \(dictOrder.getStringValue(forkey: "order_id"))"
            cell.lblOrderName.text = ""
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        tblViewOrderList.reloadData()
    }
}



class OrderCollapseCell:UITableViewCell{
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var imgArraow: UIImageView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
}

class OrderExpandCell:UITableViewCell{
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var imgArraow: UIImageView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblClientFullName: UILabel!
    @IBOutlet weak var lblOrderTime: UILabel!


    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!

    @IBOutlet weak var lblBillingAddress: UILabel!

    @IBOutlet weak var lblUnitPrice: UILabel!
    @IBOutlet weak var lblQTY: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!

}

