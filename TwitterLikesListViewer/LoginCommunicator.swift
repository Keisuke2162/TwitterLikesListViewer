//
//  LoginCommunicator.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/26.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Social
import Accounts

struct LoginCommunicator {
    
    func login(handler: @escaping (Bool) -> ()) {
        if !SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
    }
}
