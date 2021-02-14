//
//  AboutMeVC.swift
//  HobbyCourse
//
//  Created by Nitin on 16/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit
import iOSDropDown
let appdelegate = UIApplication.shared.delegate as! AppDelegate

class AboutMeVC: ParentViewController {

    //MARK:- Outlets
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnProfileEditing: UIButton!
    @IBOutlet weak var lblAboutMe: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnSubjects: UIButton!
    @IBOutlet weak var btnQUALIFICATION: UIButton!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfGender: DropDown!
    @IBOutlet weak var tfHouseNo: UITextField!
    @IBOutlet weak var tfLandMark: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfZipcode: UITextField!
    @IBOutlet weak var tfWebsite: UITextField!
    @IBOutlet weak var tfTagline: UITextField!
    @IBOutlet weak var tfVideoUrl: UITextField!
    @IBOutlet weak var tfReferenceName: UITextField!
    @IBOutlet weak var tfOfferCode: UITextField!
    @IBOutlet weak var tfTravelPolicy: UITextField!
    @IBOutlet weak var txtVwAboutMe: UITextView!
    
    var dictData = [String:Any]()
    var countries: [String] = {
        var arrayOfCountries: [String] = []
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            arrayOfCountries.append(name)
        }
        return arrayOfCountries
    }()

    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDatePicker()
        
        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfTravelPolicy.delegate = self
        tfDOB.delegate = self
        tfCity.delegate  = self
        tfGender.delegate = self
        tfState.delegate  = self
        tfCountry.delegate = self
//        tfLetUsKnow1.delegate = self
//        tfLetUsKnow2.delegate = self
//        tfLetUsKnow3.delegate =  self
        tfReferenceName.delegate = self
        tfOfferCode.delegate = self
        tfZipcode.delegate = self
        tfPhone.delegate = self
        tfEmail.delegate = self
        tfGender.optionArray = ["Male","Female","Other"]
        self.get_hour_profileAPI()
       }

    @IBAction func btnSubject(_ sender: Any) {
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

    @IBAction func btnQualification(_ sender: Any) {
        var isNavigatePop = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: QualificationViewController.self) {
                isNavigatePop = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if !isNavigatePop {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QualificationViewController") as! QualificationViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        self.updateProfileApi()
    }
}

extension AboutMeVC {
    fileprivate func setupDatePicker() {
        let datepicker = UIDatePicker()
        datepicker.maximumDate = Date()
        datepicker.datePickerMode = .date
        self.tfDOB.inputView = datepicker
        datepicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
        self.tfDOB.text = dateFormat.string(from: sender.date)
    }
}

extension AboutMeVC:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        switch textField {
////        case tfDOB:
////            return false
//        case tfGender:
//             return false
////        case tfCountry:
////             return false
////        case tfState:
////             return false
////        case tfCity:
////             return false
////        case tfTravelPolicy:
////             return false
//        default:
//            return true
//        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case tfFirstName:
            tfLastName.becomeFirstResponder()
        case tfLastName:
            tfEmail.becomeFirstResponder()
        case tfEmail:
            tfPhone.becomeFirstResponder()
        case tfPhone:
            tfPhone.resignFirstResponder()
        case tfHouseNo:
            tfLandMark.becomeFirstResponder()
        case tfLandMark:
            tfLandMark.resignFirstResponder()
        case tfZipcode:
            tfZipcode.resignFirstResponder()
        case tfFirstName:
            tfLastName.becomeFirstResponder()
        case tfWebsite:
            tfTagline.becomeFirstResponder()
        case tfTagline:
            tfVideoUrl.becomeFirstResponder()
        case tfVideoUrl:
            tfReferenceName.becomeFirstResponder()
        case tfReferenceName:
            tfOfferCode.becomeFirstResponder()
        default:
            self.view.endEditing(true)
            return false
        }

        return true
    }
}

extension AboutMeVC {
    func changeApiData(){
        let subjectDict = self.dictData.getDictionaryValue(forkey: "subject")
        let englishDict = subjectDict.getDictionaryValue(forkey: "english")
    }

