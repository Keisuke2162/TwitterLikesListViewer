//
//  TESTLoginWithTwitterViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/25.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

class TESTLoginWithTwitterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeline") as! CustomTableViewCell
        
        cell.setCell(name: "user_name", id: "user_id", content: "content", iconImage: UIImage(named: "information")!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    var tableView:UITableView!
    var tweet: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "timeline")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(tableView)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
