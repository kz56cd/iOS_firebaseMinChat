//
//  ViewController.swift
//  iOS_firebaseMinChat
//
//  Created by msano on 2017/01/25.
//  Copyright © 2017年 msano. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameTextFileld: UITextField!
    @IBOutlet weak var messageTextFileld: UITextField!
    
    var databaseRef = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dbのインスタンス生成
        databaseRef = FIRDatabase.database().reference()
        
        // 子要素の追加を監視
        databaseRef.observe(.childAdded, with: { snapshot in
            if let name = (snapshot.value! as AnyObject).object(forKey: "name") as? String,
                let message = (snapshot.value! as AnyObject).object(forKey: "message") as? String {
                if let text = self.textView.text {
                    self.textView.text = "\(text)\n\(name) : \(message)"
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let messageData = ["name": nameTextFileld.text!, "message": messageTextFileld.text!]
        if textField.tag == 2 {
            databaseRef.childByAutoId().setValue(messageData)
        }
        textField.resignFirstResponder()
        messageTextFileld.text = ""
        return true
    }
}

