//
//  ViewController.swift
//  SweatFreeiOSWebView
//
//  Created by Sargun Singh Bhatti on 2023-06-16.
//
//  This is the main file that contains all the information about the iOS app

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var toolbar: UIToolbar!
    var homeURL = URL(string: "https://www.sweatfree.co")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  If the application loads properly without crash, then the webView loads
        //  our website. MyRequest is the url we wish to load, and webView.load() loads
        //  that to our app.
        
        setupWebView()
        setupToolbar()
        
        let myRequest = URLRequest(url: homeURL!)
        webView.load(myRequest)
    }
    
    func setupWebView() {
        
        //  Sets up the dimension of our webView. Since I have inserted a toolbar, it's
        //  best to decrease the height of the webView. The height of the toolbar is 80px
        //  and hence the webView's height is decreased by 80
        
        webView = WKWebView(frame: CGRect(x: 0, y: 80, width: view.bounds.width, height: view.bounds.height - 80))
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        
    }
    
    func setupToolbar() {
        
        //  Setting up the toolbar dimensions (1st part) and the buttons (2nd part).
        //  Note: .flexibleSpace has been created for aesthetic purpose, it just gives
        //  some padding between the icons, and spreads them out evenly in the toolbar.
        
        
        //  Part 1: Dimensions
        toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        toolbar.barTintColor = UIColor(red: 60/255, green: 67/255, blue: 70/255, alpha: 1.0)
        toolbar.tintColor = .white
        view.addSubview(toolbar)
        
        
        //  Part 2: Buttons
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(goBack))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(goHome))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goForward))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshWebView))
        let openInBrowserButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(openInBrowser))
        
        toolbar.items = [backButton, flexibleSpace, homeButton, flexibleSpace, shareButton, flexibleSpace, openInBrowserButton, flexibleSpace, refreshButton, flexibleSpace, forwardButton]
    }
    
    // Setting up the functions
    
    @objc func share() {
        //  Takes the current url the user is on, and shows options of sharing that with
        //  people on whichever social media platform that the user has downloaded.
        guard let currentURL = webView.url else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [currentURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        //  Goes back whenever clicked, till it's possible.
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func goForward() {
        //  Goes forward whenever clicked, till it's possible.
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func goHome() {
        //  Goes to the homeURL. Which, in this case, is https://www.sweatfree.co
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
