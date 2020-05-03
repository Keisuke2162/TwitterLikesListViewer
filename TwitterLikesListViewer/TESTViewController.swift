//
//  TESTViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/05/01.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit

class TESTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.frame.size = CGSize(width: 50, height: 50)
        button.center = view.center
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(NextView), for: .touchUpInside)
        
        view.addSubview(button)

        // Do any additional setup after loading the view.
    }
    
    @objc func NextView() {
        let vc = ImageVewerViewController()
        present(vc, animated: true, completion: nil)
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
