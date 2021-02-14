//
//  SubjectsViewController.swift
//  HobbyCourse
//
//  Created by Nitin on 17/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class SubjectsViewController: ParentViewController {
    //MARK:- Outlets
    @IBOutlet weak var imgHeader: UIImageView!
    
    @IBOutlet weak var lblSubjects: StylishUILabel!
    @IBOutlet weak var btnAboutMe: UIButton!
    @IBOutlet weak var btnProfileEditing: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnQualification: UIButton!
    
    @IBOutlet weak var cvSubjects: UICollectionView!
    @IBOutlet weak var hgtConsTblSub: NSLayoutConstraint!
    
    @IBOutlet weak var tblSubject: UITableView!
    
    var isSlectedIndex = 0
    lazy var arrSubjectData = [[String: Any]]()
    lazy var arrSubjectOfSubject = [[String: Any]]()
    var strSubjectTitle: String?
    fileprivate var aboutMeVc: AboutMeVC?
    fileprivate var qualificationVc: QualificationViewController?
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSubject.delegate = self
        tblSubject.dataSource = self
        cvSubjects.delegate = self
        cvSubjects.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tblSubject.estimatedRowHeight = 75
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.tblSubject.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblSubject.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.getSubjectListAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblSubject.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblSubject && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblSub.constant = size.height
                }
            }
        }
    }
    
    @IBAction func btnAboutMe(_ sender: Any) {
        var isNavigatePop = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AboutMeVC.self) {
                isNavigatePop = true
                self.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
        if !isNavigatePop {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutMeVC") as! AboutMeVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnQualification(_ sender: Any) {
        
        var isNavigatePop = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: QualificationViewController.self) {
                isNavigatePop = true
                self.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
        if !isNavigatePop {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QualificationViewController") as! QualificationViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnSaveChangesAction(_ sender: Any) {
        var arrTid = [String]()
        for data in self.arrSubjectData {
            let arrTemp = data["Subjects"] as? [[String: Any]] ?? [[String: Any]]()
            for temp in arrTemp {
                if (temp["is_selected"] as? Bool) == true {
                    arrTid.append("\(temp["tid"] ?? "")")
                }
            }
        }
        print("Selected subject = ", arrTid)
        self.updateSubject(arrSubject: arrTid)
    }
}


//MARK:- UItableview delegate and datasource methods
extension SubjectsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.strSubjectTitle == nil {
            return 0
        }
        return 1//self.arrSubjectOfSubject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectTableCell", for: indexPath) as! SubjectTableCell
        cell.lblHeader.text = self.strSubjectTitle
        cell.cvSubjectOnTable.tag = indexPath.row
        cell.cvSubjectOnTable.delegate = self
        cell.cvSubjectOnTable.dataSource = self
        cell.cvSubjectOnTable.reloadData()
//        let data = self.arrSubjectOfSubject["subject_name"]
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK:- Collectionview delegate method
extension SubjectsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvSubjects{
            return self.arrSubjectData.count//arrSubjectType.count
        }else{
            return self.arrSubjectOfSubject.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView != cvSubjects{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedSubjectCell", for: indexPath) as! SelectedSubjectCell
//            let subjectData = self.arrSubjectData[indexPath.row]
//            cell.lblSubjectName.text = subjectData["subject_name"] as? String
            let data = self.arrSubjectOfSubject[indexPath.row]
            for (key,value) in data {
                print("key:- ",key)
                print("value:- ",value)
                if key == "\(value)" {
                    cell.btnSubject.setTitle(key, for: .normal)
                    cell.btnSubject.setTitle(key, for: .selected)
                    break
                }
            }
            
            if (data["is_selected"] as! Bool) == true {
                cell.btnSubject.isSelected = true
            }else {
                cell.btnSubject.isSelected = false
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
            cell.lblSubjects.backgroundColor = isSlectedIndex == indexPath.row ? #colorLiteral(red: 0.862745098, green: 0.1843137255, blue: 0.4470588235, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            cell.lblSubjects.text = arrSubjectType.getStringValue(atIndex: indexPath.row)
            cell.lblSubjects.textColor = isSlectedIndex != indexPath.row ? #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            let subjectData = self.arrSubjectData[indexPath.row]
            cell.lblSubjects.text = subjectData["subject_name"] as? String
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvSubjects{
            let label = UILabel()
            label.text = self.arrSubjectData[indexPath.row].getStringValue(forkey: "subject_name")
            return CGSize.init(width: label.intrinsicContentSize.width+50, height: 52)
        }else{
            return CGSize(width: collectionView.frame.width/2.0-30, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvSubjects{
            isSlectedIndex = indexPath.row
            collectionView.reloadData()
            let subjects = self.arrSubjectData[indexPath.row]
            self.strSubjectTitle = subjects["subject_name"] as? String
            self.arrSubjectOfSubject = subjects["Subjects"] as? [[String: Any]] ?? [[String: Any]]()
            self.tblSubject.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tblSubject.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tblSubject.reloadData()
            }
        }else{
            var data = self.arrSubjectOfSubject[indexPath.row]
            if (data["is_selected"] as? Bool) == true {
                data["is_selected"] = false
                self.arrSubjectOfSubject[indexPath.row] = data
                var tempData = self.arrSubjectData[self.isSlectedIndex]
                tempData["Subjects"] = self.arrSubjectOfSubject
                self.arrSubjectData[self.isSlectedIndex] = tempData
            }else {
                data["is_selected"] = true
                self.arrSubjectOfSubject[indexPath.row] = data
                var tempData = self.arrSubjectData[self.isSlectedIndex]
                tempData["Subjects"] = self.arrSubjectOfSubject
                self.arrSubjectData[self.isSlectedIndex] = tempData
            }
            collectionView.reloadData()
        }
    }
}

//MARK:- API Calling
//MARK:-
extension SubjectsViewController {
    func getSubjectListAPI() {
        self.startActivity()
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                dictParam["data"] = "subject"
                
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
            }
            let get_hour_profile = "http://myhobbycourses.com/myhobbycourses_endpoint/book_schdule/subject_student"
            
            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(get_hour_profile)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\(dictParam)
                ==============================
                """)
            ApiManagerURLSession.CreateAndGetRes(url: get_hour_profile, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                self.stopActivity()
                guard let status = statusCode else{return}
                if status == 200 {
                    self.getUpdatedJson(res: res["data"] as? [[String : Any]])
                }else{
                    
                }
            }
        }
    }
    
    private func getUpdatedJson(res: [[String : Any]]?) {
        if let arrJsonResult = res {
            let arrMainSubject = getParentSubjects(arrSubs: arrJsonResult)
            var arrMainSubs = [[String : Any]]()
            
            for obj in arrMainSubject{
                var mainSubDict = [String : Any]()
                //var subJectName = String()
                let filterSubjectName = getSubjectName(subjectInfo: obj)
                
                mainSubDict["subject_name"] = filterSubjectName
                mainSubDict["tid"] = obj["tid"]
                var innerSubject = [[String : Any]]()
                // Get All sub subject base on parent ID
                for responseSubServer in arrJsonResult{
                    let pid1 = obj["tid"] as? String
                    var pid2 = String()
                    if let tempPid2 = responseSubServer["parent_tid"] as? Int {
                        pid2 = String(tempPid2)
                    }else{
                        pid2 = ""
                    }
                    
                    if pid1 == pid2{
                        var tempData = responseSubServer
                        
                        let tid = tempData["tid"] as? String
                        if AbouMeDetail.shared.arrSubjects.contains(tid ?? "") {
                            tempData["is_selected"] = false
                        }else {
                            tempData["is_selected"] = true
                        }
                        innerSubject.append(tempData)
                    }
                }
                
                mainSubDict["Subjects"] = innerSubject
                arrMainSubs.append(mainSubDict)
            }
            print("Main Array with new formation = \(arrMainSubs)")
            self.arrSubjectData = arrMainSubs
            self.cvSubjects.reloadData()
            
            isSlectedIndex = 0
            let subjects = self.arrSubjectData[0]
            self.strSubjectTitle = subjects["subject_name"] as? String
            self.arrSubjectOfSubject = subjects["Subjects"] as? [[String: Any]] ?? [[String: Any]]()
            self.tblSubject.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tblSubject.reloadData()
            }
        }
    }
    
    func getSubjectName(subjectInfo : [String : Any]) -> String{
        let allKeys = subjectInfo.keys
        
        for strSubjectName in allKeys{
            if subjectInfo[strSubjectName] as? String == strSubjectName{
                return strSubjectName
            }
        }
        return String()
    }
    
    func getParentSubjects(arrSubs : [[String : Any]]) -> [[String : Any]]{
        var mainArrSubs = [[String : Any]]()
        
        for obj in arrSubs {
            if (obj["parent_tid"] as? NSNull) != nil{
                mainArrSubs.append(obj)
            }
        }
        return mainArrSubs
    }
}


class SubjectTableCell : UITableViewCell {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var cvSubjectOnTable: UICollectionView!
    @IBOutlet weak var hgtConsCVSubject: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.cvSubjectOnTable.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.cvSubjectOnTable && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.oldKey] as? CGSize{
                    hgtConsCVSubject.constant = size.height
                    print(">>>>>>>>>>>>>>\(size.height)")
                }
            }
        }
    }
}

//MARK:- Update Api
//MARK:-
extension SubjectsViewController {
    fileprivate func updateSubject(arrSubject: [String]) {
        self.startActivity()
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                dictParam["subject"] = arrSubject
                dictParam["mail"] = "myhobbypunith@gmail.com"
                let token = dict["token"] as! String
                dictHeader["X-CSRF-Token"] = token
            }
            let updateQualification = "http://myhobbycourses.com/myhobbycourses_endpoint/custom_user_service/update"
            
            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(updateQualification)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\(dictParam)
                ==============================
                """)
            ApiManagerURLSession.CreateAndGetRes(url: updateQualification, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                self.stopActivity()
                guard let status = statusCode else{return}
                if status == 200 {
                    print("Update qualification success")
                }else{
                    print("Update qualification failure")
                }
            }
        }
    }
}

class SubjectCell:UICollectionViewCell{
    @IBOutlet weak var lblSubjects: UILabel!
}

class SelectedSubjectCell:UICollectionViewCell{
    @IBOutlet weak var btnSubject: UIButton!
}



class AbouMeDetail: NSObject {
    static let shared = AbouMeDetail()
    
    lazy var dict = [String: Any]()
    lazy var arrSubjects = [String]()
    lazy var qualification = [String: Any]()
}
