//
//  QualificationViewController_iPad.swift
//  HobbyCourse
//
//  Created by Nitin on 28/07/19.
//  Copyright © 2019 Advantal. All rights reserved.
//

import UIKit

class QualificationViewController_iPad: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var imgProfile: StylishUIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var cvQualification: UICollectionView!
    @IBOutlet weak var imgUserProfile: StylishUIImageView!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblDesignation: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        cvQualification.delegate = self
        cvQualification.dataSource = self
        // Do any additional setup after loading the view.
    }
    


}

extension QualificationViewController_iPad : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QualificationCell_iPad", for: indexPath) as! QualificationCell_iPad
            cell.lblSeperator.isHidden = (indexPath.row%2 == 0)
            return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width/2.0-5, height: 280)
    }




}







class QualificationCell_iPad : UICollectionViewCell {

    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var tfUniversity: StylishUITextField!
    @IBOutlet weak var tfSubject: StylishUITextField!
    @IBOutlet weak var tfSelectDegree: StylishUITextField!
    @IBOutlet weak var switchStudying: UISwitch!
        @IBOutlet weak var lblStillStudying: UILabel!





}
