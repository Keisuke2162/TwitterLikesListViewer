//
//  GeneralViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/04/28.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

protocol DoingViewController {
    func AddViewControlle()
}

class GeneralViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //
    var viewArray: [String] = []
    
    //
    var addViewController: DoingViewController?
    
    //カテゴリが保存されてるクラス
    let database = ViewCategory()
    
    //
    var tableView = UITableView()
    
    //
    let settingField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewArray = database.GetValue()

        // Do any additional setup after loading the view.
        
        settingField.frame = CGRect(x: 25, y: 50, width: view.frame.width - 125, height: 50)
        settingField.layer.cornerRadius = 10.0
        settingField.layer.borderWidth = 1.0
        settingField.layer.borderColor = UIColor.white.cgColor
        
        view.addSubview(settingField)
        
        let addButton = UIButton()
        addButton.frame = CGRect(x: view.frame.width - 75, y: 50, width: 50, height: 50)
        addButton.layer.cornerRadius = 10.0
        addButton.backgroundColor = .yellow
        addButton.addTarget(self, action: #selector(AddViewTitle), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        //tableView描画
        tableView.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height - 100)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(self.tableView)
        
        //textViewにDoneボタンを追加
        setToolbarTextView()
        
    }
    
    //追加ボタン押下
    @objc func AddViewTitle() {
        if let title = settingField.text?.trimmingCharacters(in: .whitespaces) {
            settingField.text = ""
            var checkResult: Bool = true
            
            //タイトル名空チェック
            if title != "" {
                
                //同名タイトルチェック
                for viewTitleList in viewArray {
                    if title == viewTitleList {
                        print("既に有る名前です")
                        checkResult = false
                        break
                    }
                    
                }
                
                //チェック合格ならView追加
                if checkResult {
                    viewArray.append(title)
                    tableView.reloadData()
                    
                    database.SaveValue(array: viewArray)
                    print("Add")
                    
                    if let del = addViewController {
                        del.AddViewControlle()
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = viewArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            viewArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
            if let del = addViewController {
                del.AddViewControlle()
            }
        }
    }
    
    
    
    func setToolbarTextView() {
        // ツールバー生成 サイズはsizeToFitメソッドで自動で調整される。
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        //サイズの自動調整。敢えて手動で実装したい場合はCGRectに記述してsizeToFitは呼び出さない。
        toolBar.sizeToFit()

        // 左側のBarButtonItemはflexibleSpace。これがないと右に寄らない。
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // Doneボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))

        // BarButtonItemの配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        settingField.inputAccessoryView = toolBar
    }
    
    //キーボードのDoneボタンを押したらキーボード閉じる
    @objc func commitButtonTapped() {
        settingField.resignFirstResponder()
        self.view.endEditing(true)
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
