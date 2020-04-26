//
//  TweetManagement.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/27.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation
import RealmSwift

class TweetItem: Object {
    @objc dynamic var userIcon: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var userID: String = ""
    @objc dynamic var content: String? = nil
    
}
