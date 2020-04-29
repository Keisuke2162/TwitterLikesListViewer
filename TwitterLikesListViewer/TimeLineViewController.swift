//
//  TimeLineViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import RealmSwift

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //relamのアイテムリスト
    var itemList: Results<CategoriseItem>!
    
    //表示用配列
    var showTweetItems: [CategoriseItem] = []
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        //いいね欄保存用のRealmデータベース
        let realm = try! Realm()
        
        // Do any additional setup after loading the view.
        itemList = realm.objects(CategoriseItem.self)
        
        print("取得数→\(itemList.count)")
        
        /*
        showTweetItems = []
        //取得したデータを表示用配列に変換
        for i in 0 ..< itemList.count {
            let showItem = TweetItem()
            
            showItem.userName = itemList[i].userName
            showItem.userID = itemList[i].userID
            showItem.userIcon = itemList[i].userIcon
            showItem.content = itemList[i].content
            showItem.tweetID = itemList[i].tweetID
            
            showTweetItems.append(showItem)
        }
        */
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        //cell.setCell(titleStr: array[indexPath.row], iconImage: UIImage(named: "information")!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}

