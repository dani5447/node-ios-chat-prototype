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
    @IBOutlet weak var chatView: UIScrollView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    let socket = SocketIOClient(socketURL: "localhost:8080")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addHandlers()
        self.socket.connect()
        self.socket.emit("login", "testDefaultIOSUser")
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
            //let others know you've connected
            self.socket.emit("userJoined", "tempDefaultIOSUser");
            self.socket.emit("login", "tempDefaultIOSUser");
        }
        
        socket.on("welcome") {data, ack in
            print("socket welcomed")
        }
        
        socket.on("onlineUsers") {data, ack in
            print("got online users")
            if let users = data as? Array {
                for user in users{
                    print(user)
                }
            }
            
        }
        
        // Using a shorthand parameter name for closures
        // Useful for debugging
        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}

    }
    
    
    // MARK: Actions
    @IBAction func sendMessage(sender: UIButton) {
        print("sending message " + messageInput.text!)
        
        //TODO Actually send the message
        
        messageInput.text = ""
        messageInput.resignFirstResponder()
    }
    

}

