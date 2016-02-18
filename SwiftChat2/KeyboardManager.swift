//
//  KeyboardManager.swift
//  SwiftChat2
//
//  Created by Jake Johnson on 2/18/16.
//  Copyright © 2016 Jake Johnson. All rights reserved.
//

import Foundation
import UIKit

class KeyboardManager: NSObject {
    let view: UIView
    let textFields: [UITextField]?
    
    init(view: UIView, textFields: [UITextField]?) {
        self.view = view
        self.textFields = textFields
    }
    
    func start() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func stop() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        for textField in textFields ?? [UITextField]() {
            if (textField.editing) {
                view.frame.origin.y -= getKeyboardHeight(notification)
                break
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        for textField in textFields ?? [UITextField]() {
            if (textField.editing) {
                view.frame.origin.y += getKeyboardHeight(notification)
                break
            }
        }
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue) {
                return keyboardSize.CGRectValue().height
            }
        }
        
        return CGFloat(0.0)
    }
}
