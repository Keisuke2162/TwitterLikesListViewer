//
//  ViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import PageMenuKitSwift

class ViewController: UIViewController {
    
    var pageMenuController: PMKPageMenuController? = nil
    var strArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("setViewController")
            
        var controllers: [UIViewController] = []
        let dateFormatter = DateFormatter()
        
        //いいねリスト表示画面
        //let settingView: LikesListViewController = LikesListViewController()
        //settingView.title = "Setting"
        //controllers.append(settingView)
        
        //
        let settingView: Login_APIrequest_Backup_ViewController = Login_APIrequest_Backup_ViewController()
        settingView.title = "Setting"
        controllers.append(settingView)
        
        //カテゴリごとの画面
        strArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        var i = 0
        for month in dateFormatter.monthSymbols {
            let viewController: TimeLineViewController = TimeLineViewController()
            viewController.title = month
            //viewController.ViewText(month: month)
            viewController.array = strArray
                
            controllers.append(viewController)
            i += 1
        }
        
        let statusBarHeight: CGFloat = view.frame.height * 0.05
        pageMenuController = PMKPageMenuController(controllers: controllers, menuStyle: .Smart, menuColors: [], topBarHeight: statusBarHeight)
        self.addChild(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParent: self)
    }
}

