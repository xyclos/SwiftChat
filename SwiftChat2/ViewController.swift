//
//  ViewController.swift
//  SwiftChat2
//
//  Created by Jake Johnson on 6/7/14.
//  Copyright (c) 2014 Jake Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var nameLabel : UILabel? = nil
    @IBOutlet var tableView : UITableView? = nil
    @IBOutlet var msgInput : UITextField? = nil
    
    var chat: NSMutableArray = NSMutableArray()
    var firebase: Firebase
    var name: String
    
    required init(coder aDecoder: (NSCoder!)) {
        firebase = Firebase(url: "ADD YOUR FIREBASE URL HERE!")
        name = "Guest \(arc4random() % 1000)"

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel!.text = self.name
        var snapshot: FDataSnapshot = FDataSnapshot()
        
        self.firebase.observeEventType(FEventTypeChildAdded, withBlock: {snapshot in
            println(snapshot)
            self.chat.addObject(snapshot.value)
            self.tableView!.reloadData()
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.endEditing(true)
        
        self.firebase.childByAutoId().setValue(["name": self.name, "text": msgInput!.text])
        
        textField.text = ""
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.chat.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        var rowData: NSDictionary = self.chat[indexPath.row] as! NSDictionary
        cell.textLabel!.text = rowData["text"] as? String
        cell.detailTextLabel!.text = rowData["name"] as? String
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.moveView(notification.userInfo!, up: true)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.moveView(notification.userInfo!, up: false)
    }
    
    func moveView(userInfo: NSDictionary, up: Bool) {
        var keyboardEndFrame: CGRect = CGRect()
        userInfo[UIKeyboardFrameEndUserInfoKey]!.getValue(&keyboardEndFrame)
        
        var animationCurve: UIViewAnimationCurve = UIViewAnimationCurve.EaseOut
        userInfo[UIKeyboardAnimationCurveUserInfoKey]!.getValue(&animationCurve)
        
        var animationDuration: NSTimeInterval = NSTimeInterval()
        userInfo[UIKeyboardAnimationDurationUserInfoKey]!.getValue(&animationDuration)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        var keyboardFrame: CGRect = self.view.convertRect(keyboardEndFrame, toView: nil)
        var y = keyboardFrame.size.height * (up ? -1 : 1)
        self.view.frame = CGRectOffset(self.view.frame, 0, y)
        
        UIView.commitAnimations()
    }


}