    func setData(){
        self.lblName.text = dictData.getStringValue(forkey: "name")
        self.tfFirstName.text = dictData.getStringValue(forkey: "field_first_name")
        self.tfLastName.text = dictData.getStringValue(forkey: "field_last_name")
        self.tfEmail.text = dictData.getStringValue(forkey: "mail")
        self.tfPhone.text = dictData.getStringValue(forkey: "field_phone")
        self.tfDOB.text = dictData.getStringValue(forkey: "field_date_of_birth").getCurrentDate(newFormate: "dd-MM-yyyy", oldFormat: "yyyy-MM-dd HH:mm:ss")
        self.tfGender.text = dictData.getStringValue(forkey: "field_user_gender")
        self.tfHouseNo.text = dictData.getStringValue(forkey: "field_address")
        self.tfLandMark.text = dictData.getStringValue(forkey: "field_address_2")
        self.tfCity.text = dictData.getStringValue(forkey: "field_city")
        self.tfCountry.text = dictData.getStringValue(forkey: "field_country")
        self.tfZipcode.text = dictData.getStringValue(forkey: "field_postal_code")
        self.tfWebsite.text = dictData.getStringValue(forkey: "field_site")
        self.tfTagline.text = dictData.getStringValue(forkey: "field_tagline")
        self.tfVideoUrl.text = dictData.getStringValue(forkey: "field_video_url")
        self.tfTravelPolicy.text = dictData.getStringValue(forkey: "field_travel_policy_distance")
        self.txtVwAboutMe.text = dictData.getStringValue(forkey: "field_description")
        if let offerCode = dictData["field_offer_code"] as? [String] {
            self.tfOfferCode.text =  offerCode.first
        }
        
        if let refrenceFullName = dictData["field_referee_name_1"] as? [String] {
            self.tfReferenceName.text =  refrenceFullName.first
        }
        
        print(self.dictData.json)
    }


    func get_hour_profileAPI(){
        self.startActivity()
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let dictUser = dict["user"] as! [String:Any]
                let vendor_id = dictUser["uid"] as! String
                let token = dict["token"] as! String
                dictParam["vendor_id"] = vendor_id
                dictHeader["X-CSRF-Token"] = token
            }
            let get_hour_profile = "http://myhobbycourses.com/myhobbycourses_endpoint/hour_profile/get_user_profile"
            //"http://myhobbycourses.com/myhobbycourses_endpoint/hour_profile/get_hour_profile"

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
                    AbouMeDetail.shared.dict = res
                    AbouMeDetail.shared.arrSubjects = res["subject"] as? [String] ?? []
                    if let qualification = res["qualification"] as? [String: Any] {
                        AbouMeDetail.shared.qualification = qualification["University"] as? [String : Any] ?? [String: Any]()
                    }
                    
                    self.dictData = res
                    print(self.dictData)
                    self.setData()
                }else{
                    
                }
            }
        }
    }
    
    
    fileprivate func updateProfileApi() {
        self.startActivity()
        var dictParam = [String:Any]()
        var dictHeader = [String:Any]()
        if let data = UserDefaults.standard.object(forKey: "UserInformationDictionaryKey") as? Data{
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]{
                let dictUser = dict["user"] as! [String:Any]
                let vendor_id = dictUser["uid"] as! String
                let token = dict["token"] as! String
                dictParam["vendor_id"] = vendor_id
                dictHeader["X-CSRF-Token"] = token
            }
            
            dictParam["name"] = self.lblName.text
            dictParam["field_first_name"] = self.tfFirstName.text
            dictParam["field_last_name"] = self.tfLastName.text
            dictParam["mail"] = self.tfEmail.text
            dictParam["field_phone"] = self.tfPhone.text
            dictParam["field_date_of_birth"] = self.tfDOB.text
            dictParam["field_user_gender"] = self.tfGender.text
            dictParam["field_address"] = self.tfHouseNo.text
            dictParam["field_address_2"] = self.tfLandMark.text
            dictParam["field_city"] = self.tfCity.text
            dictParam["field_country"] = self.tfCountry.text
            dictParam["field_postal_code"] = self.tfZipcode.text
            dictParam["field_site"] = self.tfWebsite.text
            dictParam["field_tagline"] = self.tfTagline.text
            dictParam["field_video_url"] = self.tfVideoUrl.text
//            dictParam["Referee_1_Name"] = self.tfReferenceName.text
            dictParam["field_referee_name_1"] = [self.tfReferenceName.text]
            dictParam["field_travel_policy_distance"] = self.tfTravelPolicy.text
            dictParam["field_description"] = self.txtVwAboutMe.text
            dictParam["field_offer_code"] = [self.tfOfferCode.text]
            
            let update_hour_profile = "http://myhobbycourses.com/myhobbycourses_endpoint/custom_user_service/update"
            
            print("""
                ==================================
                URL>>>>>>>>>>>>>>>>>\(update_hour_profile)
                HEADER>>>>>>>>>>>>>>>>>>>\(dictHeader)
                PARAM>>>>>>>>>>>>>>>>\(dictParam)
                ==============================
                """)
            ApiManagerURLSession.CreateAndGetRes(url: update_hour_profile, method: .POST,dictHeader: dictHeader as? [String : String],dictParameter: dictParam) { (reply, res, error, statusCode) in
                self.stopActivity()
                guard let status = statusCode else{return}
                if status == 200 {
                    self.showAletViewWithMessage(msg: "Profile updated successfully!")
                }else{
                    self.showAletViewWithMessage(msg: error?.localizedDescription ?? "")
                }
            }
        }
    }
}
