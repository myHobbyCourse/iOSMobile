//
//  ActivityIndicator.swift
//  
//
//  Created by Nitin on 20/01/19.
//  Copyright © 2019 GSTech. All rights reserved.
//
import UIKit
import Foundation
class Activity{
    static let shared : Activity = Activity()
    private init(){}
    var indicatorColor : UIColor = UIColor.red
    
    var activityView: UIActivityIndicatorView?
    var view: UIView?
    
    func showLoader(){
        let delegate = (UIApplication.shared.delegate)
        let view = UIView(frame: UIScreen.main.bounds)
        view.tag = 9999
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        activityView.color = self.indicatorColor
        view.addSubview(activityView)
        view.backgroundColor = UIColor.clear
        view.alpha = 1
        delegate?.window??.addSubview(view)
        activityView.startAnimating()
    }
    
    
    func hideLoader() {
        let delegate = (UIApplication.shared.delegate)
        let view =   delegate?.window??.viewWithTag(9999)
        view?.removeFromSuperview()
        view?.removeFromSuperview()
        activityView?.stopAnimating()
    }
    
}
