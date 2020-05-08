//
//  CustomClass.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/05/05.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//


//カスタムクラスとExtension集

import Foundation
import UIKit

//URLを画像に変換
extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

class CustomButton: UIButton {
    var categoryTitle: String?
    var buttonBool: Bool = false
    var setNum: Int?
    
    //twitterURL用
    var twitterURL: String?
    
    //
}

struct MediaInfomation {
    var imageURL: String = ""
    var type: String = ""
}
