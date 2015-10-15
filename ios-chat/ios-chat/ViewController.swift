
//
//  ViewController.swift
//  ios-chat
//
//  Created by Admin on 10/14/15.
//  Copyright © 2015 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK : Properties
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var chatStack: UIStackView!
    
    let socket = SocketIOClient(socketURL: "localhost:8080")
    
    //TODO temporarily hardset. In future allow user to logon with a user-specified name
    let username = "testDefaultIOSUser"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addHandlers()
        self.socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMessage()
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the sendMessageButton while editing.
        sendMessageButton.enabled = false
    }
    func checkValidMessage() {
        // Disable the send button if the text field is empty.
        let text = messageInput.text ?? ""
        sendMessageButton.enabled = !text.isEmpty
    }
    
    
    // MARK : Socket Handlers
    
    func addHandlers() {
        socket.on("connect") {data, ack in
            print("socket connected")
            
            //log on
            self.socket.emit("login", self.username);
        }
        
        socket.on("loginNameExists") {data, ack in
            //Show error, someone is already using that name
            
        }
        
        socket.on("loginNameBad") {data, ack in
            //Show error, name is invalid
        }
        
        socket.on("welcome") {data, ack in
            self.socket.emit("onlineUsers");
        }
        
        socket.on("onlineUsers") {data, ack in
            print("got online users")
            //TODO add to online user list instead of printing
            if let users = data as? Array {
                for user in users{
                    print(user)
                }
            }
        }
        
        socket.on("userJoined") {data, ack in
            //Show user joined message
            
        }

        socket.on("userLeft") {data, ack in
            //Show user left message
            
        }
        
        socket.on("chat") {data, ack in
            //Chat received, display it
            let message = (data[0]["message"]) as? String
            var sender = (data[0]["sender"]) as? String
            var senderTextColor : UIColor;
            
            //custom formatting for my own messages
            if(sender == self.username){
                sender = "Me"
                senderTextColor = UIColor.blueColor()
            } else{
                senderTextColor = UIColor.redColor()
            }
            
            let lbl = UILabel()
            let myString:NSString = sender! + " : "  + message!
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            
            myMutableString.addAttribute(NSForegroundColorAttributeName, value: senderTextColor, range: NSRange(location:0,length:(sender!).characters.count))
            
            lbl.attributedText = myMutableString
            
            self.chatStack.addArrangedSubview(lbl)
        }
        
        // Using a shorthand parameter name for closures
        // Useful for debugging
        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    
    // MARK: Actions
    @IBAction func sendMessage(sender: UIButton) {
        //Send the message
        self.socket.emit("chat", messageInput.text!);
        
        //Clear input, dismiss keyboard
        messageInput.text = ""
        messageInput.resignFirstResponder()
    }
    

}

