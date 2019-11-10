//
//  LoginWebViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/8/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class LoginWebViewController: UIViewController, WKNavigationDelegate {
    var selectedService: NotificationHost!
    
    @IBOutlet weak var webKitView: WKWebView!
    
    override func viewDidAppear(_ animated: Bool) {
        webKitView.navigationDelegate = self
        
        loadLoginForSelectedService()
    
    }
    
    fileprivate func loadLoginForSelectedService() {
        let hostType = selectedService.getTypeFromHostTypeData()
        
        switch hostType?.type {
        case .github:
            let request = URLRequest(url: GithubAPIClient.endpoints.authentication.url)
            print(GithubAPIClient.endpoints.authentication.url)
            webKitView.load(request)
        case .wordpress:
            let request = URLRequest(url: WordpressAPIClient.endpoints.authentication.url)
            webKitView.load(request)
        default:
            displayNoActionAlertAndDissmissView(title: "Error Loading Page", message: "Could not load login page.  Please try again!")
        }
    }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("did commit")
            if let url = webView.url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                switch components.path {
                case "/wordpress/":
                    WordpressAPIClient.authenticate(components: components, host:selectedService, completion: handleLoginResponse(success:error:))
                case "/github/":
                    print("Github")
                    GithubAPIClient.authenticate(components: components, host: selectedService, completion: handleLoginResponse(success:error:))
                default:
                    break
                }
            }
        }
        
        fileprivate func handleLoginResponse(success: Bool, error: Error?) {
            if error != nil {
                displayNoActionAlertAndDissmissView(title: "Login Failed", message: error!.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
