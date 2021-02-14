//
//  ProfileDetailsViewController.swift
//  HobbyCourse
//
//  Created by Vinod Jat on 06/08/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var tblReviews: UITableView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var collectionMyAbi: UICollectionView!
    @IBOutlet weak var collectionMySub: UICollectionView!
    @IBOutlet weak var tblQualifications: UITableView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblBIO: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    
    @IBOutlet weak var lblSubjesctTutor: UILabel!
    var strVendorName = String()
    var arrQualification = [Any]()
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
   let cellPercentWidth: CGFloat = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_hour_profile(vendorName: strVendorName)
        lblTime.layer.masksToBounds = false
        lblTime.layer.cornerRadius = lblTime.frame.height/2
        lblTime.clipsToBounds = true
            setUPCollectionView()
    }

    @IBAction func btnLocationAction(_ sender: UIButton) {
    }
    @IBAction func btnLogOutAction(_ sender: UIButton) {
    }
    @IBAction func btnFavoriteAction(_ sender: Any) {
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ProfileDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tblReviews == tableView{
        return 20
        }else{
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.tblReviews == tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell") as! ReviewsCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tblQualificationCell") as! tblQualificationCell
            return cell
        }
       
    }
    
}
extension ProfileDetailsViewController:  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionMyAbi{
            return 10

        }else{
            return 10
    }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionMyAbi {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyList", for: indexPath) as! HobbyList
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyList", for: indexPath) as! HobbyList
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collectionMyAbi == collectionView{
            return centeredCollectionViewFlowLayout.itemSize
        }
        return CGSize.zero
    }
    func setUPCollectionView(){
        guard let flowLayout = collectionMyAbi.collectionViewLayout as? CenteredCollectionViewFlowLayout else {
            return
        }
        centeredCollectionViewFlowLayout = flowLayout

        // Modify the collectionView's decelerationRate (REQURED)
        // collectionMyAvail.decelerationRate = UIScrollView.DecelerationRate.fast

        // Do any additional setup after loading the view.

        collectionMyAbi.delegate = self
        collectionMyAbi.dataSource = self
        collectionMySub.delegate  = self
        collectionMySub.dataSource  = self

        // Configure the required item size (REQURED)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: collectionMyAbi.bounds.width * cellPercentWidth,
            height: collectionMyAbi.bounds.height
        )

        // Configure the optional inter item spacing (OPTIONAL)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 10
    }

}
extension ProfileDetailsViewController {
    
    func get_hour_profile(vendorName:String){
            var dictParam = [String:Any]()
            var dictHeader = [String:Any]()
            if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
                if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                    let token = dict["token"] as! String
                    dictHeader["X-CSRF-Token"] = token
                    dictHeader["Content-Type"] = ContentType.Application_Json.rawValue
                    dictParam["vendor_name"] = vendorName
                    
                }
                let get_hour_profile = "http://myhobbycourses.com/myhobbycourses_endpoint/hour_profile/get_hour_profile"
                
                print("""
                    ==================================
                    URL>>>>>>>>>>>>>>>>>\(get_hour_profile)
                    HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                    PARAM>>>>>>>>>>>>>>>>\(dictParam)
                    ==============================
                    """)
                
                ApiManagerURLSession.CreateAndGetRes(url: get_hour_profile, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                    guard let status = statusCode else{return}
                    if status == 200 {
                        print(">>>>>>>>>>>>>>",res)
                       
                            self.lblProfileName.text = res.getStringValue(forkey: "name")
                        self.lblDiscription.text = res.getStringValue(forkey: "field_description")
                        self.lblTime.text = res.getStringValue(forkey: "hour_rate")
                        let strLocation = res.getStringValue(forkey: "field_travel_policy_street") + " " + res.getStringValue(forkey: "field_travel_policy_town") + " " + res.getStringValue(forkey: "field_travel_policy_county")
                        self.btnLocation.setTitle(strLocation, for: .normal)
                        self.lblSubjesctTutor.text = res.getStringIntValue(forkey: "subject")
                        self.lblBIO.text = res.getStringIntValue(forkey: "about_me")
                        let arrPic = res.getDictionaryValue(forkey: "picture")
                            if let url = URL.init(string: arrPic.getStringValue(forkey: "uri")){
                                self.imgProfile.sd_setImage(with: url, completed:  nil )
                            }
                            
                        
                        
                    }else{
                        
                    }
                }
            }
        
    }
}


class ReviewsCell: UITableViewCell {
    
    @IBOutlet weak var imgUser: StylishUIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDec: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
   
}



