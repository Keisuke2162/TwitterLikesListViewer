//
//  TimeLineViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/24.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import RealmSwift

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {
    
    func MoveImageViewer(sender: [MediaInfomation], currentPage: Int) {
        
        let vc: ImageVewerViewController = ImageVewerViewController()
        vc.imageInformation = sender
        vc.currentPage = currentPage
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func TweetChecked(row: Int, judge: Bool) {
        print("check")
    }
    
    
    //表示用配列
    var showTweetItems: [CategoriseItem] = []
    //画像表示用配列
    var showTweetImages: [[MediaInfomation]] = []
    
    var tableView:UITableView!
    
    //tableViewのリフレッシュ
    let refresh = UIRefreshControl()
    
    //Realmのインスタンス
    var realm = try! Realm()
    //カテゴライズしたツイートのアイテムリスト
    var tweetList: Results<CategoriseItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        refresh.addTarget(self, action: #selector(Reload), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refresh
        
        SettingTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    @objc func Reload() {
        SettingTableView()
        
        refresh.endRefreshing()
    }
    
    func SettingTableView() {
        
        let viewTitle = self.title!
        
        showTweetItems = []
        showTweetItems = []
        
        //Realmからカテゴライズしたツイートを取得
        tweetList = realm.objects(CategoriseItem.self)
        
        //カテゴライズツイートの中から該当カテゴリと一致するデータを抽出
        //Realmからの取得段階でフィルターかける方がいいかも
        for i in 0 ..< tweetList.count {
            
            if tweetList[i].category! == viewTitle {
                showTweetItems.append(tweetList[i])
                
                //画像、GIF、動画情報格納用
                var mediaArray: [MediaInfomation] = []
                var media = MediaInfomation()
                
                for j in 0 ..< tweetList[i].picImage.count {
                    media.type = tweetList[i].picImage[j].type
                    media.imageURL = tweetList[i].picImage[j].image
                    
                    mediaArray.append(media)
                }
                
                showTweetImages.append(mediaArray)
            }
        }
        
        self.tableView.reloadData()
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
        return showTweetItems.count
    }
    
    //セルタップ時の挙動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WebTweetViewController()
        let url = "https://twitter.com/" + showTweetItems[indexPath.row].userID + "/status/" + showTweetItems[indexPath.row].tweetID
        vc.modalPresentationStyle = .fullScreen
        vc.url = url
        present(vc, animated: true, completion: nil)
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        let tweet = showTweetItems[indexPath.row]
        cell.setCell(name: tweet.userName, id: tweet.userID, content: tweet.content, iconImage: UIImage(url: tweet.userIcon),images: showTweetImages[indexPath.row], judge: false)
        
        cell.checkButton.isHidden = true
        
        cell.row = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}

