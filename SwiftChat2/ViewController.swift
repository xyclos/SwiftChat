//
//  ViewController.swift
//  SwiftChat2
//
//  Created by Jake Johnson on 6/7/14.
//  Copyright (c) 2014 Jake Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var msgInput : UITextField!
    
    var chat: NSMutableArray = NSMutableArray()
    var firebase: Firebase = Firebase(url: "ADD YOUR FIREBASE URL HERE!")
    var name: String = "Guest"
    
    var keyboardManager: KeyboardManager!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        name = "Guest \(arc4random() % 1000)"
        keyboardManager?.start()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup keyboard manager
        keyboardManager = KeyboardManager(view: view, textFields: [msgInput!])

        nameLabel!.text = self.name
        
        self.firebase.observeEventType(FEventType.ChildAdded, withBlock: {snapshot in
            self.chat.addObject(snapshot.value)
            self.tableView!.reloadData()
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.endEditing(true)
        
        var value = [String:String]()
        value = ["name": self.name, "text": msgInput!.text!]
        
        self.firebase.childByAutoId().setValue(value)
        
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
        let rowData: NSDictionary = self.chat[indexPath.row] as! NSDictionary
        cell.textLabel!.text = rowData["text"] as? String
        cell.detailTextLabel!.text = rowData["name"] as? String
        
        return cell
    }
}

