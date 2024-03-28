//
//  XIDPhotoWebViewController.swift
//  XLLightMagic
//
//  Created by admin on 2024/3/28.
//

import Foundation
import UIKit
import WebKit

class XIDPhotoWebViewController:XWebViewController{
    override func configUI() {
        super.configUI()
        self.delegate = self
        let path = Bundle.main.path(forResource: "11", ofType: "html")
        let count = try! String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        self.webView.loadHTMLString(count, baseURL: Bundle.main.bundleURL)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            /// JS调用iOS 并可以向iOS传值
            self.webView.configuration.userContentController.add(self, name: "back")
            self.webView.configuration.userContentController.add(self, name: "camera")
            self.webView.configuration.userContentController.add(self, name: "album")
            self.webView.configuration.userContentController.add(self, name: "loadIndicator")
            self.webView.configuration.userContentController.add(self, name: "hiddenIndicator")
            
            // 针对1) 先用JS调用iOS方法
            self.webView.configuration.userContentController.add(self, name: "getUserInfoBeforeLoaded")
            
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //移除
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "back")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "camera")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "album")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "loadIndicator")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "hiddenIndicator")
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getUserInfoBeforeLoaded")
    }
}


//MARK: WKScriptMessageHandler
extension XIDPhotoWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        print(message.body)
        /// message 是 JS向iOS传递的信息 message.name：方法名     message.body参数
        switch message.name {
        case "back":
            if let body = message.body as? String {
                print("这是返回" + body)
            } else {
                print("这是返回")
            }
        case "camera":
            print("这是相机")
            chooseImageFromGallery()
        case "album":
            print("这是相册")
        case "loadIndicator":
            print("这是加载进度条")
        case "hiddenIndicator":
            print("这是取消进度条")
        // 针对1) 实现该方法并且在此向JS传值
//        case "getUserInfoBeforeLoaded":
//            let dic = ["id": "123","name": "iOS向JS传值"]
//            if let data = try?JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted) {
//                let str = String(data: data, encoding: String.Encoding.utf8)
//                
//                let inputJS = "getCurrentUser" + "(\(str ?? ""))"
//                print(inputJS)
//                self.webView.evaluateJavaScript(inputJS) { (response, error) in
//                    
//                    print( response , error)
//                    
//                }
//            }
        default:
            break;
        }
    }
}

//MARK: WKNavigationDelegate
extension XIDPhotoWebViewController: XWebViewDelegate {
    //MARK: 2) webview加载完成 iOS向JS传值
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let inputJS = "getUserInfo" + "('延迟5秒后:iOS向JS传递的值->sinleee hello')"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
            self.webView.evaluateJavaScript(inputJS) { (response, error) in
                
            print(response , error)
                
            }
        }
    }
}

extension XIDPhotoWebViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func chooseImageFromGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               // Do something with the picked image
               // 处理所选图片，进行网络处理，拿到URL给web
               let inputJS = "imageUrlCallBack" + "('拿到了返回的图片url')"
               self.webView.evaluateJavaScript(inputJS) { (response, error) in
                   
                   print(response , error)
                   
               }
           }
           dismiss(animated: true, completion: nil)
       }

       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
    
}

