//
//  ViewController.swift
//  SweatFreeiOSWebView
//
//  Created by Sargun Singh Bhatti on 2023-06-16.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var toolbar: UIToolbar!
    var homeURL = URL(string: "https://www.sweatfree.co")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupToolbar()
        
        let myRequest = URLRequest(url: homeURL!)
        webView.load(myRequest)
    }
    
    func setupWebView() {
        webView = WKWebView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height - 80))
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    func setupToolbar() {
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        toolbar.barTintColor = UIColor(red: 60/255, green: 67/255, blue: 70/255, alpha: 1.0)
        toolbar.tintColor = .white
        view.addSubview(toolbar)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(goBack))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(goHome))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goForward))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshWebView))
        let openInBrowserButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(openInBrowser))
        
        toolbar.items = [backButton, flexibleSpace, homeButton, flexibleSpace, shareButton, flexibleSpace, openInBrowserButton, flexibleSpace, refreshButton, flexibleSpace, forwardButton]
    }
    
    @objc func share() {
        guard let currentURL = webView.url else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [currentURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func goHome() {
        let myRequest = URLRequest(url: homeURL!)
        webView.load(myRequest)
    }
    
    @objc func refreshWebView() {
        webView.reload()
    }
    
    @objc func openInBrowser() {
        guard let currentURL = webView.url else { return }
        UIApplication.shared.open(currentURL)
    }
}
