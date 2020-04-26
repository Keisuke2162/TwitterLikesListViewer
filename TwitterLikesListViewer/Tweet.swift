//
//  Tweet.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/25.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import Foundation

struct Tweet {
    
    // Tweetのid
    let id: String

    // Tweetの本文
    let text: String

    // このTweetの主
    let user: User
}
