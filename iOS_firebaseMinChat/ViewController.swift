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
    
    fileprivate var databaseRef = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFIRDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // private
    
    private func initFIRDatabase() {
        databaseRef = FIRDatabase.database().reference() // dbのインスタンス生成
        // 子要素の追加を監視
        databaseRef.observe(.childAdded, with: { snapshot in
            guard let name = (snapshot.value! as AnyObject).object(forKey: "name") as? String,
                let message = (snapshot.value! as AnyObject).object(forKey: "message") as? String,
                let text = self.textView.text else {
                    return
            }
            self.textView.text = "\(text)\n\(name) : \(message)"
        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let messageData = ["name": nameTextFileld.text!, "message": messageTextFileld.text!]
        if textField.tag == TextFieldTag.Message.rawValue {
            databaseRef.childByAutoId().setValue(messageData)
        }
        textField.resignFirstResponder()
        messageTextFileld.text = ""
        return true
    }
}

extension ViewController {
    fileprivate enum TextFieldTag: Int {
        case Name = 1
        case Message
    }
}
