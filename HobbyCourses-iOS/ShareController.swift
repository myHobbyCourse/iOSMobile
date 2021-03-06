//
//  ShareController.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import MessageUI

class ShareSturcture {
    
    var arrEmails: [String] = []
    var allCounts: Int = 0
    var sentCompBlock: (()->())?
    var sentCount: Int = 0 {
        didSet {
            if sentCount == allCounts {
                sentCompBlock?()
            }
        }
    }
}

enum SendStatus: Int {
    case Sent
    case Cancelled
    case Failed
    case NotSupported
    case Saved
}

@objc class ShareController: NSObject, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    static var shared = ShareController()
    
    var completionBlock: ((SendStatus) -> ())?

    func sendMessageToRecipients(numbers: [String], messages: [String], toController: UIViewController, block:(SendStatus)->()) {
        guard MFMessageComposeViewController.canSendText() else {
            block(.NotSupported)
            return
        }
        MFMessageComposeViewController.canSendText()
        completionBlock = block
        let msgController = MFMessageComposeViewController()
        msgController.subject = messages[0]
        msgController.body = messages[1]
        msgController.recipients = numbers
        msgController.messageComposeDelegate = self
        toController.presentViewController(msgController, animated: true, completion: nil)
    }
    
    func sendMailToRecipients(emails: [String], messages: [String], toController: UIViewController, block:(SendStatus)->()) {
        guard MFMailComposeViewController.canSendMail() else {
            block(.NotSupported)
            return
        }
        completionBlock = block
        let mailController = MFMailComposeViewController()
        mailController.setSubject(messages[0])
        mailController.setMessageBody(messages[1], isHTML: false)
        mailController.setToRecipients(emails)
        mailController.mailComposeDelegate = self
        toController.presentViewController(mailController, animated: true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch result {
        case MessageComposeResultSent:
            completionBlock?(.Sent)
        case MessageComposeResultCancelled:
            completionBlock?(.Cancelled)
        case MessageComposeResultFailed:
            completionBlock?(.Failed)
        default:
            completionBlock?(.NotSupported)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch result {
        case MFMailComposeResultSent:
            completionBlock?(.Sent)
        case MFMailComposeResultCancelled:
            completionBlock?(.Cancelled)
        case MFMailComposeResultFailed:
            completionBlock?(.Failed)
        case MFMailComposeResultSaved:
            completionBlock?(.Saved)
        default:
            completionBlock?(.NotSupported)
        }
    }

}

// Typical Example
/*
 
ShareController.shared.sendMessageToRecipients(numbers, messages: ["Cool APP","APP URL"], toController: self, block: { (status) in
    var statusAlert: (msg:String?, popupType: String?)
    switch status {
    case .Sent:
        statusAlert.msg = "Invitation\nSent"
        statusAlert.popupType = "Splash"
    case .Cancelled:
        statusAlert.msg = "Invitation\nCancelled"
        statusAlert.popupType = "Splash"
    case .Failed:
        statusAlert.msg = "Invitation\nFailed"
        statusAlert.popupType = "Splash"
    default:
        statusAlert.msg = "Not Supported"
        statusAlert.popupType = "Bar"
    }
    if statusAlert.popupType! == "Bar" {
        ValidationToast.showBarMessage(statusAlert.msg!, inView: self.view)
    } else {
        Alert.instanceWithMessageFromNib(statusAlert.msg!, alertType: Alert.AlertType.Negative, automaticallyAnimateOut: true)
}

ShareController.shared.sendMailToRecipients([self.contactUsers[sender.tag].email], messages: ["Cool APP","APP URL"], toController: self, block: { (status) in
    var statusAlert: (msg:String?, popupType: String?)
    switch status {
    case .Sent:
        statusAlert.msg = "Message\nSent"
        statusAlert.popupType = "Splash"
    case .Cancelled:
        statusAlert.msg = "Message\nCancelled"
        statusAlert.popupType = "Splash"
    case .Failed:
        statusAlert.msg = "Message\nFailed"
        statusAlert.popupType = "Splash"
    case .Saved:
        statusAlert.msg = "Message\nSaved"
        statusAlert.popupType = "Splash"
    default:
        statusAlert.msg = "Not Supported"
        statusAlert.popupType = "Bar"
    }
    if statusAlert.popupType! == "Bar" {
        ValidationToast.showBarMessage(statusAlert.msg!, inView: self.view)
    } else {
        Alert.instanceWithMessageFromNib(statusAlert.msg!, alertType: Alert.AlertType.Negative, automaticallyAnimateOut: true)
    }
})

*/


extension ShareController {
        
    func sendMailToRecipient(email: String, subject: String, body: String, toController: UIViewController, block: (SendStatus)->()) {
        guard MFMailComposeViewController.canSendMail() else {
            block(.NotSupported)
            return
        }
        completionBlock = block
        let mailController = MFMailComposeViewController()
        mailController.setSubject(subject)
        mailController.setMessageBody(body, isHTML: false)
        mailController.setToRecipients([email])
        mailController.mailComposeDelegate = self
        toController.presentViewController(mailController, animated: true, completion: nil)
    }
    
    func sendMessageToRecipient(number: String, subject: String?, body: String, toController: UIViewController, block: (SendStatus)->()) {
        guard MFMessageComposeViewController.canSendText() else {
            block(.NotSupported)
            return
        }
        MFMessageComposeViewController.canSendText()
        completionBlock = block
        let msgController = MFMessageComposeViewController()
        msgController.recipients = [number]
        msgController.subject = subject
        msgController.body = body
        msgController.messageComposeDelegate = self
        toController.presentViewController(msgController, animated: true, completion: nil)
    }
}
