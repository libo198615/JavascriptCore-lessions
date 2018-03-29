//
//  ViewController.swift
//  JavaScriptCore-Lessions
//
//  Created by Megvii on 2018/3/29.
//  Copyright © 2018年 libo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var myView: UIView!
    
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController.init()
        contentController.add(self, name: "jsContent1")
        contentController.add(self, name: "jsContent2")
        let webViewConfiguration = WKWebViewConfiguration.init()
        webViewConfiguration.userContentController = contentController

        // TODO: 从xib中创建的 WKWebView 不支持设置 WKWebViewConfiguration ？
//        webView.configuration = webViewConfiguration
        webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 200), configuration: webViewConfiguration)
        self.view.addSubview(webView)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        
        logUrl()
    }
    
    func logUrl() {
        let url = Bundle.main.url(forResource: "index", withExtension: "html")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @IBAction func callJS(_ sender: Any) {
        swiftToJavaScript()
    }
    
    func swiftToJavaScript() {
        let jsStr =  "swiftCallJS('\(count)')"
        count = count + 1
        webView.evaluateJavaScript(jsStr) { (result, error) in
            if error == nil {
                print(result ?? "no result")
            } else {
                print(error!)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIViewController: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // The name of the message handler to which the message is sent
        print(message.name)
        print("参数：\(message.body)")
        
    }
    
}

extension ViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void) {
        print("get JS notice to displays an alert panel")

        let action = UIAlertAction.init(title: "OK", style: .default) { action in
            print(" swift 点击了 OK")
//            print("必须调用 completionHandler()")
            completionHandler()
        }
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void) {
        print("get JS notice to displays a confirm panel")
        
        let action0 = UIAlertAction.init(title: "YES", style: .default) { (action) in
            print(" swift 点击了 YES")
//            print("必须调用 completionHandler()")
            completionHandler(true)
        }
        
        let action1 = UIAlertAction.init(title: "NO", style: .default) { (action) in
            print(" swift 点击了 NO")
//            print("必须调用 completionHandler()")
            completionHandler(false)
        }
        
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(action0)
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void) {
        print("get JS notice to displays a text input panel")
        
        let alertController = UIAlertController.init(title: nil, message: prompt, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = defaultText
        }
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in
            print(" swift 输入完毕")
            completionHandler(alertController.textFields?.first?.text)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: WKNavigationDelegate {
    
  
    
}
