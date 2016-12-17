//
//  Message.swift
//  Everywherechat
//
//  Created by Admin on 2016/12/10.
//  Copyright © 2016年 Everywhere. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    //eps12
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
