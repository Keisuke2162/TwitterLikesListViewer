//
//  ViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import PageMenuKitSwift
import RealmSwift

class ViewController: UIViewController, DoingViewController {


    var pageMenuController: PMKPageMenuController? = nil
    
    var category: [String] = []
    
    let categoryData = ViewCategory()
    
    var controllers: [UIViewController] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("setViewController")
        
        /*
        //テスト用
        let testImageViewer: TESTViewController = TESTViewController()
        testImageViewer.title = "TEST"
        controllers.append(testImageViewer)
        */
        
        
        //項目設定画面
        let generalView: GeneralViewController = GeneralViewController()
        generalView.title = "General"
        generalView.addViewController = self
        controllers.append(generalView)

        //いいね欄表示用画面
        let homeView: Login_APIrequest_Backup_ViewController = Login_APIrequest_Backup_ViewController()
        homeView.title = "Likes"
        controllers.append(homeView)
        
        
        category = categoryData.GetValue()
        print(category.count)
        //カテゴリごとの画面
        for viewTitle in category {
            let viewController: TimeLineViewController = TimeLineViewController()
            viewController.title = viewTitle
            
            controllers.append(viewController)
        }
        
        let statusBarHeight: CGFloat = view.frame.height * 0.05
        pageMenuController = PMKPageMenuController(controllers: controllers, menuStyle: .Tab, menuColors: [], topBarHeight: statusBarHeight)
        self.addChild(pageMenuController!)
        self.view.addSubview(pageMenuController!.view)
        pageMenuController?.didMove(toParent: self)
    }
    
    //ViewController追加処理
    func AddViewControlle() {
        
        for i in view.subviews {
            i.removeFromSuperview()
        }
        
        for j in self.children {
            j.removeFromParent()
        }
        
        controllers = []
        
        viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

