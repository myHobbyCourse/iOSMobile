//
//  SubjectViewController_iPad.swift
//  HobbyCourse
//
//  Created by Nitin on 27/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class SubjectViewController_iPad: UIViewController {


    @IBOutlet weak var imgProfile: StylishUIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var cvSubjects: UICollectionView!
    @IBOutlet weak var imgUserProfile: StylishUIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblSubjectList: UITableView!

    @IBOutlet weak var lblDesignation: UILabel!

    var isSelectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        cvSubjects.delegate = self
        cvSubjects.dataSource = self
        tblSubjectList.delegate = self
        tblSubjectList.dataSource = self
    }

    //MARK:- Actions

    @IBAction func btnBack(_ sender: Any) {
    }
    @IBAction func btnAboutME(_ sender: Any) {
    }
    @IBAction func btnSubject(_ sender: Any) {
    }
    @IBAction func btnQualification(_ sender: Any) {
    }
    @IBAction func btnLogout(_ sender: Any) {
    }
    @IBAction func btnBell(_ sender: Any) {
    }
    @IBAction func btnProfileInfo(_ sender: Any) {
    }
    @IBAction func btnSaveChanges(_ sender: Any) {
    }

}

extension SubjectViewController_iPad : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject", for: indexPath)
        if let imageView = cell.viewWithTag(1000){

        }
        if let label = cell.viewWithTag(2000){

        }

        return cell
    }


}




extension SubjectViewController_iPad : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
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
        cvSubjects.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = "the quick"
        return CGSize.init(width: label.intrinsicContentSize.width+50, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if  kind == UICollectionElementKindSectionHeader{
             let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! headerView
            headerView.lblHeader.text = "Nitin Jain"
            return headerView
        }else{
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            return footerView
        }
    }
}

class headerView:UICollectionReusableView{
     @IBOutlet weak var lblHeader: UILabel!
}
