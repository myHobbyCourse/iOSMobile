//
//  HomeViewController.swift
//  HobbyCourse
//
//  Created by Nitin on 27/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class HomeViewController_iPad: UIViewController {


    //MARK:- Outlets

    @IBOutlet weak var lbluserType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: StylishUIImageView!
    @IBOutlet weak var imgProfile: StylishUIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblProfileCompletion: UILabel!
    @IBOutlet weak var lblProfileCompletion1: StylishUILabel!
    @IBOutlet weak var lblProfileCompletion2: StylishUILabel!
    @IBOutlet weak var lblProfileCompletion3: StylishUILabel!
    @IBOutlet weak var lblProfileCompletion4: StylishUILabel!
    @IBOutlet weak var lblProfileCompletion5: StylishUILabel!
    @IBOutlet weak var tfFName: StylishUITextField!
    @IBOutlet weak var tfFLame: StylishUITextField!
    @IBOutlet weak var tfEmail: StylishUITextField!
    @IBOutlet weak var tfPhone: StylishUITextField!
    @IBOutlet weak var tfBirth: StylishUITextField!
    @IBOutlet weak var tfAddress1: StylishUITextField!
    @IBOutlet weak var tfAddress2: StylishUITextField!
    @IBOutlet weak var tfCity: StylishUITextField!
    @IBOutlet weak var tfPostal: StylishUITextField!
    @IBOutlet weak var tfCompanyName: StylishUITextField!
    @IBOutlet weak var tfCompanyNumber: StylishUITextField!
    @IBOutlet weak var tfCompanyVat: StylishUITextField!
    @IBOutlet weak var tfCompanyWebsite: StylishUITextField!
    @IBOutlet weak var cvHobby: UICollectionView!
    @IBOutlet weak var tfWebsite: StylishUITextField!
    @IBOutlet weak var tfTagline: StylishUITextField!
    @IBOutlet weak var tfVideoURL: StylishUITextField!
    @IBOutlet weak var tfRefereeName: StylishUITextField!
    @IBOutlet weak var tfOfferCode: StylishUITextField!
    @IBOutlet weak var tfDistance: StylishUITextField!
    @IBOutlet weak var hgtConsCVHobby: NSLayoutConstraint!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!

    var isSelectedIndex = 0
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cvHobby.delegate = self
        cvHobby.dataSource = self
        self.cvHobby.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        //cvHobby.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.cvHobby.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.cvHobby.removeObserver(self, forKeyPath: "contentSize")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UICollectionView {
            if obj == self.cvHobby && keyPath == "contentSize" {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize{
                    hgtConsCVHobby.constant = size.height
                    print(">>>>>>>>>>>>>>\(size.height)")
                }
            }
        }
    }

    // MARK: - Action
    @IBAction func btnBack(_ sender: Any) {
    }
    @IBAction func lblAboutME(_ sender: Any) {
    }

    @IBAction func btnSubject(_ sender: Any) {
    }
    @IBAction func lblQualification(_ sender: Any) {
    }

    @IBAction func btnLogout(_ sender: Any) {
    }

    @IBAction func btnNotification(_ sender: UIButton) {
    }

    @IBAction func btnClickOnSideProfileInfo(_ sender: Any) {
    }
    @IBAction func btnGender(_ sender: UIButton) {
    }

    @IBAction func btnFacebook(_ sender: Any) {
    }

    @IBAction func btnTwitter(_ sender: Any) {
    }
    @IBAction func btnSaveChanges(_ sender: Any) {
    }
}

extension HomeViewController_iPad:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyList", for: indexPath) as! HobbyList
        cell.lblHobby.backgroundColor = isSelectedIndex == indexPath.row ? #colorLiteral(red: 0.862745098, green: 0.1843137255, blue: 0.4470588235, alpha: 1) : #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isSelectedIndex = indexPath.row
        cvHobby.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = "the quick"
        return CGSize.init(width: label.intrinsicContentSize.width+50, height: 44)
    }

}

class HobbyList : UICollectionViewCell{
    @IBOutlet weak var lblHobby: UILabel!
}
