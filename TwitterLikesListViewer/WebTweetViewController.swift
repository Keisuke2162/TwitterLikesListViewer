//
//  WebTweetViewController.swift
//  TwitterLikesListViewer
//
//  Created by 植田圭祐 on 2020/05/07.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

import UIKit
import WebKit

class WebTweetViewController: UIViewController {
    
    var webView: WKWebView!
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let backColor = UIColor.dynamicColor(light: .white, dark: UIColor(colorCode: "13202c"))
        view.backgroundColor = backColor
        
        let webConfigure = WKWebViewConfiguration()
        
        let frame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 70)
        webView = WKWebView(frame: frame, configuration: webConfigure)
        
        let webUrl = URL(string: url)
        let request = URLRequest(url: webUrl!)
        
        webView.load(request)
        
        view.addSubview(webView)
        
        
        
        let dismissButton = UIButton()
        dismissButton.frame = CGRect(x: 20, y: 25, width: 40, height: 40)
        dismissButton.layer.cornerRadius = 20
        dismissButton.backgroundColor = .blue
        dismissButton.addTarget(self, action: #selector(ReturnView), for: .touchUpInside)
        
        view.addSubview(dismissButton)
        
    }
    
    @objc func ReturnView() {
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

}

extension UIColor {
    /// ライト/ダーク用の色を受け取ってDynamic Colorを作って返す
    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }
}
