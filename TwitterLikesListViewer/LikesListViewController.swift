//
//  LikesListViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import Firebase
import OAuthSwift

class LikesListViewController: UIViewController {
    
    let apiRequest = APIRequest()
    var timeLineTextArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signIn = apiRequest.SigninWithTwitter()
        
        if signIn.0 {
            let timeLineValue = apiRequest.ShowTimeLine(accessToken: signIn.1, secret: signIn.2)
            if timeLineValue.0 {
                timeLineTextArray = timeLineValue.1
                
                print(timeLineTextArray[0])
            } else {
                print("タイムライン取得処理にてエラー発生")
            }
        } else {
            print("認証処理にてエラー発生")
        }
        
        
    }
    
    
    
    
}
