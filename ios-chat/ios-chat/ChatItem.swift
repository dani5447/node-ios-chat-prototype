//
//  ChatItem.swift
//  ios-chat
//
//  Created by Admin on 10/14/15.
//  Copyright © 2015 Admin. All rights reserved.
//

import Foundation

class ChatItem {
    
    var message: String?
    var sender: String?
    
    init(message : String, sender : String) {
        self.message = message
        self.sender = sender
    }
}