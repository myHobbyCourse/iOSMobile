//
//  ProfileDetailsViewController_iPad.swift
//  HobbyCourse
//
//  Created by Vinod Jat on 13/08/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class ProfileDetailsViewController_iPad: UIViewController {

    @IBOutlet weak var lblTimer: StylishUILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgUserProfile: StylishUIImageView!
    @IBOutlet weak var tblQualification: UITableView!
    @IBOutlet weak var collectionSkills: UICollectionView!
    @IBOutlet weak var tblReviews: UITableView!
    @IBOutlet weak var collectionMyAvail: UICollectionView!
    @IBOutlet weak var collectionSubject: UICollectionView!
    @IBOutlet weak var btnLike: StylishUIButton!

    @IBOutlet weak var hgtConsCVSubject: NSLayoutConstraint!

    let cellPercentWidth: CGFloat = 0.9
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!

    var vendorID = ""
    var dictVendorDetail = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPCollectionView()
        get_search_hour_detail()
    }
    
    @IBAction func btnLike(_ sender: Any) {
    }
    @IBAction func btnLogoutAction(_ sender: Any) {
    }
    @IBAction func btnSkypeAction(_ sender: Any) {
    }
    
    @IBAction func btnMessageAction(_ sender: Any) {
    }
    @IBAction func btnCallAction(_ sender: Any) {
    }
    @IBAction func btnMessageMeAction(_ sender: Any) {
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func setUPCollectionView(){
        guard let flowLayout = collectionMyAvail.collectionViewLayout as? CenteredCollectionViewFlowLayout else {
            return
        }
        centeredCollectionViewFlowLayout = flowLayout

        // Modify the collectionView's decelerationRate (REQURED)
       // collectionMyAvail.decelerationRate = UIScrollView.DecelerationRate.fast

        // Do any additional setup after loading the view.
        collectionMyAvail.delegate = self
        collectionMyAvail.dataSource = self
        collectionSkills.delegate  = self
        collectionSkills.dataSource  = self
        collectionSubject.delegate  = self
        collectionSubject.dataSource = self
        // Configure the required item size (REQURED)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: collectionMyAvail.bounds.width * cellPercentWidth,
            height: collectionMyAvail.bounds.height
        )

        // Configure the optional inter item spacing (OPTIONAL)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 10
    }
}





extension ProfileDetailsViewController_iPad :UITableViewDataSource,UITableViewDelegate{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 20
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if self.tblReviews == tableView{
                let cell = tableView.dequeueReusableCell(withIdentifier: "tblReviewsCell") as! tblReviewsCell
                return cell
            }else{
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "tblQualificationCell") as! tblQualificationCell
                return cell1
                
            }
            
        }
        
    }

    extension ProfileDetailsViewController_iPad:  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate  {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
        }
   
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if self.collectionMyAvail == collectionView{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAvailabilityCVCell", for: indexPath) as! MyAvailabilityCVCell
                return cell
                
            }else if collectionView == collectionSubject{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyList", for: indexPath) as! HobbyList
                cell.lblHobby.text = "jfdsfjhsfh"
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyList", for: indexPath) as! HobbyList
                cell.lblHobby.text = "jfdsfjhsfh"
                return cell
            }
            
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == collectionSubject{
                let label = UILabel()
                label.text = "jfdsfjhsfh"
                return CGSize.init(width: label.intrinsicContentSize.width+10, height: 44)
            }else if collectionView == collectionSkills{
                let label = UILabel()
                label.text = "jfdsfjhsfh"
                return CGSize.init(width: label.intrinsicContentSize.width+10, height: 44)
            }
            return centeredCollectionViewFlowLayout.itemSize
        }

        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionElementKindSectionHeader{
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubjectReusableView", for: indexPath) as! SubjectReusableView
                headerView.lblHeader.text = "Nitin"
                return headerView
            }
            return UICollectionReusableView()
        }
        
}



extension ProfileDetailsViewController_iPad{
    func get_search_hour_detail(){
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
                dictHeader["Content-Type"] = ContentType.Application_Json.rawValue
                dictParam["vendor_id"] = vendorID
            }
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
                self.dictVendorDetail = res
                self.setUPData()
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>",self.dictVendorDetail)
            }else{

            }
        }

    }


    func setUPData(){
        var arrSub = [Any]()
        let dictSubject = self.dictVendorDetail.getDictionaryValue(forkey: "subject")
        for (key,_) in dictSubject {
            let dictSub = dictSubject.getDictionaryValue(forkey: key)

        }
        self.hgtConsCVSubject.constant = self.collectionSubject.contentSize.height
        self.view.layoutIfNeeded()
    }
}



class tblQualificationCell: UITableViewCell {
    @IBOutlet weak var lblUniversity: UILabel!
    @IBOutlet weak var lblDegree: UILabel!
    @IBOutlet weak var lblSchoolName: UILabel!
}
class tblReviewsCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
}
class SubjectReusableView : UICollectionReusableView {
    @IBOutlet weak var lblHeader: UILabel!
}



class MyAvailabilityCVCell : UICollectionViewCell{}
