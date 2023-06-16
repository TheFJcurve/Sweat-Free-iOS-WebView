//
//  ViewController.swift
//  SweatFreeiOSWebView
//
//  Created by Sargun Singh Bhatti on 2023-06-16.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var goBackButton: UIButton!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
        goBackButton = UIButton(type: .system)
        goBackButton.setTitle("<", for: .normal)
        goBackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        goBackButton.setTitleColor(.white, for: .normal)
        goBackButton.backgroundColor = .red
        goBackButton.layer.cornerRadius = 16
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(goBackButton)
        
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goBackButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 840),
            goBackButton.widthAnchor.constraint(equalToConstant: 50),
            goBackButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.sweatfree.co")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
}
