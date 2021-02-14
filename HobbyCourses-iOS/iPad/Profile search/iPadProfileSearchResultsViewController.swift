//
//  iPadProfileSearchResultsViewController.swift
//  HobbyCourse
//
//  Created by Vinod Jat on 09/08/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class iPadProfileSearchResultsViewController: UIViewController {

    @IBOutlet weak var collectioniPadProfileSearchResults : UICollectionView!
    @IBOutlet weak var lblRecordCount: UILabel!
    var arrTutor = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        get_search_hour()
        // Do any additional setup after loading the view.
    }

}


extension iPadProfileSearchResultsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTutor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iPadProfileSearchResults", for: indexPath) as! iPadProfileSearchResults
        let dict = arrTutor.getDictionaryValue(atIndex: indexPath.row)
        cell.lblUserName.text = dict.getStringValue(forkey: "vendor_name")
        cell.lblDic.text = dict.getStringValue(forkey: "about_me")
        cell.lblPricerate.text = "\(dict.getStringValue(forkey: "price")) £/hr"
        let font1 = UIFont.init(name: "OpenSans", size: 20)
        let font2 = UIFont.init(name: "OpenSans", size: 14)
        let color1 = #colorLiteral(red: 0.862745098, green: 0.1843137255, blue: 0.4470588235, alpha: 1)
        let color2 = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        cell.lblDistance2.attributedText = setAttributedString(str1: dict.getStringValue(forkey: "time_count_replay").time(), color1: color1, str2: " for replies", color2: color2, font1: font1!, font2: font2!)

        cell.lblDistance1.attributedText = setAttributedString(str1: dict.getStringValue(forkey: "distance"), color1: color1, str2: " miles travel radius", color2: color2, font1: font1!, font2: font2!)
        cell.lblDistance3.attributedText = setAttributedString(str1: dict.getStringValue(forkey: "total_hour_worked"), color1: color1, str2: " hrs taught", color2: color2, font1: font1!, font2: font2!)

        if let url = URL.init(string: dict.getStringValue(forkey: "image_src")){
            cell.imgUserProfile.sd_setImage(with: url, completed:  nil )
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/2-20, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = arrTutor.getDictionaryValue(atIndex: indexPath.row)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailsViewController_iPad") as! ProfileDetailsViewController_iPad
        vc.vendorID = dict.getStringValue(forkey: "entity_id")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension iPadProfileSearchResultsViewController {
    func get_search_hour(){
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
                dictHeader["Content-Type"] = ContentType.Application_Json.rawValue
                dictParam["city"] = "london"
                dictParam["subject"] = "maths"
                dictParam["Radius"] = "50"
            }
        }
            let get_search_hour = "http://myhobbycourses.com/myhobbycourses_endpoint/search_courses/get_search_hour"

            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(get_search_hour)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\(dictParam)
                ==============================
                """)

            ApiManagerURLSession.CreateAndGetRes(url: get_search_hour, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                guard let status = statusCode else{return}
                if status == 200 {
                    print(">>>>>>>>>>>>>>",res)
                    self.arrTutor = res.getArrayValue(forkey: "rows")
                    if self.arrTutor.count > 0 {
                        self.lblRecordCount.text = "\(self.arrTutor.count) \(dictParam.getStringValue(forkey: "subject").capitalized) tutors found"
                    }else{
                        self.lblRecordCount.text = "No match record found"
                    }
                    self.collectioniPadProfileSearchResults.reloadData()
                }else{

                }
            }

    }
}



class iPadProfileSearchResults : UICollectionViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDic: UILabel!
    @IBOutlet weak var lblDic2: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    @IBOutlet weak var imgUserProfile: StylishUIImageView!
    @IBOutlet weak var btnMore: StylishUIButton!
    @IBOutlet weak var lblPricerate: UILabel!

    @IBOutlet weak var lblDistance1: UILabel!

    @IBOutlet weak var lblDistance2: UILabel!

    @IBOutlet weak var lblDistance3: UILabel!


}
