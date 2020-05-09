//
//  CategoryChoiseViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/05/09.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

protocol CategoryChoosed {
    var categoryArray: [String] { get set }
}

class CategoryChoiseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //カテゴリが保存されてるクラス
    let database = ViewCategory()
    
    //カテゴリのタブの色一覧
    var tabColor: [UIColor] = []
    
    //カテゴリ名一覧
    var viewArray: [String] = []
    
    //チェック済みカテゴリ
    var checkCategory: [String] = []
    
    //tableView
    var tableView = UITableView()
    
    var delegate: CategoryChoosed?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.dynamicColor(light: .white, dark: .black)
        
        viewArray = database.GetValue()
        


        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        print(checkCategory)
        
        let doneButton = UIButton()
        doneButton.frame = CGRect(x: view.frame.width - 80, y: 10, width: 70, height: 30)
        //doneButton.backgroundColor = .blue
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.dynamicColor(light: .black, dark: .white), for: .normal)
        doneButton.addTarget(self, action: #selector(ReturnView), for: .touchUpInside)
        
        view.addSubview(doneButton)
        
        //tableView描画
        tableView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "category")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        view.addSubview(tableView)
    }
    
    @objc func ReturnView() {
        
        delegate?.categoryArray = checkCategory
        
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewArray.count
    }
    
    
    //セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category")!
        
        cell.textLabel?.text = viewArray[indexPath.row]
        
        let cellColor: UIColor = tabColor[(indexPath.row + 2) % 9]
        cell.backgroundColor = cellColor
        
        
        for i in checkCategory {
            if i == viewArray[indexPath.row] {
                cell.accessoryType = .checkmark
                
                break
            } else{
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    //セルタップ時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        var check: Bool = true
        
        //既にチェックされていたらチェック済み配列から削除かつチェックマークを外す
        for i in 0 ..< checkCategory.count {
            if checkCategory[i] == viewArray[indexPath.row] {
                checkCategory.remove(at: i)
                
                check = false
                break
            }
        }
        
        if check {
            checkCategory.append(viewArray[indexPath.row])
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        
    }
    
    /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
        
        //
        for i in 0 ..< checkCategory.count {
            if checkCategory[i] == viewArray[indexPath.row] {
                checkCategory.remove(at: i)
                
                break
            }
        }
    }
    */
}
