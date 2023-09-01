//
//  ViewController.swift
//  SweatFreeiOSWebView
//
//  Created by Sargun Singh Bhatti on 2023-06-16.
//
//  This is the main file that contains all the information about the iOS app

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    var webView: WKWebView!
    var toolbar: UIToolbar!
    var homeURL = URL(string: "https://www.sweatfree.co") //  Default home location. Change this if replicating project.
    var toolbarThickness: CGFloat = 40
    var padding: CGFloat = 20 //  Distance of buttons from button of the toolbar
    
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
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height:view.bounds.height - (toolbarThickness + 2 * padding)))
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        
    }
    
    func setupToolbar() {
        
        //  Setting up the toolbar dimensions (1st part) and the buttons (2nd part).
        //  Note: .flexibleSpace has been created for aesthetic purpose, it just gives
        //  some padding between the icons, and spreads them out evenly in the toolbar.
        
        let toolbarHeight = toolbarThickness + padding
        let toolbarY = view.bounds.height - toolbarHeight - padding // Adjusted the Y position
        toolbar = UIToolbar(frame: CGRect(x: 0, y: toolbarY, width: view.bounds.width, height: toolbarHeight))
        toolbar.barTintColor = UIColor(red: 61/255, green: 66/255, blue: 70/255, alpha: 1.0)
        toolbar.tintColor = .white
        toolbar.backgroundColor = UIColor(red: 61/255, green: 66/255, blue: 70/255, alpha: 1.0)

        view.addSubview(toolbar)

        // Part 2: Buttons
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(goBack))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let homeButton = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(goHome))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goForward))
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshWebView))
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showMenu))
            

        toolbar.items = [menuButton, flexibleSpace, backButton, flexibleSpace, homeButton, flexibleSpace, refreshButton, flexibleSpace, shareButton, flexibleSpace, forwardButton]
        }
    
    //  The option to make the toolbar disappear on scrolling.
    
//    func handleToolbarVisibility(for url: URL?) {
//            guard let url = url else {
//                toolbar.isHidden = false
//                webView.frame.size.height = view.bounds.height - (toolbarThickness + 2 * padding)
//                return
//            }
//
//            if url.absoluteString.hasPrefix("https://www.sweatfree.co") {
//                toolbar.isHidden = true
//                webView.frame.size.height = view.bounds.height
//            } else {
//                toolbar.isHidden = false
//                webView.frame.size.height = view.bounds.height - (toolbarThickness + 2 * padding)
//            }
//        }
//
//    // Delegate method to track changes in the URL
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        handleToolbarVisibility(for: webView.url)
//    }
    
    // Setting up the functions
    
    class OpenInSafari: UIActivity {
        
        //  Creates a new button for opening the url in safari inside the share function
        //  Have to initlize webView inside the function since we need to use webView.url property
        //  Main button activity is coded insdie perform().
        
        private let webView: WKWebView
        
        init(webView: WKWebView) {
            self.webView = webView
            super.init()
        }
        
        override var activityTitle: String? { "Open In Safari" }
        override var activityType: UIActivity.ActivityType? { UIActivity.ActivityType("openInSafari") }
        override var activityImage: UIImage? { UIImage(systemName: "safari") }
        
        override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
            true
        }
        
        override func perform() {
            if let currentURL = webView.url {
                UIApplication.shared.open(currentURL)
            }
        }
    }

    @objc func share() {
        
        //  Creates a share popup that helps you to share to media etc.
        //  Have added another custom button (openInSafari), the code for which is written in class OpenInSafari
        
        guard let currentURL = webView.url else { return }

        let openInSafariActivity = OpenInSafari(webView: webView)
        let activityViewController = UIActivityViewController(activityItems: [currentURL], applicationActivities: [openInSafariActivity])

        // Set the source view for the popover presentation
        activityViewController.popoverPresentationController?.sourceView = toolbar

        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func showMenu() {
        
        //  Creates a popup which allows you to select an activity, this can be going to your account, showing your
        //  orders, etc.
        
        let alertController = UIAlertController(title: "Choose an Activity", message: nil, preferredStyle: .actionSheet)
        
        let accountAction = UIAlertAction(title: "Your Account", style: .default) { [weak self] _ in
            // Change the WKWebView to the 'https://www.sweatfree.co/account' URL
            if let url = URL(string: "https://www.sweatfree.co/account") {
                let request = URLRequest(url: url)
                self?.webView.load(request)
            }
        }
        
        let cartAction = UIAlertAction(title: "Cart", style: .default) { [weak self] _ in
            // Change the WKWebView to the 'https://www.sweatfree.co/cart' URL
            if let url = URL(string: "https://www.sweatfree.co/cart") {
                let request = URLRequest(url: url)
                self?.webView.load(request)
            }
        }
        
        let aboutAction = UIAlertAction(title: "About", style: .default) { [weak self] _ in
            // Change the WKWebView to the 'https://www.sweatfree.co/pages/about-sweat-free-apparel' URL
            if let url = URL(string: "https://www.sweatfree.co/pages/about-sweat-free-apparel") {
                let request = URLRequest(url: url)
                self?.webView.load(request)
            }
        }
        
        let contactAction = UIAlertAction(title: "Contact", style: .default) { [weak self] _ in
            // Change the WKWebView to the 'https://www.sweatfree.co/pages/contact-us' URL
            if let url = URL(string: "https://www.sweatfree.co/pages/contact-us") {
                let request = URLRequest(url: url)
                self?.webView.load(request)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(accountAction)
        alertController.addAction(cartAction)
        alertController.addAction(aboutAction)
        alertController.addAction(contactAction)
        alertController.addAction(cancelAction)
        
        // For iPad support
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = toolbar
            popoverController.sourceRect = toolbar.bounds
        }
        
        present(alertController, animated: true, completion: nil)
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
    
        //  Goes to the home URL of the current website.
        
        let myRequest = URLRequest(url: homeURL!)
        webView.load(myRequest)
    }
    
    @objc func refreshWebView() {
        webView.reload()
    }
}
