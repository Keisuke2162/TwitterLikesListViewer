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
    //@objc dynamic var content: String? = nil
    @objc dynamic var content: String = ""
    @objc dynamic var tweetID: String = ""
    
    @objc dynamic var judge: Bool = false
    
    let picImage = List<Extended_Entities>()
    
}

class Extended_Entities: Object {
    @objc dynamic var image: String = ""
    @objc dynamic var type: String = ""
    
    //@objc dynamic var video_info: Video_Info? = nil
}

/*
class Video_Info: Object {
    let variants = List<Variants>()
}

class Variants: Object {
    @objc dynamic var bitrate: Int = 0
    @objc dynamic var content_type: String = ""
    @objc dynamic var url = ""
}
*/


class CategoriseItem: Object {
    
    @objc dynamic var userIcon: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var userID: String = ""
    //@objc dynamic var content: String? = nil
    @objc dynamic var content: String = ""
    @objc dynamic var tweetID: String = ""
    
    //ツイートが選択されたどうか判定用
    @objc dynamic var judge: Bool = false
    
    var picImage = List<Extended_Entities>()
    
    //カテゴリ名
    @objc dynamic var category: String?
}

