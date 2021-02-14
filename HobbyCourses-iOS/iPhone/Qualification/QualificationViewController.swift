//
//  QualificationViewController.swift
//  HobbyCourse
//
//  Created by Nitin on 20/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit
import iOSDropDown

class QualificationViewController: ParentViewController {

    //MARK:- Outlets
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnProfileEditing: UIButton!
    @IBOutlet weak var lblQualification: StylishUILabel!
    @IBOutlet weak var cvQualification: UICollectionView!
    @IBOutlet weak var tblQualification: UITableView!
    @IBOutlet weak var hgtConsTblQualification: NSLayoutConstraint!

    //MARK:- Variables
    var arrSubjectType = ["University","Add"]
    //["university":"","subject":"","isStudying":"0","degree":""]
    var arrTableData = [Qualification]()
    var isSlectedIndex = 0
    
    //MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let arrDegree = AbouMeDetail.shared.qualification["degree"] as? [String] {
            print("Degree data", arrDegree)
            let arrSubject = AbouMeDetail.shared.qualification["subject"] as? [String]
            let arrUniversity = AbouMeDetail.shared.qualification["univer"] as? [String]
            var i = 0
            for _ in 0...arrDegree.count-1 {
                let qulifi = Qualification()
                qulifi.degree = arrDegree[i]
                qulifi.subject = arrSubject?[i]
                qulifi.university = arrUniversity?[i]
                qulifi.isStudying = false
                self.arrTableData.append(qulifi)
                i += 1
            }
        }else {
            self.arrTableData.append(Qualification())
        }
        
        tblQualification.delegate = self
        tblQualification.dataSource = self
        cvQualification.delegate = self
        cvQualification.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblQualification.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tblQualification.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblQualification && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    self.hgtConsTblQualification.constant = size.height
                }
            }
        }
    }

    //MARK:- Button Actions
    @IBAction func btnAboutMe(_ sender: Any) {
        var isNavigatePop = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AboutMeVC.self) {
                isNavigatePop = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if !isNavigatePop {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutMeVC") as! AboutMeVC
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    @IBAction func btnMoveToSubjects(_ sender: Any) {
        var isNavigatePop = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SubjectsViewController.self) {
                isNavigatePop = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if !isNavigatePop {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubjectsViewController") as! SubjectsViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    @IBAction func saveSubjectsAction(_ sender: UIButton) {
        let filterData = self.arrTableData.filter({$0.university == nil || $0.degree == nil || $0.subject == nil})
        if filterData.count > 0 {
            self.showAletViewWithMessage(msg: "Please fill all the details")
        }else {
            var arr:[String] = []
            for data in self.arrTableData {
                arr.append("")
                arr.append(data.university ?? "")
                arr.append(data.subject ?? "")
                arr.append(data.degree ?? "")
                if data.isStudying == false {
                    arr.append("0")
                }else {
                    arr.append("1")
                }
            }
            print("Save subject ka data:- ", arr)
            self.updateQualification(arrQualification: arr)
        }
    }
    
    private func updateQualification(arrQualification: [String]) {
        self.startActivity()
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                dictParam["qualification_university"] = arrQualification
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
                    self.showAletViewWithMessage(msg: "Qualification updated successfully!")
                }else{
                    self.showAletViewWithMessage(msg: "Qualification not updated!")
                }
            }
        }
    }

}

//MARK:- UITAbleview delegate and datasource method(s)
extension QualificationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualificationCell", for: indexPath) as! QualificationCell
        let dictQualification = arrTableData[indexPath.row]
        cell.dict = dictQualification
        return cell
    }
}

//MARK:- Collection view delegate and datasource method(s)
//MARK:-
extension QualificationViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubjectType.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.lblSubjects.text = arrSubjectType[indexPath.row]
        cell.lblSubjects.backgroundColor = isSlectedIndex == indexPath.row ? #colorLiteral(red: 0.862745098, green: 0.1843137255, blue: 0.4470588235, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.lblSubjects.text = arrSubjectType[indexPath.row]
        cell.lblSubjects.textColor = isSlectedIndex != indexPath.row ? #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = arrSubjectType[indexPath.row]
        return CGSize.init(width: label.intrinsicContentSize.width+50, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.arrSubjectType[indexPath.row] == "Add" {
            self.arrTableData.append(Qualification())
            self.tblQualification.reloadData()
        }
    }
}

class QualificationCell: UITableViewCell, UITextFieldDelegate{
    
    var dict: /*[String:String]?*/ Qualification? {
        didSet {
            self.tfUniversity.text = dict?.university//"\(dict?["university"] ?? "")"
            self.tfSubjects.text = dict?.subject//"\(dict?["subject"] ?? "")"
            self.tfDegree.text = dict?.degree//"\(dict?["degree"] ?? "")"
            self.imgStillStudying.image = dict?.isStudying == false ? UIImage(named: "Rectangle_unselected") : UIImage(named: "checkBoxFill")
            self.setUpInitialValue()
        }
    }
    
    @IBOutlet weak var tfUniversity: StylishUITextField!
    @IBOutlet weak var tfSubjects: StylishUITextField!
    @IBOutlet weak var tfDegree: DropDown!
    @IBOutlet weak var btnStillStudying: UIButton!
    @IBOutlet weak var imgStillStudying: UIImageView!
    
    
    func setUpInitialValue() {
        self.tfDegree.optionArray = ["BE", "BTech", "BSC", "MSC"]
        self.tfDegree.didSelect { [weak self](strData, a, b) in
            self?.dict?.degree = strData
        }
    }
    
    //MARK:- UITextfield delegate method(s)
    //MARK:-
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let tag = textField.superview?.tag ?? 0
//        var dict = arrTableData[tag]
        switch textField {
        case self.tfUniversity:
            self.dict?.university = textField.text
        case self.tfSubjects:
            self.dict?.subject = textField.text
        default:
            print("Hello")
        }
//        arrTableData[tag] = dict
//        tblQualification.reloadRows(at: [IndexPath.init(row: tag, section: 0)], with: .none)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tfDegree {
            return false
        }
        return true
    }
    
    @IBAction func btnStillStudying(_ sender: UIButton) {
        self.dict?.isStudying = dict?.isStudying == false ? true : false
        self.imgStillStudying.image = dict?.isStudying == false ? UIImage(named: "Rectangle_unselected") : UIImage(named: "checkBoxFill")
    }
}

class Qualification {
    var university: String?
    var subject: String?
    var degree: String?
    var isStudying: Bool? = false
}


extension UIViewController {
    func showAletViewWithMessage(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ok) in }))
        appdelegate.window.rootViewController?.present(alert, animated: true, completion: {})
    }
}
